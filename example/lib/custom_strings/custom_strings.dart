// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  static const title = 'Example: Google Gemini AI';

  const App({super.key});

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(title: title, home: CustomStringsExample());
}

class CustomStringsExample extends StatelessWidget {
  static const title = 'Custom Chat Strings';

  const CustomStringsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final customStrings = const LlmChatViewStrings(
      addAttachment: 'Add',
      attachFile: 'Attach File',
      takePhoto: 'Take Photo',
      stop: '⏹️ Stop',
      close: '❌ Close',
      cancel: '❌ Cancel',
      copyToClipboard: '📋 Copy',
      editMessage: '✏️ Edit',
      attachImage: '🖼️ Add Image',
      recordAudio: '🎤 Record',
      submitMessage: '📤 Send',
      closeMenu: '❌ Close Menu',

      // Message related
      typeAMessage: 'Type your message here...',
      recording: '🔴 Recording...',
      tapToStop: 'Tap to stop',
      tapToRecord: 'Tap to record',
      releaseToCancel: 'Release to cancel',
      slideToCancel: 'Slide to cancel',

      submit: 'Submit',
      send: 'Send',
      delete: '🗑️ Delete',
      edit: '✏️ Edit',
      copy: '📋 Copy',
      share: '↗️ Share',
      retry: '🔄 Retry',
      yes: '✅ Yes',
      no: '❌ No',
      clear: '🗑️ Clear',
      search: '🔍 Search',

      // Messages and errors
      messageCopiedToClipboard: '📋 Copied to clipboard!',
      editing: '✏️ Editing',
      error: '❌ Error',
      cancelMessage: 'Cancel',
      confirmDelete: 'Confirm Delete',
      areYouSureYouWantToDeleteThisMessage:
          'Are you sure you want to delete this message?',
      errorSendingMessage: '❌ Failed to send message',
      errorLoadingMessages: '❌ Failed to load messages',
      noMessagesYet: 'No messages yet. Start the conversation!',
      tapToRetry: 'Tap to retry',
      noResultsFound: 'No results found',
      unableToRecordAudio: 'Unable to record audio',
      unsupportedImageSource: 'Unsupported image source',
      unableToPickImage: 'Unable to pick image',
      unableToPickFile: 'Unable to pick file',
      unableToPickUrl: 'Unable to process URL',
    );

    return Scaffold(
      appBar: AppBar(title: const Text(App.title)),
      body: LlmChatView(
        provider: FirebaseProvider(
          model: FirebaseAI.googleAI().generativeModel(
            model: 'gemini-2.0-flash',
          ),
        ),
        strings: customStrings,
        style: LlmChatViewStyle(strings: customStrings),
      ),
    );
  }
}
