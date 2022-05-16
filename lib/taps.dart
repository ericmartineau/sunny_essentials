import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sunny_essentials/provided.dart';
import 'package:sunny_essentials/state/state_observer.dart';

import 'theme/sunny_text_theme.dart';

/// Enforces HitTest.opaque and removes parameters
Widget tappable<R>(Widget child,
    {FutureOrTappableCallback? onTap,
    Key? key,
    double pressOpacity = 1.0,
    BuildContext? context,
    String? routeName,
    arguments,
    void callback(R? result)?}) {
  if (onTap == null && routeName == null) return child;

  return GestureDetector(
      child: child,
      onTap: () async {
        onTap?.call();
        assert(routeName == null || context != null,
            "If you provide a route, you must also provide a buildContext");
        if (routeName != null) {
          final R? result = await Navigator.pushNamed(context!, routeName,
              arguments: arguments);
          callback!(result);
        }
      },
      behavior: HitTestBehavior.opaque);
}

typedef FutureOrTappableCallback<T> = FutureOr<T> Function();
typedef FutureTappableCallback<T> = FutureOr<T> Function(BuildContext context);
typedef LongPressCallback = FutureOr Function(BuildContext context);

enum TapTransform {
  opacity,
  scale,
}

class Tappable extends StatefulWidget {
  static const defaultScale = 0.98;

  final double? pressOpacity;
  final double? pressScale;
  final FutureTappableCallback? onTap;
  final LongPressCallback? onLongPress;
  final LongPressCallback? onSecondaryPress;
  final HitTestBehavior behavior;
  final Widget? child;
  final Duration duration;
  final bool useMouseCursor;

  Tappable.link(
    String s, {
    this.onTap,
    this.behavior = HitTestBehavior.opaque,
    this.onLongPress,
    this.onSecondaryPress,
    this.useMouseCursor = true,
    TextStyle? style,
  })  : duration = const Duration(milliseconds: 300),
        pressOpacity = null,
        pressScale = null,
        child = Text(s, style: style ?? sunnyText.body1Link);

  const Tappable(
      {Key? key,
      this.pressOpacity = 0.7,
      this.pressScale,
      this.behavior = HitTestBehavior.opaque,
      this.onLongPress,
      this.onSecondaryPress,
      this.duration = const Duration(milliseconds: 300),
      this.onTap,
      this.useMouseCursor = true,
      this.child})
      : super(key: key);

  @override
  _TappableState createState() => _TappableState();
}

class _TappableState extends State<Tappable>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _ac = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 0,
      reverseDuration: widget.duration,
    );
    _opacityAnimation =
        _ac.drive(Tween(begin: 1, end: widget.pressOpacity ?? 1));
    _scaleAnimation = _ac.drive(Tween(begin: 1, end: widget.pressScale ?? 1));
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  var elevation = 4.0;
  var scale = 1.0;
  var translate = Offset(0, 0);

  _onTap() async {
    try {
      await widget.onTap?.call(context);
    } finally {
      if (mounted) {
        _ac.reverse();
      }
    }
  }

  _onLongPress() async {
    HapticFeedback.heavyImpact();
    late var res;
    res = await widget.onLongPress!(context);

    if (res == true) {
      widget.onTap?.call(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.useMouseCursor
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: widget.behavior,
        onSecondaryTap:
            (widget.onSecondaryPress == null && widget.onLongPress == null)
                ? null
                : () {
                    if (widget.onSecondaryPress != null) {
                      widget.onSecondaryPress!(context);
                    } else {
                      _onLongPress();
                    }
                  },
        onTap: widget.onTap != null ? _onTap : null,
        onLongPress: widget.onLongPress != null ? _onLongPress : null,
        onTapDown: (tap) {
          setState(() {
            _ac.forward();
          });
        },
        onTapUp: (_) {
//        _ac.reverse();
//        print("Tap up!");
        },
        onTapCancel: () {
          setState(() {
            _ac.reverse();
          });
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

typedef HoverBuilder = Widget Function(bool isHover);

class HoverEffect extends StatefulWidget {
  final HoverBuilder builder;
  final MouseCursor cursor;

  const HoverEffect(
      {Key? key, this.cursor = MouseCursor.defer, required this.builder})
      : super(key: key);

  @override
  _HoverEffectState createState() => _HoverEffectState();
}

class _HoverEffectState extends State<HoverEffect> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) {
        if (isHover != true) {
          setState(() {
            isHover = true;
          });
        }
      },
      onExit: (_) {
        if (isHover == true) {
          setState(() {
            isHover = false;
          });
        }
      },
      child: widget.builder(isHover),
    );
  }
}

abstract class CursorPosition {
  Offset get currentPosition;

  /// Gets the current cursor position
  static Offset current(BuildContext context) {
    return Provided.get<CursorPosition>(context).currentPosition;
  }
}

class CursorTracker extends StatefulWidget {
  final Widget child;

  const CursorTracker({Key? key, required this.child}) : super(key: key);

  @override
  State<CursorTracker> createState() => _CursorTrackerState();
}

class _CursorTrackerState extends BaseState<CursorTracker>
    implements CursorPosition {
  Offset currentPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Provider<CursorPosition>.value(
      value: this,
      updateShouldNotify: (_, __) => false,
      child: MouseRegion(
        opaque: false,
        onHover: (p) {
          currentPosition = p.position;
        },
        child: widget.child,
      ),
    );
  }
}
