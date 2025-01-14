// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../../chat_view_model/chat_view_model_client.dart';
import '../../providers/interface/chat_message.dart';
import '../../styles/styles.dart';
import '../attachment_view/attachment_view.dart';
import 'adaptive_copy_text.dart';
import 'hovering_buttons.dart';

/// A widget that displays a user's message in a chat interface.
///
/// This widget is responsible for rendering the user's message, including any
/// attachments, in a right-aligned layout. It uses a [Row] and [Column] to
/// structure the content, with the message text displayed in a styled
/// container.
@immutable
class UserMessageView extends StatelessWidget {
  /// Creates a [UserMessageView].
  ///
  /// The [message] parameter is required and contains the [ChatMessage] to be
  /// displayed.
  const UserMessageView(this.message, {super.key, this.onEdit});

  /// The chat message to be displayed.
  final ChatMessage message;

  /// The callback to be invoked when the message is edited.
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ...[
            for (final attachment in message.attachments)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 80,
                    width: 200,
                    child: AttachmentView(attachment),
                  ),
                ),
              ),
          ],
          ChatViewModelClient(
            builder: (context, viewModel, child) {
              final text = message.text!;
              final chatStyle = LlmChatViewStyle.resolve(viewModel.style);
              final userStyle = UserMessageStyle.resolve(
                chatStyle.userMessageStyle,
              );

              return Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: HoveringButtons(
                    isUserMessage: true,
                    chatStyle: chatStyle,
                    clipboardText: text,
                    onEdit: onEdit,
                    child: DecoratedBox(
                      decoration: userStyle.decoration!,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 12,
                          bottom: 12,
                        ),
                        child: AdaptiveCopyText(
                          chatStyle: chatStyle,
                          clipboardText: text,
                          onEdit: onEdit,
                          child: Text(text, style: userStyle.textStyle),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
}
