import 'package:flutter/material.dart';

typedef TextRender = Text Function(
  String text, {
  InlineSpan? textSpan,
  StrutStyle? strutStyle,
  TextAlign? textAlign,
  TextDirection? textDirection,
  Locale? locale,
  bool? softWrap,
  TextOverflow? overflow,
  double? textScaleFactor,
  int? maxLines,
  String? semanticsLabel,
  TextWidthBasis? textWidthBasis,
  TextHeightBehavior? textHeightBehavior,
  Color? selectionColor,
  FontWeight? fontWeight,
});

TextRender _render(TextStyle style) {
  return (
    String text, {
    InlineSpan? textSpan,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
    FontWeight? fontWeight,
  }) =>
      Text(
        text,
        style:
            fontWeight == null ? style : style.copyWith(fontWeight: fontWeight),
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
}

extension TextRenderExt on ThemeData {
  TextRender get displayLarge => _render(textTheme.displayLarge!);
  TextRender get displayMedium => _render(textTheme.displayMedium!);
  TextRender get displaySmall => _render(textTheme.displaySmall!);

  TextRender get headlineLarge => _render(textTheme.headlineLarge!);
  TextRender get headlineMedium => _render(textTheme.headlineMedium!);
  TextRender get headlineSmall => _render(textTheme.headlineSmall!);

  TextRender get titleLarge => _render(textTheme.titleLarge!);
  TextRender get titleMedium => _render(textTheme.titleMedium!);
  TextRender get titleSmall => _render(textTheme.titleSmall!);

  TextRender get bodyLarge => _render(textTheme.bodyLarge!);
  TextRender get bodyMedium => _render(textTheme.bodyMedium!);
  TextRender get bodySmall => _render(textTheme.bodySmall!);

  TextRender get labelLarge => _render(textTheme.labelLarge!);
  TextRender get labelMedium => _render(textTheme.labelMedium!);
  TextRender get labelSmall => _render(textTheme.labelSmall!);
}
