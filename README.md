[![package:flutter_ai_toolkit](https://github.com/flutter/ai/actions/workflows/flutter.yml/badge.svg)](https://github.com/flutter/ai/actions/workflows/flutter.yml)
[![pub package](https://img.shields.io/pub/v/flutter_ai_toolkit.svg)](https://pub.dev/packages/flutter_ai_toolkit)
[![package publisher](https://img.shields.io/pub/publisher/flutter_ai_toolkit.svg)](https://pub.dev/packages/flutter_ai_toolkit/publisher)

Hello and welcome to the [Flutter AI Toolkit][]!

The AI Toolkit is a set of AI chat-related widgets to make it easy to add an AI
chat window to your Flutter app. The AI Toolkit is organized around an abstract
LLM provider API that makes it easy to swap out the LLM provider that you'd like
your chat provider to use. Out of the box, it comes with support for one LLM
provider integration: [Firebase AI][].

[Flutter AI Toolkit]: https://docs.flutter.dev/ai-toolkit
[Firebase AI]: https://firebase.google.com/docs/vertex-ai

## Key features

* **Multi-turn chat:**
  Maintains context across multiple interactions.
* **Streaming responses:**
  Displays AI responses in real-time as they're generated.
* **Rich text display:**
  Supports formatted text in chat messages.
* **Voice input:**
  Allows users to input prompts using speech.
* **Multimedia attachments:**
  Enables sending and receiving various media types.
* **Custom styling:**
  Offers extensive customization to match your app's design.
* **Chat serialization/deserialization:**
  Store and retrieve conversations between app sessions.
* **Pluggable LLM support:**
  Implement a simple interface to plug in your own LLM.
* **Cross-platform support:**
  Compatible with the Android, iOS, web, and macOS platforms.

## Migration to v0.9.0

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

## Getting started

<a href="https://idx.google.com/new?template=https%3A%2F%2Fgithub.com%2Fflutter%2Fai">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://cdn.idx.dev/btn/try_light_32.svg">
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://cdn.idx.dev/btn/try_dark_32.svg">
    <img
      height="32"
      alt="Try in IDX"
      src="https://cdn.idx.dev/btn/try_purple_32.svg">
  </picture>
</a>

 1. **Installation**

    Add the following dependencies to your `pubspec.yaml` file:

    ```sh
    $ flutter pub add flutter_ai_toolkit firebase_ai firebase_core
    ```

 2. **Configuration**

    To use Firebase AI in your project, follow the steps described in [Get
    started with the Gemini API using the Firebase AI Logic SDKs](https://firebase.google.com/docs/ai-logic/get-started?api=dev).

    After following these instructions, you're ready to use Firebase AI in your
    Flutter app. Start by initializing Firebase:

    ```dart
    import 'package:firebase_core/firebase_core.dart';
    import 'package:firebase_vertexai/firebase_ai.dart';
    import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

    // Other app imports...

    import 'firebase_options.dart'; // Generated by `flutterfire config`.

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      runApp(const App());
    }

    // Implementation of App and other widgets...
    ```

    With Firebase properly initialized in your Flutter app, you're now ready to
    create an instance of the Firebase provider:

    ```dart
    class ChatPage extends StatelessWidget {
      const ChatPage({super.key});

      @override
      Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: LlmChatView(
          provider: FirebaseProvider(
            model: FirebaseAI.vertexAI().generativeModel(
              model: 'gemini-2.0-flash'
            ),
          ),
        ),
      );
    }
    ```

    The `FirebaseAI` class comes from the `firebase_ai` package. The AI Toolkit
    provides the `FirebaseProvider` class to expose Firebase AI to the
    `LlmChatView`. Note that you provide a model name that corresponds to one of
    the [available model names][firebase-models].

    For a complete usage example, check out the [`vertex.dart` sample][].

 3. **Set up device permissions**

To enable your users to take advantage of features like voice input and media
attachments, ensure that your app has the necessary permissions:

- **Network access:**

To enable network access on macOS, add the following to your `*.entitlements`
files:

```xml
<plist version="1.0">
    <dict>
      ...
      <key>com.apple.security.network.client</key>
      <true/>
    </dict>
</plist>
```

To enable network access on Android, ensure that your `AndroidManifest.xml` file contains the following:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    ...
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
```

- **Microphone access:**
  To enable voice input for users, update configs according to the
  [permission and setup instructions][record-setup] for `package:record`.

- **File selection:**
  To enable users to select and attach files,
  follow the [usage instructions][file-setup] for `package:file_selector`.

- **Image selection:**
  To enable users to take or select a picture from their device, refer to
  the [installation instructions][image-setup] for `package:image_picker`.

[firebase-models]: https://firebase.google.com/docs/ai-logic/models#available-model-names
[`vertex.dart` sample]: https://github.com/flutter/ai/blob/main/example/lib/vertex/vertex.dart

[record-setup]: https://pub.dev/packages/record#setup-permissions-and-others
[file-setup]: https://pub.dev/packages/file_selector#usage
[image-setup]: https://pub.dev/packages/image_picker#installation

## Samples

To run the [example apps][] in the `example/lib` directory, first replace the
`example/lib/firebase_options.dart` file by running `flutterfire config` (you
may need to manually delete this file first). The provided
`firebase_options.dart` file is a placeholder for configuration needed by the
examples.

[example apps]: https://github.com/flutter/ai/tree/main/example/lib

## Feedback

As you use this package, please [log issues and feature requests][] as well as
submit any [code you'd like to contribute][]. We want your feedback and
contributions to ensure that the AI Toolkit is as robust and useful as it can be
for your real-world apps.

[log issues and feature requests]: https://github.com/flutter/ai/issues
[code you'd like to contribute]: https://github.com/flutter/ai/pulls
