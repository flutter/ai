// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:mime/mime.dart';
import 'package:super_clipboard/super_clipboard.dart';

import '../../providers/interface/attachments.dart';

bool _isListenerRegistered = false;
final _events = ClipboardEvents.instance;

/// Handles paste events in a web environment, supporting both text, file, and image pasting.
///
/// This function processes the clipboard contents, registers a paste event listener and either:
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
  })
  insertText,
}) async {
  try {
    if (_isListenerRegistered) return;

    _isListenerRegistered = true;

    if (_events == null) return;

    _events!.registerPasteEventListener((event) async {
      final reader = await event.getClipboardReader();
      await _pasteOperation(
        controller: controller,
        onAttachments: onAttachments,
        insertText: insertText,
        reader: reader,
      );
    });
  } catch (e, s) {
    debugPrint('Error in handlePasteWeb: $e');
    debugPrintStack(stackTrace: s);
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
  if (bytes != null &&
      (mimeType.isEmpty || mimeType == 'application/octet-stream')) {
    detectedMimeType = lookupMimeType('', headerBytes: bytes) ?? mimeType;
  }
  final extension = extensionFromMime(detectedMimeType);
  if (extension == null || extension.isEmpty) {
    return detectedMimeType.startsWith('image/') ? 'png' : 'bin';
  }
  return extension.startsWith('.') ? extension.substring(1) : extension;
}

/// Internal function to handle the actual clipboard reading and data processing.
///
/// It checks for various data formats (files, images, plain text, HTML) in a specific order
/// and executes the appropriate action (calling [onAttachments] or [insertText]).
///
/// Parameters:
///   - [controller]: The text editing controller.
///   - [onAttachments]: Callback to handle file/image attachments.
///   - [insertText]: Function to handle text insertion.
///   - [reader]: The [ClipboardReader] containing the clipboard data.
Future<void> _pasteOperation({
  required TextEditingController controller,
  required void Function(List<Attachment> attachments)? onAttachments,
  required void Function({
    required TextEditingController controller,
    required String text,
  })
  insertText,
  required ClipboardReader reader,
}) async {
  if (onAttachments != null) {
    final imageFormats = [
      Formats.png,
      Formats.jpeg,
      Formats.bmp,
      Formats.gif,
      Formats.tiff,
      Formats.webp,
    ];

    final fileFormats = [
      Formats.pdf,
      Formats.doc,
      Formats.docx,
      Formats.xls,
      Formats.xlsx,
      Formats.ppt,
      Formats.pptx,
      Formats.epub,
    ];

    for (final format in fileFormats) {
      if (reader.canProvide(format)) {
        reader.getFile(format, (file) async {
          final stream = file.getStream();

          await stream.toList().then((chunks) {
            final attachmentBytes = Uint8List.fromList(
              chunks.expand((e) => e).toList(),
            );
            final mimeType =
                lookupMimeType('', headerBytes: attachmentBytes) ??
                'application/octet-stream';
            final attachment = FileAttachment.fileOrImage(
              name:
                  'pasted_file_${DateTime.now().millisecondsSinceEpoch}.${_getExtensionFromMime(mimeType)}',
              mimeType: mimeType,
              bytes: attachmentBytes,
            );
            onAttachments([attachment]);
            return;
          });
        });
        return;
      }
    }

    if (reader.canProvide(Formats.fileUri)) {
      await reader.readValue(Formats.fileUri).then((val) async {
        if (val != null) {
          if (val.isScheme('file')) {
            final path = val.toFilePath();
            final file = XFile(path);
            final attachment = await FileAttachment.fromFile(file);
            onAttachments([attachment]);
          }
        }
      });
      return;
    }

    for (final format in imageFormats) {
      if (reader.canProvide(format)) {
        reader.getFile(format, (file) async {
          final stream = file.getStream();
          await stream.toList().then((chunks) {
            final attachmentBytes = Uint8List.fromList(
              chunks.expand((e) => e).toList(),
            );
            final mimeType =
                lookupMimeType('', headerBytes: attachmentBytes) ?? 'image/png';
            final attachment = ImageFileAttachment(
              name:
                  'pasted_image_${DateTime.now().millisecondsSinceEpoch}.${_getExtensionFromMime(mimeType)}',
              mimeType: mimeType,
              bytes: attachmentBytes,
            );
            onAttachments([attachment]);
            return;
          });
        });
        return;
      }
    }

    if (reader.canProvide(Formats.plainText)) {
      final text = await reader.readValue(Formats.plainText);
      if (text != null && text.isNotEmpty) {
        insertText(controller: controller, text: text);
        return;
      }
    }

    if (reader.canProvide(Formats.htmlText)) {
      final html = await reader.readValue(Formats.htmlText);
      if (html != null && html.isNotEmpty) {
        insertText(controller: controller, text: html);
        return;
      }
    }
  }
}

/// Unregisters the paste event listener established in [handlePasteWeb].
///
/// This is necessary to stop processing paste events when they are no longer needed
/// (e.g., when a widget is disposed).
void unregisterPasteListener() {
  if (_events != null) {
    _events!.unregisterPasteEventListener;
  }
}
