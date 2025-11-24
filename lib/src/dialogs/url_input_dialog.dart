// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../providers/interface/attachments.dart';

/// Shows a dialog to input a URL and returns a [LinkAttachment].
///
/// The dialog is platform-aware and will show either a Material or Cupertino
/// style dialog based on the current platform. The dialog includes:
/// - A text field for entering a URL
/// - Input validation to ensure a valid URL is entered
/// - Proper error messages for invalid input
///
/// Returns:
/// - A [LinkAttachment] if a valid URL is entered and submitted
/// - `null` if the dialog is dismissed or cancelled
///
/// Example:
/// ```dart
/// final attachment = await showUrlInputDialog(context);
/// if (attachment != null) {
///   // Handle the URL attachment
/// }
/// ```
Future<LinkAttachment?> showUrlInputDialog(BuildContext context) async {
  final controller = TextEditingController();
  String? errorText;

  final result = await showDialog<LinkAttachment?>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoAlertDialog(
                  title: const Text('Attach URL'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      CupertinoTextField(
                        controller: controller,
                        placeholder: 'https://flutter.dev',
                        keyboardType: TextInputType.url,
                        autofocus: true,
                        onChanged: (value) {
                          if (errorText != null) {
                            setState(() => errorText = null);
                          }
                        },
                      ),
                      if (errorText != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            errorText!,
                            style: const TextStyle(
                              color: CupertinoColors.systemRed,
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: const Text('Cancel'),
                    ),
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () {
                        final attachment = _validateAndCreateAttachment(
                          controller.text,
                        );
                        if (attachment != null) {
                          Navigator.of(context).pop(attachment);
                        } else {
                          setState(() => errorText = 'Please enter a valid URL');
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                )
              : AlertDialog(
                  title: const Text('Attach URL'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'https://flutter.dev',
                          errorText: errorText,
                        ),
                        keyboardType: TextInputType.url,
                        autofocus: true,
                        onChanged: (value) {
                          if (errorText != null) {
                            setState(() => errorText = null);
                          }
                        },
                        onSubmitted: (value) {
                          final attachment = _validateAndCreateAttachment(value);
                          if (attachment != null) {
                            Navigator.of(context).pop(attachment);
                          } else {
                            setState(() => errorText = 'Please enter a valid URL');
                          }
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        final attachment = _validateAndCreateAttachment(
                          controller.text,
                        );
                        if (attachment != null) {
                          Navigator.of(context).pop(attachment);
                        } else {
                          setState(() => errorText = 'Please enter a valid URL');
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
        },
      );
    },
  );

  return result;
}

LinkAttachment? _validateAndCreateAttachment(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return null;

  try {
    final uri = Uri.parse(trimmed);
    if (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return null;
    }
    return LinkAttachment(
      name: uri.host.isNotEmpty ? uri.host : trimmed,
      url: uri,
    );
  } catch (e) {
    return null;
  }
}
