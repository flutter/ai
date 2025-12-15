## Migration to v0.9.0

The v0.9.8 release contained breaking changes. For migration notes,
please see [migration-notes.md][].

The v0.9.0 release marks the first real breaking change since the initial
release of the Flutter AI Toolkit. This change was brought on by the migration
from the `google_generative_ai` and `firebase_vertexai` packages to the new
`firebase_ai` package.

One change is that there is now a single `FirebaseProvider` that works for both
Gemini and Vertex. Both of these providers served the same models in the past,
e.g. `gemini-2.0-flash`, but did so via different mechanisms: one used an API
key and the other used a Firebase project. Another difference is the billing
model. When using the `firebase_ai` package, API key support has been dropped in
favor of always requiring a Firebase project. You can read about billing in the
Firebase docs: https://firebase.google.com/docs/ai-logic/get-started?platform=flutter&api=dev#set-up-firebase

To migrate, the following code that uses the `GeminiProvider`:

```dart
class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: LlmChatView(
        provider: GeminiProvider( // this changes
          model: GenerativeModel( // and this changes
            model: 'gemini-2.0-flash',
            apiKey: 'GEMINI-API-KEY', // and this changes
          ),
        ),
      ),
    );
  }
}
```

now becomes code that uses `googleAI()`:

```dart
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(App.title)),
    body: LlmChatView(
      provider: FirebaseProvider( // use FirebaseProvider and googleAI()
        model: FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash'),
      ),
    ),
  );
}
```

And the following code that uses the `VertexProvider`:

```dart
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(App.title)),
    body: LlmChatView(
      provider: VertexProvider( // this changes
        chatModel: FirebaseVertexAI.instance.generativeModel( // and this
          model: 'gemini-2.0-flash',
        ),
      ),
    ),
  );
}
```

becomes code that uses `vertexAI()`:

```dart
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(App.title)),
    body: LlmChatView(
      provider: FirebaseProvider( // use FirebaseProvider and vertexAI()
        model: FirebaseAI.vertexAI().generativeModel(model: 'gemini-2.0-flash'),
      ),
    ),
  );
}
```

Also, all projects must now be initialized as Firebase projects, even those
using `googleAI()`:

```dart
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

// from `flutterfire config`: https://firebase.google.com/docs/flutter/setup
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

// now you can use FirebaseAI.googleAI() or FirebaseAI.vertexAI()
```
