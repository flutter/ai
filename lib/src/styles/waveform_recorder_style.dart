import 'package:flutter/material.dart';

/// Style for the waveform recorder widget.
@immutable
class VoiceNoteRecorderStyle {
  /// Creates a style object for the waveform recorder.
  const VoiceNoteRecorderStyle({
    this.height,
    this.waveColor,
    this.durationTextStyle,
  });

  /// Resolves the provided [style] with the [defaultStyle].
  ///
  /// This method returns a new [VoiceNoteRecorderStyle] instance where each property
  /// is taken from the provided [style] if it is not null, otherwise from the
  /// [defaultStyle].
  ///
  /// - [style]: The style to resolve. If null, the [defaultStyle] will be used.
  /// - [defaultStyle]: The default style to use for any properties not provided
  ///   by the [style].
  factory VoiceNoteRecorderStyle.resolve(
    VoiceNoteRecorderStyle? style, {
    VoiceNoteRecorderStyle? defaultStyle,
  }) {
    defaultStyle ??= VoiceNoteRecorderStyle.defaultStyle();
    return VoiceNoteRecorderStyle(
      height: style?.height ?? defaultStyle.height,
      waveColor: style?.waveColor ?? defaultStyle.waveColor,
      durationTextStyle:
          style?.durationTextStyle ?? defaultStyle.durationTextStyle,
    );
  }

  /// Provides default style if none is specified.
  factory VoiceNoteRecorderStyle.defaultStyle() => const VoiceNoteRecorderStyle(
    height: 48.0,
    waveColor: Colors.black,
    durationTextStyle: TextStyle(color: Colors.black),
  );

  /// The height of the waveform recorder.
  final double? height;

  /// The color of the waveform.
  final Color? waveColor;

  /// The text style for the duration display.
  final TextStyle? durationTextStyle;
}
