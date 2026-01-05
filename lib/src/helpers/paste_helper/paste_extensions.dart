// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:mime/mime.dart';

/// Determines the appropriate file extension for a given MIME type.
///
/// Parameters:
///   - [mimeType]: The MIME type to get the extension for (e.g., 'image/png')
///   - [bytes]: Optional header bytes to detect the MIME type if the provided type is generic.
///
/// Returns:
///   A string representing the file extension (without the dot), defaults to 'bin' if unknown
String getExtensionFromMime(String mimeType, [List<int>? bytes]) {
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
