import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:openai_dart/openai_dart.dart';

import '../../llm_exception.dart';
import '../interface/attachments.dart';
import '../interface/chat_message.dart';
import '../interface/llm_provider.dart';
import '../interface/message_origin.dart';

/// A provider for OpenAI's language models.
///
/// This provider implements the [LlmProvider] interface to integrate OpenAI's
/// models into the chat interface.
class OpenAIProvider extends LlmProvider with ChangeNotifier {
  /// Creates an OpenAI provider instance.
  ///
  /// The [apiKey] parameter is required for authentication with OpenAI's API.
  /// Optionally, [organization] can be specified for users belonging to multiple
  /// organizations.
  ///
  /// The [model] parameter specifies the LLM to use. You can find a list of available
  /// models [here](https://platform.openai.com/docs/models).
  ///
  /// For consuming OpenAI-compatible APIs, you can specify a custom [baseUrl], [headers],
  /// and [queryParams].
  OpenAIProvider({
    required String apiKey,
    String? organization,
    String? baseUrl,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    String model = 'gpt-4o',
  })  : _client = OpenAIClient(
          apiKey: apiKey,
          organization: organization,
          baseUrl: baseUrl,
          headers: headers,
          queryParams: queryParams,
        ),
        _model = model,
        _history = [];

  final OpenAIClient _client;
  final String _model;
  final List<ChatMessage> _history;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final messages = _mapToOpenAIMessages([
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

    final messages = _mapToOpenAIMessages(_history);
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

    // notify listeners that the history has changed when response is complete
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

  Stream<String> _generateStream(List<ChatCompletionMessage> messages) async* {
    final stream = _client.createChatCompletionStream(
      request: CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId(_model),
        messages: messages,
      ),
    );

    yield* stream
        .map((res) => res.choices.firstOrNull?.delta.content)
        .where((content) => content != null)
        .cast<String>();
  }

  List<ChatCompletionMessage> _mapToOpenAIMessages(List<ChatMessage> messages) {
    return messages.map((message) {
      switch (message.origin) {
        case MessageOrigin.user:
          if (message.attachments.isEmpty) {
            return ChatCompletionMessage.user(
              content:
                  ChatCompletionUserMessageContent.string(message.text ?? ''),
            );
          }

          final parts = [
            ChatCompletionMessageContentPart.text(text: message.text ?? ''),
            for (final attachment in message.attachments)
              if (attachment is ImageFileAttachment)
                ChatCompletionMessageContentPart.image(
                  imageUrl: ChatCompletionMessageImageUrl(
                    url:
                        'data:${attachment.mimeType};base64,${base64Encode(attachment.bytes)}',
                  ),
                )
              else
                throw LlmFailureException(
                    'Unsupported attachment type: $attachment'),
          ];
          return ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.parts(parts),
          );
        case MessageOrigin.llm:
          return ChatCompletionMessage.assistant(
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
