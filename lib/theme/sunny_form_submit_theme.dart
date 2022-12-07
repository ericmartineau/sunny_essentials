import 'package:flutter/material.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

class SunnyButtonSizeData {
  final double height;
  final double textSize;
  final TextStyle Function() _style;

  const SunnyButtonSizeData(
      {required this.height,
      required this.textSize,
      required TextStyle Function() textStyle})
      : _style = textStyle;

  SunnyButtonSizeData.ofTextStyle({required TextStyle style})
      : textSize = style.fontSize!,
        height = style.fontSize! * 1.5,
        _style = (() => style);

  TextStyle get textStyle {
    return _style().copyWith(fontSize: textSize);
  }

  static TextStyle _button1() => sunnyText.button1;
  static TextStyle _button2() => sunnyText.button2;
  static TextStyle _button3() => sunnyText.button3;

  SunnyButtonSizeData copyWith({
    double? height,
    double? textSize,
    TextStyle Function()? textStyle,
  }) {
    return SunnyButtonSizeData(
      height: height ?? this.height,
      textSize: textSize ?? this.textSize,
      textStyle: textStyle ?? this._style,
    );
  }

  static const SunnyButtonSizeData defaultSmall = SunnyButtonSizeData(
    height: 40,
    textSize: 14,
    textStyle: SunnyButtonSizeData._button1,
  );

  static const SunnyButtonSizeData defaultMedium = SunnyButtonSizeData(
    height: 50,
    textSize: 20,
    textStyle: SunnyButtonSizeData._button2,
  );

  static const SunnyButtonSizeData defaultLarge = SunnyButtonSizeData(
    height: 60,
    textSize: 26,
    textStyle: SunnyButtonSizeData._button3,
  );
}

enum SunnyButtonSize {
  small,
  medium,
  large;
}

const _kDefaultBorderWidth = 2.0;

class SunnyButtonColors {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final Color? progressColor;
  final double? borderWidth;

  const SunnyButtonColors(
      {this.backgroundColor,
      this.foregroundColor,
      Color? progressColor,
      this.borderColor,
      this.borderWidth})
      : progressColor = progressColor ?? foregroundColor;

  SunnyButtonColors merge(SunnyButtonColors? other) {
    if (other == null) return this;

    return this.copyWith(
      backgroundColor: other.backgroundColor,
      foregroundColor: other.foregroundColor,
      borderColor: other.borderColor,
      progressColor: other.progressColor,
      borderWidth: other.borderWidth,
    );
  }

  SunnyButtonColors copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    Color? progressColor,
    double? borderWidth,
  }) {
    return SunnyButtonColors(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
      progressColor: progressColor ?? this.progressColor,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }
}

SunnyButtonColors? _defaultLight;
SunnyButtonColors defaultLight(BuildContext context) {
  return _defaultLight ??= SunnyButtonColors(
    borderWidth: 0.0,
    backgroundColor: Colors.white,
    borderColor: Colors.white,
    foregroundColor: context.sunnyColors.primaryColor,
  );
}

SunnyButtonColors? _defaultDark;
SunnyButtonColors defaultDark(BuildContext context) {
  return _defaultDark ??= SunnyButtonColors(
    borderWidth: _kDefaultBorderWidth,
    backgroundColor: context.sunnyColors.primaryColor,
    foregroundColor: Colors.white,
    borderColor: context.sunnyColors.primaryColor,
  );
}

class SunnyFormSubmitThemeData {
  final SunnyButtonColors? _dark;
  final SunnyButtonColors? _light;

  final Map<SunnyButtonSize, SunnyButtonSizeData> sizes;

  const SunnyFormSubmitThemeData({
    SunnyButtonColors? dark,
    SunnyButtonColors? light,
    this.sizes = const {
      SunnyButtonSize.small: SunnyButtonSizeData.defaultSmall,
      SunnyButtonSize.medium: SunnyButtonSizeData.defaultMedium,
      SunnyButtonSize.large: SunnyButtonSizeData.defaultLarge,
    },
  })  : _dark = dark,
        _light = light;

  SunnyButtonColors resolve(BuildContext context, bool isLight,
      [SunnyButtonColors? colors]) {
    var theme = isLight ? _light : _dark;
    var fallback = isLight ? defaultLight(context) : defaultDark(context);

    return SunnyButtonColors(
      borderColor:
          colors?.borderColor ?? theme?.borderColor ?? fallback.borderColor,
      foregroundColor: colors?.foregroundColor ??
          theme?.foregroundColor ??
          fallback.foregroundColor,
      backgroundColor: colors?.backgroundColor ??
          theme?.backgroundColor ??
          fallback.backgroundColor,
      borderWidth:
          colors?.borderWidth ?? theme?.borderWidth ?? fallback.borderWidth,
      progressColor: colors?.progressColor ??
          theme?.progressColor ??
          fallback.progressColor,
    );
  }

  static SunnyFormSubmitThemeData of(BuildContext context) {
    var existing = Provided.find<SunnyFormSubmitThemeData>(context);
    return existing ?? const SunnyFormSubmitThemeData();
  }

  factory SunnyFormSubmitThemeData.ofTheme(ThemeData theme) {
    final Map<SunnyButtonSize, SunnyButtonSizeData> sizes;

    var scheme = theme.buttonTheme.colorScheme!;
    return SunnyFormSubmitThemeData(
        dark: SunnyButtonColors(
            backgroundColor: scheme.background,
            foregroundColor: scheme.onBackground,
            progressColor: scheme.primary,
            borderColor: scheme.primary),
        light: SunnyButtonColors(
            backgroundColor: scheme.inverseSurface,
            foregroundColor: scheme.onInverseSurface,
            progressColor: scheme.primary,
            borderColor: scheme.primary),
        sizes: {
          SunnyButtonSize.small: SunnyButtonSizeData.ofTextStyle(
              style: theme.textTheme.labelSmall!),
          SunnyButtonSize.medium: SunnyButtonSizeData.ofTextStyle(
              style: theme.textTheme.labelMedium!),
          SunnyButtonSize.large: SunnyButtonSizeData.ofTextStyle(
              style: theme.textTheme.labelLarge!),
        });
  }
}
