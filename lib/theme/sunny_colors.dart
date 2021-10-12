// ignore_for_file: unused_field
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:info_x/info_x.dart';

SunnyColors? _sunnyColors;

SunnyColors get sunnyColors =>
    _sunnyColors ??
    (throw Exception(
        "No sunny colors have been initialized.  Set using SunnyColors.init"));

abstract class SunnyColors {
  /// The currently resolved brightness of this color set.
  Brightness get brightness;

  /// Resolves all colors against this BuildContext and returns an immutable
  /// copy of the color data
  SunnyColors resolve(BuildContext context);

  CupertinoDynamicColor get white;

  CupertinoDynamicColor get red;

  CupertinoDynamicColor get g50;

  CupertinoDynamicColor get g100;

  CupertinoDynamicColor get g200;

  CupertinoDynamicColor get g300;

  CupertinoDynamicColor get g400;

  CupertinoDynamicColor get g500;

  CupertinoDynamicColor get g600;

  CupertinoDynamicColor get g700;

  CupertinoDynamicColor get g800;

  CupertinoDynamicColor get g900;

  CupertinoDynamicColor get black;

  CupertinoDynamicColor get iconDark;

  CupertinoDynamicColor get shadow;

  CupertinoDynamicColor get appBarBackground;

  CupertinoDynamicColor get placeholder;

  CupertinoDynamicColor get inputBackground;

  CupertinoDynamicColor get scaffoldBackground;

  CupertinoDynamicColor get modalBackground;

  CupertinoDynamicColor get inputBorder;

  CupertinoDynamicColor get headerLink;

  CupertinoDynamicColor get separator;

  CupertinoDynamicColor get text;

  CupertinoDynamicColor get textLight;

  CupertinoDynamicColor get primaryColor;

  CupertinoDynamicColor get linkColor;

  Color get barrierColor;

  const factory SunnyColors({
    required Brightness brightness,
    required CupertinoDynamicColor white,
    required CupertinoDynamicColor primaryColor,
    required CupertinoDynamicColor linkColor,
    required CupertinoDynamicColor red,
    required CupertinoDynamicColor g50,
    required CupertinoDynamicColor g100,
    required CupertinoDynamicColor g200,
    required CupertinoDynamicColor g300,
    required CupertinoDynamicColor g400,
    required CupertinoDynamicColor g500,
    required CupertinoDynamicColor g600,
    required CupertinoDynamicColor g700,
    required CupertinoDynamicColor g800,
    required CupertinoDynamicColor g900,
    required CupertinoDynamicColor black,
    required CupertinoDynamicColor iconDark,
    required CupertinoDynamicColor shadow,
    required CupertinoDynamicColor appBarBackground,
    required CupertinoDynamicColor placeholder,
    required CupertinoDynamicColor inputBackground,
    required CupertinoDynamicColor scaffoldBackground,
    required CupertinoDynamicColor modalBackground,
    required CupertinoDynamicColor inputBorder,
    required CupertinoDynamicColor headerLink,
    required CupertinoDynamicColor separator,
    required CupertinoDynamicColor text,
    required CupertinoDynamicColor textLight,
    required Color barrierColor,
  }) = SunnyColorData;

  static void init([SunnyColors? color]) {
    _sunnyColors = color ?? SunnyColors.defaults();
  }

  /**
   * Given a brightness, resolves colors against it
   */
  static SunnyColors resolveBrightness(BuildContext context) {
    _sunnyColors = sunnyColors.resolve(context);
    return sunnyColors;
  }

  factory SunnyColors.defaults() => const _DefaultSunnyColors();

  SunnyColors copyWith({
    CupertinoDynamicColor? white,
    CupertinoDynamicColor? primaryColor,
    CupertinoDynamicColor? linkColor,
    CupertinoDynamicColor? red,
    CupertinoDynamicColor? g50,
    CupertinoDynamicColor? g100,
    CupertinoDynamicColor? g200,
    CupertinoDynamicColor? g300,
    CupertinoDynamicColor? g400,
    CupertinoDynamicColor? g500,
    CupertinoDynamicColor? g600,
    CupertinoDynamicColor? g700,
    CupertinoDynamicColor? g800,
    CupertinoDynamicColor? g900,
    CupertinoDynamicColor? black,
    CupertinoDynamicColor? iconDark,
    CupertinoDynamicColor? shadow,
    CupertinoDynamicColor? appBarBackground,
    CupertinoDynamicColor? placeholder,
    CupertinoDynamicColor? inputBackground,
    CupertinoDynamicColor? scaffoldBackground,
    CupertinoDynamicColor? modalBackground,
    CupertinoDynamicColor? inputBorder,
    CupertinoDynamicColor? headerLink,
    CupertinoDynamicColor? separator,
    CupertinoDynamicColor? text,
    CupertinoDynamicColor? textLight,
    Color? barrierColor,
  });
}

class RawSunnyColors {
  static const gray950 = Color(0xFF202327);
  static const gray900 = Color(0xFF212429);
  static const gray800 = Color(0xFF353A40);
  static const gray700 = Color(0xFF495058);
  static const gray600 = Color(0xFF868F96);
  static const gray500 = Color(0xFFADB6BD);
  static const gray400 = Color(0xFFCFD4DA);
  static const gray300 = Color(0xFFDEE1E6);
  static const gray200 = Color(0xFFE8ECEF);
  static const gray100 = Color(0xFFF2F3F5);
  static const gray50 = Color(0xFFF8F9FB);
  static const blueColor = Color(0xFF0F54F0);
  static const linkColor = Color(0xFF0A42BE);
}

/// This class hold unmodified constants.
class _DefaultSunnyColors with SunnyColorMixin {
  Brightness get brightness => Brightness.light;

  CupertinoDynamicColor get primaryColor =>
      const CupertinoDynamicColor.withBrightness(
        color: RawSunnyColors.blueColor,
        darkColor: RawSunnyColors.blueColor,
      );

  CupertinoDynamicColor get linkColor =>
      const CupertinoDynamicColor.withBrightness(
        color: RawSunnyColors.linkColor,
        darkColor: RawSunnyColors.linkColor,
      );

  CupertinoDynamicColor get text => g800;

  CupertinoDynamicColor get textLight => g600;

  CupertinoDynamicColor get white => const CupertinoDynamicColor(
        debugLabel: "white/black",
        color: Colors.white,
        darkColor: Colors.black,
        darkElevatedColor: Colors.black,
        elevatedColor: Colors.white,
        highContrastColor: Colors.white,
        highContrastElevatedColor: Colors.white,
        darkHighContrastElevatedColor: Colors.black,
        darkHighContrastColor: Colors.black,
      );

  /// Lowest contrast colors
  CupertinoDynamicColor get g50 => const CupertinoDynamicColor(
        debugLabel: "contrast50",
        color: RawSunnyColors.gray50,
        darkColor: RawSunnyColors.gray900,
        darkElevatedColor: RawSunnyColors.gray800,
        elevatedColor: RawSunnyColors.gray100,
        highContrastColor: Colors.white,
        highContrastElevatedColor: RawSunnyColors.gray100,
        darkHighContrastElevatedColor: RawSunnyColors.gray800,
        darkHighContrastColor: RawSunnyColors.gray800,
      );

  CupertinoDynamicColor get g100 => const CupertinoDynamicColor(
        debugLabel: "contrast100",
        color: RawSunnyColors.gray100,
        darkColor: RawSunnyColors.gray800,
        darkElevatedColor: RawSunnyColors.gray700,
        elevatedColor: RawSunnyColors.gray200,
        highContrastColor: RawSunnyColors.gray50,
        highContrastElevatedColor: RawSunnyColors.gray200,
        darkHighContrastElevatedColor: RawSunnyColors.gray700,
        darkHighContrastColor: RawSunnyColors.gray700,
      );

  CupertinoDynamicColor get g200 => const CupertinoDynamicColor(
        debugLabel: "contrast200",
        color: RawSunnyColors.gray200,
        darkColor: RawSunnyColors.gray700,
        darkElevatedColor: RawSunnyColors.gray600,
        elevatedColor: RawSunnyColors.gray300,
        highContrastColor: RawSunnyColors.gray100,
        highContrastElevatedColor: RawSunnyColors.gray300,
        darkHighContrastElevatedColor: RawSunnyColors.gray600,
        darkHighContrastColor: RawSunnyColors.gray600,
      );

  CupertinoDynamicColor get g300 => const CupertinoDynamicColor(
        debugLabel: "contrast300",
        color: RawSunnyColors.gray300,
        darkColor: RawSunnyColors.gray600,
        darkElevatedColor: RawSunnyColors.gray500,
        elevatedColor: RawSunnyColors.gray400,
        highContrastColor: RawSunnyColors.gray200,
        highContrastElevatedColor: RawSunnyColors.gray400,
        darkHighContrastElevatedColor: RawSunnyColors.gray500,
        darkHighContrastColor: RawSunnyColors.gray500,
      );

  CupertinoDynamicColor get g400 => const CupertinoDynamicColor(
        debugLabel: "contrast400",
        color: RawSunnyColors.gray400,
        darkColor: RawSunnyColors.gray600,
        darkElevatedColor: RawSunnyColors.gray500,
        elevatedColor: RawSunnyColors.gray500,
        highContrastColor: RawSunnyColors.gray500,
        highContrastElevatedColor: RawSunnyColors.gray500,
        darkHighContrastElevatedColor: RawSunnyColors.gray500,
        darkHighContrastColor: RawSunnyColors.gray500,
      );

  CupertinoDynamicColor get g500 => const CupertinoDynamicColor(
        debugLabel: "contrast500",
        color: RawSunnyColors.gray500,
        darkColor: RawSunnyColors.gray500,
        darkElevatedColor: RawSunnyColors.gray400,
        elevatedColor: RawSunnyColors.gray500,
        highContrastColor: RawSunnyColors.gray300,
        highContrastElevatedColor: RawSunnyColors.gray400,
        darkHighContrastElevatedColor: RawSunnyColors.gray400,
        darkHighContrastColor: RawSunnyColors.gray400,
      );

  CupertinoDynamicColor get g600 => const CupertinoDynamicColor(
        debugLabel: "contrast300",
        color: RawSunnyColors.gray600,
        elevatedColor: RawSunnyColors.gray500,
        highContrastElevatedColor: RawSunnyColors.gray500,
        highContrastColor: RawSunnyColors.gray500,
        darkColor: RawSunnyColors.gray300,
        darkElevatedColor: RawSunnyColors.gray400,
        darkHighContrastColor: RawSunnyColors.gray200,
        darkHighContrastElevatedColor: RawSunnyColors.gray400,
      );

  CupertinoDynamicColor get g700 => const CupertinoDynamicColor(
        debugLabel: "contrast700",
        darkColor: RawSunnyColors.gray200,
        darkElevatedColor: RawSunnyColors.gray300,
        darkHighContrastColor: RawSunnyColors.gray100,
        darkHighContrastElevatedColor: RawSunnyColors.gray300,
        color: RawSunnyColors.gray700,
        elevatedColor: RawSunnyColors.gray600,
        highContrastElevatedColor: RawSunnyColors.gray600,
        highContrastColor: RawSunnyColors.gray600,
      );

  CupertinoDynamicColor get g800 => const CupertinoDynamicColor(
        debugLabel: "contrast800",
        color: RawSunnyColors.gray800,
        elevatedColor: RawSunnyColors.gray700,
        highContrastElevatedColor: RawSunnyColors.gray700,
        highContrastColor: RawSunnyColors.gray700,
        darkColor: RawSunnyColors.gray100,
        darkHighContrastColor: RawSunnyColors.gray50,
        darkHighContrastElevatedColor: RawSunnyColors.gray200,
        darkElevatedColor: RawSunnyColors.gray200,
      );

  /// Highest contrast colors
  CupertinoDynamicColor get g900 => const CupertinoDynamicColor(
        debugLabel: "g900",
        color: RawSunnyColors.gray900,
        elevatedColor: RawSunnyColors.gray800,
        highContrastElevatedColor: RawSunnyColors.gray800,
        highContrastColor: RawSunnyColors.gray800,
        darkColor: RawSunnyColors.gray50,
        darkElevatedColor: RawSunnyColors.gray100,
        darkHighContrastColor: Colors.white,
        darkHighContrastElevatedColor: RawSunnyColors.gray100,
      );

  /// Highest contrast colors
  CupertinoDynamicColor get black => CupertinoDynamicColor.withBrightness(
      debugLabel: "black/white", color: Colors.black, darkColor: Colors.white);

  CupertinoDynamicColor get red => const CupertinoDynamicColor.withBrightness(
        color: Color(0xFFDE4040),
        darkColor: Color(0xFFDE4040),
      );

  CupertinoDynamicColor get iconDark => g800;

  CupertinoDynamicColor get shadow => g300;

  CupertinoDynamicColor get appBarBackground => g50;

  CupertinoDynamicColor get placeholder => g600;

  CupertinoDynamicColor get inputBackground => g50;

  CupertinoDynamicColor get scaffoldBackground => g100;
  CupertinoDynamicColor get modalBackground => g50;

  CupertinoDynamicColor get inputBorder => g200;

  CupertinoDynamicColor get headerLink => g500;

  CupertinoDynamicColor get separator => g400;

  Color get barrierColor => infoX.isIOS
      ? CupertinoDynamicColor.withBrightness(
          color: Color(0x33000000),
          darkColor: Color(0x7A000000),
        )
      : CupertinoColors.black.withOpacity(0.35);

  /// Names from the hex values to make it easier
  static const x202327 = RawSunnyColors.gray950;
  static const x212429 = RawSunnyColors.gray900;
  static const x353A40 = RawSunnyColors.gray800;
  static const x495058 = RawSunnyColors.gray700;
  static const x868F96 = RawSunnyColors.gray600;
  static const xADB6BD = RawSunnyColors.gray500;
  static const xCFD4DA = RawSunnyColors.gray400;
  static const xDEE1E6 = RawSunnyColors.gray300;
  static const xE8ECEF = RawSunnyColors.gray200;
  static const xF2F3F5 = RawSunnyColors.gray100;
  static const xF8F9FB = RawSunnyColors.gray50;

  const _DefaultSunnyColors();
}

/// Implementation of color spec.
class SunnyColorData with SunnyColorMixin implements SunnyColors {
  final Brightness brightness;
  final CupertinoDynamicColor primaryColor;
  final CupertinoDynamicColor linkColor;
  final CupertinoDynamicColor red;
  final CupertinoDynamicColor white;
  final CupertinoDynamicColor g50;
  final CupertinoDynamicColor g100;
  final CupertinoDynamicColor g200;
  final CupertinoDynamicColor g300;
  final CupertinoDynamicColor g400;
  final CupertinoDynamicColor g500;
  final CupertinoDynamicColor g600;
  final CupertinoDynamicColor g700;
  final CupertinoDynamicColor g800;
  final CupertinoDynamicColor g900;
  final CupertinoDynamicColor black;
  final CupertinoDynamicColor iconDark;
  final CupertinoDynamicColor shadow;
  final CupertinoDynamicColor appBarBackground;
  final CupertinoDynamicColor placeholder;
  final CupertinoDynamicColor inputBackground;
  final CupertinoDynamicColor scaffoldBackground;
  final CupertinoDynamicColor modalBackground;
  final CupertinoDynamicColor inputBorder;
  final CupertinoDynamicColor headerLink;
  final CupertinoDynamicColor separator;
  final CupertinoDynamicColor text;
  final CupertinoDynamicColor textLight;
  final Color barrierColor;

  const SunnyColorData({
    required this.brightness,
    required this.white,
    required this.primaryColor,
    required this.linkColor,
    required this.red,
    required this.g50,
    required this.g100,
    required this.g200,
    required this.g300,
    required this.g400,
    required this.g500,
    required this.g600,
    required this.g700,
    required this.g800,
    required this.g900,
    required this.black,
    required this.iconDark,
    required this.shadow,
    required this.appBarBackground,
    required this.placeholder,
    required this.inputBackground,
    required this.scaffoldBackground,
    required this.modalBackground,
    required this.inputBorder,
    required this.headerLink,
    required this.separator,
    required this.text,
    required this.textLight,
    required this.barrierColor,
  });
}

mixin SunnyColorMixin implements SunnyColors {
  SunnyColors resolve(BuildContext context) {
    if (platformBrightness != this.brightness) {
      return SunnyColors(
        brightness: platformBrightness,
        white: this.white.resolveFrom(context),
        primaryColor: this.primaryColor.resolveFrom(context),
        linkColor: this.linkColor.resolveFrom(context),
        red: this.red.resolveFrom(context),
        g50: this.g50.resolveFrom(context),
        g100: this.g100.resolveFrom(context),
        g200: this.g200.resolveFrom(context),
        g300: this.g300.resolveFrom(context),
        g400: this.g400.resolveFrom(context),
        g500: this.g500.resolveFrom(context),
        g600: this.g600.resolveFrom(context),
        g700: this.g700.resolveFrom(context),
        g800: this.g800.resolveFrom(context),
        g900: this.g900.resolveFrom(context),
        black: this.black.resolveFrom(context),
        iconDark: this.iconDark.resolveFrom(context),
        shadow: this.shadow.resolveFrom(context),
        appBarBackground: this.appBarBackground.resolveFrom(context),
        placeholder: this.placeholder.resolveFrom(context),
        inputBackground: this.inputBackground.resolveFrom(context),
        scaffoldBackground: this.scaffoldBackground.resolveFrom(context),
        modalBackground: this.modalBackground.resolveFrom(context),
        inputBorder: this.inputBorder.resolveFrom(context),
        headerLink: this.headerLink.resolveFrom(context),
        separator: this.separator.resolveFrom(context),
        text: this.text.resolveFrom(context),
        textLight: this.textLight.resolveFrom(context),
        barrierColor: this.barrierColor,
      );
    } else {
      return this;
    }
  }

  SunnyColorData copyWith({
    CupertinoDynamicColor? white,
    CupertinoDynamicColor? primaryColor,
    CupertinoDynamicColor? linkColor,
    CupertinoDynamicColor? red,
    CupertinoDynamicColor? g50,
    CupertinoDynamicColor? g100,
    CupertinoDynamicColor? g200,
    CupertinoDynamicColor? g300,
    CupertinoDynamicColor? g400,
    CupertinoDynamicColor? g500,
    CupertinoDynamicColor? g600,
    CupertinoDynamicColor? g700,
    CupertinoDynamicColor? g800,
    CupertinoDynamicColor? g900,
    CupertinoDynamicColor? black,
    CupertinoDynamicColor? iconDark,
    CupertinoDynamicColor? shadow,
    CupertinoDynamicColor? appBarBackground,
    CupertinoDynamicColor? placeholder,
    CupertinoDynamicColor? inputBackground,
    CupertinoDynamicColor? scaffoldBackground,
    CupertinoDynamicColor? modalBackground,
    CupertinoDynamicColor? inputBorder,
    CupertinoDynamicColor? headerLink,
    CupertinoDynamicColor? separator,
    CupertinoDynamicColor? text,
    CupertinoDynamicColor? textLight,
    Color? barrierColor,
  }) {
    return SunnyColorData(
      brightness: this.brightness,
      white: white ?? this.white,
      primaryColor: primaryColor ?? this.primaryColor,
      linkColor: linkColor ?? this.linkColor,
      red: red ?? this.red,
      g50: g50 ?? this.g50,
      g100: g100 ?? this.g100,
      g200: g200 ?? this.g200,
      g300: g300 ?? this.g300,
      g400: g400 ?? this.g400,
      g500: g500 ?? this.g500,
      g600: g600 ?? this.g600,
      g700: g700 ?? this.g700,
      g800: g800 ?? this.g800,
      g900: g900 ?? this.g900,
      black: black ?? this.black,
      iconDark: iconDark ?? this.iconDark,
      shadow: shadow ?? this.shadow,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      placeholder: placeholder ?? this.placeholder,
      inputBackground: inputBackground ?? this.inputBackground,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      modalBackground: modalBackground ?? this.modalBackground,
      inputBorder: inputBorder ?? this.inputBorder,
      headerLink: headerLink ?? this.headerLink,
      separator: separator ?? this.separator,
      text: text ?? this.text,
      textLight: textLight ?? this.textLight,
      barrierColor: barrierColor ?? this.barrierColor,
    );
  }
}

const primaryLetterSpacing = 0.0;
const wideLetterSpacing = 0.0;

final defaultLightTheme = ThemeData.light();
final defaultDarkTheme = ThemeData.dark();

/// we run points calculations off this
// const basePixelWidth = 375;

extension TextStyleColorExt on TextStyle {
  // TextStyle get selected {
  //   return isIOS ? this : this.copyWith(color: sunnyColors.white);
  // }
}

extension BrightnessExt on Brightness {
  bool get isDark => this == Brightness.dark;

  bool get isLight => !isDark;
}

extension CupertinoDynamicColorToWidgetExt on CupertinoDynamicColor {
  BorderSide toBorderSide(double amount) {
    return BorderSide(color: this, width: amount);
  }
}

extension BorderSideExtensions on BorderSide {
  Border toBorder() {
    return Border.fromBorderSide(this);
  }
}

extension ColorResolver on Color {
  Color resolveFrom(BuildContext context) {
    final self = this;
    if (self is CupertinoDynamicColor) {
      return self.resolveFrom(context);
    } else {
      return this;
    }
  }

  Color withBrightness(Brightness brightness) {
    final self = this;
    if (self is CupertinoDynamicColor) {
      return brightness == Brightness.light ? self.color : self.darkColor;
    } else {
      return this;
    }
  }
}

extension ColorToWidgetExt on Color {
  BorderSide get borderSide1 {
    return BorderSide(color: this);
  }

  BorderSide toBorderSide(double amount) {
    return BorderSide(color: this, width: amount);
  }

  BorderSide get borderSide05 {
    return BorderSide(color: this, width: 0.5);
  }

  Border get border05 {
    return Border.fromBorderSide(BorderSide(color: this, width: 0.5));
  }

  Border get border05Top {
    return Border(top: BorderSide(color: this, width: 0.5));
  }

  Border get border1Top {
    return Border(top: BorderSide(color: this, width: 1));
  }

  Border get border1 {
    return Border.fromBorderSide(BorderSide(color: this, width: 0.5));
  }
}

extension SunnyColorExt on SunnyColors {
  CupertinoDynamicColor get iconDisabled {
    return this.textLight;
  }
}

Brightness get platformBrightness {
  return WidgetsBinding.instance!.window.platformBrightness;
}
