import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:waveform_recorder/waveform_recorder.dart';

import '../../styles/styles.dart';
import '../../utility.dart';
import '../chat_text_field.dart';
import 'editing_indicator.dart';
import 'input_state.dart';

class TextOrAudioInput extends StatelessWidget {
  const TextOrAudioInput({
    super.key,
    required this.inputStyle,
    required this.waveController,
    required this.onCancelEdit,
    required this.onRecordingStopped,
    required this.onSubmitPrompt,
    required this.textController,
    required this.focusNode,
    required this.autofocus,
    required this.inputState,
    required this.cancelButtonStyle,
  });

  final ChatInputStyle inputStyle;
  final WaveformRecorderController waveController;
  final void Function()? onCancelEdit;
  final void Function() onRecordingStopped;
  final void Function() onSubmitPrompt;
  final TextEditingController textController;
  final FocusNode focusNode;
  final bool autofocus;
  final InputState inputState;
  final ActionButtonStyle cancelButtonStyle;
  static const _minInputHeight = 48.0;
  static const _maxInputHeight = 144.0;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: onCancelEdit != null ? 24 : 8,
          bottom: 8,
        ),
        child: DecoratedBox(
          decoration: inputStyle.decoration!,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: _minInputHeight,
              maxHeight: _maxInputHeight,
            ),
            child:
                waveController.isRecording
                    ? WaveformRecorder(
                      controller: waveController,
                      height: _minInputHeight,
                      onRecordingStopped: onRecordingStopped,
                    )
                    : ChatTextField(
                      minLines: 1,
                      maxLines: 1024,
                      controller: textController,
                      autofocus: autofocus,
                      focusNode: focusNode,
                      textInputAction:
                          isMobile
                              ? TextInputAction.newline
                              : TextInputAction.done,
                      onSubmitted:
                          inputState == InputState.canSubmitPrompt
                              ? (_) => onSubmitPrompt()
                              : (_) => focusNode.requestFocus(),
                      style: inputStyle.textStyle!,
                      hintText: inputStyle.hintText!,
                      hintStyle: inputStyle.hintStyle!,
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
            onCancelEdit != null
                ? EditingIndicator(
                  onCancelEdit: onCancelEdit!,
                  cancelButtonStyle: cancelButtonStyle,
                )
                : const SizedBox(),
      ),
    ],
  );
}
