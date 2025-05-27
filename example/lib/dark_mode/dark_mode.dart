// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

import '../dark_style.dart';
// from `flutterfire config`: https://firebase.google.com/docs/flutter/setup
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  static const title = 'Example: Dark Mode';
  static final themeMode = ValueNotifier(ThemeMode.dark);

  const App({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
    valueListenable: themeMode,
    builder:
        (BuildContext context, ThemeMode mode, Widget? child) => MaterialApp(
          title: title,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: ChatPage(),
          debugShowCheckedModeBanner: false,
        ),
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

  final _lightStyle = LlmChatViewStyle.defaultStyle();
  final _darkStyle = darkChatViewStyle();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(App.title),
      actions: [
        IconButton(
          onPressed:
              () =>
                  App.themeMode.value =
                      App.themeMode.value == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light,
          tooltip:
              App.themeMode.value == ThemeMode.light
                  ? 'Dark Mode'
                  : 'Light Mode',
          icon: const Icon(Icons.brightness_4_outlined),
        ),
      ],
    ),
    body: LlmChatView(
      provider: _provider,
      style: App.themeMode.value == ThemeMode.dark ? _darkStyle : _lightStyle,
    ),
  );
}
