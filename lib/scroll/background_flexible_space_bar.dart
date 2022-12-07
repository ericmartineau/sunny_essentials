import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class SunnyFlexibleSpaceBar extends FlexibleSpaceBar {
  const SunnyFlexibleSpaceBar({
    super.key,
    super.background,
    super.centerTitle,
    super.collapseMode,
    super.expandedTitleScale,
    super.stretchModes,
    super.title,
    super.titlePadding,
    this.startBackgroundPadding = 0,
    this.minBackgroundOpacity = 0.0,
    this.endTitlePadding,
  });

  final double minBackgroundOpacity;
  final double startBackgroundPadding;
  final EdgeInsets? endTitlePadding;
  @override
  _SunnyFlexibleSpaceBarState createState() => _SunnyFlexibleSpaceBarState();
}

class _SunnyFlexibleSpaceBarState extends State<SunnyFlexibleSpaceBar> {
  bool _getEffectiveCenterTitle(ThemeData theme) {
    if (widget.centerTitle != null) return widget.centerTitle!;
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
    }
  }

  Alignment _getTitleAlignment(bool effectiveCenterTitle) {
    if (effectiveCenterTitle) return Alignment.bottomCenter;
    final TextDirection textDirection = Directionality.of(context);
    switch (textDirection) {
      case TextDirection.rtl:
        return Alignment.bottomRight;
      case TextDirection.ltr:
        return Alignment.bottomLeft;
    }
  }

  double _getCollapsePadding(double t, FlexibleSpaceBarSettings settings) {
    switch (widget.collapseMode) {
      case CollapseMode.pin:
        return -(settings.maxExtent - settings.currentExtent) -
            (widget.startBackgroundPadding * (1 - t));
      case CollapseMode.none:
        return 0.0;
      case CollapseMode.parallax:
        final double deltaExtent = settings.maxExtent - settings.minExtent;
        return -Tween<double>(begin: 0.0, end: deltaExtent / 4.0).transform(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final FlexibleSpaceBarSettings settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;

        final List<Widget> children = <Widget>[];

        final double deltaExtent = settings.maxExtent - settings.minExtent;

        // 0.0 -> Expanded
        // 1.0 -> Collapsed to toolbar
        final double t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);

        // background
        if (widget.background != null) {
          final double fadeStart =
              math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
          const double fadeEnd = 1.0;
          assert(fadeStart <= fadeEnd);
          // If the min and max extent are the same, the app bar cannot collapse
          // and the content should be visible, so opacity = 1.
          double opacity = settings.maxExtent == settings.minExtent
              ? 1.0
              : 1.0 - Interval(fadeStart, fadeEnd).transform(t);
          double height = settings.maxExtent;

          opacity = math.max(widget.minBackgroundOpacity, opacity);

          // StretchMode.zoomBackground
          if (widget.stretchModes.contains(StretchMode.zoomBackground) &&
              constraints.maxHeight > height) {
            height = constraints.maxHeight;
          }
          children.add(Positioned(
            top: _getCollapsePadding(t, settings),
            left: 0.0,
            right: 0.0,
            height: height,
            child: Opacity(
              // IOS is relying on this semantics node to correctly traverse
              // through the app bar when it is collapsed.
              alwaysIncludeSemantics: true,
              opacity: opacity,
              child: widget.background,
            ),
          ));

          // StretchMode.blurBackground
          if (widget.stretchModes.contains(StretchMode.blurBackground) &&
              constraints.maxHeight > settings.maxExtent) {
            final double blurAmount =
                (constraints.maxHeight - settings.maxExtent) / 10;
            children.add(Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(
                  sigmaX: blurAmount,
                  sigmaY: blurAmount,
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ));
          }
        }

        // title
        if (widget.title != null) {
          final ThemeData theme = Theme.of(context);

          Widget? title;
          switch (theme.platform) {
            case TargetPlatform.iOS:
            case TargetPlatform.macOS:
              title = widget.title;
              break;
            case TargetPlatform.android:
            case TargetPlatform.fuchsia:
            case TargetPlatform.linux:
            case TargetPlatform.windows:
              title = Semantics(
                namesRoute: true,
                child: widget.title,
              );
              break;
          }

          // StretchMode.fadeTitle
          if (widget.stretchModes.contains(StretchMode.fadeTitle) &&
              constraints.maxHeight > settings.maxExtent) {
            final double stretchOpacity = 1 -
                (((constraints.maxHeight - settings.maxExtent) / 100)
                    .clamp(0.0, 1.0));
            title = Opacity(
              opacity: stretchOpacity,
              child: title,
            );
          }

          final double opacity = settings.toolbarOpacity;
          if (opacity > 0.0) {
            TextStyle titleStyle = theme.primaryTextTheme.headline6!;
            titleStyle = titleStyle.copyWith(
              color: titleStyle.color!.withOpacity(opacity),
            );
            final bool effectiveCenterTitle = _getEffectiveCenterTitle(theme);
            var defaultPadding = EdgeInsetsDirectional.only(
              start: effectiveCenterTitle ? 0.0 : 72.0,
              bottom: 16.0,
            );

            final EdgeInsetsGeometry padding =
                widget.endTitlePadding is! EdgeInsets ||
                        widget.titlePadding is! EdgeInsets
                    ? (widget.titlePadding ?? defaultPadding)
                    : EdgeInsets.lerp(widget.titlePadding as EdgeInsets,
                        widget.endTitlePadding!, t)!;
            final double scaleValue =
                Tween<double>(begin: widget.expandedTitleScale, end: 1.0)
                    .transform(t);
            final Matrix4 scaleTransform = Matrix4.identity()
              ..scale(scaleValue, scaleValue, 1.0);
            final Alignment titleAlignment =
                _getTitleAlignment(effectiveCenterTitle);
            children.add(Container(
              padding: padding,
              child: Transform(
                alignment: titleAlignment,
                transform: scaleTransform,
                child: Align(
                  alignment: titleAlignment,
                  child: DefaultTextStyle(
                    style: titleStyle,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          width: constraints.maxWidth / scaleValue,
                          alignment: titleAlignment,
                          child: title,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ));
          }
        }

        return ClipRect(child: Stack(children: children));
      },
    );
  }
}
