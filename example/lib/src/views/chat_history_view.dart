// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../chat_view_model/chat_view_model_client.dart';
import '../providers/interface/chat_message.dart';
import '../providers/interface/message_origin.dart';
import 'chat_message_view/llm_message_view.dart';
import 'chat_message_view/user_message_view.dart';

/// A widget that displays a history of chat messages.
///
/// This widget renders a scrollable list of chat messages, supporting
/// selection and editing of messages. It displays messages in reverse
/// chronological order (newest at the bottom).
@immutable
class ChatHistoryView extends StatefulWidget {
  /// Creates a [ChatHistoryView].
  ///
  /// If [onEditMessage] is provided, it will be called when a user initiates an
  /// edit action on an editable message (typically the last user message in the
  /// history).
  const ChatHistoryView({
    this.onEditMessage,
    super.key,
  });

  /// Optional callback function for editing a message.
  ///
  /// If provided, this function will be called when a user initiates an edit
  /// action on an editable message (typically the last user message in the
  /// history). The function receives the [ChatMessage] to be edited as its
  /// parameter.
  final void Function(ChatMessage message)? onEditMessage;

  @override
  State<ChatHistoryView> createState() => _ChatHistoryViewState();
}

class _ChatHistoryViewState extends State<ChatHistoryView> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: ChatViewModelClient(
          builder: (context, viewModel, child) {
            final history = [
              if (viewModel.welcomeMessage != null)
                ChatMessage(
                  origin: MessageOrigin.llm,
                  text: viewModel.welcomeMessage,
                  attachments: [],
                ),
              ...viewModel.provider.history,
            ];

            return ListView.builder(
              reverse: true,
              itemCount: history.length,
              itemBuilder: (context, index) {
                final messageIndex = history.length - index - 1;
                final message = history[messageIndex];
                final isLastUserMessage =
                    message.origin.isUser && messageIndex >= history.length - 2;
                final canEdit =
                    isLastUserMessage && widget.onEditMessage != null;
                final isUser = message.origin.isUser;

                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: isUser
                      ? UserMessageView(
                          message,
                          onEdit: canEdit
                              ? () => widget.onEditMessage?.call(message)
                              : null,
                        )
                      : LlmMessageView(
                          message,
                          isWelcomeMessage: messageIndex == 0,
                        ),
                );
              },
            );
          },
        ),
      );
}
