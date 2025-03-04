// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// A function type that defines how to build a widget for displaying a response
/// in the chat interface.
///
/// [context] is the build context, which can be used to access theme data and
/// other contextual information.
///
/// [response] is the text of the response from the LLM.
///
/// The function should return a [Widget] that represents the formatted response
/// in the chat interface.
typedef ResponseBuilder =
    Widget Function(BuildContext context, String response);
