import 'dart:convert';

import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import 'package:flutter/foundation.dart';

import '../../llm_exception.dart';
import '../interface/attachments.dart';
import '../interface/chat_message.dart';
import '../interface/llm_provider.dart';
import '../interface/message_origin.dart';

/// A provider for Anthropic's language models (Claude).
///
/// This provider implements the [LlmProvider] interface to integrate Anthropic's
/// models into the chat interface.
class AnthropicProvider extends LlmProvider with ChangeNotifier {
  /// Creates an Anthropic provider instance.
  ///
  /// The [apiKey] parameter is required for authentication with Anthropic's API.
  AnthropicProvider({
    required String apiKey,
    String? baseUrl,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    String model = 'claude-3-5-sonnet-latest',
  })  : _client = AnthropicClient(
          apiKey: apiKey,
          baseUrl: baseUrl,
          headers: {
            'anthropic-dangerous-direct-browser-access': 'true',
            if (headers != null) ...headers,
          },
          queryParams: queryParams,
        ),
        _model = model,
        _history = [];

  final AnthropicClient _client;
  final String _model;
  final List<ChatMessage> _history;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final messages = _mapToAnthropicMessages([
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

    final messages = _mapToAnthropicMessages(_history);
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
    final stream = _client.createMessageStream(
      request: CreateMessageRequest(
        model: Model.modelId(_model),
        messages: messages,
        maxTokens: 1024,
      ),
    );

    yield* stream.map((event) {
      return event.mapOrNull(
            contentBlockDelta: (e) => e.delta.text,
            error: (e) => throw LlmFailureException(e.error.message),
          ) ??
          '';
    });
  }

  List<Message> _mapToAnthropicMessages(List<ChatMessage> messages) {
    return messages.map((message) {
      switch (message.origin) {
        case MessageOrigin.user:
          if (message.attachments.isEmpty) {
            return Message(
              role: MessageRole.user,
              content: MessageContent.text(message.text ?? ''),
            );
          }

          final blocks = <Block>[
            Block.text(text: message.text ?? ''),
            for (final attachment in message.attachments)
              if (attachment is ImageFileAttachment)
                Block.image(
                  source: ImageBlockSource(
                    type: ImageBlockSourceType.base64,
                    mediaType: switch (attachment.mimeType) {
                      'image/jpeg' => ImageBlockSourceMediaType.imageJpeg,
                      'image/png' => ImageBlockSourceMediaType.imagePng,
                      'image/gif' => ImageBlockSourceMediaType.imageGif,
                      'image/webp' => ImageBlockSourceMediaType.imageWebp,
                      _ => throw LlmFailureException(
                          'Unsupported image MIME type: ${attachment.mimeType}',
                        ),
                    },
                    data: base64Encode(attachment.bytes),
                  ),
                )
              else
                throw LlmFailureException(
                  'Unsupported attachment type: $attachment',
                ),
          ];

          return Message(
            role: MessageRole.user,
            content: MessageContent.blocks(blocks),
          );

        case MessageOrigin.llm:
          return Message(
            role: MessageRole.assistant,
            content: MessageContent.text(message.text ?? ''),
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
