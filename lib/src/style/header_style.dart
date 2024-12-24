import 'package:flutter/material.dart';

/// Class for styling Calendar's header.
class HeaderStyle {
  /// Provide text style for calendar's header.
  final TextStyle? headerTextStyle;

  /// Determines left icon visibility.
  final bool leftIconVisible;

  /// Determines right icon visibility.
  final bool rightIconVisible;

  /// Internal padding of the whole header.
  final EdgeInsets headerPadding;

  /// External margin of the whole header.
  final EdgeInsets headerMargin;

  /// Define Alignment of header text.
  final TextAlign titleAlign;

  /// Create a `HeaderStyle` of calendar view
  const HeaderStyle({
    this.headerTextStyle,
    this.leftIconVisible = true,
    this.rightIconVisible = true,
    this.headerMargin = EdgeInsets.zero,
    this.headerPadding = const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 12,
    ),
    this.titleAlign = TextAlign.center,
  });
}
