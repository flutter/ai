// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pp;

import '../gemini_api_key.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: History';

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
  late final _provider = GeminiProvider(
    model: GenerativeModel(model: 'gemini-2.0-flash', apiKey: geminiApiKey),
  );

  @override
  void initState() {
    super.initState();
    _provider.addListener(_saveHistory);
    _loadHistory();
  }

  @override
  void dispose() {
    _provider.removeListener(_saveHistory);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(App.title),
      actions: [
        IconButton(onPressed: _clearHistory, icon: const Icon(Icons.history)),
      ],
    ),
    body: LlmChatView(provider: _provider, welcomeMessage: _welcomeMessage),
  );

  io.Directory? _historyDir;

  final _welcomeMessage =
      '# Welcome\n'
      'Hello and welcome to the chat! This sample shows off a simple way to '
      'use the Flutter AI Toolkit to create a chat history that is saved to '
      'disk and restored the next time the app is launched.\n\n'
      '# Note\n'
      '**Since this sample depends on the availability of a file system and '
      'the ability to save and restore files, it will not work in an '
      'environment that does not support these capabilities, such as a web '
      'browser.**'
      '';

  Future<io.Directory> _getHistoryDir() async {
    if (_historyDir == null) {
      final temp = await pp.getTemporaryDirectory();
      _historyDir = io.Directory(path.join(temp.path, 'chat-history'));
      await _historyDir!.create();
    }
    return _historyDir!;
  }

  Future<io.File> _messageFile(int messageNo) async {
    final fileName = path.join(
      (await _getHistoryDir()).path,
      'message-${messageNo.toString().padLeft(3, '0')}.json',
    );
    return io.File(fileName);
  }

  Future<void> _loadHistory() async {
    // read the history from disk
    final history = <ChatMessage>[];
    for (var i = 0; ; ++i) {
      final file = await _messageFile(i);
      if (!file.existsSync()) break;

      debugPrint('Loading: ${file.path}');
      final map = jsonDecode(await file.readAsString());
      history.add(ChatMessage.fromJson(map));
    }

    // set the history on the controller
    _provider.history = history;
  }

  Future<void> _saveHistory() async {
    // get the latest history
    final history = _provider.history.toList();

    // write the new messages
    for (var i = 0; i != history.length; ++i) {
      // skip if the file already exists
      final file = await _messageFile(i);
      if (file.existsSync()) continue;

      // write the new message to disk
      debugPrint('Saving: ${file.path}');
      final map = history[i].toJson();
      final json = JsonEncoder.withIndent('  ').convert(map);
      await file.writeAsString(json);
    }
  }

  void _clearHistory() async {
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear history?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Clear'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );

    if (ok != true) return;

    // delete any old messages
    for (var i = 0; ; ++i) {
      final file = await _messageFile(i);
      if (!file.existsSync()) break;
      debugPrint('Deleting: ${file.path}');
      await file.delete();
    }

    _provider.history = [];
  }
}
