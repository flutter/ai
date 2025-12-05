// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart'
    show TextEditingController, TextSelection, debugPrint, debugPrintStack;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mime/mime.dart';
import 'package:pasteboard/pasteboard.dart';

import 'paste_helper.dart' as pst;
import '../../providers/interface/attachments.dart';

/// Handles paste operations, supporting both text and image pasting.
///
/// This function processes the clipboard contents and either:
/// - Extracts and handles image data if images are present in the clipboard
/// - Inserts plain text into the provided text controller if no images are found
///
/// On web, it delegates to [handlePasteWeb] for more comprehensive handling
/// of web-specific clipboard APIs.
///
/// Parameters:
///   - [controller]: The text editing controller to insert text into
///   - [onAttachments]: Callback that receives a list of attachments when images are pasted.
///     If null, image pasting will be skipped even if images are available.
///
/// Returns:
///   A [Future] that completes when the paste operation is finished
Future<void> handlePaste({
  required TextEditingController controller,
  required void Function(List<Attachment> attachments)? onAttachments,
}) async {
  try {
    if (kIsWeb) {
      await pst.handlePasteWeb(
        controller: controller,
        onAttachments: onAttachments,
        insertText: _insertText,
      );
      return;
    }
    final files = await Pasteboard.files();
    if (files.isNotEmpty && onAttachments != null) {
      for (final file in files) {
        final looksLikeImage = _looksLikeImagePath(file);
        if (looksLikeImage["isFile"] == true) {
          final bytes = await XFile(file).readAsBytes();
          final attachment = ImageFileAttachment(
            name: 'pasted_image_${DateTime.now().millisecondsSinceEpoch}.${_getExtensionFromMime(looksLikeImage["mimeType"], bytes)}',
            mimeType: looksLikeImage["mimeType"],
            bytes: bytes,
          );
          onAttachments([attachment]);
        }
      return;
      }
    }


    final image = await Pasteboard.image;
    if (image != null && onAttachments != null) {
      final mimeType = lookupMimeType('', headerBytes: image) ?? 'image/png';
      final attachment = ImageFileAttachment(
        name: 'pasted_image_${DateTime.now().millisecondsSinceEpoch}.${_getExtensionFromMime(mimeType)}',
        mimeType: mimeType,
        bytes: image,
      );
      onAttachments([attachment]);
      return;
    }
  } catch (e, s) {
    debugPrint('Error pasting image: $e');
    debugPrintStack(stackTrace: s);
  }

  final text = await Pasteboard.text;
  if (text != null && text.isNotEmpty) {
    _insertText(controller: controller, text: text);
  }
}

/// Inserts text at the current cursor position in the text controller.
///
/// If there's a text selection, it will be replaced by the new text.
/// If there's no selection, the text will be inserted at the cursor position.
///
/// Parameters:
///   - [controller]: The text editing controller to insert text into
///   - [text]: The text to insert
void _insertText({
  required TextEditingController controller,
  required String text,
}) {
  final cursorPosition = controller.selection.base.offset;
  if (cursorPosition == -1) {
    controller.text = text;
  } else {
    final newText = controller.text.replaceRange(
      controller.selection.start,
      controller.selection.end,
      text,
    );
    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: controller.selection.start + text.length,
      ),
    );
  }
}

/// Determines the appropriate file extension for a given MIME type.
///
/// Parameters:
///   - [mimeType]: The MIME type to get the extension for (e.g., 'image/png')
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

/// Checks if the given text appears to be an image file path or URL.
///
/// Parameters:
///   - [text]: The text to check
///
/// Returns:
///   true if the text looks like an image path/URL, false otherwise
Map<String, dynamic> _looksLikeImagePath(String text) {
  final lower = text.toLowerCase();
  final uri = Uri.tryParse(lower);
  if (uri != null && uri.path.isNotEmpty) {
    final mimeType = lookupMimeType(uri.path) ?? "";
    return mimeType.startsWith('image/') ? {"isFile": mimeType.startsWith('image/'), "mimeType": mimeType} : {"isFile": false, "mimeType": ""};
  }
  return {"isFile": false, "mimeType": ""};
}