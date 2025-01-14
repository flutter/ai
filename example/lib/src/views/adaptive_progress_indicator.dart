// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:flutter/widgets.dart';

import '../utility.dart';

/// A progress indicator that adapts to the current platform.
///
@immutable
class AdaptiveCircularProgressIndicator extends StatelessWidget {
  /// Creates an adaptive circular progress indicator.
  ///
  /// This widget will display a [CupertinoActivityIndicator] on iOS
  /// and a [CircularProgressIndicator] on other platforms.
  ///
  /// The [key] parameter is optional and is used to control how one widget
  /// replaces another widget in the tree.
  const AdaptiveCircularProgressIndicator({required this.color, super.key});

  /// The color of the progress indicator.
  final Color color;

  @override
  Widget build(BuildContext context) => isCupertinoApp(context)
      ? CupertinoActivityIndicator(color: color)
      : CircularProgressIndicator(color: color);
}
