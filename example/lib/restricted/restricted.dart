// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

// from `flutterfire config`: https://firebase.google.com/docs/flutter/setup
import '../firebase_options.dart';

/// An example demonstrating how to create a restricted chat interface
/// where attachments and voice notes are disabled.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

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
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.0-flash',
    );

    // Create a FirebaseProvider with the model
    final provider = FirebaseProvider(model: model);

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
