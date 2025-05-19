// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Smoke Test - Echo Provider', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: LlmChatView(provider: SimpleEchoProvider())),
      ),
    );

    // Find the text field and enter a message
    final textField = find.byWidgetPredicate((widget) => widget is TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, 'Hello, World!');
    await tester.pump();

    // Find the submit button by its tooltip and tap it
    final submitButton = find.byTooltip('Submit Message');
    expect(submitButton, findsOneWidget);
    await tester.tap(submitButton);
    await tester.pump();

    // Check for the response
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is MarkdownBody &&
            widget.data == 'prompt: Hello, World!\nattachments: []',
      ),
      findsOneWidget,
    );
  });
}

class SimpleEchoProvider extends LlmProvider with ChangeNotifier {
  SimpleEchoProvider({Iterable<ChatMessage>? history})
    : _history = List<ChatMessage>.from(history ?? []);

  final List<ChatMessage> _history;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    yield 'prompt: $prompt\n';
    yield 'attachments: ${attachments.isEmpty ? '[]' : attachments.map((a) => a.toString())}';
  }

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    _history.addAll([userMessage, llmMessage]);
    final chunks = generateStream(prompt, attachments: attachments);
    await for (final chunk in chunks) {
      llmMessage.append(chunk);
      yield chunk;
    }
    notifyListeners();
  }

  @override
  Iterable<ChatMessage> get history => _history;

  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    notifyListeners();
  }
}
