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
              FunctionDeclaration(
                'c_to_f',
                'Convert a temperature from Celsius to Fahrenheit',
                parameters: {
                  'temperature': Schema.number(
                    description: 'The temperature in Celsius',
                  ),
                },
              ),
            ]),
          ],
        ),
        onFunctionCall: _onFunctionCall,
      ),
      suggestions: [
        'can you get the current time?',
        'can you get the current time and temp?',
        'can you get the current temp in Fahrenheit?',
      ],
      welcomeMessage: '''
Welcome to the function calls example!
This example includes three tools:
- current time: always returns 1970-01-01T00:00:00Z
- current temperature: always returns 0°C
- convert from Celsius to Fahrenheit

The hardcoded values are for demonstration purposes. Not only can you ask Gemini
to use these tools one at time, like:

_can you get the current time?_

but you can ask them in combination, like:

_can you get the current time and temp?_

you can even ask it to use the results of one function call in another, like:

_can you get the current temp in Fahrenheit?_
''',
    ),
  );

  // note: we're not actually calling any external APIs in this example
  Future<Map<String, Object?>?> _onFunctionCall(
    FunctionCall functionCall,
  ) async => switch (functionCall.name) {
    'get_temperature' => {'temperature': 0, 'unit': 'C'},
    'get_time' => {'time': DateTime(1970, 1, 1).toIso8601String()},
    'c_to_f' => {
      'temperature':
          (functionCall.args['temperature'] as num).toDouble() * 1.8 + 32,
    },
    _ => throw Exception('Unknown function call: ${functionCall.name}'),
  };
}
