// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

import '../providers/interface/llm_provider.dart';
import '../styles/llm_chat_view_style.dart';
import '../views/response_builder.dart';

@immutable

/// A view model class for managing chat interactions and configurations.
///
/// This class encapsulates the core data and functionality needed for the chat
/// interface, including the LLM provider, style configuration, welcome message,
/// response builder, and message sender.
class ChatViewModel {
  /// Creates a new [ChatViewModel] instance.
  ///
  /// [provider] is the required [LlmProvider] for handling LLM interactions.
  /// [style] is the optional [LlmChatViewStyle] for customizing the chat view's
  /// appearance. [welcomeMessage] is an optional message displayed when the
  /// chat interface is first opened. [responseBuilder] is an optional builder
  /// for customizing chat responses. [messageSender] is an optional
  /// [LlmStreamGenerator] for sending messages.
  const ChatViewModel({
    required this.provider,
    required this.style,
    required this.welcomeMessage,
    required this.responseBuilder,
    required this.messageSender,
  });

  /// The LLM provider for the chat interface.
  ///
  /// This provider is responsible for managing interactions with the language
  /// model, including sending and receiving messages.
  final LlmProvider provider;

  /// The style configuration for the chat view.
  ///
  /// Defines visual properties like colors, decorations, and layout parameters
  /// for the chat interface. If null, default styling will be applied.
  final LlmChatViewStyle? style;

  /// The welcome message to display in the chat interface.
  ///
  /// This message is shown to users when they first open the chat interface,
  /// providing a friendly introduction or prompt.
  final String? welcomeMessage;

  /// The builder for the chat response.
  ///
  /// This builder allows for customization of how chat responses are rendered
  /// in the interface, enabling tailored presentation of messages.
  final ResponseBuilder? responseBuilder;

  /// The message sender for the chat interface.
  ///
  /// This optional generator is used to send messages to the LLM, allowing for
  /// asynchronous communication and response handling.
  final LlmStreamGenerator? messageSender;

  // The following is needed to support the
  // ChatViewModelProvider.updateShouldNotify implementation
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatViewModel &&
          other.provider == provider &&
          other.style == style &&
          other.welcomeMessage == welcomeMessage &&
          other.responseBuilder == responseBuilder &&
          other.messageSender == messageSender);

  // the following is best practices when overriding operator ==
  @override
  int get hashCode => Object.hash(
        provider,
        style,
        welcomeMessage,
        responseBuilder,
        messageSender,
      );
}
