## 0.10.0

- Support `firebase_ai: ^3.0.0` and `firebase_core: ^4.0.0` (https://github.com/flutter/ai/pull/145)

## 0.9.2

- fix [#137](https://github.com/flutter/ai/issues/137): Link Attachments are not
  supported. This prevented the use of a `messageSender` function to upload
  files on the fly when making requests to certain providers (I'm looking at
  you, Firebase) that require larger (ok, really just not tiny) files to be
  uploaded before they can be processed. Check out simulated upload in the new
  file update example.

- fix [#112](https://github.com/flutter/ai/issues/112): attachments pop-up menu
  appears behind soft keyboard on mobile

- fix [#133](https://github.com/flutter/ai/issues/133): Avoiding autofocus

- fix [#127](https://github.com/flutter/ai/issues/127): stt should strip
  newlines

- fix [#100]([#127](https://github.com/flutter/ai/issues/100): audio
  transcription returns mixed AI response or no text (iOS & Android). We fix
  this by allowing you to provide your own speech-to-text implementation. Take a
  look at the new custom stt example.

- fix [#135](https://github.com/flutter/ai/issues/135): fix function calling to
  handle multiple tool calls. check out the updated function calls example! This
  gives the `FirebaseProvider` the inner loop to keep calling functions
  requested by Gemini until it gets all the info it needs to provide its
  response. That's the beating heart of an AI agent.

- fix [#111]((https://github.com/flutter/ai/issues/111): canceling the editing
  of a prompt should reset the attachments and prompt


## 0.9.1
* fix [#96](https://github.com/flutter/ai/issues/96): input field overlap issue

* fix [#121](https://github.com/flutter/ai/issues/121): [bug] waiting response
  indicator JumpingDotsProgressIndicator overflow

## 0.9.0
* added support for tool calls to the Gemini and Vertex providers. Check out the
  new `function_calls` example to see it in action. Thanks to @toshiossada for
  [the inspiration](https://github.com/flutter/ai/pull/99). Fixes
  [#98](https://github.com/flutter/ai/issues/98): How Can I get functionCalls?

* fixed [#95](https://github.com/flutter/ai/issues/95): Image Attachment
  Disappears After Audio Recording

* fixed [#102](https://github.com/flutter/ai/issues/102): migration from
  flutter_markdown to flutter_markdown_plus

* fixed [#109](https://github.com/flutter/ai/issues/109): [task] migrate
  to firebase_ai. This is a breaking change, since it removes both
  `GeminiProvider` and `VertexProvider` and replaces it with `FirebaseProvider`.
  See README.md for migration details.

* removed online demo -- no longer able to bring-your-own-API-key

## 0.8.0
* fixed [#90](https://github.com/flutter/ai/issues/90): Input box
  shrinks unexpectedly when clicking file attachment button – customization not
  supported by Flutter AI Toolkit. Moved from a menu that moves the text input
  to a pop-up menu. Added a `menuColor` setting to `LlmChatViewStyle`. Moved
  the `tooltip` related styles to `text` related styles, as some action buttons
  have icons (with tooltips) and some are menu items (with icon + text).

* fixed [#92](https://github.com/flutter/ai/issues/92): Cupertino render doesn't
  center text input inside text input area 

* fixed an issue with missing localizations under Cupertino

## 0.7.1

* fixed [#74](https://github.com/flutter/ai/issues/74): Suggestions overlapping
  with welcome message. thanks to @luis901101 for working with me to define an
  improved UX and for [the PR](https://github.com/flutter/ai/pull/79)!

## 0.7.0

* fixed [#55](https://github.com/flutter/ai/issues/55): The input field does
  not unfocus on iPhone simulator

* fixed [#52](https://github.com/flutter/ai/issues/52): Make Chat Input
  Configurable to Disable Attachments and Voice Notes

* fixed [#63](https://github.com/flutter/ai/issues/63): update all samples to
  use the 2.0 flash model

* fixed [#49](https://github.com/flutter/ai/issues/49): pub publish has warnings

* fixed [#61](https://github.com/flutter/ai/issues/61): [test] add a smoke test

* fixed [#75](https://github.com/flutter/ai/issues/75): "No MaterialLocalizations
  found" error in SelectionArea widget

## 0.6.8

* Require Dart 3.5 or later.
* Remove dependency on `package:gap`.
* fixed #40: Unrecoverable Black screen
* implements #37: Custom Callback on Prompt/Response Error

## 0.6.7

* Minor fixes

## 0.6.6

* Update for Flutter 3.27.0

## 0.6.5

* implemented #12: would like some hover icons for copy+edit on web and desktop

* implemented #9: need to be able to cancel a prompt edit and get back the last response unharmed

## 0.6.4

* fixed #62: bug: getting an image back from the LLM that doesn't exist throws an exception

* expanded the `messageSender` docs on `LlmChatView` to make it clear what it's for and when it's used

* renamed FatXxx to ToolkitXxx e.g. FatColors => ToolkitColors

* fixed #77: move dark theming to the samples and out of the toolkit, since it has no designer input

## 0.6.3

* fixed #55: TextField overflow error for large inputs

* fixed #39: bug: notify developer of invalid API key on the web

* fixed #18: Gemini or Vertex + the web + a file attachment == hang

## 0.6.2

* minor API and README updates based on review feedback

## 0.6.1

* implemented #16: feature: ensure pressing the camera button on desktop web brings up the camera

## 0.6.0

* simplifying the `LlmProvider` interface for implementors

## 0.5.0

* fixed #67: bug: audio recording translation repopulated after history cleared

* fixed #68: bug: need suggestion styling

* implemented #72: feature: move welcome message to the LlmChatView

* updated recipes sample to use required properties in the JSON schema, which improved LLM responses a great deal

* implemented #74: remove controllers as an unnecessary abstraction

* fixed an issue where canceling an operation w/ no response yet will continue showing the progress indicator.


## 0.4.2

* upgraded to waveform_recorder 1.3.0

* fix #69: SDK dependency conflict by lowering sdk requirement to 3.4.0

## 0.4.1

* updated samples, demo and README

## 0.4.0

* implemented #13: UI needs dark mode support

* implemented #30: chat serialization/deserialization

* fixed #64: bug: selection sticks around after clearing the history

* fixed #63: bug: broke multi-line text input

* fixed #60: bug: if an LLM request fails with no text in the response, the progress indicator never stops

* implemented #31: feature: provide a list of initial suggested prompts to display in an empty chat session

* implemented #25: better mobile long-press action menu for chat messages

* fixed #47: bug: Long pressing a message and then clicking outside of the toolbar should make the toolbar disappear

## 0.3.0

* implemented #32: feature: dev-configured LLM message icon

* fixed #19: prompt attachments are incorrectly merging when editing after adding attachments to a new prompt

* implemented #27: feature: styling of colors and fonts

## 0.2.1

* fixing the user message edit menu

* show errors and cancelations as separate from message output; this is necessary so that you can tell the difference between an LLM message response with a successful result that, for example, can be parsed as JSON, or an error

## 0.2.0

* implemented #33: feature: chat microphone only prompt input

* added a `generateStream` method to `LlmProvider` to support talking to the underlying generative model w/o adding to the chat history; moved `chatModel` properties in the Gemini and Vertex providers to use a more generic `generativeModel` to make it clear which model is being used for both `sendMessageStream` and `generateStream`.

* moved from [flutter_markdown_selectionarea](https://pub.dev/packages/flutter_markdown_selectionarea) to plain ol' [flutter_markdown](https://pub.dev/packages/flutter_markdown) which does now support selection if you ask it nicely. I still have some work to do on selection, however, as described in [issue #1212).

* implemented #27: styling support, including a sample

* fixed #3: ensure Google Font Roboto is being resolved

* implemented #2: feature: enable full functionality inside a Cupertino app

* fixed #45: bug: X icon button is also pushing up against the top and left edges without any padding

* fixed #59: bug: Android Studio LadyBug Upgrade Issues

* upgraded to the GA version of firebase_vertexai

## 0.1.6

* added optional `welcomeMessage` to `LlmChatView` and a welcome sample. thanks, @berkaykurkcu!

* updated VertexProvider to take a separate chat and embedding model like GeminiProvider

* fixed #51 : Click on an image to get a preview. thanks,  @Shashwat-111!

* fixed #6: get a spark icon to designate the LLM
 
* updated README for clarity

## 0.1.5

* Reference docs update

## 0.1.4

* CHANGELOG fix

## 0.1.3

* new real-world-ish sample: recipes

* new custom LLM provider sample: gemma

* handling structured LLM responses via `responseBuilder` (see recipes sample)

* app-provided prompt suggestions (see recipes sample)

* pre-processing prompts to add prompt engineering via `messageSender`

* pre-processing requests to enrich the output, e.g. host Flutter widgets (see recipes sample)

* swappable support for LLM providers; oob support for Gemini and Vertex (see gemma example)

* fixed trim and over-eager message editing issues -- thanks, @Shashwat-111!

## 0.1.2

* More README fixups

## 0.1.1

* Fixing README screenshot (sigh)

## 0.1.0

* Initial alpha release
