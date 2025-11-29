// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'tookit_icons.dart';
import 'toolkit_colors.dart';
import 'toolkit_text_styles.dart';

/// Style for LLM messages.
@immutable
class LlmMessageStyle {
  /// Creates an LlmMessageStyle.
  const LlmMessageStyle({
    this.icon,
    this.iconColor,
    this.iconDecoration,
    this.decoration,
    this.markdownStyle,
    this.maxWidth = 600.0,
    this.minWidth = 300.0,
    this.flex = 6,
    this.padding = const EdgeInsets.all(12.0),
    this.margin = const EdgeInsets.symmetric(vertical: 4.0),
  });

  /// Resolves the provided style with the default style.
  ///
  /// This method creates a new [LlmMessageStyle] by combining the provided
  /// [style] with the [defaultStyle]. If a property is not specified in the
  /// provided [style], it falls back to the corresponding property in the
  /// [defaultStyle].
  ///
  /// If [defaultStyle] is not provided, it uses [LlmMessageStyle.defaultStyle].
  ///
  /// Parameters:
  ///   - [style]: The custom style to apply. Can be null.
  ///   - [defaultStyle]: The default style to use as a fallback. If null, uses
  ///     [LlmMessageStyle.defaultStyle].
  ///
  /// Returns: A new [LlmMessageStyle] instance with resolved properties.
  factory LlmMessageStyle.resolve(
    LlmMessageStyle? style, {
    LlmMessageStyle? defaultStyle,
  }) {
    defaultStyle ??= LlmMessageStyle.defaultStyle();
    return LlmMessageStyle(
      icon: style?.icon ?? defaultStyle.icon,
      iconColor: style?.iconColor ?? defaultStyle.iconColor,
      iconDecoration: style?.iconDecoration ?? defaultStyle.iconDecoration,
      markdownStyle: style?.markdownStyle ?? defaultStyle.markdownStyle,
      decoration: style?.decoration ?? defaultStyle.decoration,
      maxWidth: style?.maxWidth ?? defaultStyle.maxWidth,
      minWidth: style?.minWidth ?? defaultStyle.minWidth,
      flex: style?.flex ?? defaultStyle.flex,
      padding: style?.padding ?? defaultStyle.padding,
      margin: style?.margin ?? defaultStyle.margin,
    );
  }

  /// Provides a default style.
  factory LlmMessageStyle.defaultStyle() => LlmMessageStyle._lightStyle();

  /// Provides a default light style.
  factory LlmMessageStyle._lightStyle() => LlmMessageStyle(
    icon: ToolkitIcons.spark_icon,
    iconColor: ToolkitColors.darkIcon,
    iconDecoration: const BoxDecoration(
      color: ToolkitColors.llmIconBackground,
      shape: BoxShape.circle,
    ),
    markdownStyle: MarkdownStyleSheet(
      a: ToolkitTextStyles.link,
      blockquote: ToolkitTextStyles.body1,
      checkbox: ToolkitTextStyles.body1,
      code: ToolkitTextStyles.code,
      del: ToolkitTextStyles.body1,
      em: ToolkitTextStyles.body1.copyWith(fontStyle: FontStyle.italic),
      h1: ToolkitTextStyles.heading1,
      h2: ToolkitTextStyles.heading2,
      h3: ToolkitTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
      h4: ToolkitTextStyles.body1,
      h5: ToolkitTextStyles.body1,
      h6: ToolkitTextStyles.body1,
      listBullet: ToolkitTextStyles.body1,
      img: ToolkitTextStyles.body1,
      strong: ToolkitTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
      p: ToolkitTextStyles.body1,
      tableBody: ToolkitTextStyles.body1,
      tableHead: ToolkitTextStyles.body1,
    ),
    decoration: BoxDecoration(
      color: ToolkitColors.llmMessageBackground,
      border: Border.all(color: ToolkitColors.llmMessageOutline),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.zero,
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
  );

  /// Creates a copy of this style with the given fields replaced by the new values.
  LlmMessageStyle copyWith({
    BoxDecoration? decoration,
    IconData? icon,
    Color? iconColor,
    BoxDecoration? iconDecoration,
    MarkdownStyleSheet? markdownStyle,
    double? maxWidth,
    double? minWidth,
    int? flex,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return LlmMessageStyle(
      decoration: decoration ?? this.decoration,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconDecoration: iconDecoration ?? this.iconDecoration,
      markdownStyle: markdownStyle ?? this.markdownStyle,
      maxWidth: maxWidth ?? this.maxWidth,
      minWidth: minWidth ?? this.minWidth,
      flex: flex ?? this.flex,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
    );
  }

  /// The icon to display for the LLM messages.
  final IconData? icon;

  /// The color of the icon.
  final Color? iconColor;

  /// The decoration for the icon.
  final Decoration? iconDecoration;

  /// The decoration for LLM message bubbles.
  final Decoration? decoration;

  /// The markdown style sheet for LLM messages.
  final MarkdownStyleSheet? markdownStyle;

  /// The maximum width of the message bubble.
  final double maxWidth;

  /// The minimum width of the message bubble.
  final double minWidth;

  /// The flex value used in the row layout.
  final int flex;

  /// The padding inside the message bubble.
  final EdgeInsets padding;

  /// The margin around the message bubble.
  final EdgeInsets margin;
}
