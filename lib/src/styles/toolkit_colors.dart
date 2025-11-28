// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// A collection of color constants used throughout the application.
@immutable
abstract final class ToolkitColors {
  /// Fully transparent color.
  static const Color transparent = Color(0x00000000);

  /// Pure black color.
  static const Color black = Color(0xFF000000);

  /// Pure red color.
  static const Color red = Color(0xFFFF0000);
  // Color 0 (#FFFFFF)
  /// White color used for button backgrounds.
  static const Color whiteButtonBackground = Color(0xFFFFFFFF);

  /// White color used for container backgrounds.
  static const Color containerBackground = Color(0xFFFFFFFF);

  /// White color used for LLM message backgrounds.
  static const Color llmMessageBackground = Color(0xFFFFFFFF);

  /// White color used for LLM message outlines.
  static const Color llmMessageOutline = Color(0xFFFFFFFF);

  /// White color used for icons.
  static const Color whiteIcon = Color(0xFFFFFFFF);

  /// White color used for tooltip text.
  static const Color tooltipText = Color(0xFFFFFFFF);

  // Color 100 (#F5F5F5)
  /// Light gray color used for user message backgrounds.
  static const Color userMessageBackground = Color(0xFFF5F5F5);

  /// Light gray color used for file container backgrounds.
  static const Color fileContainerBackground = Color(0xFFF5F5F5);

  /// Light gray color used for light button backgrounds.
  static const Color lightButtonBackground = Color(0xFFF5F5F5);

  /// Light gray color used for dark button icons.
  static const Color darkButtonIcon = Color(0xFFF5F5F5);

  // Color 200 (#E5E5E5)
  /// Light gray color used for outlines.
  static const Color outline = Color(0xFFE5E5E5);

  /// Light gray color used for LLM icon backgrounds.
  static const Color llmIconBackground = Color(0xFFE5E5E5);

  /// Light gray color used for disabled buttons.
  static const Color disabledButton = Color(0xFFE5E5E5);

  // Color 300 (#CACACA)
  /// Gray color used for hint text.
  static const Color hintText = Color(0xFFCACACA);

  /// Gray color used for file attachment icon backgrounds.
  static const Color fileAttachmentIconBackground = Color(0xFFCACACA);

  /// Gray color used for grey button backgrounds.
  static const Color greyButtonBackground = Color(0xFFCACACA);

  /// Gray color used for light icons.
  static const Color lightIcon = Color(0xFFCACACA);

  /// Gray color used for image placeholders.
  static const Color imagePlaceholder = Color(0xFFCACACA);

  /// Gray color used for light pagination circles.
  static const Color lightPaginationCircle = Color(0xFFCACACA);

  /// Gray color used for light voice bar lines.
  static const Color lightVoiceBarLine = Color(0xFFCACACA);

  // Color 400 (#535353)
  /// Dark gray color used for grey backgrounds.
  static const Color greyBackground = Color(0xFF535353);

  /// Dark gray color used for LLM name text.
  static const Color llmNameText = Color(0xFF535353);

  /// Dark gray color used for tooltip backgrounds.
  static const Color tooltipBackground = Color(0xFF535353);

  // Color 500 (#2F2F2F)
  /// Very dark gray color used for dark button backgrounds.
  static const Color darkButtonBackground = Color(0xFF2F2F2F);

  /// Very dark gray color used for dark icons.
  static const Color darkIcon = Color(0xFF2F2F2F);

  /// Very dark gray color used for enabled text.
  static const Color enabledText = Color(0xFF2F2F2F);

  /// Blue color used for links.
  static const Color link = Color(0xFF1E88E5);
}
