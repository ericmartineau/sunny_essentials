import 'dart:async';

import 'package:dartxx/dartxx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_degen_annotations/flutter_degen_annotations.dart';
import 'package:info_x/info_x.dart';

import '../taps.dart';

part 'platform_card.g.dart';

class PlatformCardArgs {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final Color? hoverColor;
  final BorderRadius? borderRadius;
  final bool? useShadow;
  final double? height;
  final double? width;

  final double? minHeight;
  final double? minWidth;
  final double? pressOpacity;
  final double? pressScale;
  final FutureTappableCallback? onTap;
  final FutureTappableCallback? onLongPress;
  final FutureTappableCallback? onSecondaryPress;
  final FutureTappableCallback? onHover;
  final List<BoxShadow>? shadow;
  final bool? shouldClip;

  const PlatformCardArgs({
    this.pressOpacity = 1,
    this.onHover,
    this.hoverColor,
    this.pressScale = Tappable.defaultScale,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.height,
    this.width,
    this.useShadow = true,
    this.minWidth,
    this.minHeight,
    this.onTap,
    this.shouldClip,
    this.onLongPress,
    this.onSecondaryPress,
    this.shadow,
  });
}

extension PlatformCardCopyWith on PlatformCardArgs {
  PlatformCardArgs copyArgs({
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? color,
    Color? hoverColor,
    BorderRadius? borderRadius,
    bool? useShadow,
    double? height,
    double? width,
    double? minHeight,
    double? minWidth,
    double? pressOpacity,
    double? pressScale,
    FutureTappableCallback? onTap,
    FutureTappableCallback? onLongPress,
    FutureTappableCallback? onSecondaryPress,
    FutureTappableCallback? onHover,
    List<BoxShadow>? shadow,
    bool? shouldClip,
  }) {
    return PlatformCardArgs(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      color: color ?? this.color,
      hoverColor: hoverColor ?? this.hoverColor,
      borderRadius: borderRadius ?? this.borderRadius,
      useShadow: useShadow ?? this.useShadow,
      height: height ?? this.height,
      width: width ?? this.width,
      minHeight: minHeight ?? this.minHeight,
      minWidth: minWidth ?? this.minWidth,
      pressOpacity: pressOpacity ?? this.pressOpacity,
      pressScale: pressScale ?? this.pressScale,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      onSecondaryPress: onSecondaryPress ?? this.onSecondaryPress,
      onHover: onHover ?? this.onHover,
      shadow: shadow ?? this.shadow,
      shouldClip: shouldClip ?? this.shouldClip,
    );
  }
}

class PlatformCard extends StatelessWidget with _PlatformCardArgsMixin {
  @delegate(implementDelegate: true)
  final PlatformCardArgs _args;
  final Widget? child;

  PlatformCard({
    PlatformCardArgs? args,
    this.child,
    Key? key,
  })  : _args = args ?? const PlatformCardArgs(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var theme = themeData.cardTheme.copyWith(
      clipBehavior: shouldClip == true ? Clip.hardEdge : null,
      color: color,
      shadowColor: shadow?.firstOr(null)?.color,
      elevation: useShadow == false ? 0 : 2,
      shape: borderRadius == null
          ? null
          : RoundedRectangleBorder(borderRadius: borderRadius!),
      margin: margin,
    );

    Widget widget;
    if (kIsWeb || infoX.isIOS == true || infoX.isMacOS) {
      // final inner = theme.clipBehavior == Clip.hardEdge
      //     ? ClipRRect(
      //         borderRadius: borderRadius ?? theme.shape,
      //         child: child,
      //       )
      //     : child;
      widget = Container(
        margin: margin ?? theme.margin,
        alignment: AlignmentDirectional.centerStart,
        // decoration: BoxDecoration(
        //   boxShadow: useShadow == true ? shadow ?? theme.boxShadow : null,
        // ),
        child: Material(
            clipBehavior: theme.clipBehavior ?? Clip.none,
            surfaceTintColor: theme.surfaceTintColor,
            shape: theme.shape,
            // borderRadius: theme.boborderRadius ?? theme.borderRadius,
            elevation: theme.elevation ?? 0,
            color: MaterialStateColor.resolveWith(
              (states) {
                var resolvedColor = theme.color;
                if (states.contains(MaterialState.hovered)) {
                  if (hoverColor != null) return hoverColor!;
                }
                return resolvedColor ?? themeData.scaffoldBackgroundColor;
              },
            ),
            type: MaterialType.card,
            child: Container(
              padding: padding,
              child: child,
            )),
      );
    } else {
      widget = Card(
          color: theme.color,
          shadowColor: theme.shadowColor,
          clipBehavior: theme.clipBehavior,
          margin: theme.margin,
          surfaceTintColor: theme.surfaceTintColor,
          shape: theme.shape,
          child: Container(
            padding: padding,
            child: child,
          ));
    }

    if (onTap != null || onLongPress != null || onHover != null) {
      return Tappable(
        pressOpacity: pressOpacity,
        pressScale: pressScale,
        onTap: onTap,
        behavior: HitTestBehavior.deferToChild,
        onLongPress: onLongPress,
        onSecondaryPress: onSecondaryPress,
        child: widget,
      );
    } else {
      return widget;
    }
  }
}

extension on Color {
  Color resolveColor(BuildContext context) {
    return CupertinoDynamicColor.resolve(this, context);
  }
}
