// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart'
    show MenuAnchor, MenuItemButton, MenuStyle;
import 'package:flutter/widgets.dart';
import 'package:flutter_ai_toolkit/src/utility.dart';
import 'package:image_picker/image_picker.dart';

import '../../chat_view_model/chat_view_model_client.dart';
import '../../dialogs/adaptive_snack_bar/adaptive_snack_bar.dart';
import '../../platform_helper/platform_helper.dart';
import '../../providers/interface/attachments.dart';
import '../../styles/llm_chat_view_style.dart';
import '../action_button.dart';

/// A widget that provides an action bar for attaching files or images.
@immutable
class AttachmentActionBar extends StatefulWidget {
  /// Creates an [AttachmentActionBar].
  ///
  /// The [onAttachments] parameter is required and is called when attachments
  /// are selected.
  const AttachmentActionBar({required this.onAttachments, super.key});

  /// Callback function that is called when attachments are selected.
  ///
  /// The selected [Attachment]s are passed as an argument to this function.
  final Function(Iterable<Attachment> attachments) onAttachments;

  @override
  State<AttachmentActionBar> createState() => _AttachmentActionBarState();
}

class _AttachmentActionBarState extends State<AttachmentActionBar> {
  late final bool _canCamera;

  @override
  void initState() {
    super.initState();
    _canCamera = canTakePhoto();
  }

  @override
  Widget build(BuildContext context) => ChatViewModelClient(
    builder: (context, viewModel, child) {
      final chatStyle = LlmChatViewStyle.resolve(viewModel.style);
      final menuItems = [
        if (_canCamera)
          MenuItemButton(
            leadingIcon: Icon(
              chatStyle.cameraButtonStyle!.icon!,
              color: chatStyle.cameraButtonStyle!.iconColor,
            ),
            onPressed: () => _onCamera(),
            child: Text(
              chatStyle.cameraButtonStyle!.text!,
              style: chatStyle.cameraButtonStyle!.textStyle,
            ),
          ),
        MenuItemButton(
          leadingIcon: Icon(
            chatStyle.galleryButtonStyle!.icon!,
            color: chatStyle.galleryButtonStyle!.iconColor,
          ),
          onPressed: () => _onGallery(),
          child: Text(
            chatStyle.galleryButtonStyle!.text!,
            style: chatStyle.galleryButtonStyle!.textStyle,
          ),
        ),
        MenuItemButton(
          leadingIcon: Icon(
            chatStyle.attachFileButtonStyle!.icon!,
            color: chatStyle.attachFileButtonStyle!.iconColor,
          ),
          onPressed: () => _onFile(),
          child: Text(
            chatStyle.attachFileButtonStyle!.text!,
            style: chatStyle.attachFileButtonStyle!.textStyle,
          ),
        ),
      ];

      return MenuAnchor(
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(chatStyle.menuColor),
        ),
        // Force menu above by using negative offset equal to estimated menu
        // height. NOTE: This is a hack to get the menu to appear above the
        // button so that it doesn't appear below the soft keyboard. There
        // should be no reason to set the alignmentOffset at all once this bug
        // is fixed: https://github.com/flutter/flutter/issues/142921
        alignmentOffset: _menuAnchorAlignmentOffsetHackForMobile(
          chatStyle,
          menuItems.length,
        ),
        consumeOutsideTap: true,
        builder:
            (_, controller, _) => ActionButton(
              onPressed: controller.isOpen ? controller.close : controller.open,
              style: chatStyle.addButtonStyle!,
            ),
        menuChildren: menuItems,
      );
    },
  );

  Offset? _menuAnchorAlignmentOffsetHackForMobile(
    LlmChatViewStyle chatStyle,
    int menuItems,
  ) {
    // Limit the potential damage on this hack to mobile platforms
    if (!isMobile) return null;

    // From MenuAnchor source: minimum height is 48.0 + some padding for
    // safety
    final double itemHeight = 48.0 + 8.0;
    final double menuPadding = 16.0;

    // Calculate menu height based on actual number of items
    final double estimatedMenuHeight = (menuItems * itemHeight) + menuPadding;
    return Offset(0, -estimatedMenuHeight);
  }

  void _onCamera() => unawaited(_pickImage(ImageSource.camera));
  void _onGallery() => unawaited(_pickImage(ImageSource.gallery));

  Future<void> _pickImage(ImageSource source) async {
    assert(
      source == ImageSource.camera || source == ImageSource.gallery,
      'Unsupported image source: $source',
    );

    final picker = ImagePicker();
    try {
      if (source == ImageSource.gallery) {
        final pics = await picker.pickMultiImage();
        final attachments = await Future.wait(
          pics.map(ImageFileAttachment.fromFile),
        );
        widget.onAttachments(attachments);
      } else {
        final pic = await takePhoto(context);
        if (pic == null) return;
        widget.onAttachments([await ImageFileAttachment.fromFile(pic)]);
      }
    } on Exception catch (ex) {
      if (context.mounted) {
        // I just checked this! ^^^
        // ignore: use_build_context_synchronously
        AdaptiveSnackBar.show(context, 'Unable to pick an image: $ex');
      }
    }
  }

  Future<void> _onFile() async {
    try {
      final files = await openFiles();
      final attachments = await Future.wait(files.map(FileAttachment.fromFile));
      widget.onAttachments(attachments);
    } on Exception catch (ex) {
      if (context.mounted) {
        // I just checked this! ^^^
        // ignore: use_build_context_synchronously
        AdaptiveSnackBar.show(context, 'Unable to pick a file: $ex');
      }
    }
  }
}
