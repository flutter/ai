// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// by convention, using the names of the icons as the constant names
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

/// A collection of custom icons used in the Fat application.
///
/// This class provides a set of static [IconData] constants that can be used
/// to display custom icons in the application. These icons are part of a custom
/// font called 'FatIcons'.
/// Material Design Icons, Copyright (C) Google, Inc
///         Author:    Google
///         License:   Apache 2.0 (https://www.apache.org/licenses/LICENSE-2.0)
///         Homepage:  https://design.google.com/icons/
///
@immutable
class ToolkitIcons {
  const ToolkitIcons._();

  static const _kFontFam = 'FatIcons';
  static const String _kFontPkg = 'flutter_ai_toolkit';

  /// Icon for submitting or sending.
  static const IconData submit_icon =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  /// Icon representing a spark or idea.
  static const IconData spark_icon =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  /// Icon for adding or creating new items.
  static const IconData add =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  /// Icon for attaching files.
  static const IconData attach_file =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  /// Icon for stopping or halting an action.
  static const IconData stop =
      IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  /// Icon representing a microphone.
  static const IconData mic =
      IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  /// Icon for closing or dismissing.
  static const IconData close =
      IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  /// Icon representing a camera.
  static const IconData camera_alt =
      IconData(0xe807, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  /// Icon representing an image or picture.
  static const IconData image =
      IconData(0xe808, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  /// Icon for editing.
  static const IconData edit =
      IconData(0xe809, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  /// Icon for copying content.
  static const IconData content_copy =
      IconData(0xe80a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
