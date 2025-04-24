// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// using dynamic calls to translate to/from JSON
// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'attachments.dart';
import 'message_origin.dart';
import '../../utility.dart';

/// Represents a message in a chat conversation.
///
/// This class encapsulates the properties and behavior of a chat message,
/// including its unique identifier, origin (user or LLM), text content,
/// and any attachments.
class ChatMessage extends ChangeNotifier {
  /// Constructs a [ChatMessage] instance.
  ///
  /// The [id] parameter is a unique identifier for the message.
  /// The [origin] parameter specifies the origin of the message (user or LLM).
  /// The [text] parameter is the content of the message. It can be null or
  /// empty if the message is from an LLM. For user-originated messages, [text]
  /// must not be null or empty. 
  /// The [attachments] parameter is a list of any files or media attached to the message.
  /// The [children] parameter is a list of child messages associated with
  /// this message. 
  /// The [currentChild] parameter is the currently active child message.
  ChatMessage({
    ValueKey<String>? id,
    required this.origin,
    String? text,
    this.attachments = const [],
    List<ChatMessage>? children,
    ChatMessage? currentChild,
  })  : id = id ?? ValueKey<String>(generateUuidV4()),
        _text = text,
        _children = children ?? [],
        _currentChild = currentChild {
    if (currentChild == null) {
      _currentChild = _children.isNotEmpty ? _children.first : null;
    }
    else if (!_children.contains(currentChild)) {
      _children.add(currentChild);
    }
    
    for (final child in _children) {
      child.parent = this;
    }
  }

  /// Converts a JSON map list representation to a [ChatMessage].
  /// 
  /// If no [id] is provided, it will be derived from the first map in the list with a null parent.
  /// Which is assumed to be the root message.
  factory ChatMessage.fromMapList(List<Map<String, dynamic>> mapList, [ValueKey<String>? id]) {
    id ??= ValueKey<String>(mapList.firstWhere(
      (map) => map['parent'] == null,
      orElse: () => throw ArgumentError('No root found in mapList'),
    )['id']);

    final map = mapList.firstWhere(
      (map) => map['id'] == id!.value,
      orElse: () => throw ArgumentError('No message found with id: ${id!.value}'),
    );

    List<Attachment> attachments = [];
    if (map['attachments'] != null) {
      for (final attachment in map['attachments']) {
        switch (attachment['type'] as String) {
          case 'file':
            attachments.add(
              FileAttachment.fileOrImage(
                name: attachment['name'] as String,
                mimeType: attachment['mimeType'] as String,
                bytes: base64Decode(attachment['data'] as String),
              ),
            );
            break;
          case 'link':
            attachments.add(
              LinkAttachment(
                name: attachment['name'] as String,
                url: Uri.parse(attachment['data'] as String),
              ),
            );
            break;
          default:
            throw UnimplementedError('Unknown attachment type: ${attachment['type']}');
        }
      }
    }

    List<ChatMessage> children = [];
    for (final childId in map['children']) {
      children.add(ChatMessage.fromMapList(mapList, ValueKey<String>(childId)));
    }

    ChatMessage? currentChild;
    if (map['current_child'] != null) {
      currentChild = children.firstWhere(
        (child) => child.id.value == map['current_child'],
        orElse: () => throw ArgumentError('No child found with id: ${map['current_child']}'),
      );
    }

    return ChatMessage(
      id: id,
      origin: MessageOrigin.fromString(map['role']),
      text: map['text'],
      attachments: attachments,
      children: children,
      currentChild: currentChild,
    );
  }

  /// Factory constructor for creating an LLM-originated message.
  ///
  /// Creates a message with an empty text content and no attachments.
  factory ChatMessage.llm() => ChatMessage(origin: MessageOrigin.llm);

  /// Factory constructor for creating a user-originated message.
  ///
  /// [text] is the content of the user's message.
  /// [attachments] are any files or media the user has attached to the message.
  factory ChatMessage.user(String text, Iterable<Attachment> attachments) =>
      ChatMessage(
        origin: MessageOrigin.user,
        text: text,
        attachments: attachments,
      );

  /// Appends additional text to the existing message content.
  ///
  /// This is typically used for LLM messages that are streamed in parts.
  void append(String text) => this.text = (this.text ?? '') + text;

  final List<ChatMessage> _children;

  /// List of child messages associated with this message.
  List<ChatMessage> get children => _children;

  ChatMessage? _parent;

  /// The parent message of this message.
  ChatMessage? get parent => _parent;

  set parent(ChatMessage? value) {
    if (_parent != null) {
      throw ArgumentError('Parent already set');
    }

    _parent = value;
    notifyListeners();
  }

  /// A Unique identifier for the message.
  final ValueKey<String> id;

  String? _text;

  /// Text content of the message.
  String? get text => _text;
  
  set text(String? value) {
    _text = value;
    notifyListeners();
  }

  /// The origin of the message (user or LLM).
  final MessageOrigin origin;

  /// Any attachments associated with the message.
  final Iterable<Attachment> attachments;

  ChatMessage? _currentChild;

  /// The currently active child message.
  ChatMessage? get currentChild => _currentChild;

  /// Sets the currently active child message to the next child in the list.
  /// If there are no children or if the current child is the last one, it does nothing.
  /// If the current child is null, it sets the first child as the current child.
  void nextChild() {
    if (_children.isEmpty) return;

    int index = 0;
    if (_currentChild != null) {
      final lastIndex = _children.indexOf(_currentChild!);
      index = math.min(_children.length - 1, lastIndex + 1);
    }
    _currentChild = _children[index];
    notifyListeners();
  }

  /// Sets the currently active child message to the previous child in the list.
  /// If there are no children or if the current child is the first one, it does nothing.
  /// If the current child is null, it sets the first child as the current child.
  void previousChild() {
    if (_children.isEmpty) return;

    int index = 0;
    if (_currentChild != null) {
      final lastIndex = _children.indexOf(_currentChild!);
      index = math.max(0, lastIndex - 1);
    }
    _currentChild = _children[index];
    notifyListeners();
  }

  /// Adds a child message to the list of children.
  /// Sets the added child as the current child.
  void addChild(ChatMessage child) {
    _children.add(child);
    child.parent = this;
    _currentChild = child;
    notifyListeners();
  }

  /// Removes a child message from the list of children.
  /// If the removed child was the current child, sets the first child as the current child.
  void removeChild(ChatMessage child) {
    _children.remove(child);
    _currentChild = _children.isNotEmpty ? _children.first : null;
    notifyListeners();
  }

  /// Returns the last message in the chain of messages.
  ChatMessage get tail => chain.last;

  /// Returns the first message in the chain of messages.
  ChatMessage get root => chainReverse.last;

  /// Returns the current conversation chain of messages.
  /// 
  /// The chain starts from the current message and goes down to the last message.
  List<ChatMessage> get chain {
    final List<ChatMessage> chain = [];

    ChatMessage current = this;
    do {
      chain.add(current);
      
      if (current.currentChild != null) {
        current = current.currentChild!;
      }
    } while (current.currentChild != null);

    return chain;
  }

  /// Returns the reverse of the current conversation chain of messages.
  /// 
  /// The chain starts from the this message and goes up to the first message.
  List<ChatMessage> get chainReverse {
    final List<ChatMessage> chain = [];

    ChatMessage current = this;
    do {
      chain.add(current);

      if (current.parent != null) {
        current = current.parent!;
      }
    } while (current.parent != null);

    return chain;
  }

  /// Returns the index of the current child in the list of children.
  /// If the current child is null, it returns -1.
  int get currentChildIndex => _children.indexOf(_currentChild!);

  /// Converts the message and its children to a list of maps.
  List<Map<String, dynamic>> toMapList() {
    final mapList = [{
      'id': id.value,
      'parent': parent?.id.value,
      'children': children.map((child) => child.id.value).toList(),
      'current_child': currentChild?.id.value,
      'origin': origin.name,
      'text': text,
      'attachments': [
        for (final attachment in attachments)
          {
            'type': switch (attachment) {
              (FileAttachment _) => 'file',
              (LinkAttachment _) => 'link',
            },
            'name': attachment.name,
            'mimeType': switch (attachment) {
              (final FileAttachment a) => a.mimeType,
              (final LinkAttachment a) => a.mimeType,
            },
            'data': switch (attachment) {
              (final FileAttachment a) => base64Encode(a.bytes),
              (final LinkAttachment a) => a.url,
            },
          },
      ]
    }];

    for (final child in _children) {
      mapList.addAll(child.toMapList());
    }

    return mapList;
  }

  @override
  String toString() =>
      'ChatMessage('
      'id: $id, '
      'parent: ${parent?.id.value}, '
      'currentChild: ${currentChild?.id.value}, '
      'children: ${_children.map((child) => child.id.value).toList()}, '
      'origin: $origin, '
      'text: $text, '
      'attachments: $attachments'
      ')';
}