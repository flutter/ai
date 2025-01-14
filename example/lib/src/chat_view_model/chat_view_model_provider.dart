// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'chat_view_model.dart';

/// A provider widget that makes a [ChatViewModel] available to its descendants.
///
/// This widget uses the [InheritedWidget] mechanism to efficiently propagate
/// the [ChatViewModel] down the widget tree.
@immutable
class ChatViewModelProvider extends InheritedWidget {
  /// Creates a [ChatViewModelProvider].
  ///
  /// The [child] and [viewModel] arguments must not be null.
  const ChatViewModelProvider({
    required super.child,
    required this.viewModel,
    super.key,
  });

  /// The [ChatViewModel] to be made available to descendants.
  final ChatViewModel viewModel;

  /// Retrieves the [ChatViewModel] from the closest [ChatViewModelProvider]
  /// ancestor in the widget tree.
  ///
  /// This method will assert if no [ChatViewModelProvider] is found in the
  /// widget's ancestors.
  ///
  /// [context] must not be null.
  static ChatViewModel of(BuildContext context) {
    final viewModel = maybeOf(context);
    assert(viewModel != null, 'No ChatViewModelProvider found in context');
    return viewModel!;
  }

  /// Retrieves the [ChatViewModel] from the closest [ChatViewModelProvider]
  /// ancestor in the widget tree, if one exists.
  ///
  /// Returns null if no [ChatViewModelProvider] is found.
  ///
  /// [context] must not be null.
  static ChatViewModel? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ChatViewModelProvider>()
      ?.viewModel;

  @override
  bool updateShouldNotify(ChatViewModelProvider oldWidget) =>
      viewModel != oldWidget.viewModel;
}
