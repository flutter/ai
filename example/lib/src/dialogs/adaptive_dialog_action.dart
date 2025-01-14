// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart' show CupertinoDialogAction;
import 'package:flutter/material.dart' show TextButton;
import 'package:flutter/widgets.dart';

import '../utility.dart';

/// A button that adapts its appearance based on the design language, either
/// Material or Cupertino.
///
/// The [AdaptiveDialogAction] widget is designed to provide a consistent user
/// experience across different platforms while adhering to platform-specific
/// design guidelines.
@immutable
class AdaptiveDialogAction extends StatelessWidget {
  /// Creates an adaptive dialog action.
  ///
  /// The [onPressed] and [child] arguments must not be null.
  const AdaptiveDialogAction({
    required this.onPressed,
    required this.child,
    super.key,
  });

  /// The callback that is called when the button is tapped or pressed.
  final VoidCallback onPressed;

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  @override
  Widget build(BuildContext context) => isCupertinoApp(context)
      ? CupertinoDialogAction(
          onPressed: onPressed,
          child: child,
        )
      : TextButton(onPressed: onPressed, child: child);
}
