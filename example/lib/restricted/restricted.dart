// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../gemini_api_key.dart';

/// An example demonstrating how to create a restricted chat interface
/// where attachments and voice notes are disabled.
void main() => runApp(const App());

/// A Flutter application that demonstrates a restricted chat interface.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(home: const ChatPage(), debugShowCheckedModeBanner: false);
}

/// A screen that displays a restricted chat interface.
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a Gemini model instance
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: geminiApiKey,
    );

    // Create a GeminiProvider with the model
    final provider = GeminiProvider(model: model);

    return Scaffold(
      appBar: AppBar(title: const Text('Restricted Chat')),
      body: LlmChatView(
        provider: provider,
        enableAttachments: false,
        enableVoiceNotes: false,
      ),
    );
  }
}
