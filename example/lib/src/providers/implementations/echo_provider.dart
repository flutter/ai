// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

import '../../llm_exception.dart';
import '../interface/attachments.dart';
import '../interface/chat_message.dart';
import '../interface/llm_provider.dart';

/// A simple LLM provider that echoes the input prompt and attachment
/// information.
///
/// This provider is primarily used for testing and debugging purposes.
class EchoProvider extends LlmProvider with ChangeNotifier {
  /// Creates an [EchoProvider] instance with an optional chat history.
  ///
  /// The [history] parameter is an optional iterable of [ChatMessage] objects
  /// representing the chat history. If provided, it will be converted to a list
  /// and stored internally. If not provided, an empty list will be used.
  EchoProvider({Iterable<ChatMessage>? history})
      : _history = List<ChatMessage>.from(history ?? []);

  final List<ChatMessage> _history;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    if (prompt == 'FAILFAST') throw const LlmFailureException('Failing fast!');

    await Future.delayed(const Duration(milliseconds: 1000));
    yield '# Echo\n';

    switch (prompt) {
      case 'CANCEL':
        throw const LlmCancelException();
      case 'FAIL':
        throw const LlmFailureException('User requested failure');
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    yield prompt;

    yield '\n\n# Attachments\n${attachments.map((a) => a.toString())}';
  }

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    _history.addAll([userMessage, llmMessage]);
    final response = generateStream(prompt, attachments: attachments);

    // don't write this code if you're targeting the web until this is fixed:
    // https://github.com/dart-lang/sdk/issues/47764
    // await for (final chunk in chunks) {
    //   llmMessage.append(chunk);
    //   yield chunk;
    // }
    yield* response.map((chunk) {
      llmMessage.append(chunk);
      return chunk;
    });

    notifyListeners();
  }

  @override
  Iterable<ChatMessage> get history => _history;

  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    notifyListeners();
  }
}
