// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' show ScaffoldMessenger, SnackBar;
import 'package:flutter/widgets.dart';

import '../../utility.dart';
import 'cupertino_snack_bar.dart';

/// A utility class for showing adaptive snack bars in Flutter applications.
///
/// This class provides a static method to display snack bars that adapt to the
/// current application environment, showing either a Material Design snack bar
/// or a Cupertino-style snack bar based on the app's context.
@immutable
class AdaptiveSnackBar {
  /// Shows an adaptive snack bar with the given message.
  ///
  /// This method determines whether the app is using Cupertino or Material
  /// design and displays an appropriate snack bar.
  ///
  /// Parameters:
  ///   * [context]: The build context in which to show the snack bar.
  ///   * [message]: The text message to display in the snack bar.
  static void show(BuildContext context, String message) {
    if (isCupertinoApp(context)) {
      _showCupertinoSnackBar(context: context, message: message);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  static void _showCupertinoSnackBar({
    required BuildContext context,
    required String message,
    int durationMillis = 4000,
  }) {
    const animationDurationMillis = 200;
    final overlayEntry = OverlayEntry(
      builder: (context) => CupertinoSnackBar(
        message: message,
        animationDurationMillis: animationDurationMillis,
        waitDurationMillis: durationMillis,
      ),
    );
    Future.delayed(
      Duration(milliseconds: durationMillis + 2 * animationDurationMillis),
      overlayEntry.remove,
    );
    Overlay.of(context).insert(overlayEntry);
  }
}
