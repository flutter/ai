// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'chat_view_model.dart';
import 'chat_view_model_provider.dart';

/// A widget that provides access to a [ChatViewModel] and builds its child
/// using a builder function.
///
/// This widget is typically used in conjunction with [ChatViewModelProvider]
/// to access the [ChatViewModel] from the widget tree.
@immutable
class ChatViewModelClient extends StatelessWidget {
  /// Creates a [ChatViewModelClient].
  ///
  /// The [builder] argument must not be null.
  const ChatViewModelClient({required this.builder, this.child, super.key});

  /// A function that builds a widget tree based on the current [ChatViewModel].
  ///
  /// This function is called with the current [BuildContext], the
  /// [ChatViewModel] obtained from the nearest [ChatViewModelProvider]
  /// ancestor, and the optional [child].
  final Widget Function(
    BuildContext context,
    ChatViewModel viewModel,
    Widget? child,
  )
  builder;

  /// An optional child widget that can be passed to the [builder] function.
  ///
  /// This is useful when part of the widget subtree does not depend on the
  /// [ChatViewModel] and can be shared across multiple builds.
  final Widget? child;

  @override
  Widget build(BuildContext context) =>
      builder(context, ChatViewModelProvider.of(context), child);
}
