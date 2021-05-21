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

  const PlatformOverlayTheme({Color? backgroundColor, double? minHeight})
      : _backgroundColor = backgroundColor;

  Color get backgroundColor =>
      _backgroundColor ?? sunnyColors.scaffoldBackground.darkColor;
}
