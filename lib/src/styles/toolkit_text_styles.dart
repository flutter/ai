// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'toolkit_colors.dart';

/// A utility class that defines text styles for the Fat design system.
@immutable
abstract final class ToolkitTextStyles {
  /// Large display text style.
  ///
  /// Used for the most prominent text elements, typically headers or titles.
  static final TextStyle display = GoogleFonts.roboto(
    color: ToolkitColors.enabledText,
    fontSize: 32,
    fontWeight: FontWeight.w400,
  );

  /// Primary heading text style.
  ///
  /// Used for main section headings or important subheadings.
  static final TextStyle heading1 = GoogleFonts.roboto(
    color: ToolkitColors.enabledText,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  /// Secondary heading text style.
  ///
  /// Used for subsection headings or less prominent titles.
  static final TextStyle heading2 = GoogleFonts.roboto(
    color: ToolkitColors.enabledText,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  /// Primary body text style.
  ///
  /// Used for the main content text in the application.
  static final TextStyle body1 = GoogleFonts.roboto(
    color: ToolkitColors.enabledText,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  /// Code text style.
  ///
  /// Used for displaying code snippets or monospaced text.
  static final TextStyle code = GoogleFonts.robotoMono(
    color: ToolkitColors.enabledText,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  /// Secondary body text style.
  ///
  /// Used for less prominent body text or supporting information.
  static final TextStyle body2 = GoogleFonts.roboto(
    color: ToolkitColors.enabledText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// Tooltip text style.
  ///
  /// Used for the text of tooltips.
  static final TextStyle tooltip = GoogleFonts.roboto(
    color: ToolkitColors.tooltipText.withAlpha(230),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// Filename text style.
  ///
  /// Used for the text of file attachments.
  static final TextStyle filename = GoogleFonts.roboto(
    color: ToolkitColors.enabledText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// File type text style.
  ///
  /// Used for displaying the file type or MIME type of attachments.
  static final TextStyle filetype = GoogleFonts.roboto(
    color: ToolkitColors.hintText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// Label text style.
  ///
  /// Used for small labels, captions, or helper text.
  static final TextStyle label = GoogleFonts.roboto(
    color: ToolkitColors.enabledText,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  /// Primary body text style.
  ///
  /// Used for the main content text in the application.
  static final TextStyle link = GoogleFonts.roboto(
    color: ToolkitColors.link,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
    decorationColor: ToolkitColors.link,
  );
}
