import 'package:flutter/widgets.dart';

import '../../styles/action_button_style.dart';
import '../../styles/toolkit_text_styles.dart';
import '../../utility.dart';
import '../action_button.dart';

/// A widget that displays an editing indicator with a cancel button.
///
/// This widget is used to show that the user is currently editing a message.
/// It provides a visual indicator with the text "Editing" and a button to
/// cancel the editing action.
///
/// The [onCancelEdit] callback is triggered when the cancel button is pressed.
/// The [cancelButtonStyle] is used to style the cancel button.
class EditingIndicator extends StatelessWidget {
  /// Creates an [EditingIndicator].
  ///
  /// The [onCancelEdit] and [cancelButtonStyle] parameters are required.
  const EditingIndicator({
    required this.onCancelEdit,
    required this.cancelButtonStyle,
    super.key,
  });

  /// The callback to be invoked when the cancel button is pressed.
  final VoidCallback onCancelEdit;

  /// The style to be applied to the cancel button.
  final ActionButtonStyle cancelButtonStyle;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 6,
      children: [
        Text(
          'Editing',
          style: ToolkitTextStyles.label.copyWith(
            color: invertColor(cancelButtonStyle.iconColor),
          ),
        ),
        ActionButton(
          onPressed: onCancelEdit,
          style: cancelButtonStyle,
          size: 16,
        ),
      ],
    ),
  );
}
