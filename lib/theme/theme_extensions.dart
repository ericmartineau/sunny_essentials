import 'package:flutter/material.dart';

const _hovered = {MaterialState.hovered};
const _focused = {MaterialState.focused};
const _pressed = {MaterialState.pressed};
const _dragged = {MaterialState.dragged};
const _selected = {MaterialState.selected};
const _scrolledUnder = {MaterialState.scrolledUnder};
const _disabled = {MaterialState.disabled};
const _error = {MaterialState.error};

extension on Color {
  Color operator +(Color other) => Color.alphaBlend(other, this);
}

extension BorderSideMergeExt on BorderSide {
  BorderSide merge(BorderSide? fromSide, [BorderSide? source]) {
    return fromSide == null
        ? this
        : source == null
            ? fromSide
            : BorderSide(
                color: fromSide.color == source.color
                    ? this.color
                    : fromSide.color,
                style: fromSide.style == source.style
                    ? this.style
                    : fromSide.style,
                width: fromSide.width == source.width
                    ? this.width
                    : fromSide.width,
                strokeAlign: fromSide.strokeAlign == source.strokeAlign
                    ? this.strokeAlign
                    : fromSide.strokeAlign,
              );
  }
}

extension BorderDirectionalMergeExt on BorderDirectional {
  BorderDirectional merge(BorderDirectional? other,
      [BorderDirectional? source]) {
    return other == null
        ? this
        : source == null
            ? other
            : BorderDirectional(
                top: top.merge(other.top, source.top),
                bottom: bottom.merge(other.bottom, source.bottom),
                start: start.merge(other.start, source.start),
                end: end.merge(other.end, source.end),
              );
  }
}

extension BorderMergeExt on Border {
  Border merge(Border? other, [Border? source]) {
    return other == null
        ? this
        : source == null
            ? other
            : Border(
                top: top.merge(other.top, source.top),
                bottom: bottom.merge(other.bottom, source.bottom),
                left: left.merge(other.left, source.left),
                right: right.merge(other.right, source.right),
              );
  }
}

extension BoxBorderMergeExt on BoxBorder {
  BoxBorder merge(BoxBorder? other, [BoxBorder? source]) {
    if (other == null) return this;
    if (source == null) return other;
    final self = this;
    if (self is BorderDirectional &&
        other is BorderDirectional &&
        source is BorderDirectional) {
      return self.merge(other, source);
    } else if (self is Border && other is Border && source is Border) {
      return self.merge(other, source);
    } else {
      // Convert all to directional first, assuming ltr
      return toDirectional().merge(
        other.toDirectional(),
        source.toDirectional(),
      );
    }
    return this;
  }

  BorderDirectional toDirectional() {
    final self = this;
    return self is BorderDirectional
        ? self
        : self is Border
            ? BorderDirectional(
                top: top,
                bottom: bottom,
                start: self.left,
                end: self.right,
              )
            : error<BorderDirectional>(
                'Cannot convert ${runtimeType} to BorderDirectional');
  }
}

T error<T>([String? message]) {
  throw StateError(message ?? 'Illegal state');
}

extension BoxDecorationMergeExt on BoxDecoration {
  BoxDecoration merge(BoxDecoration? other) {
    if (other == null) return this;
    return copyWith(
      color: other.color ?? color,
      image: other.image ?? image,
      border: other.border ?? border,
      borderRadius: other.borderRadius ?? borderRadius,
      boxShadow: other.boxShadow ?? boxShadow,
      gradient: other.gradient ?? gradient,
      backgroundBlendMode: other.backgroundBlendMode ?? backgroundBlendMode,
      shape: other.shape,
    );
  }
}

extension MaterialPExt on MaterialStateProperty<Color?> {
  /// Attempts to resolve a hover state color.  If the overlay color is not null
  /// then it will be combined with the empty material state version of the property.
  /// Otherwise, we'll use the "hovered" color variant;
  Color hoverState(MaterialStateProperty<Color?>? overlayColor) {
    if (overlayColor != null) {
      final overlay = overlayColor.tryGet(_hovered) ?? overlayColor.require();
      var selfColor = require();
      var combined = selfColor + overlay;
      return combined;
    } else {
      return require(_hovered);
    }
  }

  Color? get hoveredOrNull => resolve(_hovered);
  Color get hovered => require(_hovered);

  Color? get focusedOrNull => resolve(_focused);
  Color get focused => require(_focused);

  Color? get pressedOrNull => resolve(_pressed);
  Color get pressed => require(_pressed);

  Color? get draggedOrNull => resolve(_dragged);
  Color get dragged => require(_dragged);

  Color? get selectedOrNull => resolve(_selected);
  Color get selected => require(_selected);

  Color? get scrolledUnderOrNull => resolve(_scrolledUnder);
  Color get scrolledUnder => require(_scrolledUnder);

  Color? get disabledOrNull => resolve(_disabled);
  Color get disabled => require(_disabled);

  Color? get errorOrNull => resolve(_error);
  Color get error => require(_error);
}

extension ButtonStyleStateResolvers on ButtonStyle {
  Color get backgroundHoverColor {
    return backgroundColor.get().hoverState(overlayColor);
  }

  Color get foregroundHoverColor {
    return foregroundColor.get().hoverState(overlayColor);
  }

  Color get backgroundDisabledColor {
    return backgroundColor.require(_disabled);
  }

  Color get foregroundDisabledColor {
    return foregroundColor.require(_disabled);
  }
}

extension ObjectNullExt<T> on T? {
  T get([String? debug]) {
    if (this is T) return this as T;
    throw StateError('Cannot extract non-null $T: $debug');
  }
}

extension MaterialStatePropertyExtension<T> on MaterialStateProperty<T?>? {
  T require([Set<MaterialState> states = const {}]) {
    return this?.get().tryGet(states) ??
        (throw StateError('No resolved $T for $states'));
  }

  T? tryGet([Set<MaterialState> states = const {}]) {
    return this?.resolve(states);
  }
}
