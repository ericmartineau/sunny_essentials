import 'package:flutter/widgets.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

import '../provided.dart';
import '../theme/sunny_spacing.dart';
import '../widget_wrapper.dart';
import '../widget_wrapper.dart';

enum ModalMode { popover, alert, menu }
enum ModalSize { tiny, small, medium, large, fullScreen }

extension BoxConstraintsToModal on BoxConstraints {
  ModalConstraints toModalConstraints() {
    return ModalConstraints.constraints(this);
  }
}

class ModalConstraints implements WidgetDecorator {
  final BoxConstraints? constraints;
  final double? height;
  final double? width;
  final ModalSize? size;
  final double? largeInset;

  static const ModalConstraints empty = ModalConstraints();

  static const ModalConstraints fullScreen = ModalConstraints(
    size: ModalSize.fullScreen,
  );

  const ModalConstraints.constraints(BoxConstraints constraints)
      : height = null,
        width = null,
        largeInset = null,
        size = null,
        constraints = constraints;

  static const ModalConstraints small = ModalConstraints(
    size: ModalSize.small,
  );
  static const ModalConstraints tiny = ModalConstraints(
    size: ModalSize.tiny,
  );
  static const ModalConstraints medium = ModalConstraints(
    size: ModalSize.medium,
  );

  const ModalConstraints.large({double? inset})
      : this(
          largeInset: inset,
          size: ModalSize.large,
        );

  const ModalConstraints({
    this.constraints,
    this.largeInset,
    this.height,
    this.width,
    this.size,
  });

  ModalConstraints.size(
      {this.height, this.width, bool applyConstraints = false})
      : size = null,
        largeInset = null,
        constraints = (applyConstraints && height != null && width != null)
            ? BoxConstraints(maxWidth: width, maxHeight: height)
            : null;

  ModalConstraints.ofSize(Size size)
      : size = null,
        height = size.height,
        width = size.width,
        largeInset = null,
        constraints = null;

  bool get isEmpty {
    return size == null &&
        constraints == null &&
        height == null &&
        width == null;
  }

  /// Returns constraints derived from Provider, or the one passed in
  static ModalConstraints of(BuildContext context,
      [List<ModalConstraints?> provided = const [],
      ModalConstraints fallback = ModalConstraints.empty]) {
    ModalConstraints? found;
    for (var provide in provided) {
      if (provide != null) {
        found = provide;
        break;
      }
    }
    found ??= Provided.find<ModalConstraints>(context) ?? fallback;

    return found.resolveSize(context);
  }

  ModalConstraints resolveSize(BuildContext context) {
    if (this.size == null) return this;
    var sizing = this.size!.sizing(context, largeInset: largeInset);
    return ModalConstraints(
      constraints: constraints ?? sizing.constraints,
      width: width ?? sizing.width,
      height: height ?? sizing.height,
      size: null, // Set the size to null because we are resolving it
    );
  }

  Widget build(BuildContext context,
      {required Widget child, bool injectProvider = true}) {
    if (isEmpty) return child;
    var sizing = size?.sizing(context);
    var h = this.height ?? sizing?.height;
    var w = this.width ?? sizing?.width;
    var c = this.constraints ?? sizing?.constraints;

    var result = child;
    if (c != null) {
      result = ConstrainedBox(constraints: c, child: result);
    }
    if (h != null || w != null) {
      result = SizedBox(height: h, width: w, child: result);
    }
    return result;
  }

  ModalConstraints shrink({double height = 0, double width = 0}) {
    return ModalConstraints(
      constraints: this
          .constraints
          ?.deflate(EdgeInsets.symmetric(vertical: height, horizontal: width)),
      width: this.width == null ? null : (this.width! - width),
      height: this.height == null ? null : (this.height! - height),
      size: size,
      largeInset: largeInset,
    );
  }
}

const _smallModal = ModalConstraints(
  height: 350,
  width: 500,
  constraints: BoxConstraints(
    maxHeight: 350,
    maxWidth: 500,
  ),
);

const _tinyModal = ModalConstraints(
  height: 260,
  width: 260,
  constraints: BoxConstraints(
    maxHeight: 260,
    maxWidth: 260,
  ),
);

const _mediumModal = ModalConstraints(
  height: 600,
  width: 800,
  constraints: BoxConstraints(
    maxHeight: 600,
    maxWidth: 800,
  ),
);

extension ConstraintOrSizeExt on ModalSize {
  ModalConstraints sizing(BuildContext context, {double? largeInset}) {
    switch (this) {
      case ModalSize.tiny:
        return _tinyModal;
      case ModalSize.small:
        return _smallModal;
      case ModalSize.medium:
        return _mediumModal;
      case ModalSize.large:
        final size = MediaQuery.of(context).size;
        return ModalConstraints.constraints(
          BoxConstraints(
            maxHeight: size.height - (largeInset ?? sunnySpacing * 4),
            minWidth: size.width - (largeInset ?? sunnySpacing * 4),
          ),
        );
      case ModalSize.fullScreen:
        final size = MediaQuery.of(context).size;
        return ModalConstraints.size(
          height: size.height,
          width: size.width,
        );
        break;
    }
  }
}

class ModalOptions {
  final ModalMode? modalMode;
  final ModalConstraints? constraints;

  static const ModalOptions empty = ModalOptions();
  const ModalOptions.popover({
    this.constraints = ModalConstraints.tiny,
  }) : modalMode = ModalMode.popover;

  const ModalOptions.menu({
    this.constraints = ModalConstraints.tiny,
  }) : modalMode = ModalMode.menu;

  const ModalOptions.alert({
    this.constraints,
  }) : modalMode = ModalMode.popover;

  factory ModalOptions.of(BuildContext context, extraOptions) {
    if (extraOptions is ModalOptions) {
      return extraOptions;
    } else {
      return const ModalOptions();
    }
  }

  bool get isPopover => modalMode == ModalMode.popover;

  bool get isAlert => modalMode == ModalMode.alert;

  const ModalOptions({
    this.modalMode,
    this.constraints,
  });

  ModalOptions copyWith({
    ModalMode? modalMode,
    ModalConstraints? constraints,
  }) {
    return ModalOptions(
      modalMode: modalMode ?? this.modalMode,
      constraints: constraints ?? this.constraints,
    );
  }
}
