import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_ai_toolkit/src/views/chat_input/chat_suggestion_view.dart';
import 'package:flutter_ai_toolkit/src/views/chat_text_field.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Suggestions - Welcome message overlap tests', () {
    Widget materialApp(int suggestionsCount) => MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Title')),
        body: LlmChatView(
          welcomeMessage:
              'Hello! This is the Flutter AI Assistant, how can I help you today?',
          suggestions: List.generate(
            suggestionsCount,
            (index) => 'Suggestion sample ${index + 1}',
          ),
          provider: EchoProvider(),
        ),
      ),
    );
    testWidgets('Welcome message without suggestions', (tester) async {
      await tester.pumpWidget(materialApp(0));

      // Suggestions must not be visible
      final suggestionsView = find.byType(ChatSuggestionsView);
      expect(suggestionsView, findsNothing);

      // ChatTextField must be autofocus true and TextField must be focused
      final chatTextField = find.byType(ChatTextField);
      final textField = find.byType(TextField);
      expect((tester.widget<ChatTextField>(chatTextField)).autofocus, true);
      expect((tester.widget<TextField>(textField)).focusNode?.hasFocus, true);
    });
    testWidgets('Welcome message with a few suggestions', (tester) async {
      await tester.pumpWidget(materialApp(6));

      // Suggestions must be visible
      Finder suggestionsView = find.byType(ChatSuggestionsView);
      expect(suggestionsView, findsOne);

      // Suggestions must be a child of ListView
      final listView = find.ancestor(
        of: suggestionsView,
        matching: find.byType(ListView),
      );
      expect(listView, findsOne);

      // ChatTextField must be autofocus false and TextField must not be focused
      final chatTextField = find.byType(ChatTextField);
      final textField = find.byType(TextField);
      expect((tester.widget<ChatTextField>(chatTextField)).autofocus, false);
      expect((tester.widget<TextField>(textField)).focusNode?.hasFocus, false);

      // Show keyboard and write something to focus it
      await tester.showKeyboard(textField);
      await tester.enterText(textField, 'Hi');
      // Changing viewInsets bottom padding to simulate keyboard showing
      tester.view.viewInsets = FakeViewPadding(
        bottom: tester.view.viewInsets.bottom + 5,
      );
      await tester.pumpAndSettle();

      // Suggestions must still be visible now
      suggestionsView = find.byType(ChatSuggestionsView);
      expect(suggestionsView, findsOne);

      // TextField must be focused now
      expect((tester.widget<TextField>(textField)).focusNode?.hasFocus, true);
    });
    testWidgets('Welcome message with a lot of suggestions allowing scroll', (
      tester,
    ) async {
      await tester.pumpWidget(materialApp(40));

      // Suggestions must be visible
      final suggestionsView = find.byType(ChatSuggestionsView);
      expect(suggestionsView, findsOne);

      // Ensure the ChatSuggestionsView is inside a Scrollable
      final scrollable = find.ancestor(
        of: suggestionsView,
        matching: find.byType(Scrollable),
      );
      expect(scrollable, findsOne);

      // Get the ScrollableState to access the current scroll position
      final scrollableState = tester.state<ScrollableState>(scrollable);

      // Perform a scroll gesture
      await tester.drag(scrollable, const Offset(0, 200));
      await tester.pumpAndSettle();

      // Check that the scroll position has changed
      expect(scrollableState.position.pixels, isNot(0));
    });
  });
}
