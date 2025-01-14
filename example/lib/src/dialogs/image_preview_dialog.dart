// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../providers/interface/attachments.dart';

/// Displays a dialog to preview the image when the user taps on an attached
/// image.
@immutable
class ImagePreviewDialog extends StatelessWidget {
  /// Shows the [ImagePreviewDialog] for the given [attachment].
  const ImagePreviewDialog(this.attachment, {super.key});

  /// The image file attachment to be previewed in the dialog.
  final ImageFileAttachment attachment;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Image.memory(attachment.bytes, fit: BoxFit.contain),
        ),
      );
}
