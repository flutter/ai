// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../gemini_api_key.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: Logging';

  const App({super.key});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(title: title, home: ChatPage());
}

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  final _provider = GeminiProvider(
    model: GenerativeModel(model: 'gemini-2.0-flash', apiKey: geminiApiKey),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(App.title)),
      body: LlmChatView(provider: _provider, messageSender: _logMessage),
    );
  }

  Stream<String> _logMessage(
    String prompt, {
    required Iterable<Attachment> attachments,
  }) async* {
    // log the message and attachments
    debugPrint('# Sending Message');
    debugPrint('## Prompt\n$prompt');
    debugPrint('## Attachments\n${attachments.map((a) => a.toString())}');

    // forward the message on to the provider
    final response = _provider.sendMessageStream(
      prompt,
      attachments: attachments,
    );

    // log the response
    final text = response.join();
    debugPrint('## Response\n$text');
  }
}
