// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart'; //request permission from iOS
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:file_selector_macos/file_selector_macos.dart';
import 'package:mime/mime.dart';


import '../gemini_api_key.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: Google Gemini AI';

  const App({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: title,
        home: ChatPage(),
      );
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: LlmChatView(
          provider: GeminiProvider(
            model: GenerativeModel(
              model: 'gemini-1.5-flash',
              apiKey: geminiApiKey,
            ),
          ),
        ),
      );
}
