// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart' show TextEditingController;

import '../../providers/interface/attachments.dart';

/// A no-op implementation of the web paste handler for non-web platforms.
///
/// This function is provided for API compatibility with web platforms but does nothing
/// when called on non-web platforms. On web, this would handle paste events.
///
/// Parameters:
///   - [controller]: The text editing controller (unused in stub)
///   - [onAttachments]: Callback for handling attachments (unused in stub)
///   - [insertText]: Function to handle text insertion (unused in stub)
///
/// Returns:
///   A [Future] that completes immediately with no effect
Future<void> handlePasteWeb({
  required TextEditingController controller,
  required void Function(List<Attachment> attachments)? onAttachments,
  required void Function({
    required TextEditingController controller,
    required String text,
  })
  insertText,
}) async {}

/// A no-op implementation of unregistering the web listener for non-web platforms.
///
/// This function is provided for API compatibility with web platforms but does nothing
/// when called on non-web platforms. On web, this unregister the paste event listener.
void unregisterPasteListener() {}
