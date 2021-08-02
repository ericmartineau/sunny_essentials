import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

class PlatformOverlayTheme {
  factory PlatformOverlayTheme.of(BuildContext context) {
    try {
      return Provider.of(context);
    } catch (e) {
      return const PlatformOverlayTheme();
    }
  }

  final Color? _backgroundColor;
  final Color? _foregroundColor;
  final EdgeInsets padding;
  final double elevation;

  const PlatformOverlayTheme(
      {Color? backgroundColor,
      Color? foregroundColor,
      this.padding =
          const EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 10),
      this.elevation = 2})
      : _backgroundColor = backgroundColor,
        _foregroundColor = foregroundColor;

  Color get backgroundColor =>
      _backgroundColor ?? sunnyColors.scaffoldBackground.darkColor;

  Color get foregroundColor => _foregroundColor ?? sunnyColors.g800.darkColor;
}
