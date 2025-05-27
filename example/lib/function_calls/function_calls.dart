// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

// from `flutterfire config`: https://firebase.google.com/docs/flutter/setup
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

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
      provider: FirebaseProvider(
        model: FirebaseAI.googleAI().generativeModel(
          model: 'gemini-2.0-flash',
          tools: [
            Tool.functionDeclarations([
              FunctionDeclaration(
                'get_temperature',
                'Get the current local temperature',
                parameters: {},
              ),
              FunctionDeclaration(
                'get_time',
                'Get the current local time',
                parameters: {},
              ),
            ]),
          ],
        ),
        onFunctionCall: _onFunctionCall,
      ),
    ),
  );

  Future<Map<String, Object?>?> _onFunctionCall(
    FunctionCall functionCall,
  ) async {
    // note: we're not actually calling any external APIs in this example
    return switch (functionCall.name) {
      'get_temperature' => {'temperature': 60, 'unit': 'F'},
      'get_time' => {'time': DateTime(1970, 1, 1).toIso8601String()},
      _ => throw Exception('Unknown function call: ${functionCall.name}'),
    };
  }
}
