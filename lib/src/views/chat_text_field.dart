// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart'
    show
        CupertinoTextField,
        CupertinoAdaptiveTextSelectionToolbar,
        CupertinoLocalizations;
import 'package:flutter/material.dart'
    show
        InputBorder,
        InputDecoration,
        TextField,
        TextInputAction,
        ContextMenuController,
        AdaptiveTextSelectionToolbar,
        MaterialLocalizations;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mac_menu_bar/mac_menu_bar.dart';
import 'package:super_clipboard/super_clipboard.dart';
import '../helpers/paste_helper/paste_handler.dart';
import '../helpers/paste_helper/paste_helper.dart' as pst;
import 'package:universal_platform/universal_platform.dart';
import '../providers/interface/attachments.dart';

import '../styles/toolkit_colors.dart';
import '../utility.dart';

/// A text field that adapts to the current app style (Material or Cupertino).
///
/// This widget will render either a [CupertinoTextField] or a [TextField]
/// depending on whether the app is using Cupertino or Material design.
@immutable
class ChatTextField extends StatefulWidget {
  /// Creates an adaptive text field.
  ///
  /// Many of the parameters are required to ensure consistent behavior
  /// across both Cupertino and Material designs.
  const ChatTextField({
    required this.minLines,
    required this.maxLines,
    required this.autofocus,
    required this.style,
    required this.textInputAction,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    this.onAttachments,
    required this.hintText,
    required this.hintStyle,
    required this.hintPadding,
    super.key,
  });

  /// The minimum number of lines to show.
  final int minLines;

  /// The maximum number of lines to show.
  final int maxLines;

  /// Whether the text field should be focused initially.
  final bool autofocus;

  /// The style to use for the text being edited.
  final TextStyle style;

  /// The type of action button to use for the keyboard.
  final TextInputAction textInputAction;

  /// Controls the text being edited.
  final TextEditingController controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode focusNode;

  /// The text to show when the text field is empty.
  final String hintText;

  /// The style to use for the hint text.
  final TextStyle hintStyle;

  /// The padding to use for the hint text.
  final EdgeInsetsGeometry? hintPadding;

  /// Called when the user submits editable content.
  final void Function(String text) onSubmitted;

  /// Called when attachments are pasted into the text field.
  final void Function(List<Attachment> attachments)? onAttachments;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  /// Inserts text at the current cursor position in the text controller.
  ///
  /// If there's a text selection, it will be replaced by the new text.
  /// If there's no selection, the text will be inserted at the cursor position.
  ///
  /// Parameters:
  ///   - [controller]: The text editing controller to insert text into
  ///   - [text]: The text to insert
  void _insertText({
    required TextEditingController controller,
    required String text,
  }) {
    final cursorPosition = controller.selection.base.offset;
    if (cursorPosition == -1) {
      controller.text = text;
    } else {
      final newText = controller.text.replaceRange(
        controller.selection.start,
        controller.selection.end,
        text,
      );
      controller.value = controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
          offset: controller.selection.start + text.length,
        ),
      );
    }
  }

  Future registerListeners() async {
    if (UniversalPlatform.isMacOS) {
      MacMenuBar.onPaste(() async {
        await _handlePaste();
        return true;
      });

      MacMenuBar.onCopy(_copyToClipboard);
      MacMenuBar.onCut(_cutToClipboard);
      MacMenuBar.onSelectAll(_selectAll);
    }
    return pst.handlePasteWeb(
      controller: widget.controller,
      onAttachments: widget.onAttachments,
      insertText: _insertText,
    );
  }

  Future<void> _handlePaste() async {
    return handlePaste(
      controller: widget.controller,
      onAttachments: widget.onAttachments,
      insertText: _insertText,
    );
  }

  /// Copies the currently selected text to the system clipboard.
  ///
  /// If there is a text selection, it will be copied to the clipboard.
  /// If no text is selected, this method does nothing.
  ///
  /// Returns `true` if the operation was successful, `false` otherwise.
  /// This method is typically called when the user triggers the copy command
  /// from the mac menu bar.
  Future<bool> _copyToClipboard() async {
    final selection = TextSelection(
      baseOffset: widget.controller.selection.start,
      extentOffset: widget.controller.selection.end,
    );

    if (selection.isValid && !selection.isCollapsed) {
      final selectedText = widget.controller.text.substring(
        selection.start,
        selection.end,
      );
      final data = DataWriterItem();
      data.add(Formats.plainText(selectedText));
      await SystemClipboard.instance?.write([data]);
    }
    return true;
  }

  /// Selects all text in the text field.
  ///
  /// This method updates the text selection to include all characters
  /// in the text field's content. The selection will have its base at the
  /// start of the text and its extent at the end.
  ///
  /// Returns `true` to indicate successful completion.
  /// This method is typically called when the user triggers the select all command
  /// (e.g., Cmd+A on macOS or Ctrl+A on other platforms).
  Future<bool> _selectAll() async {
    widget.controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.controller.text.length,
    );
    return true;
  }

  /// Cuts the currently selected text to the system clipboard and removes it from the text field.
  ///
  /// If there is a text selection, it will be copied to the clipboard and then
  /// removed from the text field. The cursor will be positioned at the start
  /// of the original selection after the cut operation.
  ///
  /// Returns `true` if the operation was successful, `false` otherwise.
  /// This method is typically called when the user triggers the cut command
  /// (e.g., Cmd+X on macOS or Ctrl+X on other platforms).
  Future<bool> _cutToClipboard() async {
    final selection = widget.controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      final selectedText = widget.controller.text.substring(
        selection.start,
        selection.end,
      );

      final data = DataWriterItem();
      data.add(Formats.plainText(selectedText));
      await SystemClipboard.instance?.write([data]);

      final newValue = widget.controller.value;
      final newText = newValue.text.replaceRange(
        selection.start,
        selection.end,
        '',
      );

      widget.controller.value = newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start),
        composing: TextRange.empty,
      );
    }
    return true;
  }

  @override
  void initState() {
    registerListeners();
    super.initState();
  }

  @override
  void dispose() {
    pst.unregisterPasteListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.enter):
            () => widget.onSubmitted(widget.controller.text),
        if (UniversalPlatform.isMacOS)
          const SingleActivator(LogicalKeyboardKey.keyV, meta: true):
              _handlePaste,
        if (UniversalPlatform.isWindows || UniversalPlatform.isLinux)
          const SingleActivator(LogicalKeyboardKey.keyV, control: true):
              _handlePaste,
      },
      child: _buildAdaptiveTextField(context),
    );
  }

  Widget _buildAdaptiveTextField(BuildContext context) {
    return isCupertinoApp(context)
        ? CupertinoTextField(
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          autofocus: widget.autofocus,
          style: widget.style,
          textInputAction: widget.textInputAction,
          controller: widget.controller,
          focusNode: widget.focusNode,
          onSubmitted: widget.onSubmitted,
          placeholder: widget.hintText,
          placeholderStyle: widget.hintStyle,
          padding: widget.hintPadding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(width: 0, color: ToolkitColors.transparent),
          ),
          keyboardType: TextInputType.multiline,
          contextMenuBuilder: (context, editable) {
            final l10n = CupertinoLocalizations.of(context);
            final defaultItems = editable.contextMenuButtonItems;

            final filteredItems = defaultItems.where((item) {
              return item.type.name != 'paste';
            });

            final customItems = [
              ContextMenuButtonItem(
                label: l10n.pasteButtonLabel,
                onPressed: () async {
                  ContextMenuController.removeAny();
                  await _handlePaste();
                },
              ),
              ...filteredItems,
            ];

            return CupertinoAdaptiveTextSelectionToolbar.buttonItems(
              anchors: editable.contextMenuAnchors,
              buttonItems: customItems,
            );
          },
        )
        : TextField(
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          autofocus: widget.autofocus,
          style: widget.style,
          textInputAction: widget.textInputAction,
          controller: widget.controller,
          focusNode: widget.focusNode,
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
            border: InputBorder.none,
            contentPadding: widget.hintPadding,
            isDense: false,
          ),
          keyboardType: TextInputType.multiline,
          contextMenuBuilder: (context, editable) {
            final defaultItems = editable.contextMenuButtonItems;

            final filteredItems = defaultItems.where((item) {
              return item.type.name != 'paste';
            });

            final customItems = [
              ContextMenuButtonItem(
                label: MaterialLocalizations.of(context).pasteButtonLabel,
                onPressed: () async {
                  ContextMenuController.removeAny();
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await _handlePaste();
                  });
                },
              ),
              ...filteredItems,
            ];
            return AdaptiveTextSelectionToolbar.buttonItems(
              anchors: editable.contextMenuAnchors,
              buttonItems: customItems,
            );
          },
        );
  }
}
