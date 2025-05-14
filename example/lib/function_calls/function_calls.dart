// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../gemini_api_key.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: Function Calls';

  const App({super.key});

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(title: title, home: ChatPage());
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(App.title)),
    body: LlmChatView(
      provider: GeminiProvider(
        model: GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: geminiApiKey,
          tools: [
            Tool(
              functionDeclarations: [
                FunctionDeclaration(
                  'get_temperature',
                  'Get the current local temperature',
                  Schema.object(properties: {}),
                ),
                FunctionDeclaration(
                  'get_time',
                  'Get the current local time',
                  Schema.object(properties: {}),
                ),
              ],
            ),
          ],
        ),
        onFunctionCall: _onFunctionCall,
      ),
    ),
  );

  Future<Map<String, Object?>?> _onFunctionCall(
    FunctionCall functionCall,
  ) async {
    // note: just as an example, we're not actually calling any external APIs
    return switch (functionCall.name) {
      'get_temperature' => {'temperature': 60, 'unit': 'F'},
      'get_time' => {'time': DateTime(1970, 1, 1).toIso8601String()},
      _ => throw Exception('Unknown function call: ${functionCall.name}'),
    };
  }
}
