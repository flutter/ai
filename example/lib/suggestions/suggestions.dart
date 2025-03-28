// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../gemini_api_key.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: Suggestions';

  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: title,
    home: ChatPage(),
    debugShowCheckedModeBanner: false,
  );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _provider = GeminiProvider(
    model: GenerativeModel(model: 'gemini-2.0-flash', apiKey: geminiApiKey),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(App.title),
      actions: [
        IconButton(onPressed: _clearHistory, icon: const Icon(Icons.history)),
      ],
    ),
    body: LlmChatView(
      provider: _provider,
      suggestions: const [
        'Tell me a joke.',
        'Write me a limerick.',
        'Perform a haiku.',
      ],
    ),
  );

  void _clearHistory() => _provider.history = [];
}
