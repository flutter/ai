// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Enum representing different types of action buttons in the chat view.
enum ActionButtonType {
  /// Button to add content or initiate a new action.
  add,

  /// Button to attach a file to the chat.
  attachFile,

  /// Button to access the camera for taking photos or videos.
  camera,

  /// Button to cancel an ongoing action or input.
  stop,

  /// Button to close the current view or dialog.
  close,

  /// Button to close an open menu.
  closeMenu,

  /// Button to cancel an operation.
  cancel,

  /// Button to copy selected text or content.
  copy,

  /// Button to edit existing content or settings.
  edit,

  /// Button to access the device's photo gallery.
  gallery,

  /// Button to start or stop audio recording.
  record,

  /// Button to submit the current input or action.
  submit,

  /// Disabled button.
  disabled,

  /// Button to attach a URL to the chat.
  url,
}
