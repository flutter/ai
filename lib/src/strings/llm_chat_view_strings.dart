// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

/// A class that contains all the strings used in the LlmChatView.
///
/// This class provides a way to customize the text displayed in the chat interface.
/// You can use the default values or provide your own custom strings.
@immutable
class LlmChatViewStrings {
  /// Default instance with all default values
  static const LlmChatViewStrings defaults = LlmChatViewStrings();

  /// Input/Attachment related strings
  /// Text for the add attachment button.
  final String addAttachment;

  /// Label for attaching a file.
  final String attachFile;

  /// Label for taking a photo.
  final String takePhoto;

  /// Text for the stop button.
  final String stop;

  /// Text for the close button.
  final String close;

  /// Text for the cancel button.
  final String cancel;

  /// Text for the copy to clipboard action.
  final String copyToClipboard;

  /// Text for the edit message action.
  final String editMessage;

  /// Label for attaching an image.
  final String attachImage;

  /// Text for the record audio button.
  final String recordAudio;

  /// Text for the submit message button.
  final String submitMessage;

  /// Text for closing a menu.
  final String closeMenu;

  /// Error message when unable to record audio.
  final String unableToRecordAudio;

  /// Error message prefix for unsupported image sources.
  final String unsupportedImageSource;

  /// Error message prefix when unable to pick an image.
  final String unableToPickImage;

  /// Error message prefix when unable to pick a file.
  final String unableToPickFile;

  /// Error message prefix when unable to pick a url.
  final String unableToPickUrl;

  /// Confirmation message when a message is copied to clipboard.
  final String messageCopiedToClipboard;

  /// Label indicating editing mode.
  final String editing;

  /// Generic error message.
  final String error;

  /// Text for cancel action in dialogs.
  final String cancelMessage;

  /// Text for submit action.
  final String submit;

  /// Text for the send button.
  final String send;

  /// Placeholder text for the message input field.
  final String typeAMessage;

  /// Label shown during audio recording.
  final String recording;

  /// Instruction to stop recording audio.
  final String tapToStop;

  /// Instruction to start recording audio.
  final String tapToRecord;

  /// Instruction shown when dragging to cancel recording.
  final String releaseToCancel;

  /// Instruction shown when sliding to cancel an action.
  final String slideToCancel;

  /// Text for the delete action.
  final String delete;

  /// Title for the delete confirmation dialog.
  final String confirmDelete;

  /// Confirmation message for message deletion.
  final String areYouSureYouWantToDeleteThisMessage;

  /// Affirmative response text (e.g., 'YES', 'OK').
  final String yes;

  /// Negative response text (e.g., 'NO', 'Cancel').
  final String no;

  /// Text for the edit action.
  final String edit;

  /// Text for the copy action.
  final String copy;

  /// Text for the share action.
  final String share;

  /// Text for the retry action.
  final String retry;

  /// Error message when failing to send a message.
  final String errorSendingMessage;

  /// Error message when failing to load messages.
  final String errorLoadingMessages;

  /// Placeholder text when there are no messages.
  final String noMessagesYet;

  /// Instruction to retry a failed action.
  final String tapToRetry;

  /// Label for the search functionality.
  final String search;

  /// Text for clearing input or search.
  final String clear;

  /// Message shown when no search results are found.
  final String noResultsFound;

  /// Creates a new instance of [LlmChatViewStrings] with the given strings.
  ///
  /// All parameters are optional and will default to the provided values.
  const LlmChatViewStrings({
    // Input/Attachment related
    this.addAttachment = 'Add Attachment',
    this.attachFile = 'Attach File',
    this.takePhoto = 'Take Photo',
    this.attachImage = 'Attach Image',
    this.recordAudio = 'Record Audio',
    this.typeAMessage = 'Type a message...',
    this.recording = 'Recording...',
    this.tapToStop = 'Tap to stop',
    this.tapToRecord = 'Tap to record',
    this.releaseToCancel = 'Release to cancel',
    this.slideToCancel = 'Slide to cancel',

    // Common actions
    this.stop = 'Stop',
    this.close = 'Close',
    this.cancel = 'Cancel',
    this.submit = 'Submit',
    this.send = 'Send',
    this.delete = 'Delete',
    this.edit = 'Edit',
    this.copy = 'Copy',
    this.share = 'Share',
    this.retry = 'Retry',
    this.yes = 'Yes',
    this.no = 'No',
    this.clear = 'Clear',
    this.search = 'Search',

    // Messages and errors
    this.copyToClipboard = 'Copy to Clipboard',
    this.editMessage = 'Edit Message',
    this.submitMessage = 'Submit Message',
    this.closeMenu = 'Close Menu',
    this.unableToRecordAudio = 'Unable to record audio',
    this.unsupportedImageSource = 'Unsupported image source: ',
    this.unableToPickImage = 'Unable to pick an image: ',
    this.unableToPickFile = 'Unable to pick a file: ',
    this.unableToPickUrl = 'Unable to pick a URL: ',
    this.messageCopiedToClipboard = 'Message copied to clipboard',
    this.editing = 'Editing',
    this.error = 'Error',
    this.cancelMessage = 'Cancel',
    this.confirmDelete = 'Confirm Delete',
    this.areYouSureYouWantToDeleteThisMessage =
        'Are you sure you want to delete this message?',
    this.errorSendingMessage = 'Error sending message',
    this.errorLoadingMessages = 'Error loading messages',
    this.noMessagesYet = 'No messages yet',
    this.tapToRetry = 'Tap to retry',
    this.noResultsFound = 'No results found',
  });

  /// Creates a copy of this [LlmChatViewStrings] with the given fields replaced
  /// with the new values.
  LlmChatViewStrings copyWith({
    String? addAttachment,
    String? attachFile,
    String? takePhoto,
    String? stop,
    String? close,
    String? cancel,
    String? copyToClipboard,
    String? editMessage,
    String? attachImage,
    String? recordAudio,
    String? submitMessage,
    String? closeMenu,
    String? unableToRecordAudio,
    String? unsupportedImageSource,
    String? unableToPickImage,
    String? unableToPickFile,
    String? unableToPickUrl,
    String? messageCopiedToClipboard,
    String? editing,
    String? error,
    String? cancelMessage,
    String? submit,
    String? send,
    String? typeAMessage,
    String? recording,
    String? tapToStop,
    String? tapToRecord,
    String? releaseToCancel,
    String? slideToCancel,
    String? delete,
    String? confirmDelete,
    String? areYouSureYouWantToDeleteThisMessage,
    String? yes,
    String? no,
    String? edit,
    String? copy,
    String? share,
    String? retry,
    String? errorSendingMessage,
    String? errorLoadingMessages,
    String? noMessagesYet,
    String? tapToRetry,
    String? search,
    String? clear,
    String? noResultsFound,
    String? today,
    String? yesterday,
    String? lastWeek,
    String? older,
  }) {
    return LlmChatViewStrings(
      addAttachment: addAttachment ?? this.addAttachment,
      attachFile: attachFile ?? this.attachFile,
      takePhoto: takePhoto ?? this.takePhoto,
      stop: stop ?? this.stop,
      close: close ?? this.close,
      cancel: cancel ?? this.cancel,
      copyToClipboard: copyToClipboard ?? this.copyToClipboard,
      editMessage: editMessage ?? this.editMessage,
      attachImage: attachImage ?? this.attachImage,
      recordAudio: recordAudio ?? this.recordAudio,
      submitMessage: submitMessage ?? this.submitMessage,
      closeMenu: closeMenu ?? this.closeMenu,
      unableToRecordAudio: unableToRecordAudio ?? this.unableToRecordAudio,
      unsupportedImageSource:
          unsupportedImageSource ?? this.unsupportedImageSource,
      unableToPickImage: unableToPickImage ?? this.unableToPickImage,
      unableToPickFile: unableToPickFile ?? this.unableToPickFile,
      unableToPickUrl: unableToPickUrl ?? this.unableToPickUrl,
      messageCopiedToClipboard:
          messageCopiedToClipboard ?? this.messageCopiedToClipboard,
      editing: editing ?? this.editing,
      error: error ?? this.error,
      cancelMessage: cancelMessage ?? this.cancelMessage,
      submit: submit ?? this.submit,
      send: send ?? this.send,
      typeAMessage: typeAMessage ?? this.typeAMessage,
      recording: recording ?? this.recording,
      tapToStop: tapToStop ?? this.tapToStop,
      tapToRecord: tapToRecord ?? this.tapToRecord,
      releaseToCancel: releaseToCancel ?? this.releaseToCancel,
      slideToCancel: slideToCancel ?? this.slideToCancel,
      delete: delete ?? this.delete,
      confirmDelete: confirmDelete ?? this.confirmDelete,
      areYouSureYouWantToDeleteThisMessage:
          areYouSureYouWantToDeleteThisMessage ??
          this.areYouSureYouWantToDeleteThisMessage,
      yes: yes ?? this.yes,
      no: no ?? this.no,
      edit: edit ?? this.edit,
      copy: copy ?? this.copy,
      share: share ?? this.share,
      retry: retry ?? this.retry,
      errorSendingMessage: errorSendingMessage ?? this.errorSendingMessage,
      errorLoadingMessages: errorLoadingMessages ?? this.errorLoadingMessages,
      noMessagesYet: noMessagesYet ?? this.noMessagesYet,
      tapToRetry: tapToRetry ?? this.tapToRetry,
      search: search ?? this.search,
      clear: clear ?? this.clear,
      noResultsFound: noResultsFound ?? this.noResultsFound,
    );
  }

  /// Formats [source] into a string that describes an unsupported image source.
  ///
  /// The formatted string includes the value of [source] and the string
  /// representation of [unsupportedImageSource].
  ///
  /// The [source] parameter is the image source that is not supported.
  ///
  /// Returns a string that describes the unsupported image source.
  String formatUnsupportedImageSource(String source) =>
      '$unsupportedImageSource: $source';

  /// Formats [error] into a string that describes an error occurred while
  /// picking an image.
  ///
  /// The formatted string includes the value of [error] and the string
  /// representation of [unableToPickImage].
  ///
  /// The [error] parameter is the error that occurred.
  ///
  /// Returns a string that describes the error.
  String formatUnableToPickImage(String error) => '$unableToPickImage: $error';

  /// Formats [error] into a string that describes an error occurred while
  /// picking a file.
  ///
  /// The formatted string includes the value of [error] and the string
  /// representation of [unableToPickFile].
  ///
  /// The [error] parameter is the error that occurred.
  ///
  /// Returns a string that describes the error.
  String formatUnableToPickFile(String error) => '$unableToPickFile: $error';

  /// Formats [error] into a string that describes an error occurred while
  /// picking a url.
  ///
  /// The formatted string includes the value of [error] and the string
  /// representation of [unableToPickUrl].
  ///
  /// The [error] parameter is the error that occurred.
  ///
  /// Returns a string that describes the error.
  String formatUnableToPickUrl(String error) => '$unableToPickUrl: $error';
}
