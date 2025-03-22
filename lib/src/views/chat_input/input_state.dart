// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Represents the different states of the chat input.
enum InputState {
  /// The input has text and the submit button is enabled.
  canSubmitPrompt,

  /// A prompt is being submitted and the cancel button is enabled.
  canCancelPrompt,

  /// The input is empty and the microphone button for speech-to-text is
  /// enabled.
  canStt,

  /// Speech is being recorded and the stop button is enabled.
  isRecording,

  /// Speech is being translated to text and a progress indicator is shown.
  canCancelStt,

  /// Can't submit, cancel, or record
  disabled,
}
