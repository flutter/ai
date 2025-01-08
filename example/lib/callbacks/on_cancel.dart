// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../gemini_api_key.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: Welcome Message';

  const App({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: title,
        home: ChatPage(),
      );
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  void _onCancel(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chat cancelled')),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: LlmChatView(
          onCancelCallback: _onCancel,
          cancelMessage: 'Request cancelled',
          provider: GeminiProvider(
            model: GenerativeModel(
              model: 'gemini-1.5-flash',
              apiKey: geminiApiKey,
            ),
          ),
        ),
      );
}
