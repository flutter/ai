// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' show Tooltip;
import 'package:flutter/widgets.dart';

import '../../styles/action_button_style.dart';
import '../../utility.dart';

/// A button widget with an icon.
///
/// This widget creates a button with a customizable icon, size, decoration, and
/// color. It can be enabled or disabled based on the presence of an [onPressed]
/// callback.
@immutable
class ActionButton extends StatelessWidget {
  /// Creates an [ActionButton].
  ///
  /// The [onPressed] and [style] parameters must not be null.
  /// The [size] parameter defaults to 40 if not provided.
  const ActionButton({
    required this.onPressed,
    required this.style,
    super.key,
    this.size = 40,
  });

  /// The callback that is called when the button is tapped.
  /// If null, the button will be disabled.
  final VoidCallback onPressed;

  /// The style of the button.
  final ActionButtonStyle style;

  /// The diameter of the circular button.
  final double size;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: style.iconDecoration,
          // tooltips aren't a thing in cupertino, so skip it
          child: isCupertinoApp(context)
              ? Icon(
                  style.icon,
                  color: style.iconColor,
                  size: size * 0.6,
                )
              : Tooltip(
                  message: style.tooltip,
                  textStyle: style.tooltipTextStyle,
                  decoration: style.tooltipDecoration,
                  child: Icon(
                    style.icon,
                    color: style.iconColor,
                    size: size * 0.6,
                  ),
                ),
        ),
      );
}
