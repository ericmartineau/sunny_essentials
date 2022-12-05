import 'dart:math' as math;
import 'dart:ui';

import 'package:dartxx/dartxx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

typedef ImageFilterBuilder = ImageFilter Function(double scrollAmount);

class SunnySliverAppBar extends StatefulWidget {
  /// Creates a material design app bar that can be placed in a [CustomScrollView].
  ///
  /// The arguments [forceElevated], [primary], [floating], [pinned], [snap]
  /// and [automaticallyImplyLeading] must not be null.
  const SunnySliverAppBar({
    Key? key,
    this.leading,
    this.fadeExpanded = true,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shadowColor,
    this.forceElevated = false,
    this.backgroundColor,
    this.backgroundMaxOpacity,
    this.backgroundMinOpacity,
    this.foregroundColor,
    @Deprecated(
      'This property is no longer used, please use systemOverlayStyle instead. '
      'This feature was deprecated after v2.4.0-0.0.pre.',
    )
        this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    @Deprecated(
      'This property is no longer used, please use toolbarTextStyle and titleTextStyle instead. '
      'This feature was deprecated after v2.4.0-0.0.pre.',
    )
        this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.collapsedHeight,
    this.expandedHeight,
    this.floating = false,
    this.pinned = false,
    this.snap = false,
    this.stretch = false,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.shape,
    this.backgroundFilter,
    this.backgroundFilterBuilder,
    this.toolbarHeight = kToolbarHeight,
    this.leadingWidth,
    @Deprecated(
      'This property is obsolete and is false by default. '
      'This feature was deprecated after v2.4.0-0.0.pre.',
    )
        this.backwardsCompatibility,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
  })  : assert(floating || !snap,
            'The "snap" argument only makes sense for floating app bars.'),
        assert(stretchTriggerOffset > 0.0),
        assert(collapsedHeight == null || collapsedHeight >= toolbarHeight,
            'The "collapsedHeight" argument has to be larger than or equal to [toolbarHeight].'),
        super(key: key);

  final ImageFilter? backgroundFilter;
  final ImageFilterBuilder? backgroundFilterBuilder;

  final bool fadeExpanded;
  final double? backgroundMaxOpacity;
  final double? backgroundMinOpacity;

  /// {@macro flutter.material.appbar.leading}
  ///
  /// This property is used to configure an [AppBar].
  final Widget? leading;

  /// {@macro flutter.material.appbar.automaticallyImplyLeading}
  ///
  /// This property is used to configure an [AppBar].
  final bool automaticallyImplyLeading;

  /// {@macro flutter.material.appbar.title}
  ///
  /// This property is used to configure an [AppBar].
  final Widget? title;

  /// {@macro flutter.material.appbar.actions}
  ///
  /// This property is used to configure an [AppBar].
  final List<Widget>? actions;

  /// {@macro flutter.material.appbar.flexibleSpace}
  ///
  /// This property is used to configure an [AppBar].
  final Widget? flexibleSpace;

  /// {@macro flutter.material.appbar.bottom}
  ///
  /// This property is used to configure an [AppBar].
  final PreferredSizeWidget? bottom;

  /// {@macro flutter.material.appbar.elevation}
  ///
  /// This property is used to configure an [AppBar].
  final double? elevation;

  /// {@macro flutter.material.appbar.shadowColor}
  ///
  /// This property is used to configure an [AppBar].
  final Color? shadowColor;

  /// Whether to show the shadow appropriate for the [elevation] even if the
  /// content is not scrolled under the [AppBar].
  ///
  /// Defaults to false, meaning that the [elevation] is only applied when the
  /// [AppBar] is being displayed over content that is scrolled under it.
  ///
  /// When set to true, the [elevation] is applied regardless.
  ///
  /// Ignored when [elevation] is zero.
  final bool forceElevated;

  /// {@macro flutter.material.appbar.backgroundColor}
  ///
  /// This property is used to configure an [AppBar].
  final Color? backgroundColor;

  /// {@macro flutter.material.appbar.foregroundColor}
  ///
  /// This property is used to configure an [AppBar].
  final Color? foregroundColor;

  /// {@macro flutter.material.appbar.brightness}
  ///
  /// This property is used to configure an [AppBar].
  @Deprecated(
    'This property is no longer used, please use systemOverlayStyle instead. '
    'This feature was deprecated after v2.4.0-0.0.pre.',
  )
  final Brightness? brightness;

  /// {@macro flutter.material.appbar.iconTheme}
  ///
  /// This property is used to configure an [AppBar].
  final IconThemeData? iconTheme;

  /// {@macro flutter.material.appbar.actionsIconTheme}
  ///
  /// This property is used to configure an [AppBar].
  final IconThemeData? actionsIconTheme;

  /// {@macro flutter.material.appbar.textTheme}
  ///
  /// This property is used to configure an [AppBar].
  @Deprecated(
    'This property is no longer used, please use toolbarTextStyle and titleTextStyle instead. '
    'This feature was deprecated after v2.4.0-0.0.pre.',
  )
  final TextTheme? textTheme;

  /// {@macro flutter.material.appbar.primary}
  ///
  /// This property is used to configure an [AppBar].
  final bool primary;

  /// {@macro flutter.material.appbar.centerTitle}
  ///
  /// This property is used to configure an [AppBar].
  final bool? centerTitle;

  /// {@macro flutter.material.appbar.excludeHeaderSemantics}
  ///
  /// This property is used to configure an [AppBar].
  final bool excludeHeaderSemantics;

  /// {@macro flutter.material.appbar.titleSpacing}
  ///
  /// This property is used to configure an [AppBar].
  final double? titleSpacing;

  /// Defines the height of the app bar when it is collapsed.
  ///
  /// By default, the collapsed height is [toolbarHeight]. If [bottom] widget is
  /// specified, then its height from [PreferredSizeWidget.preferredSize] is
  /// added to the height. If [primary] is true, then the [MediaQuery] top
  /// padding, [EdgeInsets.top] of [MediaQueryData.padding], is added as well.
  ///
  /// If [pinned] and [floating] are true, with [bottom] set, the default
  /// collapsed height is only the height of [PreferredSizeWidget.preferredSize]
  /// with the [MediaQuery] top padding.
  final double? collapsedHeight;

  /// The size of the app bar when it is fully expanded.
  ///
  /// By default, the total height of the toolbar and the bottom widget (if
  /// any). If a [flexibleSpace] widget is specified this height should be big
  /// enough to accommodate whatever that widget contains.
  ///
  /// This does not include the status bar height (which will be automatically
  /// included if [primary] is true).
  final double? expandedHeight;

  /// Whether the app bar should become visible as soon as the user scrolls
  /// towards the app bar.
  ///
  /// Otherwise, the user will need to scroll near the top of the scroll view to
  /// reveal the app bar.
  ///
  /// If [snap] is true then a scroll that exposes the app bar will trigger an
  /// animation that slides the entire app bar into view. Similarly if a scroll
  /// dismisses the app bar, the animation will slide it completely out of view.
  ///
  /// ## Animated Examples
  ///
  /// The following animations show how the app bar changes its scrolling
  /// behavior based on the value of this property.
  ///
  /// * App bar with [floating] set to false:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar.mp4}
  /// * App bar with [floating] set to true:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_floating.mp4}
  ///
  /// See also:
  ///
  ///  * [SunnySliverAppBar] for more animated examples of how this property changes the
  ///    behavior of the app bar in combination with [pinned] and [snap].
  final bool floating;

  /// Whether the app bar should remain visible at the start of the scroll view.
  ///
  /// The app bar can still expand and contract as the user scrolls, but it will
  /// remain visible rather than being scrolled out of view.
  ///
  /// ## Animated Examples
  ///
  /// The following animations show how the app bar changes its scrolling
  /// behavior based on the value of this property.
  ///
  /// * App bar with [pinned] set to false:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar.mp4}
  /// * App bar with [pinned] set to true:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_pinned.mp4}
  ///
  /// See also:
  ///
  ///  * [SunnySliverAppBar] for more animated examples of how this property changes the
  ///    behavior of the app bar in combination with [floating].
  final bool pinned;

  /// {@macro flutter.material.appbar.shape}
  ///
  /// This property is used to configure an [AppBar].
  final ShapeBorder? shape;

  /// If [snap] and [floating] are true then the floating app bar will "snap"
  /// into view.
  ///
  /// If [snap] is true then a scroll that exposes the floating app bar will
  /// trigger an animation that slides the entire app bar into view. Similarly
  /// if a scroll dismisses the app bar, the animation will slide the app bar
  /// completely out of view. Additionally, setting [snap] to true will fully
  /// expand the floating app bar when the framework tries to reveal the
  /// contents of the app bar by calling [RenderObject.showOnScreen]. For
  /// example, when a [TextField] in the floating app bar gains focus, if [snap]
  /// is true, the framework will always fully expand the floating app bar, in
  /// order to reveal the focused [TextField].
  ///
  /// Snapping only applies when the app bar is floating, not when the app bar
  /// appears at the top of its scroll view.
  ///
  /// ## Animated Examples
  ///
  /// The following animations show how the app bar changes its scrolling
  /// behavior based on the value of this property.
  ///
  /// * App bar with [snap] set to false:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_floating.mp4}
  /// * App bar with [snap] set to true:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_floating_snap.mp4}
  ///
  /// See also:
  ///
  ///  * [SunnySliverAppBar] for more animated examples of how this property changes the
  ///    behavior of the app bar in combination with [pinned] and [floating].
  final bool snap;

  /// Whether the app bar should stretch to fill the over-scroll area.
  ///
  /// The app bar can still expand and contract as the user scrolls, but it will
  /// also stretch when the user over-scrolls.
  final bool stretch;

  /// The offset of overscroll required to activate [onStretchTrigger].
  ///
  /// This defaults to 100.0.
  final double stretchTriggerOffset;

  /// The callback function to be executed when a user over-scrolls to the
  /// offset specified by [stretchTriggerOffset].
  final AsyncCallback? onStretchTrigger;

  /// {@macro flutter.material.appbar.toolbarHeight}
  ///
  /// This property is used to configure an [AppBar].
  final double toolbarHeight;

  /// {@macro flutter.material.appbar.leadingWidth}
  ///
  /// This property is used to configure an [AppBar].
  final double? leadingWidth;

  /// {@macro flutter.material.appbar.backwardsCompatibility}
  ///
  /// This property is used to configure an [AppBar].
  @Deprecated(
    'This property is obsolete and is false by default. '
    'This feature was deprecated after v2.4.0-0.0.pre.',
  )
  final bool? backwardsCompatibility;

  /// {@macro flutter.material.appbar.toolbarTextStyle}
  ///
  /// This property is used to configure an [AppBar].
  final TextStyle? toolbarTextStyle;

  /// {@macro flutter.material.appbar.titleTextStyle}
  ///
  /// This property is used to configure an [AppBar].
  final TextStyle? titleTextStyle;

  /// {@macro flutter.material.appbar.systemOverlayStyle}
  ///
  /// This property is used to configure an [AppBar].
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  State<SunnySliverAppBar> createState() => _SunnySliverAppBarState();
}

class _SunnySliverAppBarState extends State<SunnySliverAppBar>
    with TickerProviderStateMixin {
  FloatingHeaderSnapConfiguration? _snapConfiguration;
  OverScrollHeaderStretchConfiguration? _stretchConfiguration;
  PersistentHeaderShowOnScreenConfiguration? _showOnScreenConfiguration;

  void _updateSnapConfiguration() {
    if (widget.snap && widget.floating) {
      _snapConfiguration = FloatingHeaderSnapConfiguration(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 200),
      );
    } else {
      _snapConfiguration = null;
    }

    _showOnScreenConfiguration = widget.floating & widget.snap
        ? const PersistentHeaderShowOnScreenConfiguration(
            minShowOnScreenExtent: double.infinity)
        : null;
  }

  void _updateStretchConfiguration() {
    if (widget.stretch) {
      _stretchConfiguration = OverScrollHeaderStretchConfiguration(
        stretchTriggerOffset: widget.stretchTriggerOffset,
        onStretchTrigger: widget.onStretchTrigger,
      );
    } else {
      _stretchConfiguration = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _updateSnapConfiguration();
    _updateStretchConfiguration();
  }

  @override
  void didUpdateWidget(SunnySliverAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.snap != oldWidget.snap || widget.floating != oldWidget.floating)
      _updateSnapConfiguration();
    if (widget.stretch != oldWidget.stretch) _updateStretchConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.primary || debugCheckHasMediaQuery(context));
    final double bottomHeight = widget.bottom?.preferredSize.height ?? 0.0;
    final double topPadding =
        widget.primary ? MediaQuery.of(context).padding.top : 0.0;
    final double collapsedHeight =
        (widget.pinned && widget.floating && widget.bottom != null)
            ? (widget.collapsedHeight ?? 0.0) + bottomHeight + topPadding
            : (widget.collapsedHeight ?? widget.toolbarHeight) +
                bottomHeight +
                topPadding;

    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: SliverPersistentHeader(
        floating: widget.floating,
        pinned: widget.pinned,
        delegate: _SliverAppBarDelegate(
          widget: widget,
          vsync: this,
          collapsedHeight: collapsedHeight,
          topPadding: topPadding,
          snapConfiguration: _snapConfiguration,
          stretchConfiguration: _stretchConfiguration,
          showOnScreenConfiguration: _showOnScreenConfiguration,
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final SunnySliverAppBar widget;
  _SliverAppBarDelegate({
    this.snapConfiguration,
    this.stretchConfiguration,
    this.showOnScreenConfiguration,
    required this.widget,
    required this.vsync,
    required this.topPadding,
    required this.collapsedHeight,
  })  : assert(widget.primary || topPadding == 0.0),
        assert(
          !widget.floating ||
              (snapConfiguration == null &&
                  showOnScreenConfiguration == null) ||
              vsync != null,
          'vsync cannot be null when snapConfiguration or showOnScreenConfiguration is not null, and floating is true',
        ),
        _bottomHeight = widget.bottom?.preferredSize.height ?? 0.0;

  final double collapsedHeight;
  final double topPadding;
  Widget? get leading => widget.leading;
  ImageFilter? get backgroundFilter => widget.backgroundFilter;
  ImageFilterBuilder? get backgroundFilterBuilder =>
      widget.backgroundFilterBuilder;
  bool get automaticallyImplyLeading => widget.automaticallyImplyLeading;
  Widget? get title => widget.title;
  List<Widget>? get actions => widget.actions;
  Widget? get flexibleSpace => widget.flexibleSpace;
  PreferredSizeWidget? get bottom => widget.bottom;
  double? get elevation => widget.elevation;
  Color? get shadowColor => widget.shadowColor;
  bool get forceElevated => widget.forceElevated;
  Color? get backgroundColor => widget.backgroundColor;
  Color? get foregroundColor => widget.foregroundColor;
  Brightness? get brightness => widget.brightness;
  IconThemeData? get iconTheme => widget.iconTheme;
  IconThemeData? get actionsIconTheme => widget.actionsIconTheme;
  TextTheme? get textTheme => widget.textTheme;
  bool get primary => widget.primary;
  bool? get centerTitle => widget.centerTitle;
  bool get excludeHeaderSemantics => widget.excludeHeaderSemantics;
  double? get titleSpacing => widget.titleSpacing;
  double? get expandedHeight => widget.expandedHeight;
  bool get floating => widget.floating;
  bool get pinned => widget.pinned;
  ShapeBorder? get shape => widget.shape;
  double? get toolbarHeight => widget.toolbarHeight;
  double? get leadingWidth => widget.leadingWidth;
  bool? get backwardsCompatibility => widget.backwardsCompatibility;
  TextStyle? get toolbarTextStyle => widget.toolbarTextStyle;
  TextStyle? get titleTextStyle => widget.titleTextStyle;
  SystemUiOverlayStyle? get systemOverlayStyle => widget.systemOverlayStyle;
  final double _bottomHeight;

  @override
  final FloatingHeaderSnapConfiguration? snapConfiguration;

  @override
  final OverScrollHeaderStretchConfiguration? stretchConfiguration;

  @override
  final PersistentHeaderShowOnScreenConfiguration? showOnScreenConfiguration;

  @override
  double get minExtent => collapsedHeight;

  @override
  double get maxExtent => math.max(
      topPadding +
          (expandedHeight ?? (toolbarHeight ?? kToolbarHeight) + _bottomHeight),
      minExtent);

  @override
  final TickerProvider vsync;

  double get _toolbarHeight => toolbarHeight ?? kToolbarHeight;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double visibleMainHeight = maxExtent - shrinkOffset - topPadding;
    final double extraToolbarHeight =
        math.max(minExtent - _bottomHeight - topPadding - _toolbarHeight, 0.0);
    final double visibleToolbarHeight =
        visibleMainHeight - _bottomHeight - extraToolbarHeight;

    final bool isScrolledUnder =
        overlapsContent || (pinned && shrinkOffset > maxExtent - minExtent);
    final bool isPinnedWithOpacityFade =
        pinned && floating && bottom != null && extraToolbarHeight == 0.0;
    var toolBarScrollPct =
        (visibleToolbarHeight / _toolbarHeight).clamp(0.0, 1.0);
    final double toolbarOpacity = !widget.fadeExpanded
        ? 1.0
        : !pinned || isPinnedWithOpacityFade
            ? toolBarScrollPct
            : 1.0;
    var currentExtent = math.max(minExtent, maxExtent - shrinkOffset);

    /// How much of the "extra" has been scrolled
    var expandedPct = expandedHeight == null
        ? 1.0
        : (((visibleToolbarHeight - _toolbarHeight) /
                (expandedHeight! - _toolbarHeight)))
            .clamp(0.0, 1.0);
    var maxBgOpacity = widget.backgroundMaxOpacity ?? 1.0;
    var minBgOpacity = widget.backgroundMinOpacity ?? 1.0;
    var opacityDiff = maxBgOpacity - minBgOpacity;

    final Widget appBar = FlexibleSpaceBar.createSettings(
      minExtent: minExtent,
      maxExtent: maxExtent,
      currentExtent: currentExtent,
      toolbarOpacity: widget.fadeExpanded ? toolbarOpacity : 1.0,
      isScrolledUnder: isScrolledUnder,
      child: AppBar(
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: title,
        actions: actions,
        flexibleSpace:
            (title == null && flexibleSpace != null && !excludeHeaderSemantics)
                ? Semantics(
                    header: true,
                    child: flexibleSpace,
                  )
                : flexibleSpace,
        bottom: bottom,
        elevation: forceElevated || isScrolledUnder ? elevation : 0.0,
        shadowColor: shadowColor,
        backgroundColor:
            backgroundColor?.withOpacity(opacityDiff * (1 - expandedPct)),
        foregroundColor: foregroundColor,
        brightness: brightness,
        iconTheme: iconTheme,
        actionsIconTheme: actionsIconTheme,
        textTheme: textTheme,
        primary: primary,
        centerTitle: centerTitle,
        excludeHeaderSemantics: excludeHeaderSemantics,
        titleSpacing: titleSpacing,
        shape: shape,
        toolbarOpacity: toolbarOpacity,
        bottomOpacity: pinned
            ? 1.0
            : ((visibleMainHeight / _bottomHeight).clamp(0.0, 1.0)),
        toolbarHeight: toolbarHeight,
        leadingWidth: leadingWidth,
        backwardsCompatibility: backwardsCompatibility,
        toolbarTextStyle: toolbarTextStyle,
        titleTextStyle: titleTextStyle,
        systemOverlayStyle: systemOverlayStyle,
      ),
    );

    var bgFilter = backgroundFilter ??
        backgroundFilterBuilder
            ?.call((1 - expandedPct).atLeast(0.01).toDouble());
    return bgFilter == null
        ? appBar
        : Stack(alignment: Alignment.topCenter, children: [
            Opacity(
              opacity: 1 - expandedPct,
              child: ClipRect(
                child: new BackdropFilter(
                  filter: bgFilter,
                  child: Container(
                    height: math.max(minExtent, maxExtent - shrinkOffset),
                    decoration: BoxDecoration(),
                  ),
                ),
              ),
            ),
            appBar,
          ]);
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return leading != oldDelegate.leading ||
        automaticallyImplyLeading != oldDelegate.automaticallyImplyLeading ||
        title != oldDelegate.title ||
        actions != oldDelegate.actions ||
        flexibleSpace != oldDelegate.flexibleSpace ||
        bottom != oldDelegate.bottom ||
        _bottomHeight != oldDelegate._bottomHeight ||
        elevation != oldDelegate.elevation ||
        shadowColor != oldDelegate.shadowColor ||
        backgroundColor != oldDelegate.backgroundColor ||
        foregroundColor != oldDelegate.foregroundColor ||
        brightness != oldDelegate.brightness ||
        iconTheme != oldDelegate.iconTheme ||
        actionsIconTheme != oldDelegate.actionsIconTheme ||
        textTheme != oldDelegate.textTheme ||
        primary != oldDelegate.primary ||
        centerTitle != oldDelegate.centerTitle ||
        titleSpacing != oldDelegate.titleSpacing ||
        expandedHeight != oldDelegate.expandedHeight ||
        topPadding != oldDelegate.topPadding ||
        pinned != oldDelegate.pinned ||
        floating != oldDelegate.floating ||
        vsync != oldDelegate.vsync ||
        snapConfiguration != oldDelegate.snapConfiguration ||
        stretchConfiguration != oldDelegate.stretchConfiguration ||
        showOnScreenConfiguration != oldDelegate.showOnScreenConfiguration ||
        forceElevated != oldDelegate.forceElevated ||
        toolbarHeight != oldDelegate.toolbarHeight ||
        leadingWidth != oldDelegate.leadingWidth ||
        backwardsCompatibility != oldDelegate.backwardsCompatibility ||
        toolbarTextStyle != oldDelegate.toolbarTextStyle ||
        titleTextStyle != oldDelegate.titleTextStyle ||
        systemOverlayStyle != oldDelegate.systemOverlayStyle;
  }

  @override
  String toString() {
    return '${describeIdentity(this)}(topPadding: ${topPadding.toStringAsFixed(1)}, bottomHeight: ${_bottomHeight.toStringAsFixed(1)}, ...)';
  }
}
