// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../../providers/interface/attachments.dart';
import 'removable_attachment.dart';

/// A widget that displays a horizontal list of attachments with the ability to
/// remove them.
@immutable
class AttachmentsView extends StatelessWidget {
  /// Creates an [AttachmentsView].
  ///
  /// The [attachments] parameter is required and represents the list of
  /// attachments to display. The [onRemove] parameter is a callback function
  /// that is called when an attachment is removed.
  const AttachmentsView({
    required this.attachments,
    required this.onRemove,
    super.key,
  });

  /// The list of attachments to display.
  final Iterable<Attachment> attachments;

  /// Callback function that is called when an attachment is removed.
  ///
  /// The removed [Attachment] is passed as an argument to this function.
  final Function(Attachment) onRemove;

  @override
  Widget build(BuildContext context) => Container(
        height: attachments.isNotEmpty ? 104 : 0,
        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12),
        child: attachments.isNotEmpty
            ? ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final a in attachments)
                    RemovableAttachment(attachment: a, onRemove: onRemove),
                ],
              )
            : const SizedBox(),
      );
}
