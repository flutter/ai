// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'action_button_style.dart';
import 'action_button_type.dart';
import 'chat_input_style.dart';
import 'file_attachment_style.dart';
import 'llm_message_style.dart';
import 'suggestion_style.dart';
import 'toolkit_colors.dart';
import 'user_message_style.dart';

/// Style for the entire chat widget.
@immutable
class LlmChatViewStyle {
  /// Creates a style object for the chat widget.
  const LlmChatViewStyle({
    this.backgroundColor,
    this.progressIndicatorColor,
    this.userMessageStyle,
    this.llmMessageStyle,
    this.chatInputStyle,
    this.addButtonStyle,
    this.attachFileButtonStyle,
    this.cameraButtonStyle,
    this.stopButtonStyle,
    this.closeButtonStyle,
    this.cancelButtonStyle,
    this.copyButtonStyle,
    this.editButtonStyle,
    this.galleryButtonStyle,
    this.recordButtonStyle,
    this.submitButtonStyle,
    this.closeMenuButtonStyle,
    this.actionButtonBarDecoration,
    this.fileAttachmentStyle,
    this.suggestionStyle,
  });

  /// Resolves the provided [style] with the [defaultStyle].
  ///
  /// This method returns a new [LlmChatViewStyle] instance where each property
  /// is taken from the provided [style] if it is not null, otherwise from the
  /// [defaultStyle].
  ///
  /// - [style]: The style to resolve. If null, the [defaultStyle] will be used.
  /// - [defaultStyle]: The default style to use for any properties not provided
  ///   by the [style].
  factory LlmChatViewStyle.resolve(
    LlmChatViewStyle? style, {
    LlmChatViewStyle? defaultStyle,
  }) {
    defaultStyle ??= LlmChatViewStyle.defaultStyle();
    return LlmChatViewStyle(
      backgroundColor: style?.backgroundColor ?? defaultStyle.backgroundColor,
      progressIndicatorColor:
          style?.progressIndicatorColor ?? defaultStyle.progressIndicatorColor,
      userMessageStyle: UserMessageStyle.resolve(style?.userMessageStyle,
          defaultStyle: defaultStyle.userMessageStyle),
      llmMessageStyle: LlmMessageStyle.resolve(style?.llmMessageStyle,
          defaultStyle: defaultStyle.llmMessageStyle),
      chatInputStyle: ChatInputStyle.resolve(style?.chatInputStyle,
          defaultStyle: defaultStyle.chatInputStyle),
      addButtonStyle: ActionButtonStyle.resolve(
        style?.addButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.add),
      ),
      attachFileButtonStyle: ActionButtonStyle.resolve(
        style?.attachFileButtonStyle,
        defaultStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.attachFile),
      ),
      cameraButtonStyle: ActionButtonStyle.resolve(
        style?.cameraButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.camera),
      ),
      stopButtonStyle: ActionButtonStyle.resolve(
        style?.stopButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.stop),
      ),
      closeButtonStyle: ActionButtonStyle.resolve(
        style?.closeButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.close),
      ),
      cancelButtonStyle: ActionButtonStyle.resolve(
        style?.cancelButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.cancel),
      ),
      copyButtonStyle: ActionButtonStyle.resolve(
        style?.copyButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.copy),
      ),
      editButtonStyle: ActionButtonStyle.resolve(
        style?.editButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.edit),
      ),
      galleryButtonStyle: ActionButtonStyle.resolve(
        style?.galleryButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.gallery),
      ),
      recordButtonStyle: ActionButtonStyle.resolve(
        style?.recordButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.record),
      ),
      submitButtonStyle: ActionButtonStyle.resolve(
        style?.submitButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.submit),
      ),
      closeMenuButtonStyle: ActionButtonStyle.resolve(
        style?.closeMenuButtonStyle,
        defaultStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.closeMenu),
      ),
      actionButtonBarDecoration: style?.actionButtonBarDecoration ??
          defaultStyle.actionButtonBarDecoration,
      suggestionStyle: SuggestionStyle.resolve(
        style?.suggestionStyle,
        defaultStyle: defaultStyle.suggestionStyle,
      ),
    );
  }

  /// Provides default style if none is specified.
  factory LlmChatViewStyle.defaultStyle() => LlmChatViewStyle._lightStyle();

  /// Provides a default light style.
  factory LlmChatViewStyle._lightStyle() => LlmChatViewStyle(
        backgroundColor: ToolkitColors.containerBackground,
        progressIndicatorColor: ToolkitColors.black,
        userMessageStyle: UserMessageStyle.defaultStyle(),
        llmMessageStyle: LlmMessageStyle.defaultStyle(),
        chatInputStyle: ChatInputStyle.defaultStyle(),
        addButtonStyle: ActionButtonStyle.defaultStyle(ActionButtonType.add),
        stopButtonStyle: ActionButtonStyle.defaultStyle(ActionButtonType.stop),
        recordButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.record),
        submitButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.submit),
        closeMenuButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.closeMenu),
        attachFileButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.attachFile),
        galleryButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.gallery),
        cameraButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.camera),
        closeButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.close),
        cancelButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.cancel),
        copyButtonStyle: ActionButtonStyle.defaultStyle(ActionButtonType.copy),
        editButtonStyle: ActionButtonStyle.defaultStyle(ActionButtonType.edit),
        actionButtonBarDecoration: BoxDecoration(
          color: ToolkitColors.darkButtonBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        fileAttachmentStyle: FileAttachmentStyle.defaultStyle(),
        suggestionStyle: SuggestionStyle.defaultStyle(),
      );

  /// Background color of the entire chat widget.
  final Color? backgroundColor;

  /// The color of the progress indicator.
  final Color? progressIndicatorColor;

  /// Style for user messages.
  final UserMessageStyle? userMessageStyle;

  /// Style for LLM messages.
  final LlmMessageStyle? llmMessageStyle;

  /// Style for the input text box.
  final ChatInputStyle? chatInputStyle;

  /// Style for the add button.
  final ActionButtonStyle? addButtonStyle;

  /// Style for the attach file button.
  final ActionButtonStyle? attachFileButtonStyle;

  /// Style for the camera button.
  final ActionButtonStyle? cameraButtonStyle;

  /// Style for the stop button.
  final ActionButtonStyle? stopButtonStyle;

  /// Style for the close button.
  final ActionButtonStyle? closeButtonStyle;

  /// Style for the cancel button.
  final ActionButtonStyle? cancelButtonStyle;

  /// Style for the copy button.
  final ActionButtonStyle? copyButtonStyle;

  /// Style for the edit button.
  final ActionButtonStyle? editButtonStyle;

  /// Style for the gallery button.
  final ActionButtonStyle? galleryButtonStyle;

  /// Style for the record button.
  final ActionButtonStyle? recordButtonStyle;

  /// Style for the submit button.
  final ActionButtonStyle? submitButtonStyle;

  /// Style for the close menu button.
  final ActionButtonStyle? closeMenuButtonStyle;

  /// Decoration for the action button bar.
  final Decoration? actionButtonBarDecoration;

  /// Style for file attachments.
  final FileAttachmentStyle? fileAttachmentStyle;

  /// Style for suggestions.
  final SuggestionStyle? suggestionStyle;
}
