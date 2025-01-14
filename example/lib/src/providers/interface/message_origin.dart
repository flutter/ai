// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Represents the origin of a chat message.
enum MessageOrigin {
  /// Indicates that the message originated from the user.
  user,

  /// Indicates that the message originated from the LLM.
  llm;

  /// Checks if the message origin is from the user.
  bool get isUser => this == MessageOrigin.user;

  /// Checks if the message origin is from the LLM.
  bool get isLlm => this == MessageOrigin.llm;
}
