import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ollama_dart/ollama_dart.dart';

import '../../llm_exception.dart';
import '../interface/attachments.dart';
import '../interface/chat_message.dart';
import '../interface/llm_provider.dart';
import '../interface/message_origin.dart';

/// A provider for Ollama's language models.
///
/// This provider implements the [LlmProvider] interface to integrate Ollama's
/// locally hosted models into the chat interface.
class OllamaProvider extends LlmProvider with ChangeNotifier {
  /// Creates an Ollama provider instance.
  ///
  /// The [model] parameter specifies which Ollama model to use (e.g., 'llama3.2-vision',
  /// 'gemma, etc.). You can find a list of available models [here](https://ollama.com/search).
  ///
  /// The [baseUrl] defaults to 'http://localhost:11434/api' if not provided. You can also
  /// specify custom [headers] and [queryParams] if needed.
  OllamaProvider({
    String? baseUrl,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    required String model,
  })  : _client = OllamaClient(
          baseUrl: baseUrl,
          headers: headers,
          queryParams: queryParams,
        ),
        _model = model,
        _history = [];

  final OllamaClient _client;
  final String _model;
  final List<ChatMessage> _history;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final messages = _mapToOllamaMessages([
      ChatMessage.user(prompt, attachments),
    ]);

    yield* _generateStream(messages);
  }

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    _history.addAll([userMessage, llmMessage]);

    final messages = _mapToOllamaMessages(_history);
    final stream = _generateStream(messages);

    // don't write this code if you're targeting the web until this is fixed:
    // https://github.com/dart-lang/sdk/issues/47764
    // await for (final chunk in stream) {
    //   llmMessage.append(chunk);
    //   yield chunk;
    // }
    yield* stream.map((chunk) {
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

  Stream<String> _generateStream(List<Message> messages) async* {
    final stream = _client.generateChatCompletionStream(
      request: GenerateChatCompletionRequest(
        model: _model,
        messages: messages,
      ),
    );

    yield* stream.map((res) => res.message.content);
  }

  List<Message> _mapToOllamaMessages(List<ChatMessage> messages) {
    return messages.map((message) {
      switch (message.origin) {
        case MessageOrigin.user:
          if (message.attachments.isEmpty) {
            return Message(
              role: MessageRole.user,
              content: message.text ?? '',
            );
          }

          return Message(
            role: MessageRole.user,
            content: message.text ?? '',
            images: [
              for (final attachment in message.attachments)
                if (attachment is ImageFileAttachment)
                  base64Encode(attachment.bytes)
                else
                  throw LlmFailureException(
                    'Unsupported attachment type: $attachment',
                  ),
            ],
          );

        case MessageOrigin.llm:
          return Message(
            role: MessageRole.assistant,
            content: message.text ?? '',
          );
      }
    }).toList(growable: false);
  }

  @override
  void dispose() {
    _client.endSession();
    super.dispose();
  }
}
