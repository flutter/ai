// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/cupertino.dart' show BuildContext, CupertinoApp;
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

import 'dialogs/adaptive_snack_bar/adaptive_snack_bar.dart';

bool? _isCupertinoApp;

/// Determines if the current application is a Cupertino-style app.
///
/// This function checks the widget tree for the presence of a [CupertinoApp]
/// widget. If found, it indicates that the app is using Cupertino (iOS-style)
/// widgets.
///
/// Parameters:
///   * [context]: The [BuildContext] used to search the widget tree.
///
/// Returns: A [bool] value. `true` if a [CupertinoApp] is found in the widget
///   tree, `false` otherwise.
bool isCupertinoApp(BuildContext context) {
  // caching the result to avoid recomputing it on every call; it's not likely
  // to change during the lifetime of the app
  _isCupertinoApp ??=
      context.findAncestorWidgetOfExactType<CupertinoApp>() != null;
  return _isCupertinoApp!;
}

/// Determines if the current platform is a mobile device (Android or iOS).
///
/// This constant uses the [UniversalPlatform] package to check the platform.
///
/// Returns:
///   A [bool] value. `true` if the platform is either Android or iOS,
///   `false` otherwise.
final isMobile = UniversalPlatform.isAndroid || UniversalPlatform.isIOS;

/// Copies the given text to the clipboard and shows a confirmation message.
///
/// This function uses the [Clipboard] API to copy the provided [text] to the
/// system clipboard. After copying, it displays a confirmation message using
/// [AdaptiveSnackBar] if the [context] is still mounted.
///
/// Parameters:
///   * [context]: The [BuildContext] used to show the confirmation message.
///   * [text]: The text to be copied to the clipboard.
///
/// Returns: A [Future] that completes when the text has been copied to the
///   clipboard and the confirmation message has been shown.
Future<void> copyToClipboard(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    AdaptiveSnackBar.show(context, 'Message copied to clipboard');
  }
}

/// Inverts the given color.
///
/// This function takes a [Color] object and returns a new [Color] object
/// with the RGB values inverted. The alpha value remains unchanged.
///
/// Parameters:
///   * [color]: The [Color] to be inverted. This parameter must not be null.
///
/// Returns: A new [Color] object with the inverted RGB values.
Color? invertColor(Color? color) =>
    color != null
        ? Color.from(
          alpha: color.a,
          red: 1 - color.r,
          green: 1 - color.g,
          blue: 1 - color.b,
        )
        : null;

/// Generates a random UUID (Universally Unique Identifier) version 4.
/// 
/// This function creates a random UUID using secure random bytes.
/// The UUID is formatted as a string in the standard 8-4-4-4-12 format.
/// 
/// Returns: A [String] representing the generated UUID version 4.
String generateUuidV4() {
  final random = Random.secure();
  final bytes = Uint8List(16);

  for (int i = 0; i < 16; i++) {
    bytes[i] = random.nextInt(256);
  }

  // Set version to 4 ---- 0100xxxx
  bytes[6] = (bytes[6] & 0x0f) | 0x40;

  // Set variant to DCE 1.1 ---- 10xxxxxx
  bytes[8] = (bytes[8] & 0x3f) | 0x80;

  StringBuffer buffer = StringBuffer();
  for (int i = 0; i < bytes.length; i++) {
    buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
    if ([3, 5, 7, 9].contains(i)) buffer.write('-');
  }

  return buffer.toString();
}