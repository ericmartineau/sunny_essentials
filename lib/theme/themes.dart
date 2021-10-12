import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sunny_essentials/cards/platform_overlay_theme.dart';
import '../cards.dart';
import 'visual_style.dart';

typedef ThemeDataBuilder = ThemeData Function(
    Brightness brightness, TextStyle inputStyle, TextStyle placeholder1);

class Themes with EquatableMixin {
  final Brightness brightness;
  final ThemeDataBuilder themeBuilder;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final CupertinoVisualStyle visualStyle;
  final CupertinoThemeData cupertinoTheme;
  final PlatformCardTheme cardTheme;
  final PlatformOverlayTheme platformOverlayTheme;
  final ListTileTheme listTileTheme;
  Themes(
      {required this.brightness,
      required this.cardTheme,
      required this.themeBuilder,
      required this.lightTheme,
      required this.visualStyle,
      this.platformOverlayTheme = const PlatformOverlayTheme(),
      required this.cupertinoTheme,
      this.listTileTheme = const ListTileTheme(child: const SizedBox()),
      required this.darkTheme});

  @override
  List<Object> get props => [brightness, lightTheme, darkTheme, cupertinoTheme];

  Widget buildListTileTheme({required Widget child}) {
    return ListTileTheme(
      dense: listTileTheme.dense,
      shape: listTileTheme.shape,
      style: listTileTheme.style,
      selectedColor: listTileTheme.selectedColor,
      iconColor: listTileTheme.iconColor,
      textColor: listTileTheme.textColor,
      contentPadding: listTileTheme.contentPadding,
      tileColor: listTileTheme.tileColor,
      selectedTileColor: listTileTheme.selectedTileColor,
      child: child,
    );
  }
}

extension ThemesExt on Themes {
  ThemeData get themeData => brightness==Brightness.light ? lightTheme : darkTheme;
}