// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  static const title = 'Example: Echo Test';

  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _provider = EchoProvider();

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: App.title,
    home: Scaffold(
      appBar: AppBar(title: const Text(App.title)),
      body: LlmChatView(provider: _provider),
    ),
  );
}
