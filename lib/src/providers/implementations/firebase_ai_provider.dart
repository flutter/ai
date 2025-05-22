// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

import '../interface/attachments.dart';
import '../interface/chat_message.dart';
import '../interface/llm_provider.dart';
import '../interface/message_origin.dart';

class FirebaseAIProvider with ChangeNotifier implements LlmProvider {
  final GenerativeModel _model;
  List<ChatMessage> _history = [];

  FirebaseAIProvider({required GenerativeModel model, Iterable<ChatMessage>? history}) : _model = model {
    if (history != null) {
      _history = history.toList();
    }
  }

  @override
  List<ChatMessage> get history => _history;

  @override
  set history(List<ChatMessage> newHistory) {
    _history = newHistory;
    notifyListeners();
  }

  List<Part> _convertAttachmentsToParts(Iterable<Attachment> attachments) {
    final parts = <Part>[];
    for (final attachment in attachments) {
      if (attachment is ImageAttachmentBytes) {
        parts.add(DataPart(attachment.mimeType, attachment.bytes));
      } else if (attachment is ImageAttachmentUrl) {
        // Assuming the firebase_ai SDK handles URL fetching or requires bytes.
        // For now, let's log a warning if we encounter a URL, as direct URL support in Part might vary.
        // Or, if the SDK expects a specific URI format (like gs://), that needs to be handled.
        // Based on firebase_ai, it seems to prefer bytes directly.
        // If URLs need to be fetched first, that's an additional step not directly part of this conversion.
        debugPrint('ImageAttachmentUrl currently not fully supported for direct conversion to Part. Please provide bytes.');
        // parts.add(TextPart('Image at ${attachment.url}')); // Placeholder
      }
      // Add other attachment type conversions if necessary
    }
    return parts;
  }

  Content _convertChatMessageToContent(ChatMessage message) {
    final parts = <Part>[TextPart(message.prompt)];
    parts.addAll(_convertAttachmentsToParts(message.attachments));
    // The firebase_ai Content object has a 'role' which can be 'user' or 'model'.
    // We need to map MessageOrigin to this.
    final role = message.origin == MessageOrigin.user ? 'user' : 'model';
    return Content(role, parts);
  }
  
  List<Content> _convertMessagesToContent(Iterable<ChatMessage> messages) {
    return messages.map((message) => _convertChatMessageToContent(message)).toList();
  }

  @override
  Stream<String> sendMessageStream(String prompt, {Iterable<Attachment>? attachments}) {
    final userMessageAttachments = attachments?.toList() ?? [];
    final userMessage = ChatMessage(
      prompt: prompt,
      origin: MessageOrigin.user,
      attachments: userMessageAttachments,
      timestamp: DateTime.now(),
    );
    _history.add(userMessage);
    notifyListeners();

    final currentHistoryForModel = _convertMessagesToContent(_history.toList());
    
    final controller = StreamController<String>();
    final responseBuffer = StringBuffer();

    _model.generateContentStream(currentHistoryForModel).listen(
      (response) {
        final text = response.text;
        if (text != null) {
          responseBuffer.write(text);
          controller.add(text);
        }
      },
      onError: (error) {
        // Potentially add an error message to history or handle differently
        _history.add(ChatMessage(
            prompt: "Error: ${error.toString()}",
            origin: MessageOrigin.system,
            timestamp: DateTime.now()));
        notifyListeners();
        controller.addError(error);
        controller.close();
      },
      onDone: () {
        if (responseBuffer.isNotEmpty) {
          _history.add(ChatMessage(
            prompt: responseBuffer.toString(),
            origin: MessageOrigin.llm,
            timestamp: DateTime.now(),
          ));
          notifyListeners();
        }
        controller.close();
      },
    );

    return controller.stream;
  }

  @override
  Stream<String> generateStream(String prompt, {Iterable<Attachment>? attachments}) {
    final parts = <Part>[TextPart(prompt)];
    if (attachments != null) {
      parts.addAll(_convertAttachmentsToParts(attachments));
    }
    
    // For generateStream, we typically don't pass history, just the current prompt.
    // The firebase_ai SDK expects a List<Content>. For a single prompt,
    // this would be a single Content object with role 'user'.
    final content = [Content('user', parts)];

    final controller = StreamController<String>();

    _model.generateContentStream(content).listen(
      (response) {
        final text = response.text;
        if (text != null) {
          controller.add(text);
        }
      },
      onError: (error) {
        controller.addError(error);
        controller.close();
      },
      onDone: () {
        controller.close();
      },
    );
    return controller.stream;
  }
}
