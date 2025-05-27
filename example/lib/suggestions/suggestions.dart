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
  final _provider = FirebaseProvider(
    model: FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash'),
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
