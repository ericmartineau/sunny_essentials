import 'package:dartxx/dartxx.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:info_x/info_x.dart';
import 'package:sunny_essentials/sunny_essentials.dart';
import 'dart:ui' as ui;
import '../taps.dart';
import '../theme.dart';
import '../typedefs.dart';

class TextWidgets {
  static set lightColor(Color updateLightColor) {
    _lightColor = updateLightColor;
  }
}

Color _lightColor = Colors.black26;

class TileTitle extends StatelessWidget {
  final title;

  const TileTitle._(this.title, {Key? key}) : super(key: key);

  static TileTitle? of(title) {
    if (title == null) return null;
    return TileTitle._(title);
  }

  @override
  Widget build(BuildContext context) {
    return title is Widget
        ? (title as Widget)
        : Text(title.toString(),
            maxLines: 3, softWrap: true, overflow: TextOverflow.ellipsis);
  }
}

class TileSubtitle extends StatelessWidget {
  final title;

  const TileSubtitle._(this.title, {Key? key}) : super(key: key);

  static TileSubtitle? of(title) {
    if (title == null) return null;
    return TileSubtitle._(title);
  }

  @override
  Widget build(BuildContext context) {
    return title is Widget
        ? (title as Widget)
        : Text(title.toString(),
            maxLines: 3, softWrap: true, overflow: TextOverflow.ellipsis);
  }
}

Widget? textOrNull(final txt,
    {TextAlign? alignment,
    TextStyle? style,
    Color? color,
    bool wrap = true,
    int? maxLines}) {
  if (txt is Widget) return txt;
  if (txt == null) return null;
  final text = "$txt";
  var _style = style ?? TextStyle();
  _style = _style.copyWith(color: color);

  return text.isNullOrBlank
      ? null
      : wrap == false
          ? maxLines != null && maxLines > 1
              ? Text(
                  text,
                  maxLines: maxLines,
                  style: _style,
                  textAlign: alignment,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                )
              : SingleLineText(
                  text,
                  style: _style,
                  alignment: alignment,
                )
          : Text(
              text,
              maxLines: maxLines,
              style: _style,
              textAlign: alignment,
              softWrap: true,
              overflow: TextOverflow.fade,
            );
}

class NormalText extends StatelessWidget {
  final String text;

  NormalText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.body2Normal,
    );
  }
}

// ignore: non_constant_identifier_names
Text? SingleLineText(String? text, {TextAlign? alignment, TextStyle? style}) =>
    text == null
        ? null
        : Text(
            text,
            textAlign: alignment,
            style: style,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          );

class PrimaryText extends StatelessWidget {
  final String text;
  final String? label;
  final TextAlign? textAlign;
  final bool nowrap;

  const PrimaryText(this.text,
      {this.label, this.textAlign, this.nowrap = false});

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return RichText(
        text: TextSpan(children: [
          TextSpan(
              text: label,
              style:
                  sunnyText.body2Normal.copyWith(fontWeight: FontWeight.bold)),
          TextSpan(
              text: text,
              style: sunnyText.body2Normal
                  .copyWith(fontWeight: FontWeight.normal)),
        ]),
        textAlign: textAlign ?? TextAlign.start,
        maxLines: nowrap == true ? 1 : null,
        overflow: nowrap == true ? TextOverflow.ellipsis : TextOverflow.clip,
      );
    } else {
      return Text(
        text,
        style: sunnyText.body2Normal,
        maxLines: nowrap == true ? 1 : null,
        textAlign: textAlign ?? TextAlign.start,
        overflow: nowrap == true ? TextOverflow.ellipsis : TextOverflow.clip,
      );
    }
  }
}
//
// class LabelText extends StatelessWidget {
//   final String text;
//   final TextAlign textAlign;
//   final bool nowrap;
//
//   LabelText(this.text, {this.textAlign, this.nowrap = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text ?? "",
//       style: sunnyText.label,
//       maxLines: nowrap == true ? 1 : null,
//       textAlign: textAlign,
//       overflow: nowrap == true ? TextOverflow.ellipsis : null,
//     );
//   }
// }

class InputText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final bool nowrap;

  InputText(this.text, {this.textAlign, this.nowrap = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.input1,
      maxLines: nowrap == true ? 1 : null,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class PlaceholderText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;

  PlaceholderText(this.text, {this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.placeholder1,
      textAlign: textAlign,
    );
  }
}

class LinkText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final bool bold;
  final double? fontSize;

  LinkText(this.text, {this.textAlign, this.fontSize, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.body1Link.copyWith(
        fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
        fontSize: fontSize,
      ),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}

class SecondaryText extends StatelessWidget {
  final String text;
  final bool isBold;
  final bool nowrap;

  SecondaryText(this.text, {this.isBold = false, this.nowrap = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.body2Normal
          .copyWith(fontWeight: isBold == true ? FontWeight.bold : null),
      maxLines: nowrap == true ? 1 : null,
      overflow: nowrap == true ? TextOverflow.ellipsis : TextOverflow.clip,
    );
  }
}

class TertiaryText extends StatelessWidget {
  final String text;
  final Color? color;
  final bool isBold;

  TertiaryText(this.text, {this.color, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.body3Light.copyWith(
          color: color,
          fontWeight: this.isBold == true ? FontWeight.bold : null),
    );
  }
}

// class FinePrintLinkText extends StatelessWidget {
//   final String text;
//   final bool isBold;
//
//   FinePrintLinkText(this.text, {this.isBold = true});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: sunnyText.finePrint.copyWith(
//         fontSize: 11,
//         color: context.sunnyColors.tertiaryText,
//         fontWeight: this.isBold == true ? FontWeight.bold : null,
//       ),
//     );
//   }
// }

class ErrorText extends StatelessWidget {
  final String text;
  final bool isCentered;

  ErrorText(this.text, {this.isCentered = false});

  ErrorText.ofValidationError(Object error, {this.isCentered = false})
      : text = error.toString();

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: isCentered ? TextAlign.center : TextAlign.left,
      style: sunnyText.body3Light.copyWith(
        color: Colors.red,
      ),
    );
  }
}

class PageSectionHeaderText extends StatelessWidget {
  final String text;

  const PageSectionHeaderText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.headline4,
        maxLines: 1,
        overflow: TextOverflow.fade);
  }
}

enum FontType { light, normal, medium, bold }

class Headline3Text extends StyledText {
  final String text;
  final FontType fontType;
  final Color? color;

  const Headline3Text.normal(this.text, {this.color, Key? key})
      : fontType = FontType.normal,
        super(key: key);

  const Headline3Text.bold(this.text, {this.color, Key? key})
      : fontType = FontType.bold,
        super(key: key);

  const Headline3Text.medium(this.text, {this.color, Key? key})
      : fontType = FontType.medium,
        super(key: key);

  const Headline3Text.light(this.text, {this.color, Key? key})
      : fontType = FontType.light,
        super(key: key);

  const factory Headline3Text(String text, {Key? key}) = Headline3Text.normal;

  @override
  StyleExtractor get styleGetter => (theme) => theme.headline3;
}

class Headline4Text extends StyledText {
  final String text;
  final FontType fontType;
  final Color? color;

  const Headline4Text.normal(this.text, {this.color, Key? key})
      : fontType = FontType.normal,
        super(key: key);

  const Headline4Text.bold(this.text, {this.color, Key? key})
      : fontType = FontType.bold,
        super(key: key);

  const Headline4Text.medium(this.text, {this.color, Key? key})
      : fontType = FontType.medium,
        super(key: key);

  const Headline4Text.light(this.text, {this.color, Key? key})
      : fontType = FontType.light,
        super(key: key);

  const factory Headline4Text(String text, {Key? key}) = Headline4Text.normal;

  @override
  StyleExtractor get styleGetter => (theme) => theme.headline4;
}

typedef StyleExtractor = TextStyle? Function(TextTheme theme);
typedef StyleAdjuster = TextStyle Function(TextStyle theme);

abstract class StyledText extends StatelessWidget {
  FontType get fontType;

  StyleExtractor get styleGetter;

  String? get text;

  Color? get color;

  bool? get softWrap => null;

  int? get maxLines => null;

  TextOverflow? get overflow => null;

  @override
  Widget build(BuildContext context) {
    return buildText(context);
  }

  Widget buildText(BuildContext context, {TextAlign? alignment}) {
    TextStyle style = styleGetter(Theme.of(context).textTheme)!;
    style = style.copyWith(color: color);
    switch (fontType) {
      case FontType.light:
        // Is there ever a bold or medium in the light color?
        style =
            style.copyWith(fontWeight: FontWeight.normal, color: _lightColor);
        break;
      case FontType.normal:
        style = style.copyWith(fontWeight: FontWeight.w400);
        break;
      case FontType.medium:
        style = style.copyWith(fontWeight: FontWeight.w500);
        break;
      case FontType.bold:
        style = style.copyWith(fontWeight: FontWeight.w900);
        break;
    }

    return Text(
      text ?? '',
      style: style,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textAlign: alignment,
    );
  }

  const StyledText({Key? key}) : super(key: key);
}

class Body3Text extends StyledText {
  final String text;
  final FontType fontType;
  final Color? color;

  const Body3Text.normal(this.text, {this.color, Key? key})
      : fontType = FontType.normal,
        super(key: key);

  const Body3Text.bold(this.text, {this.color, Key? key})
      : fontType = FontType.bold,
        super(key: key);

  const Body3Text.medium(this.text, {this.color, Key? key})
      : fontType = FontType.medium,
        super(key: key);

  const Body3Text.light(this.text, {this.color, Key? key})
      : fontType = FontType.light,
        super(key: key);

  const factory Body3Text(String text, {Key? key}) = Body3Text.normal;

  @override
  StyleExtractor get styleGetter => (theme) => theme.caption;
}

class Body1Text extends StyledText {
  final String text;
  final FontType fontType;
  final Color? color;

  const Body1Text.normal(this.text, {this.color, Key? key})
      : fontType = FontType.normal,
        super(key: key);

  const Body1Text.bold(this.text, {this.color, Key? key})
      : fontType = FontType.bold,
        super(key: key);

  const Body1Text.medium(this.text, {this.color, Key? key})
      : fontType = FontType.medium,
        super(key: key);

  const Body1Text.light(this.text, {this.color, Key? key})
      : fontType = FontType.light,
        super(key: key);

  const factory Body1Text(String text, {Color? color, Key? key}) =
      Body1Text.normal;

  @override
  StyleExtractor get styleGetter => (theme) => theme.bodyText1;
}

class Body0Text extends StyledText {
  final String text;
  final FontType fontType;
  final Color? color;

  const Body0Text.normal(this.text, {this.color, Key? key})
      : fontType = FontType.normal,
        super(key: key);

  const Body0Text.bold(this.text, {this.color, Key? key})
      : fontType = FontType.bold,
        super(key: key);

  const Body0Text.medium(this.text, {this.color, Key? key})
      : fontType = FontType.medium,
        super(key: key);

  const Body0Text.light(this.text, {this.color, Key? key})
      : fontType = FontType.light,
        super(key: key);

  const factory Body0Text(String text, {Color? color, Key? key}) =
      Body0Text.normal;

  @override
  StyleExtractor get styleGetter => (theme) => theme.subtitle1;
}

class Body2Text extends StyledText {
  final String text;
  final FontType fontType;
  final Color? color;
  final bool? softWrap;
  final int? maxLines;
  final TextOverflow? overflow;

  const Body2Text.normal(this.text,
      {this.softWrap, this.maxLines, this.overflow, this.color, Key? key})
      : fontType = FontType.normal,
        super(key: key);

  const Body2Text.bold(this.text,
      {this.softWrap, this.maxLines, this.overflow, this.color, Key? key})
      : fontType = FontType.bold,
        super(key: key);

  const Body2Text.medium(this.text,
      {this.softWrap, this.maxLines, this.overflow, this.color, Key? key})
      : fontType = FontType.medium,
        super(key: key);

  const Body2Text.light(this.text,
      {this.softWrap, this.maxLines, this.overflow, this.color, Key? key})
      : fontType = FontType.light,
        super(key: key);

  const factory Body2Text(String text,
      {bool? softWrap,
      int? maxLines,
      TextOverflow? overflow,
      Color? color,
      Key? key}) = Body2Text.normal;

  @override
  StyleExtractor get styleGetter => (theme) => theme.bodyText2;
}

typedef RichTextBuild = void Function(RichTextBuilder builder);

Widget richTextBuilder(BuildContext context, RichTextBuild build) {
  final b = RichTextBuilder(context);
  build(b);
  return b.buildText(context);
}

/**
 * Allows for building rich text using the known styles
 */
// ignore: must_be_immutable
class RichTextBuilder extends StatelessWidget {
  final TextTheme textTheme;
  final TextStyle lightStyle1;
  final TextStyle lightStyle2;

  /// These are build when needed- they aren't part of the normal styles
  TextStyle? _header4Bold;
  TextStyle? _header4Normal;

  TextStyle? _temp;
  SimpleFutureBuildCallback? _gesture;
  bool _preserveGestures = false;
  bool _preserveStyles = false;

  // FontStyle? _fontStyle;
  int? _maxLines;
  TextAlign _textAlign = TextAlign.start;

  double? _height = null;
  bool _softWrap = true;
  TextOverflow _overflow = TextOverflow.clip;

  final List<InlineSpan> children = [];

  RichTextBuilder(BuildContext context, {Color? lightColor, TextStyle? start})
      : this.ofTextTheme(textTheme: Theme.of(context).textTheme, start: start);

  RichTextBuilder.ofTextTheme(
      {required this.textTheme, Color? lightColor, TextStyle? start})
      : lightStyle2 =
            textTheme.bodyText2!.copyWith(color: lightColor ?? _lightColor),
        lightStyle1 =
            textTheme.bodyText1!.copyWith(color: lightColor ?? _lightColor),
        _temp = start;

  RichTextBuilder get italic =>
      this.._temp = _tmpStyle.copyWith(fontStyle: FontStyle.italic);

  RichTextBuilder call(String text, {TextStyle? style}) {
    return this.text(text, style: style);
  }

  RichTextBuilder space([int count = 1]) {
    var space = '';
    count.repeat(() {
      space += " ";
    });
    children.add(TextSpan(text: space));
    return this;
  }

  RichTextBuilder body2(String text) {
    return applyChild(text, baseStyle: textTheme.bodyText2);
  }

  RichTextBuilder body3(String text) {
    return applyChild(text, baseStyle: sunnyText.body3Light);
  }

  RichTextBuilder caption(String text) {
    return applyChild(text, baseStyle: sunnyText.body3Light);
  }

  RichTextBuilder icon(IconData data,
      {double? size, Color? color, double? offset}) {
    size ??= 20;
    offset ??= 0;
    final sizeWithOffset = size + offset;
    return widget(SizedBox(
        height: sizeWithOffset,
        width: size,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Icon(
            data,
            size: size,
          ),
        )));

    // children.add(TextSpan(
    //   text: String.fromCharCode(data.codePoint),
    //   style: TextStyle(
    //       fontFamily: data.fontFamily,
    //       fontSize: size,
    //       color: color ?? context.sunnyColors.text),
    // ));
    // return this;
  }

  RichTextBuilder widget(Widget widget) {
    children.add(WidgetSpan(
      child: Semantics(enabled: true, child: widget),
      alignment: PlaceholderAlignment.middle,
      // baseline: TextBaseline.alphabetic,
    ));

    return this;
  }

  RichTextBuilder preserve() {
    return this
      .._preserveStyles = true
      .._preserveGestures = true;
  }

  RichTextBuilder white() {
    return color(Colors.white);
  }

  RichTextBuilder softWrap() {
    return this.._softWrap = true;
  }

  RichTextBuilder nowrap() {
    return this.._softWrap = false;
  }

  RichTextBuilder twoLines() {
    return this.._maxLines = 2;
  }

  RichTextBuilder singleLine() {
    return this.._maxLines = 1;
  }

  RichTextBuilder maxLines(int maxLines) {
    return this.._maxLines = maxLines;
  }

  RichTextBuilder truncate([TextOverflow? overflow]) {
    return this.._overflow = overflow ?? TextOverflow.ellipsis;
  }

  RichTextBuilder center() {
    return this.._textAlign = TextAlign.center;
  }

  RichTextBuilder alignRight() {
    return this.._textAlign = TextAlign.right;
  }

  RichTextBuilder align(TextAlign align) {
    return this.._textAlign = align;
  }

  RichTextBuilder onTap(SimpleFutureBuildCallback callback,
      {bool isFixed = false}) {
    _gesture = callback;
    _preserveGestures = isFixed;
    return this;
  }

  RichTextBuilder color(Color color) {
    return this.._temp = _tmpStyle.copyWith(color: color);
  }

  RichTextBuilder underline() {
    return this
      .._temp = _tmpStyle.copyWith(decoration: TextDecoration.underline);
  }

  RichTextBuilder fontSize(double size) {
    return this.._temp = _tmpStyle.copyWith(fontSize: size);
  }

  RichTextBuilder font(String font) {
    return this.._temp = _tmpStyle.copyWith(fontFamily: font);
  }

  RichTextBuilder weight(FontWeight weight) {
    return this.._temp = _tmpStyle.copyWith(fontWeight: weight);
  }

  RichTextBuilder style(TextStyle style) {
    return this.._temp = _tmpStyle.mergeOrDefault(style);
  }

  RichTextBuilder height(double height) {
    return this.._height = height;
  }

  RichTextBuilder applyChild(
    String text, {
    TextStyle? baseStyle,
  }) {
    if (!text.isNullOrBlank) {
      GestureRecognizer? recognizer;
      if (_gesture != null && !_preserveGestures) {
        final tapCallback = _gesture;
        recognizer = TapGestureRecognizer()
          ..onTap = () {
            tapCallback!();
          };
        _gesture = null;
      }
      children.add(TextSpan(
        style: baseStyle.mergeOrDefault(_temp),
        text: text,
        recognizer: recognizer,
        semanticsLabel: "Tap to open record",
      ));
    }
    if (_preserveStyles != true) _temp = null;

    return this;
  }

  TextStyle get _tmpStyle {
    return _temp ??= const TextStyle();
  }

  RichTextBuilder text(String text, {TextStyle? style}) {
    return applyChild(text, baseStyle: style ?? textTheme.bodyText2);
  }

  RichTextBuilder bold2(String text) {
    return applyChild(text, baseStyle: textTheme.headline6);
  }

  RichTextBuilder medium2(String text) {
    return applyChild(text, baseStyle: textTheme.subtitle2);
  }

  RichTextBuilder light2(String text) {
    return applyChild(text, baseStyle: lightStyle2);
  }

  RichTextBuilder body1(String text) {
    return applyChild(text, baseStyle: textTheme.bodyText1);
  }

  RichTextBuilder medium1(String text) {
    return applyChild(text, baseStyle: textTheme.subtitle2);
  }

  RichTextBuilder bold1(String text) {
    return applyChild(text, baseStyle: textTheme.headline5);
  }

  RichTextBuilder h4bold(String text) {
    return applyChild(text,
        baseStyle: _header4Bold ??=
            textTheme.headline4!.copyWith(fontWeight: FontWeight.bold));
  }

  RichTextBuilder h4normal(String text) {
    return applyChild(text,
        baseStyle: _header4Normal ??=
            textTheme.headline4!.copyWith(fontWeight: FontWeight.normal));
  }

  RichTextBuilder h4(String text) {
    return applyChild(text, baseStyle: textTheme.headline4);
  }

  RichTextBuilder h4black(String text) {
    return applyChild(text,
        baseStyle: textTheme.headline4!.copyWith(
          fontWeight: FontWeight.w900,
        ));
  }

  RichTextBuilder h3(String text) {
    return applyChild(text, baseStyle: textTheme.headline3);
  }

  RichTextBuilder h3black(String text) {
    return applyChild(text,
        baseStyle: textTheme.headline3!.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0.0,
        ));
  }

  RichTextBuilder light1(String text) {
    return applyChild(text, baseStyle: lightStyle1);
  }

  @override
  Widget build(BuildContext context) {
    return buildText(context);
  }

  Widget buildText(BuildContext context) {
    TextStyle? ts = null;
    if (_height != null) {
      ts = TextStyle(height: _height);
    }
    final richText = RichText(
      text: TextSpan(children: children, style: ts?.withBrightness(context)),
      softWrap: _softWrap,
      textAlign: _textAlign,
      maxLines: _maxLines,
      overflow: _overflow,
    );
    return _gesture == null
        ? richText
        : Tappable(
            onTap: (context) => _gesture!(),
            child: richText,
          );
  }
}

extension BuildContextRichText on BuildContext {
  RichTextBuilder get richText {
    return RichTextBuilder(this);
  }

  RichTextBuilder Text({
    String? text,
    TextStyle? baseStyle,
    bool? inherit,
    TextAlign? align,
    bool? centerAlign,
    bool? leftAlign,
    bool? rightAlign,
    bool? softWrap,
    bool? nowrap,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    int? fontWeightInt,
    bool? weightBlack,
    bool? weightBold,
    bool? weightLight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    ui.TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<ui.Shadow>? shadows,
    List<ui.FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    TextOverflow? overflow,
    bool? clip,
    bool? fade,
    bool? ellipses,
    SimpleFutureBuildCallback? gesture,
    int? maxLines,
    double? widgetHeight,
  }) {
    switch (fontWeightInt) {
      case null:
        break;
      case 1:
      case 100:
        fontWeight = FontWeight.w100;
        break;
      case 2:
      case 200:
        fontWeight = FontWeight.w200;
        break;
      case 3:
      case 300:
        fontWeight = FontWeight.w300;
        break;
      case 4:
      case 400:
        fontWeight = FontWeight.w400;
        break;
      case 5:
      case 500:
        fontWeight = FontWeight.w500;
        break;
      case 6:
      case 600:
        fontWeight = FontWeight.w600;
        break;
      case 7:
      case 700:
        fontWeight = FontWeight.w700;
        break;
      case 8:
      case 800:
        fontWeight = FontWeight.w800;
        break;
      case 9:
      case 900:
        fontWeight = FontWeight.w900;
        break;
      default:
        throw ArgumentError(
            "Invalid argument for fontWeightInt.  Must be 1-9, 100-900, or null.  Was ${fontWeightInt}");
    }
    fontWeight ??= weightBlack == true
        ? FontWeight.w900
        : weightBold == true
            ? FontWeight.bold
            : weightLight == true
                ? FontWeight.w100
                : null;
    final _base =
        (baseStyle ?? Theme.of(this).textTheme.bodyText1 ?? const TextStyle())
            .copyWith(
      inherit: inherit ?? false,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
      overflow: overflow,
    );
    var builder = RichTextBuilder(this, start: _base);
    align = align ??
        (centerAlign == true
            ? TextAlign.center
            : leftAlign == true
                ? TextAlign.left
                : rightAlign == true
                    ? TextAlign.right
                    : null);
    if (align != null) {
      builder._textAlign = align;
    }
    if (softWrap != null) {
      builder._softWrap = softWrap;
    }
    if (nowrap != null) {
      builder._softWrap = !nowrap;
    }
    if (overflow != null) builder._overflow = overflow;
    builder._gesture = gesture;
    builder._maxLines = maxLines;
    builder._height = widgetHeight;
    overflow ??= clip == true
        ? TextOverflow.clip
        : ellipses == true
            ? TextOverflow.ellipsis
            : fade == true
                ? TextOverflow.fade
                : null;

    if (overflow != null) builder._overflow = overflow;
    if (text != null) builder.text(text, style: baseStyle);
    return builder;
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final bool nowrap;

  const TitleText(this.text, {this.textAlign, this.nowrap = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sunnyText.header2,
      maxLines: nowrap == true ? 1 : null,
      textAlign: textAlign,
      softWrap: nowrap != false,
      overflow: TextOverflow.fade,
    );
  }
}

extension TextStyleMergeExt on TextStyle? {
  TextStyle orDefault([TextStyle? def]) => this ?? def ?? const TextStyle();

  TextStyle? mergeOrDefault([TextStyle? mergeTarget]) {
    if (this == null || mergeTarget == null) {
      return this ?? mergeTarget;
    } else {
      return this!.merge(mergeTarget);
    }
  }
}
