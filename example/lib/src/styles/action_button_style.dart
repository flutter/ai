// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'action_button_type.dart';
import 'tookit_icons.dart';
import 'toolkit_colors.dart';
import 'toolkit_text_styles.dart';

/// Style for icon buttons.
@immutable
class ActionButtonStyle {
  /// Creates an IconButtonStyle.
  const ActionButtonStyle({
    this.icon,
    this.iconColor,
    this.iconDecoration,
    this.tooltip,
    this.tooltipTextStyle,
    this.tooltipDecoration,
  });

  /// Resolves the provided [style] with the [defaultStyle].
  ///
  /// This method returns a new [ActionButtonStyle] instance where each property
  /// is taken from the provided [style] if it is not null, otherwise from the
  /// [defaultStyle].
  ///
  /// - [style]: The style to resolve. If null, the [defaultStyle] will be used.
  /// - [defaultStyle]: The default style to use for any properties not provided
  ///   by the [style].
  factory ActionButtonStyle.resolve(
    ActionButtonStyle? style, {
    required ActionButtonStyle defaultStyle,
  }) =>
      ActionButtonStyle(
        icon: style?.icon ?? defaultStyle.icon,
        iconColor: style?.iconColor ?? defaultStyle.iconColor,
        iconDecoration: style?.iconDecoration ?? defaultStyle.iconDecoration,
        tooltip: style?.tooltip ?? defaultStyle.tooltip,
        tooltipTextStyle:
            style?.tooltipTextStyle ?? defaultStyle.tooltipTextStyle,
        tooltipDecoration:
            style?.tooltipDecoration ?? defaultStyle.tooltipDecoration,
      );

  /// Provides default style for icon buttons.
  factory ActionButtonStyle.defaultStyle(ActionButtonType type) =>
      ActionButtonStyle._lightStyle(type);

  /// Provides default light style for icon buttons.
  factory ActionButtonStyle._lightStyle(ActionButtonType type) {
    IconData icon;
    var color = ToolkitColors.darkIcon;
    var bgColor = ToolkitColors.lightButtonBackground;
    String tooltip;
    final tooltipTextStyle = ToolkitTextStyles.tooltip;
    const tooltipDecoration = BoxDecoration(
      color: ToolkitColors.tooltipBackground,
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );

    switch (type) {
      case ActionButtonType.add:
        icon = ToolkitIcons.add;
        tooltip = 'Add Attachment';
      case ActionButtonType.attachFile:
        icon = ToolkitIcons.attach_file;
        color = ToolkitColors.whiteIcon;
        bgColor = ToolkitColors.darkButtonBackground;
        tooltip = 'Attach File';
      case ActionButtonType.camera:
        icon = ToolkitIcons.camera_alt;
        color = ToolkitColors.whiteIcon;
        bgColor = ToolkitColors.darkButtonBackground;
        tooltip = 'Take Photo';
      case ActionButtonType.stop:
        icon = ToolkitIcons.stop;
        tooltip = 'Stop';
      case ActionButtonType.close:
        icon = ToolkitIcons.close;
        color = ToolkitColors.whiteIcon;
        bgColor = ToolkitColors.darkButtonBackground;
        tooltip = 'Close';
      case ActionButtonType.cancel:
        icon = ToolkitIcons.close;
        color = ToolkitColors.whiteIcon;
        bgColor = ToolkitColors.darkButtonBackground;
        tooltip = 'Cancel';
      case ActionButtonType.copy:
        icon = ToolkitIcons.content_copy;
        color = ToolkitColors.whiteIcon;
        bgColor = ToolkitColors.darkButtonBackground;
        tooltip = 'Copy to Clipboard';
      case ActionButtonType.edit:
        icon = ToolkitIcons.edit;
        color = ToolkitColors.whiteIcon;
        bgColor = ToolkitColors.darkButtonBackground;
        tooltip = 'Edit Message';
      case ActionButtonType.gallery:
        icon = ToolkitIcons.image;
        color = ToolkitColors.whiteIcon;
        bgColor = ToolkitColors.darkButtonBackground;
        tooltip = 'Image Gallery';
      case ActionButtonType.record:
        icon = ToolkitIcons.mic;
        tooltip = 'Record Audio';
      case ActionButtonType.submit:
        icon = ToolkitIcons.submit_icon;
        color = ToolkitColors.whiteIcon;
        bgColor = ToolkitColors.darkButtonBackground;
        tooltip = 'Submit Message';
      case ActionButtonType.closeMenu:
        icon = ToolkitIcons.close;
        color = ToolkitColors.whiteIcon;
        bgColor = ToolkitColors.greyBackground;
        tooltip = 'Close Menu';
    }

    return ActionButtonStyle(
      icon: icon,
      iconColor: color,
      iconDecoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      tooltip: tooltip,
      tooltipTextStyle: tooltipTextStyle,
      tooltipDecoration: tooltipDecoration,
    );
  }

  /// The icon to display for the icon button.
  final IconData? icon;

  /// The color of the icon.
  final Color? iconColor;

  /// The decoration for the icon.
  final Decoration? iconDecoration;

  /// The tooltip for the icon button.
  final String? tooltip;

  /// The text style of the tooltip.
  final TextStyle? tooltipTextStyle;

  /// The decoration of the tooltip.
  final Decoration? tooltipDecoration;
}
