// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../gemini_api_key.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: Custom Styles';
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: title,
    theme: ThemeData.from(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
    ),
    debugShowCheckedModeBanner: false,
    home: ChatPage(),
  );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  LlmProvider? _provider;
  late final _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.25,
    upperBound: 1.0,
  );

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    _provider = GeminiProvider(
      model: GenerativeModel(model: 'gemini-2.0-flash', apiKey: geminiApiKey),
    );
    _controller.value = 1.0;
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle halloweenTextStyle = GoogleFonts.hennyPenny(
      color: Colors.white,
      fontSize: 24,
    );

    final halloweenActionButtonStyle = ActionButtonStyle(
      textStyle: halloweenTextStyle,
      iconColor: Colors.black,
      iconDecoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final halloweenMenuButtonStyle = ActionButtonStyle(
      textStyle: halloweenTextStyle,
      iconColor: Colors.orange,
      iconDecoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(App.title),
        actions: [
          IconButton(onPressed: reset, icon: const Icon(Icons.edit_note)),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder:
            (context, child) => Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/halloween-bg.png',
                    fit: BoxFit.cover,
                    opacity: _controller,
                  ),
                ),
                LlmChatView(
                  provider: _provider!,
                  style: LlmChatViewStyle(
                    backgroundColor: Colors.transparent,
                    progressIndicatorColor: Colors.purple,
                    chatInputStyle: ChatInputStyle(
                      backgroundColor:
                          _controller.isAnimating
                              ? Colors.transparent
                              : Colors.black,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        border: Border.all(color: Colors.orange),
                      ),
                      textStyle: halloweenTextStyle.copyWith(
                        color: Colors.black,
                      ),
                      hintText: 'good evening...',
                      hintStyle: halloweenTextStyle.copyWith(
                        color: Colors.orange.withAlpha(128),
                      ),
                    ),
                    userMessageStyle: UserMessageStyle(
                      textStyle: halloweenTextStyle.copyWith(
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.grey.shade300,
                            Colors.grey.shade400,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(128),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    llmMessageStyle: LlmMessageStyle(
                      icon: Icons.sentiment_very_satisfied,
                      iconColor: Colors.black,
                      iconDecoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          topRight: Radius.zero,
                          bottomRight: Radius.circular(8),
                        ),
                        border: Border.all(color: Colors.black),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.deepOrange.shade900,
                            Colors.orange.shade800,
                            Colors.purple.shade900,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.zero,
                          bottomLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(76),
                            blurRadius: 8,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      markdownStyle: MarkdownStyleSheet(
                        p: halloweenTextStyle,
                        listBullet: halloweenTextStyle,
                      ),
                    ),
                    recordButtonStyle: halloweenActionButtonStyle,
                    stopButtonStyle: halloweenActionButtonStyle,
                    submitButtonStyle: halloweenActionButtonStyle,
                    addButtonStyle: halloweenActionButtonStyle,
                    attachFileButtonStyle: halloweenMenuButtonStyle,
                    cameraButtonStyle: halloweenMenuButtonStyle,
                    closeButtonStyle: halloweenActionButtonStyle,
                    cancelButtonStyle: halloweenActionButtonStyle,
                    closeMenuButtonStyle: halloweenActionButtonStyle,
                    copyButtonStyle: halloweenMenuButtonStyle,
                    editButtonStyle: halloweenMenuButtonStyle,
                    galleryButtonStyle: halloweenMenuButtonStyle,
                    actionButtonBarDecoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fileAttachmentStyle: FileAttachmentStyle(
                      decoration: BoxDecoration(color: Colors.black),
                      iconDecoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filenameStyle: halloweenTextStyle,
                      filetypeStyle: halloweenTextStyle.copyWith(
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
