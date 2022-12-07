// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:tinycolor2/tinycolor2.dart';
//
// class PlatformCardTheme {
//   static const kDefaultMargin =
//       EdgeInsets.only(left: 10, right: 10, bottom: 10);
//   static const kDefaultBorderRadius = BorderRadius.all(Radius.circular(8));
//
//   static const kDefaultPadding =
//       EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0);
//   static const kDefaultShadow = [
//     BoxShadow(
//       color: kDefaultShadowColor,
//       offset: Offset(0, 8),
//       spreadRadius: 0,
//       blurRadius: 24, // has the effect of softening the shadow
//     ),
//   ];
//
//   static const kDefaultShadowColor = Color.fromRGBO(33, 36, 41, 0.18);
//
//   factory PlatformCardTheme.of(BuildContext context) {
//     try {
//       return Provider.of(context);
//     } catch (e) {
//       return const PlatformCardTheme();
//     }
//   }
//
//   final String? debugLabel;
//   final EdgeInsetsGeometry? padding;
//   final EdgeInsetsGeometry? margin;
//   final Color? cardColor;
//   final Color? hoverColor;
//   final BorderRadius borderRadius;
//   final List<BoxShadow> boxShadow;
//   final Color? foregroundColor;
//
//   const PlatformCardTheme(
//       {this.boxShadow = kDefaultShadow,
//       this.debugLabel,
//       this.foregroundColor,
//       this.cardColor = CupertinoColors.white,
//       this.hoverColor,
//       this.padding = kDefaultPadding,
//       this.margin = kDefaultMargin,
//       this.borderRadius = kDefaultBorderRadius});
//
//   PlatformCardTheme.ofRadius({
//     required double radiusAmount,
//     this.boxShadow = kDefaultShadow,
//     this.debugLabel,
//     this.foregroundColor,
//     this.cardColor = CupertinoColors.white,
//     this.hoverColor,
//     this.padding = kDefaultPadding,
//     this.margin = kDefaultMargin,
//   }) : borderRadius = BorderRadius.all(Radius.circular(radiusAmount));
//
//   @override
//   String toString() {
//     return 'PlatformCardTheme{debugLabel: $debugLabel, padding: $padding, margin: $margin, cardColor: $cardColor, borderRadius: $borderRadius, boxShadow: $boxShadow}';
//   }
//
//   PlatformCardTheme copyWith({
//     String? debugLabel,
//     EdgeInsets? padding,
//     EdgeInsets? margin,
//     Color? cardColor,
//     Color? hoverColor,
//     BorderRadius? borderRadius,
//     List<BoxShadow>? boxShadow,
//   }) {
//     return PlatformCardTheme(
//       debugLabel: debugLabel ?? this.debugLabel,
//       padding: padding ?? this.padding,
//       margin: margin ?? this.margin,
//       cardColor: cardColor ?? this.cardColor,
//       hoverColor: hoverColor ?? this.hoverColor,
//       borderRadius: borderRadius ?? this.borderRadius,
//       boxShadow: boxShadow ?? this.boxShadow,
//     );
//   }
// }
