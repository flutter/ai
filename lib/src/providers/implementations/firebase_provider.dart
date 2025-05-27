// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

import '../interface/attachments.dart';
import '../interface/chat_message.dart';
import '../interface/llm_provider.dart';

/// A provider class for interacting with Firebase Vertex AI's language model.
///
/// This class extends [LlmProvider] and implements the necessary methods to
/// generate text using Firebase Vertex AI's generative model.
class FirebaseProvider extends LlmProvider with ChangeNotifier {
  /// Creates a new instance of [FirebaseProvider].
  ///
  /// [model] is an optional [GenerativeModel] instance for text generation. If
  /// provided, it will be used for chat-based interactions and text generation.
  ///
  /// [history] is an optional list of previous chat messages to initialize the
  /// chat session with.
  ///
  /// [chatSafetySettings] is an optional list of safety settings to apply to
  /// the model's responses.
  ///
  /// [chatGenerationConfig] is an optional configuration for controlling the
  /// model's generation behavior.
  FirebaseProvider({
    required GenerativeModel model,
    void Function(Iterable<FunctionCall>)? onFunctionCalls,
    Iterable<ChatMessage>? history,
    List<SafetySetting>? chatSafetySettings,
    GenerationConfig? chatGenerationConfig,
    Future<Map<String, Object?>?> Function(FunctionCall)? onFunctionCall,
  }) : _model = model,
       _history = history?.toList() ?? [],
       _chatSafetySettings = chatSafetySettings,
       _chatGenerationConfig = chatGenerationConfig,
       _onFunctionCall = onFunctionCall {
    _chat = _startChat(history);
  }

  final GenerativeModel _model;
  final List<SafetySetting>? _chatSafetySettings;
  final GenerationConfig? _chatGenerationConfig;
  final List<ChatMessage> _history;
  final Future<Map<String, Object?>?> Function(FunctionCall)? _onFunctionCall;
  ChatSession? _chat;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) => _generateStream(
    prompt: prompt,
    attachments: attachments,
    contentStreamGenerator: (c) => _model.generateContentStream([c]),
  );

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    _history.addAll([userMessage, llmMessage]);

    final response = _generateStream(
      prompt: prompt,
      attachments: attachments,
      contentStreamGenerator: _chat!.sendMessageStream,
    );

    // don't write this code if you're targeting the web until this is fixed:
    // https://github.com/dart-lang/sdk/issues/47764
    // await for (final chunk in response) {
    //   llmMessage.append(chunk);
    //   yield chunk;
    // }
    yield* response.map((chunk) {
      llmMessage.append(chunk);
      return chunk;
    });

    // notify listeners that the history has changed when response is complete
    notifyListeners();
  }

  Stream<String> _generateStream({
    required String prompt,
    required Iterable<Attachment> attachments,
    required Stream<GenerateContentResponse> Function(Content)
    contentStreamGenerator,
  }) async* {
    final content = Content('user', [
      TextPart(prompt),
      ...attachments.map(_partFrom),
    ]);

    final contentResponse = contentStreamGenerator(content);

    // don't write this code if you're targeting the web until this is fixed:
    // https://github.com/dart-lang/sdk/issues/47764
    // await for (final chunk in response) {
    //   final text = chunk.text;
    //   if (text != null) yield text;
    // }
    yield* contentResponse.asyncMap((chunk) async {
      if (chunk.functionCalls.isEmpty) return chunk.text ?? '';

      final functionResponses = <FunctionResponse>[];
      for (final functionCall in chunk.functionCalls) {
        try {
          functionResponses.add(
            FunctionResponse(
              functionCall.name,
              await _onFunctionCall?.call(functionCall) ?? {},
            ),
          );
        } catch (ex) {
          functionResponses.add(
            FunctionResponse(functionCall.name, {'error': ex.toString()}),
          );
        }
      }

      final functionContentResponse = await _chat!.sendMessage(
        Content.functionResponses(functionResponses),
      );

      return '${chunk.text ?? ''}${functionContentResponse.text ?? ''}';
    });
  }

  @override
  Iterable<ChatMessage> get history => _history;

  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    _chat = _startChat(history);
    notifyListeners();
  }

  ChatSession? _startChat(Iterable<ChatMessage>? history) => _model.startChat(
    history: history?.map(_contentFrom).toList(),
    safetySettings: _chatSafetySettings,
    generationConfig: _chatGenerationConfig,
  );

  static Part _partFrom(Attachment attachment) => switch (attachment) {
    (final FileAttachment a) => InlineDataPart(a.mimeType, a.bytes),
    (final LinkAttachment a) => FileData(a.mimeType, a.url.toString()),
  };

  static Content _contentFrom(ChatMessage message) => Content(
    message.origin.isUser ? 'user' : 'model',
    [TextPart(message.text ?? ''), ...message.attachments.map(_partFrom)],
  );
}
