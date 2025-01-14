// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../../providers/interface/attachments.dart';
import 'file_attatchment_view.dart';
import 'image_attachment_view.dart';

/// A widget that displays an attachment based on its type.
///
/// This widget determines the appropriate view for the given [attachment]
/// and renders it accordingly. It supports file attachments and image
/// attachments, but throws an exception for link attachments.
@immutable
class AttachmentView extends StatelessWidget {
  /// Creates an AttachmentView.
  ///
  /// The [attachment] parameter must not be null.
  const AttachmentView(this.attachment, {super.key});

  /// The attachment to be displayed.
  final Attachment attachment;

  /// The style for the attachment view.

  @override
  Widget build(BuildContext context) => switch (attachment) {
        (final ImageFileAttachment a) => ImageAttachmentView(a),
        (final FileAttachment a) => FileAttachmentView(a),
        (LinkAttachment _) => throw Exception('Link attachments not supported'),
      };
}
