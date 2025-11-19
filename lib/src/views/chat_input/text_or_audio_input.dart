import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:waveform_recorder/waveform_recorder.dart';

import '../../styles/styles.dart';
import '../../utility.dart';
import '../chat_text_field.dart';
import 'editing_indicator.dart';
import 'input_state.dart';

/// A widget that provides an input field for text or audio recording.
///
/// The [TextOrAudioInput] widget allows users to either type text or record
/// audio input. It displays a text field when not recording, and a waveform
/// recorder when recording audio.
class TextOrAudioInput extends StatelessWidget {
  /// The [TextOrAudioInput] widget requires several parameters:
  /// - [inputStyle]: Defines the styling for the input field.
  /// - [waveController]: Controls the waveform recorder.
  /// - [onCancelEdit]: Callback for when editing is canceled.
  /// - [onRecordingStopped]: Callback for when audio recording is stopped.
  /// - [onSubmitPrompt]: Callback for when the text input is submitted.
  /// - [textController]: Controls the text being edited.
  /// - [focusNode]: Manages the focus of the text field.
  /// - [autofocus]: Determines if the text field should be focused on build.
  /// - [inputState]: Represents the current state of the input.
  /// - [cancelButtonStyle]: Defines the styling for the cancel button.
  /// - [voiceNoteRecorderStyle]: Defines the styling for the waveform recorder.
  const TextOrAudioInput({
    super.key,
    required ChatInputStyle inputStyle,
    required WaveformRecorderController waveController,
    required void Function()? onCancelEdit,
    required void Function() onRecordingStopped,
    required void Function() onSubmitPrompt,
    required TextEditingController textController,
    required FocusNode focusNode,
    required bool autofocus,
    required InputState inputState,
    required ActionButtonStyle cancelButtonStyle,
    required VoiceNoteRecorderStyle voiceNoteRecorderStyle,
  }) : _cancelButtonStyle = cancelButtonStyle,
       _inputState = inputState,
       _autofocus = autofocus,
       _focusNode = focusNode,
       _textController = textController,
       _onSubmitPrompt = onSubmitPrompt,
       _onRecordingStopped = onRecordingStopped,
       _onCancelEdit = onCancelEdit,
       _waveController = waveController,
       _inputStyle = inputStyle,
       _voiceNoteRecorderStyle = voiceNoteRecorderStyle;

  final ChatInputStyle _inputStyle;
  final WaveformRecorderController _waveController;
  final void Function()? _onCancelEdit;
  final void Function() _onRecordingStopped;
  final void Function() _onSubmitPrompt;
  final TextEditingController _textController;
  final FocusNode _focusNode;
  final bool _autofocus;
  final InputState _inputState;
  final ActionButtonStyle _cancelButtonStyle;
  final VoiceNoteRecorderStyle _voiceNoteRecorderStyle;
  static const _minInputHeight = 48.0;
  static const _maxInputHeight = 144.0;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: _onCancelEdit != null ? 24 : 8,
          bottom: 8,
        ),
        child: DecoratedBox(
          decoration: _inputStyle.decoration!,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: _minInputHeight,
              maxHeight: _maxInputHeight,
            ),
            child:
                _waveController.isRecording
                    ? WaveformRecorder(
                      controller: _waveController,
                      height: _voiceNoteRecorderStyle.height!,
                      waveColor: _voiceNoteRecorderStyle.waveColor!,
                      durationTextStyle:
                          _voiceNoteRecorderStyle.durationTextStyle!,
                      onRecordingStopped: _onRecordingStopped,
                    )
                    : ChatTextField(
                      minLines: 1,
                      maxLines: 1024,
                      controller: _textController,
                      autofocus: _autofocus,
                      focusNode: _focusNode,
                      textInputAction:
                          isMobile
                              ? TextInputAction.newline
                              : TextInputAction.done,
                      onSubmitted:
                          _inputState == InputState.canSubmitPrompt
                              ? (_) => _onSubmitPrompt()
                              : (_) => _focusNode.requestFocus(),
                      style: _inputStyle.textStyle!,
                      hintText: _inputStyle.hintText!,
                      hintStyle: _inputStyle.hintStyle!,
                      hintPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child:
            _onCancelEdit != null
                ? EditingIndicator(
                  onCancelEdit: _onCancelEdit,
                  cancelButtonStyle: _cancelButtonStyle,
                )
                : const SizedBox(),
      ),
    ],
  );
}
