// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:mime/mime.dart';
import 'package:web/web.dart' as web;

import '../../providers/interface/attachments.dart';

/// Handles paste events in a web environment, supporting both text and image pasting.
///
/// This function processes the clipboard contents and either:
/// - Extracts and handles image data if images are present in the clipboard
/// - Inserts plain text into the provided text controller
///
/// Parameters:
///   - [controller]: The text editing controller to insert text into
///   - [onAttachments]: Callback that receives a list of attachments when images are pasted
///   - [insertText]: Function to handle text insertion, allowing for custom text processing
///
/// Returns:
///   A [Future] that completes when the paste operation is finished
Future<void> handlePasteWeb({
  required TextEditingController controller,
  required void Function(List<Attachment> attachments)? onAttachments,
  required void Function({
  required TextEditingController controller,
  required String text,
  }) insertText,
}) async {
  try {
    final clipboard = web.window.navigator.clipboard;
    final jsItems = await clipboard.read().toDart;

    final items = jsItems.toDart;

    for (final item in items) {
      final types = item.types.toDart;
      for (final type in types) {
        final typeString = type.toDart;

        if (typeString.startsWith("image/")) {
          final blob = await item.getType(typeString).toDart;

          if (blob.isUndefinedOrNull) continue;

          final bytes = await _blobToBytes(blob);
          if (bytes == null || bytes.isEmpty) continue;

          final extension = _getExtensionFromMime(typeString);

          final attachment = ImageFileAttachment(
            name:
            'pasted_image_${DateTime.now().millisecondsSinceEpoch}.$extension',
            mimeType: typeString,
            bytes: bytes,
          );

          onAttachments?.call([attachment]);
          return;
        }
      }

      for (final type in types) {
        final typeString = type.toDart;

        if (typeString.startsWith("text/") &&
            typeString != "text/plain") {
          final blob = await item.getType(typeString).toDart;
          if (blob.isUndefinedOrNull) continue;

          final text = await blob.text().toDart;
          final textString = text.toDart;

          if (textString.isNotEmpty) {
            insertText(controller: controller, text: textString);
            return;
          }
        }
      }

      if (types.contains('text/plain'.toJS)) {
        final blob = await item.getType("text/plain").toDart;
        if (blob.isUndefinedOrNull) continue;

        final text = await blob.text().toDart;
        final textString = text.toDart;

        if (textString.isNotEmpty) {
          insertText(controller: controller, text: textString);
          return;
        }
      }
    }
  } catch (e, s) {
    debugPrint('Error in handlePasteWeb: $e');
    debugPrintStack(stackTrace: s);
  }
}


/// Converts a web Blob object to a Uint8List.
///
/// Parameters:
///   - [blob]: The web Blob to convert
///
/// Returns:
///   A [Future] that completes with the binary data as [Uint8List], or null if conversion fails
Future<Uint8List?> _blobToBytes(web.Blob blob) async {
  try {
    final arrayBuffer = await blob.arrayBuffer().toDart;
    return Uint8List.view(arrayBuffer.toDart);
  } catch (e) {
    debugPrint('Error converting blob to bytes: $e');
    return null;
  }
}

/// Determines the appropriate file extension for a given MIME type.
///
/// Parameters:
///   - [mimeType]: The MIME type to get the extension for (e.g., 'image/png')
///   - [bytes]: Optional header bytes to detect the MIME type if the provided type is generic.
///
/// Returns:
///   A string representing the file extension (without the dot), defaults to 'bin' if unknown
String _getExtensionFromMime(String mimeType, [List<int>? bytes]) {
  String detectedMimeType = mimeType;
  if (bytes != null && (mimeType.isEmpty || mimeType == 'application/octet-stream')) {
    detectedMimeType = lookupMimeType('', headerBytes: bytes) ?? mimeType;
  }
  final extension = extensionFromMime(detectedMimeType);
  if (extension == null || extension.isEmpty) {
    return detectedMimeType.startsWith('image/') ? 'png' : 'bin';
  }
  return extension.startsWith('.') ? extension.substring(1) : extension;
}
