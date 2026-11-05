// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'smoke_test.dart' show SimpleEchoProvider;

void main() {
  const recordChannel = MethodChannel('com.llfbandit.record/messages');

  setUp(() {
    // A recorder that can't get the microphone: no permission, and starting
    // fails the way it does when the user or browser denies access.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(recordChannel, (call) async {
          switch (call.method) {
            case 'create':
            case 'dispose':
              return null;
            case 'hasPermission':
              return false;
            default:
              throw PlatformException(
                code: 'record',
                message: 'Permission denied',
              );
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(recordChannel, null);
  });

  testWidgets('shows the default message when recording fails to start', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: LlmChatView(provider: SimpleEchoProvider())),
      ),
    );

    await tester.tap(find.byTooltip('Record Audio'));
    await tester.pumpAndSettle();

    expect(find.text('Unable to record audio'), findsOneWidget);
  });

  testWidgets('passes the error to onRecordingErrorCallback', (tester) async {
    Object? recordingError;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LlmChatView(
            provider: SimpleEchoProvider(),
            onRecordingErrorCallback:
                (context, error) => recordingError = error,
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Record Audio'));
    await tester.pumpAndSettle();

    expect(recordingError, isNotNull);
    expect(find.text('Unable to record audio'), findsNothing);
  });
}
