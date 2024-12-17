[![package:flutter_ai_toolkit](https://github.com/flutter/ai/actions/workflows/flutter.yml/badge.svg)](https://github.com/flutter/ai/actions/workflows/flutter.yml)
[![pub package](https://img.shields.io/pub/v/flutter_ai_toolkit.svg)](https://pub.dev/packages/flutter_ai_toolkit)
[![package publisher](https://img.shields.io/pub/publisher/flutter_ai_toolkit.svg)](https://pub.dev/packages/flutter_ai_toolkit/publisher)

Hello and welcome to the Flutter AI Toolkit!

The AI Toolkit is a set of AI chat-related widgets to make it easy to add an AI
chat window to your Flutter app. The AI Toolkit is organized around an abstract
LLM provider API to make it easy to swap out the LLM provider that you'd like
your chat provider to use. Out of the box, it comes with support for two LLM
provider integrations: [Google Gemini AI](https://ai.google.dev/gemini-api/docs)
and [Firebase Vertex AI](https://firebase.google.com/docs/vertex-ai).

## Key Features
* **Multi-turn chat:** Maintains context across multiple interactions.  
* **Streaming responses:** Displays AI responses in real-time as they are generated.  
* **Rich text display:** Supports formatted text in chat messages.  
* **Voice input:** Allows users to input prompts using speech.  
* **Multimedia attachments:** Enables sending and receiving various media types.  
* **Custom styling:** Offers extensive customization to match your app’s design.  
* **Pluggable LLM support:** Implement a simple interface to plug in your own LLM.  
* **Cross-platform support:** Compatible with Android, iOS, web, and macOS platforms.

## Online Demo
Here's [the online demo](https://flutter-ai-toolkit-examp-60bad.web.app/) hosting the AI Toolkit:

<img src="https://raw.githubusercontent.com/flutter/ai/refs/heads/main/README/screenshot.png" height="800"/>

The [source code for this demo](https://github.com/flutter/ai/blob/main/example/lib/demo/demo.dart) is available in the repo.

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

**1. Installation**
Add the following dependencies to your `pubspec.yaml` file:

```console
$ flutter pub add flutter_ai_toolkit google_generative_ai firebase_core
```
**2. Gemini AI configuration**
The toolkit supports both Google Gemini AI and Firebase Vertex AI as LLM providers. To use Google Gemini AI, obtain an API key from [the Gemini AI Studio](https://aistudio.google.com/app/apikey). Be careful not to check this key in your source code repository to prevent unauthorized access.

You’ll also need to choose a specific Gemini model name to use in creating an instance of the Gemini model. Here we’re using `gemini-1.5-flash` but you can choose from an ever-expanding set of models.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatPage(title: 'Generative AI Chat'),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: LlmChatView(
        provider: GeminiProvider(
          model: GenerativeModel(
            model: 'gemini-1.5-flash',
            apiKey: 'GEMINI-API-KEY',
          ),
        ),
      ),
    );
  }
}
```

The `GenerativeModel` class comes from the `google_generative_ai` package. The AI Toolkit builds on top of this package with the `GeminiProvider` which plugs Gemini AI into the `LlmChatView, the top-level widget that provides an LLM-based chat conversation with your users.

Check out [the gemini.dart sample](https://github.com/flutter/ai/blob/main/example/lib/gemini/gemini.dart) for a complete usage example.

**3. Vertex AI configuration**
While Gemini AI is useful for quick prototyping, the recommended solution for production apps is Vertex AI in Firebase. This eliminates the need for an API key in your client app and replaces it with a more secure Firebase project. To use Vertex AI in your project, follow the steps described in [the Get started with the Gemini API using the Vertex AI in Firebase SDKs docs](https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter).

Once that’s complete, integrate the new Firebase project into your Flutter app using the `flutterfire` CLI tool, as described in [the Add Firebase to your Flutter app docs](https://firebase.google.com/docs/flutter/setup).

After following these instructions, you're ready to use Firebase Vertex AI in your Flutter app. Start by initializing Firebase:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

... // other imports

import 'firebase_options.dart'; // from `flutterfire config`

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

... // app stuff here
```

With Firebase properly initialized in your Flutter app, you're now ready to create an instance of the Vertex provider:

```dart
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        // create the chat view, passing in the Vertex provider
        body: LlmChatView(
          provider: VertexProvider(
            chatModel: FirebaseVertexAI.instance.generativeModel(
              model: 'gemini-1.5-flash',
            ),
          ),
        ),
      );
}
```

The FirebaseVertexAI class comes from the firebase_vertexai package. The AI Toolkit builds the VertexProvider class to expose Vertex AI to the LlmChatView. Notice that you provide a model name (and [you have several options](https://firebase.google.com/docs/vertex-ai/gemini-models#available-model-names) from which to choose) but you do not provide an API key. All of that is handled as part of the Firebase project.

Check out [the vertex.dart sample](https://github.com/flutter/ai/blob/main/example/lib/vertex/vertex.dart) for a complete usage example.

**4. Set up device permissions**
To enable your users to take advantage of features like voice input and media attachments, ensure your app has the necessary permissions:
- **Microphone access:** Configure according to the record package’s permission setup instructions.
- **File selection:** Follow the file_selector plugin’s usage instructions.
- **Image selection:** Refer to the image_picker plugin’s installation instructions.

## Samples
To execute [the example apps in repo](https://github.com/flutter/ai/tree/main/example/lib), you'll need to replace the `example/lib/gemini_api_key.dart` and `example/lib/firebase_options.dart` files, both of which are just placeholders.

### gemini_api_key.dart
Most of the example apps rely on a Gemini API key, so for those to work, you'll need to plug your API key into the `example/lib/gemini_api_key.dart` file. You can get an API key [in Gemini AI Studio](https://aistudio.google.com/app/apikey).

**NOTE: Be careful not to check the `gemini_api_key.dart` file into your git repo.**

### firebase_options.dart
To use [the Vertex AI example app](https://github.com/flutter/ai/blob/main/example/lib/vertex/vertex.dart), you need to place your Firebase configuration details into the `example/lib/firebase_options.dart` file. You can do this running the `flutterfire` CLI tool as described in [the Add Firebase to your Flutter app docs](https://firebase.google.com/docs/flutter/setup) ***from within the `example` directory***.

**NOTE: Be careful not to check the `firebase_options.dart` file into your git repo.**

## Feedback!
Along the way, as you use this package, please [log issues and feature requests](https://github.com/flutter/ai/issues) as well as any [code you'd like to contribute](https://github.com/flutter/ai/pulls). We want your feedback and your contributions to ensure that the AI Toolkit is just as robust and useful as it can be for your real-world apps.
