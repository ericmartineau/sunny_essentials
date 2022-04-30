import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PlatformCardTheme {
  static const kDefaultMargin =
      EdgeInsets.only(left: 10, right: 10, bottom: 10);
  static const kDefaultBorderRadius = BorderRadius.all(Radius.circular(8));

  static const kDefaultPadding =
      EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0);
  static const kDefaultShadow = [
    BoxShadow(
      color: kDefaultShadowColor,
      offset: Offset(0, 8),
      spreadRadius: 0,
      blurRadius: 24, // has the effect of softening the shadow
    ),
  ];

  static const kDefaultShadowColor = Color.fromRGBO(33, 36, 41, 0.18);

  factory PlatformCardTheme.of(BuildContext context) {
    try {
      return Provider.of(context);
    } catch (e) {
      return const PlatformCardTheme();
    }
  }

  final String? debugLabel;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color cardColor;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadow;

  const PlatformCardTheme(
      {this.boxShadow = kDefaultShadow,
      this.debugLabel,
      this.cardColor = CupertinoColors.white,
      this.padding = kDefaultPadding,
      this.margin = kDefaultMargin,
      this.borderRadius = kDefaultBorderRadius});

  PlatformCardTheme.ofRadius({
    required double radiusAmount,
    this.boxShadow = kDefaultShadow,
    this.debugLabel,
    this.cardColor = CupertinoColors.white,
    this.padding = kDefaultPadding,
    this.margin = kDefaultMargin,
  }) : borderRadius = BorderRadius.all(Radius.circular(radiusAmount));

  @override
  String toString() {
    return 'PlatformCardTheme{debugLabel: $debugLabel, padding: $padding, margin: $margin, cardColor: $cardColor, borderRadius: $borderRadius, boxShadow: $boxShadow}';
  }
}
