// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cross_file/cross_file.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

// from `flutterfire config`: https://firebase.google.com/docs/flutter/setup
import '../../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  static const title = 'Example: Custom Speech to Text';

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
        model: FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash'),
      ),
      speechToText: (file) => _convertSpeechToText(file),
    ),
  );

  Stream<String> _convertSpeechToText(XFile audioFile) async* {
    // create an instance of an STT model known for high quality transcription
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
    );

    // ask the model to translate the audio to text
    const prompt =
        'translate the attached audio to text. provide the result of the '
        'translation as just the raw text with no time or sound markers.';

    // generate the transcription stream
    final responseStream = model.generateContentStream([
      Content.multi([
        TextPart(prompt),
        InlineDataPart(audioFile.mimeType!, await audioFile.readAsBytes()),
      ]),
    ]);

    // yield the text chunks as they arrive
    yield* responseStream.map((chunk) => chunk.text!);
  }
}
