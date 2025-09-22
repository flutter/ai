# Flutter AI Toolkit - Project Overview

## What is Flutter AI Toolkit?

The **Flutter AI Toolkit** is an official Flutter package that provides ready-to-use AI chat widgets and components for Flutter applications. It enables developers to quickly integrate sophisticated AI-powered conversational interfaces into mobile, desktop, and web apps.

## Key Features

### 🚀 **Core Capabilities**
- **Multi-turn conversations** with context preservation
- **Real-time streaming responses** from AI models  
- **Rich text and markdown** support in messages
- **Voice input** with speech-to-text integration
- **Media attachments** (images, files, links)
- **Cross-platform** support (Android, iOS, web, macOS)

### 🛠️ **Developer-Friendly**
- **Pluggable architecture** for different AI providers
- **Extensive customization** and theming options
- **Chat persistence** with serialization support
- **Function calling** for AI agents and tools
- **Comprehensive examples** and documentation

## Architecture

### Main Components

```
LlmChatView          # Main chat interface widget
├── LlmProvider      # Abstract AI model interface
│   └── FirebaseProvider  # Firebase AI implementation
├── ChatMessage      # Individual message representation
├── ChatViewModel    # State management
└── Styling System   # Customizable themes and styles
```

### Provider System
The toolkit uses a **pluggable provider architecture**:
- **Built-in**: `FirebaseProvider` for Google's Vertex AI and Gemini
- **Extensible**: Implement `LlmProvider` for custom AI services
- **Flexible**: Easy to swap between different AI models

## Quick Start Example

```dart
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:firebase_ai/firebase_ai.dart';

// Basic AI chat interface
LlmChatView(
  provider: FirebaseProvider(
    model: FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.0-flash'
    ),
  ),
)
```

## Project Structure

```
flutter_ai_toolkit/
├── lib/src/
│   ├── providers/     # AI model integrations
│   ├── views/         # UI components  
│   ├── styles/        # Theming system
│   └── chat_view_model/ # State management
├── example/lib/       # 15+ example apps
│   ├── main.dart      # Basic chat example
│   ├── welcome/       # Welcome message demo
│   ├── function_calls/ # AI agent with tools  
│   ├── voice/         # Speech input
│   ├── file_upload/   # Media attachments
│   └── ...           # Many more examples
└── test/             # Test suite
```

## Example Applications

The project includes comprehensive examples demonstrating:

| Example | Purpose |
|---------|---------|
| `main.dart` | Basic AI chat interface |
| `welcome/` | Custom welcome messages |
| `function_calls/` | AI agents with tool calling |
| `voice/` | Speech-to-text integration |
| `file_upload/` | Media attachment handling |
| `styles/` | Custom theming and design |
| `dark_mode/` | Dark theme implementation |
| `cupertino/` | iOS-native design |
| `history/` | Conversation persistence |
| `recipes/` | Real-world structured app |

## Recent Updates (v0.10.0)

### Migration to Firebase AI
- **Unified provider**: Replaced separate `GeminiProvider` and `VertexProvider` with single `FirebaseProvider`
- **Firebase integration**: All projects now use Firebase configuration
- **Enhanced function calling**: Improved AI agent capabilities with tool support
- **Better file handling**: Support for both direct and link-based attachments

### New Features
- Custom speech-to-text implementations
- Enhanced dark mode theming  
- Improved mobile user experience
- Better error handling and validation
- Performance optimizations

## Technical Requirements

- **Flutter**: 3.27.0+
- **Dart**: 3.7.0+
- **Firebase**: Project setup required
- **Platforms**: Android, iOS, web, macOS

## Getting Started

### 1. Installation
```bash
flutter pub add flutter_ai_toolkit firebase_ai firebase_core
```

### 2. Firebase Setup
```bash
flutterfire config
```

### 3. Basic Implementation
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('AI Chat')),
      body: LlmChatView(
        provider: FirebaseProvider(
          model: FirebaseAI.googleAI().generativeModel(
            model: 'gemini-2.0-flash'
          ),
        ),
      ),
    ),
  );
}
```

## Use Cases

### Perfect For:
- **Customer support** chatbots
- **Educational** AI tutors  
- **Productivity** AI assistants
- **Creative** writing tools
- **Code assistance** applications
- **Content generation** apps

### Enterprise Ready:
- Production-tested codebase
- Comprehensive error handling
- Security best practices
- Scalable architecture
- Extensive documentation

## Contributing

The Flutter AI Toolkit is an active open-source project:
- **Repository**: https://github.com/flutter/ai
- **Issues**: Bug reports and feature requests welcome
- **Pull Requests**: Community contributions encouraged
- **Examples**: New use case demonstrations appreciated

## Resources

- **Package**: [pub.dev/packages/flutter_ai_toolkit](https://pub.dev/packages/flutter_ai_toolkit)
- **Documentation**: [docs.flutter.dev/ai-toolkit](https://docs.flutter.dev/ai-toolkit)
- **Examples**: [github.com/flutter/ai/tree/main/example](https://github.com/flutter/ai/tree/main/example)
- **Firebase AI**: [firebase.google.com/docs/vertex-ai](https://firebase.google.com/docs/vertex-ai)

---

*The Flutter AI Toolkit is developed and maintained by the Flutter team at Google, ensuring high quality, regular updates, and long-term support for production applications.*