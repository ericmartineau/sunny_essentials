// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'sunny_sliver_fill_render.dart';

/// A sliver that contains multiple box children that each fills the viewport.
///
/// [SunnySliverFillViewport] places its children in a linear array along the main
/// axis. Each child is sized to fill the viewport, both in the main and cross
/// axis.
///
/// See also:
///
///  * [SliverFixedExtentList], which has a configurable
///    [SliverFixedExtentList.itemExtent].
///  * [SliverPrototypeExtentList], which is similar to [SliverFixedExtentList]
///    except that it uses a prototype list item instead of a pixel value to define
///    the main axis extent of each item.
///  * [SliverList], which does not require its children to have the same
///    extent in the main axis.
class SunnySliverFillViewport extends StatelessWidget {
  /// Creates a sliver whose box children that each fill the viewport.
  const SunnySliverFillViewport({
    Key? key,
    required this.delegate,
    this.viewportFraction = 1.0,
    this.padEnds = true,
    required this.minHeight,
  })  : assert(viewportFraction > 0.0),
        super(key: key);

  /// The fraction of the viewport that each child should fill in the main axis.
  ///
  /// If this fraction is less than 1.0, more than one child will be visible at
  /// once. If this fraction is greater than 1.0, each child will be larger than
  /// the viewport in the main axis.
  final double viewportFraction;

  final double minHeight;

  /// Whether to add padding to both ends of the list.
  ///
  /// If this is set to true and [viewportFraction] < 1.0, padding will be added
  /// such that the first and last child slivers will be in the center of
  /// the viewport when scrolled all the way to the start or end, respectively.
  /// You may want to set this to false if this [SunnySliverFillViewport] is not the only
  /// widget along this main axis, such as in a [CustomScrollView] with multiple
  /// children.
  ///
  /// This option cannot be null. If [viewportFraction] >= 1.0, this option has no
  /// effect. Defaults to true.
  final bool padEnds;

  /// {@macro flutter.widgets.SliverMultiBoxAdaptorWidget.delegate}
  final SliverChildDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return _SliverFractionalPadding(
      viewportFraction: padEnds ? (1 - viewportFraction).clamp(0, 1) / 2 : 0,
      sliver: _SliverFillViewportRenderObjectWidget(
        viewportFraction: viewportFraction,
        delegate: delegate,
        minHeight: minHeight,
      ),
    );
  }
}

class _SliverFillViewportRenderObjectWidget
    extends SliverMultiBoxAdaptorWidget {
  const _SliverFillViewportRenderObjectWidget({
    Key? key,
    required SliverChildDelegate delegate,
    this.viewportFraction = 1.0,
    required this.minHeight,
  })  : assert(viewportFraction > 0.0),
        super(key: key, delegate: delegate);

  final double viewportFraction;
  final double minHeight;

  @override
  RenderSunnySliverFillViewport createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return RenderSunnySliverFillViewport(
        childManager: element,
        viewportFraction: viewportFraction,
        minHeight: minHeight);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSunnySliverFillViewport renderObject) {
    renderObject.viewportFraction = viewportFraction;
  }
}

class _SliverFractionalPadding extends SingleChildRenderObjectWidget {
  const _SliverFractionalPadding({
    this.viewportFraction = 0,
    Widget? sliver,
  })  : assert(viewportFraction >= 0),
        assert(viewportFraction <= 0.5),
        super(child: sliver);

  final double viewportFraction;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSliverFractionalPadding(viewportFraction: viewportFraction);

  @override
  void updateRenderObject(
      BuildContext context, _RenderSliverFractionalPadding renderObject) {
    renderObject.viewportFraction = viewportFraction;
  }
}

class _RenderSliverFractionalPadding extends RenderSliverEdgeInsetsPadding {
  _RenderSliverFractionalPadding({
    double viewportFraction = 0,
  })  : assert(viewportFraction <= 0.5),
        assert(viewportFraction >= 0),
        _viewportFraction = viewportFraction;

  SliverConstraints? _lastResolvedConstraints;

  double get viewportFraction => _viewportFraction;
  double _viewportFraction;
  set viewportFraction(double newValue) {
    if (_viewportFraction == newValue) return;
    _viewportFraction = newValue;
    _markNeedsResolution();
  }

  @override
  EdgeInsets? get resolvedPadding => _resolvedPadding;
  EdgeInsets? _resolvedPadding;

  void _markNeedsResolution() {
    _resolvedPadding = null;
    markNeedsLayout();
  }

  void _resolve() {
    if (_resolvedPadding != null && _lastResolvedConstraints == constraints)
      return;

    final double paddingValue =
        constraints.viewportMainAxisExtent * viewportFraction;
    _lastResolvedConstraints = constraints;
    switch (constraints.axis) {
      case Axis.horizontal:
        _resolvedPadding = EdgeInsets.symmetric(horizontal: paddingValue);
        break;
      case Axis.vertical:
        _resolvedPadding = EdgeInsets.symmetric(vertical: paddingValue);
        break;
    }

    return;
  }

  @override
  void performLayout() {
    _resolve();
    super.performLayout();
  }
}

/// A sliver that contains a single box child that fills the remaining space in
/// the viewport.
///
/// [SunnySliverFillRemaining] will size its [child] to fill the viewport in the
/// cross axis. The extent of the sliver and its child's size in the main axis
/// is computed conditionally, described in further detail below.
///
/// Typically this will be the last sliver in a viewport, since (by definition)
/// there is never any room for anything beyond this sliver.
///
/// ## Main Axis Extent
///
/// ### When [SunnySliverFillRemaining] has a scrollable child
///
/// The [hasScrollBody] flag indicates whether the sliver's child has a
/// scrollable body. This value is never null, and defaults to true. A common
/// example of this use is a [NestedScrollView]. In this case, the sliver will
/// size its child to fill the maximum available extent. [SunnySliverFillRemaining]
/// will not constrain the scrollable area, as it could potentially have an
/// infinite depth. This is also true for use cases such as a [ScrollView] when
/// [ScrollView.shrinkWrap] is true.
///
/// ### When [SunnySliverFillRemaining] does not have a scrollable child
///
/// When [hasScrollBody] is set to false, the child's size is taken into account
/// when considering the extent to which it should fill the space. The extent to
/// which the preceding slivers have been scrolled is also taken into
/// account in deciding how to layout this sliver.
///
/// [SunnySliverFillRemaining] will size its [child] to fill the viewport in the
/// main axis if that space is larger than the child's extent, and the amount
/// of space that has been scrolled beforehand has not exceeded the main axis
/// extent of the viewport.
///
/// {@tool dartpad}
/// In this sample the [SunnySliverFillRemaining] sizes its [child] to fill the
/// remaining extent of the viewport in both axes. The icon is centered in the
/// sliver, and would be in any computed extent for the sliver.
///
/// ** See code in examples/api/lib/widgets/sliver_fill/sliver_fill_remaining.0.dart **
/// {@end-tool}
///
/// [SunnySliverFillRemaining] will defer to the size of its [child] if the
/// child's size exceeds the remaining space in the viewport.
///
/// {@tool dartpad}
/// In this sample the [SunnySliverFillRemaining] defers to the size of its [child]
/// because the child's extent exceeds that of the remaining extent of the
/// viewport's main axis.
///
/// ** See code in examples/api/lib/widgets/sliver_fill/sliver_fill_remaining.1.dart **
/// {@end-tool}
///
/// [SunnySliverFillRemaining] will defer to the size of its [child] if the
/// [SliverConstraints.precedingScrollExtent] exceeded the length of the viewport's main axis.
///
/// {@tool dartpad}
/// In this sample the [SunnySliverFillRemaining] defers to the size of its [child]
/// because the [SliverConstraints.precedingScrollExtent] has gone
/// beyond that of the viewport's main axis.
///
/// ** See code in examples/api/lib/widgets/sliver_fill/sliver_fill_remaining.2.dart **
/// {@end-tool}
///
/// For [ScrollPhysics] that allow overscroll, such as
/// [BouncingScrollPhysics], setting the [fillOverscroll] flag to true allows
/// the size of the [child] to _stretch_, filling the overscroll area. It does
/// this regardless of the path chosen to provide the child's size.
///
/// {@animation 250 500 https://flutter.github.io/assets-for-api-docs/assets/widgets/sliver_fill_remaining_fill_overscroll.mp4}
///
/// {@tool dartpad}
/// In this sample the [SunnySliverFillRemaining]'s child stretches to fill the
/// overscroll area when [fillOverscroll] is true. This sample also features a
/// button that is pinned to the bottom of the sliver, regardless of size or
/// overscroll behavior. Try switching [fillOverscroll] to see the difference.
///
/// This sample only shows the overscroll behavior on devices that support
/// overscroll.
///
/// ** See code in examples/api/lib/widgets/sliver_fill/sliver_fill_remaining.3.dart **
/// {@end-tool}
///
///
/// See also:
///
///  * [SunnySliverFillViewport], which sizes its children based on the
///    size of the viewport, regardless of what else is in the scroll view.
///  * [SliverList], which shows a list of variable-sized children in a
///    viewport.
class SunnySliverFillRemaining extends StatelessWidget {
  /// Creates a sliver that fills the remaining space in the viewport.
  const SunnySliverFillRemaining({
    Key? key,
    this.child,
    this.hasScrollBody = true,
    this.fillOverscroll = false,
    this.maxViewportPercent = 1.0,
    this.minHeight = 0.0,
  }) : super(key: key);

  /// Box child widget that fills the remaining space in the viewport.
  ///
  /// The main [SunnySliverFillRemaining] documentation contains more details.
  final Widget? child;

  final double maxViewportPercent;

  /// Indicates whether the child has a scrollable body, this value cannot be
  /// null.
  ///
  /// Defaults to true such that the child will extend beyond the viewport and
  /// scroll, as seen in [NestedScrollView].
  ///
  /// Setting this value to false will allow the child to fill the remainder of
  /// the viewport and not extend further. However, if the
  /// [SliverConstraints.precedingScrollExtent] and/or the [child]'s
  /// extent exceeds the size of the viewport, the sliver will defer to the
  /// child's size rather than overriding it.
  final bool hasScrollBody;

  /// Indicates whether the child should stretch to fill the overscroll area
  /// created by certain scroll physics, such as iOS' default scroll physics.
  /// This value cannot be null. This flag is only relevant when the
  /// [hasScrollBody] value is false.
  ///
  /// Defaults to false, meaning the default behavior is for the child to
  /// maintain its size and not extend into the overscroll area.
  final bool fillOverscroll;

  final double minHeight;

  @override
  Widget build(BuildContext context) {
    if (hasScrollBody)
      return _SliverFillRemainingWithScrollable(
          child: child,
          minHeight: minHeight,
          maxViewportPercent: maxViewportPercent);
    if (!fillOverscroll)
      return _SliverFillRemainingWithoutScrollable(
          child: child, minHeight: minHeight);
    return _SliverFillRemainingAndOverscroll(
        child: child, minHeight: minHeight);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Widget>(
        'child',
        child,
      ),
    );
    final List<String> flags = <String>[
      if (hasScrollBody) 'scrollable',
      if (fillOverscroll) 'fillOverscroll',
    ];
    if (flags.isEmpty) flags.add('nonscrollable');
    properties.add(IterableProperty<String>('mode', flags));
  }
}

class _SliverFillRemainingWithScrollable extends SingleChildRenderObjectWidget {
  const _SliverFillRemainingWithScrollable(
      {super.child,
      required this.minHeight,
      required this.maxViewportPercent});

  final double minHeight;
  final double maxViewportPercent;
  @override
  RenderSunnySliverFillRemainingWithScrollable createRenderObject(
          BuildContext context) =>
      RenderSunnySliverFillRemainingWithScrollable(
          minHeight: minHeight, maxViewportPercent: maxViewportPercent);
}

class _SliverFillRemainingWithoutScrollable
    extends SingleChildRenderObjectWidget {
  final double minHeight;

  const _SliverFillRemainingWithoutScrollable({
    super.child,
    required this.minHeight,
  });

  @override
  RenderSunnySliverFillRemaining createRenderObject(BuildContext context) =>
      RenderSunnySliverFillRemaining();
}

class _SliverFillRemainingAndOverscroll extends SingleChildRenderObjectWidget {
  const _SliverFillRemainingAndOverscroll({
    super.child,
    required this.minHeight,
  });

  final double minHeight;

  @override
  RenderSunnySliverFillRemainingAndOverscroll createRenderObject(
          BuildContext context) =>
      RenderSunnySliverFillRemainingAndOverscroll();
}
