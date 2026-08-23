// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: implementation_imports

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_ai/src/base_model.dart';
import 'package:firebase_ai/src/client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestFirebaseCoreHostApi.setUp(_MockFirebaseApp());

  late FirebaseApp app;
  setUpAll(() async {
    app = await Firebase.initializeApp();
  });

  group('FirebaseProvider.onFunctionCalls', () {
    test(
      'invokes onFunctionCalls with the calls collected in a turn',
      () async {
        final client =
            _StubApiClient()
              ..streamResponses.addAll([
                [_functionCallResponse],
                [_textResponse],
              ]);

        final recordedCalls = <FunctionCall>[];
        final provider = FirebaseProvider(
          model: _createModel(app, client),
          onFunctionCalls: recordedCalls.addAll,
          onFunctionCall: (functionCall) async => {'temperature': 60},
        );

        await provider
            .sendMessageStream('What is the temperature?')
            .drain<void>();

        expect(recordedCalls, hasLength(1));
        expect(recordedCalls.single.name, 'getTemperature');
        expect(recordedCalls.single.args, {'city': 'Portland'});
      },
    );

    test(
      'does not invoke onFunctionCalls when no function calls are made',
      () async {
        final client = _StubApiClient()..streamResponses.add([_textResponse]);

        final recordedCalls = <FunctionCall>[];
        final provider = FirebaseProvider(
          model: _createModel(app, client),
          onFunctionCalls: recordedCalls.addAll,
        );

        await provider.sendMessageStream('Just say something').drain<void>();

        expect(recordedCalls, isEmpty);
      },
    );
  });
}

GenerativeModel _createModel(FirebaseApp app, ApiClient client) =>
    createModelWithClient(
      app: app,
      location: 'us-central1',
      model: 'some-model',
      client: client,
      useAgentPlatform: false,
    );

const _functionCallResponse = {
  'candidates': [
    {
      'content': {
        'role': 'model',
        'parts': [
          {
            'functionCall': {
              'name': 'getTemperature',
              'args': {'city': 'Portland'},
            },
          },
        ],
      },
      'finishReason': 'STOP',
    },
  ],
};

const _textResponse = {
  'candidates': [
    {
      'content': {
        'role': 'model',
        'parts': [
          {'text': 'The temperature is 60F.'},
        ],
      },
      'finishReason': 'STOP',
    },
  ],
};

final class _StubApiClient implements ApiClient {
  final streamResponses = <List<Map<String, Object?>>>[];

  @override
  Future<Map<String, Object?>> makeRequest(
    Uri uri,
    Map<String, Object?> body,
  ) => throw UnimplementedError();

  @override
  Stream<Map<String, Object?>> streamRequest(
    Uri uri,
    Map<String, Object?> body,
  ) => Stream.fromIterable(streamResponses.removeAt(0));
}

class _MockFirebaseApp implements TestFirebaseCoreHostApi {
  @override
  Future<CoreInitializeResponse> initializeApp(
    String appName,
    CoreFirebaseOptions initializeAppRequest,
  ) async => CoreInitializeResponse(
    name: appName,
    options: initializeAppRequest,
    pluginConstants: {},
  );

  @override
  Future<List<CoreInitializeResponse>> initializeCore() async => [
    CoreInitializeResponse(
      name: defaultFirebaseAppName,
      options: CoreFirebaseOptions(
        apiKey: '123',
        projectId: '123',
        appId: '123',
        messagingSenderId: '123',
      ),
      pluginConstants: {},
    ),
  ];

  @override
  Future<CoreFirebaseOptions> optionsFromResource() async =>
      CoreFirebaseOptions(
        apiKey: '123',
        projectId: '123',
        appId: '123',
        messagingSenderId: '123',
      );
}
