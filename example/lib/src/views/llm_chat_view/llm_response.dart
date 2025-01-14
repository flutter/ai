// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import '../../llm_exception.dart';

/// Represents a response from an LLM (Language Learning Model).
///
/// This class manages the streaming of LLM responses, error handling, and
/// cleanup.
class LlmResponse {
  /// Creates an LlmResponse.
  ///
  /// [stream] is the stream of text chunks from the LLM. [onDone] is an
  /// optional callback for when the response is complete or encounters an
  /// error.
  LlmResponse({
    required Stream<String> stream,
    required this.onUpdate,
    required this.onDone,
  }) {
    _subscription = stream.listen(
      onUpdate,
      onDone: () => onDone(null),
      cancelOnError: true,
      onError: (err) => _close(_exception(err)),
    );
  }

  /// Callback function to be called when a new chunk is received from the
  /// response stream.
  final void Function(String text) onUpdate;

  /// Callback function to be called when the response is complete or encounters
  /// an error.
  final void Function(LlmException? error) onDone;

  /// Cancels the response stream.
  void cancel() => _close(const LlmCancelException());

  StreamSubscription<String>? _subscription;

  LlmException _exception(dynamic err) => switch (err) {
        (LlmCancelException _) => const LlmCancelException(),
        (final LlmFailureException ex) => ex,
        _ => LlmFailureException(err.toString()),
      };

  void _close(LlmException error) {
    assert(_subscription != null);
    unawaited(_subscription!.cancel());
    _subscription = null;
    onDone.call(error);
  }
}
