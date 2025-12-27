import 'dart:async';

import 'package:flutter/cupertino.dart' show DefaultCupertinoLocalizations;
import 'package:flutter/material.dart'
    show
        DefaultMaterialLocalizations,
        SelectionArea,
        DefaultWidgetsLocalizations;
import 'package:flutter/widgets.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../../utility.dart';

/// A widget that displays text with adaptive copy functionality.
///
/// This widget provides a context menu for copying text to the clipboard on
/// mobile devices, and a selection area for mouse-driven selection on desktop
/// and web platforms.
@immutable
class AdaptiveCopyText extends StatelessWidget {
  /// Creates an [AdaptiveCopyText] widget.
  ///
  /// The [clipboardText] parameter is required and contains the text to be
  /// copied to the clipboard. The [child] parameter is required and contains
  /// the widget to be displayed. The [chatStyle] parameter is required and
  /// contains the style information for the chat. The [onEdit] parameter is
  /// optional and contains the callback to be invoked when the text is edited.
  const AdaptiveCopyText({
    required this.clipboardText,
    required this.child,
    required this.chatStyle,
    required this.chatStrings,
    this.onEdit,
    super.key,
  });

  /// The text to be copied to the clipboard.
  final String clipboardText;

  /// The widget to be displayed.
  final Widget child;

  /// The callback to be invoked when the text is edited.
  final VoidCallback? onEdit;

  /// The style information for the chat.
  final LlmChatViewStyle chatStyle;

  /// The strings used for text in the chat interface.
  final LlmChatViewStrings chatStrings;

  @override
  Widget build(BuildContext context) {
    final contextMenu = ContextMenu<dynamic>(
      entries: [
        if (onEdit != null)
          MenuItem<dynamic>(
            label: Text(chatStrings.edit),
            icon: Icon(chatStyle.editButtonStyle!.icon),
            onSelected: (_) => onEdit?.call(),
          ),
        MenuItem<dynamic>(
          label: Text(chatStrings.copy),
          icon: Icon(chatStyle.copyButtonStyle!.icon),
          onSelected:
              (_) => unawaited(
                copyToClipboard(
                  context,
                  clipboardText,
                  chatStrings.copyToClipboard,
                ),
              ),
        ),
      ],
    );

    // On mobile, show the context menu for long-press;
    // on desktop and web, show the selection area for mouse-driven selection.
    return isMobile
        ? ContextMenuRegion(contextMenu: contextMenu, child: child)
        : isCupertinoApp(context)
        // Ensure MaterialLocalizations is available for SelectionArea
        ? Localizations(
          locale: Localizations.localeOf(context),
          delegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          child: SelectionArea(child: child),
        )
        : SelectionArea(child: child);
  }
}
