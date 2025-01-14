// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picture_taker/flutter_picture_taker.dart';

/// Deletes a file from the file system.
///
/// This method is a no-op on web platforms, as web browsers do not have
/// direct access to the file system. The method is provided for API
/// compatibility with non-web platforms.
///
/// Parameters:
///   - file: An [XFile] object representing the file to be deleted.
///           This parameter is ignored on web platforms.
///
/// Returns:
///   A [Future] that completes immediately, as no actual deletion occurs.
Future<void> deleteFile(XFile file) async {}

/// Checks if the device can take a photo.
///
/// This method always returns `true` on web platforms, as the capability
/// to take a photo is assumed to be available via the flutter_picture_taker
/// package.
///
/// Returns:
///   A [bool] indicating whether the device can take a photo.
bool canTakePhoto() => true;

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
    showStillCameraDialog(context);
