// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

/// Exception class for LLM-related errors.
///
/// This class is used to represent exceptions that occur during
/// LLM (Language Learning Model) operations.
@immutable
abstract class LlmException implements Exception {
  /// Creates a new [LlmException] with the given error [message].
  ///
  /// The [message] parameter is a string describing the error that occurred.
  const LlmException._([this.message = '']);

  /// The message describing the error that occurred.
  final String message;

  @override
  String toString() => 'LlmException: $message';
}

/// Exception thrown when an LLM operation is cancelled.
///
/// This exception is used to indicate that an LLM operation was
/// intentionally cancelled, typically by user action or a timeout.
@immutable
class LlmCancelException extends LlmException {
  /// Creates a new [LlmCancelException].
  const LlmCancelException() : super._();

  @override
  String toString() => 'LlmCancelException';
}

/// Exception thrown when an LLM operation fails.
///
/// This exception is used to represent failures in LLM operations
/// that are not due to cancellation, such as network errors or
/// invalid responses from the LLM provider.
@immutable
class LlmFailureException extends LlmException {
  /// Creates a new [LlmFailureException] with the given error [message].
  ///
  /// The [message] parameter is a string describing the failure that occurred.
  const LlmFailureException([super.message]) : super._();

  @override
  String toString() => 'LlmFailureException: $message';
}
