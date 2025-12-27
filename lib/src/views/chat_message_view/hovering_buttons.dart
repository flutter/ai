import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../styles/llm_chat_view_style.dart';
import '../../utility.dart';

/// A widget that displays hovering buttons for editing and copying.
///
/// This widget is a [StatefulWidget] that shows buttons for editing and copying
/// when the user hovers over the child widget. The buttons are displayed at the
/// bottom right of the child widget.
class HoveringButtons extends StatelessWidget {
  /// Creates a [HoveringButtons] widget.
  ///
  /// The [onEdit] callback is invoked when the edit button is pressed. The
  /// [child] widget is the content over which the buttons will hover.
  HoveringButtons({
    required this.chatStyle,
    required this.isUserMessage,
    required this.child,
    this.clipboardText,
    required this.clipboardMessage,
    this.onEdit,
    super.key,
  });

  /// The style information for the chat.
  final LlmChatViewStyle chatStyle;

  /// Whether the message is a user message.
  final bool isUserMessage;

  /// The text to be copied to the clipboard.
  final String? clipboardText;

  ///The text to be shown when copying to the clipboard.
  final String clipboardMessage;

  /// The child widget over which the buttons will hover.
  final Widget child;

  /// The callback to be invoked when the edit button is pressed.
  final VoidCallback? onEdit;

  static const _iconSize = 16;
  final _hovering = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final paddedChild = Padding(
      padding: const EdgeInsets.only(bottom: _iconSize + 2),
      child: child,
    );

    return clipboardText == null
        ? paddedChild
        : MouseRegion(
          onEnter: (_) => _hovering.value = true,
          onExit: (_) => _hovering.value = false,
          child: Stack(
            children: [
              paddedChild,
              ListenableBuilder(
                listenable: _hovering,
                builder:
                    (context, child) =>
                        _hovering.value
                            ? Positioned(
                              bottom: 0,
                              right: isUserMessage ? 0 : null,
                              left: isUserMessage ? null : 32,
                              child: Row(
                                spacing: 6,
                                children: [
                                  if (onEdit != null)
                                    GestureDetector(
                                      onTap: onEdit,
                                      child: Icon(
                                        chatStyle.editButtonStyle!.icon,
                                        size: _iconSize.toDouble(),
                                        color: invertColor(
                                          chatStyle.editButtonStyle!.iconColor,
                                        ),
                                      ),
                                    ),
                                  GestureDetector(
                                    onTap:
                                        () => unawaited(
                                          copyToClipboard(
                                            context,
                                            clipboardText!,
                                            clipboardMessage,
                                          ),
                                        ),
                                    child: Icon(
                                      chatStyle.copyButtonStyle!.icon,
                                      size: 12,
                                      color: invertColor(
                                        chatStyle.copyButtonStyle!.iconColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : const SizedBox(),
              ),
            ],
          ),
        );
  }
}
