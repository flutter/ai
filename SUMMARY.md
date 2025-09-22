# Flutter AI Toolkit - Quick Summary

## What is it?
**Flutter AI Toolkit** is an official Flutter package providing ready-to-use AI chat widgets for building conversational interfaces in Flutter apps.

## Key Stats
- **Package**: `flutter_ai_toolkit` on pub.dev
- **Version**: 0.10.0 (current)
- **License**: BSD (Flutter standard)
- **Platforms**: Android, iOS, web, macOS
- **Codebase**: ~9,000 lines across Dart, YAML, and Markdown files
- **Examples**: 15+ comprehensive demo applications

## Core Features
✅ **Multi-turn chat** with context preservation  
✅ **Streaming responses** from AI models  
✅ **Voice input** with speech-to-text  
✅ **Media attachments** (images, files, links)  
✅ **Rich text** with markdown support  
✅ **Custom styling** and theming  
✅ **Chat persistence** (save/load conversations)  
✅ **Function calling** for AI agents  
✅ **Cross-platform** compatibility  

## Architecture
```
LlmChatView (main widget)
└── LlmProvider (pluggable AI interface)
    └── FirebaseProvider (Google AI integration)
```

## Quick Setup
```bash
# 1. Add dependencies
flutter pub add flutter_ai_toolkit firebase_ai firebase_core

# 2. Configure Firebase
flutterfire config

# 3. Use in your app
LlmChatView(
  provider: FirebaseProvider(
    model: FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash'),
  ),
)
```

## Recent Changes (v0.9.0-0.10.0)
- **Unified Firebase integration** (replaced separate Gemini/Vertex providers)
- **Enhanced function calling** for AI agents
- **Custom speech-to-text** support  
- **Improved file handling** and attachments
- **Better mobile UX** and dark mode

## Project Structure
- **`lib/src/`** - Core toolkit implementation
- **`example/lib/`** - 15+ demo applications
- **`test/`** - Test suite
- **README.md** - Comprehensive documentation

## Use Cases
Perfect for: Customer support bots, AI tutors, coding assistants, creative writing tools, productivity apps, and any application needing conversational AI.

## Maintained By
Flutter team at Google - ensuring production quality, regular updates, and long-term support.

---
*For detailed information, see PROJECT_OVERVIEW.md or README.md*