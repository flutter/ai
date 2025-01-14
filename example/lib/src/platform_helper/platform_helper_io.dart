// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

/// Deletes a file from the file system.
///
/// This method takes an [XFile] object and deletes the corresponding file
/// from the file system. It uses the [File] class from dart:io to perform
/// the deletion.
///
/// Parameters:
///   - file: An [XFile] object representing the file to be deleted.
///
/// Returns:
///   A [Future] that completes when the file has been deleted.
///
/// Throws:
///   - [FileSystemException] if the file cannot be deleted.
Future<void> deleteFile(XFile file) async {
  await File(file.path).delete();
}

/// Checks if the device can take a photo.
///
/// This method returns `true` if the device supports taking photos using
/// the camera, and `false` otherwise. It uses the [ImagePicker] class
/// to check for camera support.
///
/// Returns:
///   A [bool] indicating whether the device can take a photo.
bool canTakePhoto() => ImagePicker().supportsImageSource(ImageSource.camera);

/// Opens a dialog to take a photo using the device's camera.
///
/// This method displays a camera interface to the user, allowing them to
/// capture a photo. The captured photo is returned as an [XFile] object.
///
/// Parameters:
///   - context: The build context in which to show the camera dialog.
///
/// Returns:
///   A [Future] that completes with an [XFile] object representing the
///   captured photo, or `null` if the photo capture was canceled.
Future<XFile?> takePhoto(BuildContext context) =>
    ImagePicker().pickImage(source: ImageSource.camera);
