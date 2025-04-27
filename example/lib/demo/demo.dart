// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dark_style.dart';
import 'api_key_page.dart';

late final SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(App(prefs: prefs));
}

class App extends StatefulWidget {
  static const title = 'Demo: Flutter AI Toolkit';
  static final themeMode = ValueNotifier(ThemeMode.light);

  const App({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String? _geminiApiKey;

  @override
  void initState() {
    super.initState();
    _geminiApiKey = widget.prefs.getString('gemini_api_key');
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
    valueListenable: App.themeMode,
    builder:
        (context, mode, child) => MaterialApp(
          title: App.title,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home:
              _geminiApiKey == null
                  ? GeminiApiKeyPage(title: App.title, onApiKey: _setApiKey)
                  : ChatPage(
                    geminiApiKey: _geminiApiKey!,
                    onResetApiKey: _resetApiKey,
                  ),
          debugShowCheckedModeBanner: false,
        ),
  );

  void _setApiKey(String apiKey) {
    setState(() => _geminiApiKey = apiKey);
    widget.prefs.setString('gemini_api_key', apiKey);
  }

  void _resetApiKey() {
    setState(() => _geminiApiKey = null);
    widget.prefs.remove('gemini_api_key');
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.geminiApiKey,
    required this.onResetApiKey,
    super.key,
  });

  final String geminiApiKey;
  final void Function() onResetApiKey;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.25,
    upperBound: 1.0,
  );

  late final _provider = GeminiProvider(
    model: GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: widget.geminiApiKey,
    ),
  );

  final _halloweenMode = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _resetAnimation();
  }

  void _resetAnimation() {
    _animationController.value = 1.0;
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: _halloweenMode,
    builder:
        (context, halloween, child) => Scaffold(
          appBar: AppBar(
            title: const Text(App.title),
            actions: [
              IconButton(
                onPressed: widget.onResetApiKey,
                tooltip: 'Reset API Key',
                icon: const Icon(Icons.key),
              ),
              IconButton(
                onPressed: _clearHistory,
                tooltip: 'Clear History',
                icon: const Icon(Icons.history),
              ),
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
              IconButton(
                onPressed: () {
                  _halloweenMode.value = !_halloweenMode.value;
                  if (_halloweenMode.value) _resetAnimation();
                },
                tooltip:
                    _halloweenMode.value ? 'Normal Mode' : 'Halloween Mode',
                icon: Text('🎃'),
              ),
            ],
          ),
          body: AnimatedBuilder(
            animation: _animationController,
            builder:
                (context, child) => Stack(
                  children: [
                    SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/halloween-bg.png',
                        fit: BoxFit.cover,
                        opacity: _animationController,
                      ),
                    ),
                    LlmChatView(
                      provider: _provider,
                      style: style,
                      welcomeMessage:
                          'Hello and welcome to the Flutter AI Toolkit!',
                      suggestions: [
                        'I\'m a Star Wars fan. What should I wear for Halloween?',
                        'I\'m allergic to peanuts. What candy should I avoid at '
                            'Halloween?',
                        'What\'s the difference between a pumpkin and a squash?',
                      ],
                    ),
                  ],
                ),
          ),
        ),
  );

  void _clearHistory() {
    _provider.history = [];
    _resetAnimation();
  }

  LlmChatViewStyle get style {
    if (!_halloweenMode.value) {
      return App.themeMode.value == ThemeMode.dark
          ? darkChatViewStyle()
          : LlmChatViewStyle.defaultStyle();
    }

    // Halloween mode
    final TextStyle halloweenTextStyle = GoogleFonts.hennyPenny(
      color: Colors.white,
      fontSize: 24,
    );

    final TextStyle halloweenMenuItemTextStyle = GoogleFonts.hennyPenny(
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

    final halloweenMenuItemStyle = ActionButtonStyle(
      textStyle: halloweenMenuItemTextStyle,
      iconColor: Colors.white,
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

    return LlmChatViewStyle(
      backgroundColor: Colors.transparent,
      menuColor: Colors.grey.shade600,
      progressIndicatorColor: Colors.purple,
      suggestionStyle: SuggestionStyle(
        textStyle: halloweenTextStyle.copyWith(color: Colors.black),
        decoration: BoxDecoration(
          color: Colors.yellow,
          border: Border.all(color: Colors.orange),
        ),
      ),
      chatInputStyle: ChatInputStyle(
        backgroundColor:
            _animationController.isAnimating
                ? Colors.transparent
                : Colors.black,
        decoration: BoxDecoration(
          color: Colors.yellow,
          border: Border.all(color: Colors.orange),
        ),
        textStyle: halloweenTextStyle.copyWith(color: Colors.black),
        hintText: 'good evening...',
        hintStyle: halloweenTextStyle.copyWith(
          color: Colors.orange.withAlpha(128),
        ),
      ),
      userMessageStyle: UserMessageStyle(
        textStyle: halloweenTextStyle.copyWith(color: Colors.black),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade300, Colors.grey.shade400],
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
      attachFileButtonStyle: halloweenMenuItemStyle,
      cameraButtonStyle: halloweenMenuItemStyle,
      closeButtonStyle: halloweenActionButtonStyle,
      cancelButtonStyle: halloweenActionButtonStyle,
      closeMenuButtonStyle: halloweenActionButtonStyle,
      copyButtonStyle: halloweenMenuButtonStyle,
      editButtonStyle: halloweenMenuButtonStyle,
      galleryButtonStyle: halloweenMenuItemStyle,
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
    );
  }
}
