// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../../styles/styles.dart';
import 'action_button.dart';

/// A widget that displays a horizontal bar of [ActionButton]s.
///
/// This widget creates a container with rounded corners that houses a series of
/// [ActionButton]s. The buttons are laid out horizontally and can overflow if
/// there's not enough space.
@immutable
class ActionButtonBar extends StatelessWidget {
  /// Creates a [ActionButtonBar].
  ///
  /// The [buttons] parameter is required and specifies the list of
  /// [ActionButton]s to be displayed in the bar.
  const ActionButtonBar(
    this.buttons, {
    required this.style,
    super.key,
  });

  /// The list of [ActionButton]s to be displayed in the bar.
  final List<ActionButton> buttons;

  /// The style of the action button bar.
  final LlmChatViewStyle style;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: style.actionButtonBarDecoration!,
        child: OverflowBar(
          children: buttons,
        ),
      );
}
