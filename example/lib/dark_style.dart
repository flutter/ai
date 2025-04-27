// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

LlmChatViewStyle darkChatViewStyle() {
  final style = LlmChatViewStyle.defaultStyle();
  return LlmChatViewStyle(
    backgroundColor: _invertColor(style.backgroundColor),
    menuColor: Colors.grey.shade800,
    progressIndicatorColor: _invertColor(style.progressIndicatorColor),
    userMessageStyle: _darkUserMessageStyle(),
    llmMessageStyle: _darkLlmMessageStyle(),
    chatInputStyle: _darkChatInputStyle(),
    addButtonStyle: _darkActionButtonStyle(ActionButtonType.add),
    attachFileButtonStyle: _darkActionButtonStyle(ActionButtonType.attachFile),
    cameraButtonStyle: _darkActionButtonStyle(ActionButtonType.camera),
    stopButtonStyle: _darkActionButtonStyle(ActionButtonType.stop),
    recordButtonStyle: _darkActionButtonStyle(ActionButtonType.record),
    submitButtonStyle: _darkActionButtonStyle(ActionButtonType.submit),
    closeMenuButtonStyle: _darkActionButtonStyle(ActionButtonType.closeMenu),
    actionButtonBarDecoration: _invertDecoration(
      style.actionButtonBarDecoration,
    ),
    fileAttachmentStyle: _darkFileAttachmentStyle(),
    suggestionStyle: _darkSuggestionStyle(),
    closeButtonStyle: _darkActionButtonStyle(ActionButtonType.close),
    cancelButtonStyle: _darkActionButtonStyle(ActionButtonType.cancel),
    copyButtonStyle: _darkActionButtonStyle(ActionButtonType.copy),
    editButtonStyle: _darkActionButtonStyle(ActionButtonType.edit),
    galleryButtonStyle: _darkActionButtonStyle(ActionButtonType.gallery),
  );
}

UserMessageStyle _darkUserMessageStyle() {
  final style = UserMessageStyle.defaultStyle();
  return UserMessageStyle(
    textStyle: _invertTextStyle(style.textStyle),
    // inversion doesn't look great here
    // decoration: invertDecoration(style.decoration),
    decoration: (style.decoration! as BoxDecoration).copyWith(
      color: _greyBackground,
    ),
  );
}

LlmMessageStyle _darkLlmMessageStyle() {
  final style = LlmMessageStyle.defaultStyle();
  return LlmMessageStyle(
    icon: style.icon,
    iconColor: _invertColor(style.iconColor),
    // inversion doesn't look great here
    // iconDecoration: invertDecoration(style.iconDecoration),
    iconDecoration: BoxDecoration(
      color: _greyBackground,
      shape: BoxShape.circle,
    ),
    markdownStyle: _invertMarkdownStyle(style.markdownStyle),
    decoration: _invertDecoration(style.decoration),
  );
}

ChatInputStyle _darkChatInputStyle() {
  final style = ChatInputStyle.defaultStyle();
  return ChatInputStyle(
    decoration: _invertDecoration(style.decoration),
    textStyle: _invertTextStyle(style.textStyle),
    // inversion doesn't look great here
    // hintStyle: invertTextStyle(style.hintStyle),
    hintStyle: GoogleFonts.roboto(
      color: _greyBackground,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    hintText: style.hintText,
    backgroundColor: _invertColor(style.backgroundColor),
  );
}

ActionButtonStyle _darkActionButtonStyle(ActionButtonType type) {
  final style = ActionButtonStyle.defaultStyle(type);
  return ActionButtonStyle(
    icon: style.icon,
    iconColor: _invertColor(style.iconColor),
    iconDecoration: switch (type) {
      ActionButtonType.add ||
      ActionButtonType.record ||
      ActionButtonType.stop => BoxDecoration(
        color: _greyBackground,
        shape: BoxShape.circle,
      ),
      _ => _invertDecoration(style.iconDecoration),
    },
    text: style.text,
    textStyle: _invertTextStyle(style.textStyle),
  );
}

FileAttachmentStyle _darkFileAttachmentStyle() {
  final style = FileAttachmentStyle.defaultStyle();
  return FileAttachmentStyle(
    // inversion doesn't look great here
    // decoration: invertDecoration(style.decoration),
    decoration: ShapeDecoration(
      color: _greyBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    icon: style.icon,
    iconColor: _invertColor(style.iconColor),
    iconDecoration: _invertDecoration(style.iconDecoration),
    filenameStyle: _invertTextStyle(style.filenameStyle),
    // inversion doesn't look great here
    // filetypeStyle: invertTextStyle(style.filetypeStyle),
    filetypeStyle: style.filetypeStyle!.copyWith(color: Colors.black),
  );
}

SuggestionStyle _darkSuggestionStyle() {
  final style = SuggestionStyle.defaultStyle();
  return SuggestionStyle(
    textStyle: _invertTextStyle(style.textStyle),
    decoration: BoxDecoration(
      color: _greyBackground,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );
}

const Color _greyBackground = Color(0xFF535353);

Color? _invertColor(Color? color) =>
    color != null
        ? Color.from(
          alpha: color.a,
          red: 1 - color.r,
          green: 1 - color.g,
          blue: 1 - color.b,
        )
        : null;

Decoration _invertDecoration(Decoration? decoration) => switch (decoration!) {
  final BoxDecoration d => d.copyWith(color: _invertColor(d.color)),
  final ShapeDecoration d => ShapeDecoration(
    color: _invertColor(d.color),
    shape: d.shape,
    shadows: d.shadows,
    image: d.image,
    gradient: d.gradient,
  ),
  _ => decoration,
};

TextStyle _invertTextStyle(TextStyle? style) =>
    style!.copyWith(color: _invertColor(style.color));

MarkdownStyleSheet? _invertMarkdownStyle(MarkdownStyleSheet? markdownStyle) =>
    markdownStyle?.copyWith(
      a: _invertTextStyle(markdownStyle.a),
      blockquote: _invertTextStyle(markdownStyle.blockquote),
      checkbox: _invertTextStyle(markdownStyle.checkbox),
      code: _invertTextStyle(markdownStyle.code),
      del: _invertTextStyle(markdownStyle.del),
      em: _invertTextStyle(markdownStyle.em),
      strong: _invertTextStyle(markdownStyle.strong),
      p: _invertTextStyle(markdownStyle.p),
      tableBody: _invertTextStyle(markdownStyle.tableBody),
      tableHead: _invertTextStyle(markdownStyle.tableHead),
      h1: _invertTextStyle(markdownStyle.h1),
      h2: _invertTextStyle(markdownStyle.h2),
      h3: _invertTextStyle(markdownStyle.h3),
      h4: _invertTextStyle(markdownStyle.h4),
      h5: _invertTextStyle(markdownStyle.h5),
      h6: _invertTextStyle(markdownStyle.h6),
      listBullet: _invertTextStyle(markdownStyle.listBullet),
      img: _invertTextStyle(markdownStyle.img),
    );
