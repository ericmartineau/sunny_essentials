import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import 'spaced.dart';

Widget sliverBox(Widget widget, [bool wrap = true]) =>
    wrap == true ? SliverToBoxAdapter(child: widget) : widget;

Widget slivers({Widget? child}) => SliverToBoxAdapter(child: child);

WidgetBuilder buildSliverBox(WidgetBuilder builder) =>
    (context) => sliverBox(builder(context));

List<Widget> sliverBoxes(Iterable<Widget> widgets) =>
    widgets.map((widget) => SliverToBoxAdapter(child: widget)).toList();

Widget? assumeWidget(BuildContext context, dynamic item) {
  assert(item is Widget?, 'Item must be a widget!');
  return item as Widget?;
}

Widget AlignCenterLeft({required Widget child}) =>
    Align(alignment: Alignment.centerLeft, child: child);

Widget AlignCenterRight({required Widget child}) =>
    Align(alignment: Alignment.centerRight, child: child);

Widget AlignTopCenter({required Widget child}) =>
    Align(alignment: Alignment.topCenter, child: child);

Widget AlignBottomCenter({required Widget child}) =>
    Align(alignment: Alignment.bottomCenter, child: child);

Widget SliverBox({required Widget child}) => SliverToBoxAdapter(child: child);

List<Widget> SliverBoxes({required Iterable<Widget> children}) => [
      for (final c in children) SliverBox(child: c),
    ];

typedef SliverWidgetBuilder<T> = Widget? Function(BuildContext context, T item);

class SimpleSliverList<W> extends StatelessWidget {
  static final log = Logger("SimpleSliverList");
  final Iterable<W> itemsIter;
  final SliverWidgetBuilder<W> builder;

  SimpleSliverList(
    this.itemsIter, {
    Key? key,
    this.divider,
    SliverWidgetBuilder<W>? builder,
  })  : builder = builder ?? ((context, item) => assumeWidget(context, item)),
        super(key: key);

  static SimpleSliverList<Widget> children(
    Iterable<Widget> itemsIter, {
    Key? key,
    Widget? divider,
  }) {
    return SimpleSliverList<Widget>(
      itemsIter,
      key: key,
      divider: divider,
      builder: (context, item) => item,
    );
  }

  static SimpleSliverList<T> of<T>(Iterable<T> itemsIter,
      {Key? key,
      Widget? divider,
      Widget? builder(BuildContext context, T item)?}) {
    return SimpleSliverList<T>(itemsIter,
        key: key, divider: divider, builder: builder);
  }

  final Widget? divider;

  @override
  Widget build(BuildContext context) {
    final Iterable<W> itemsIter = this.itemsIter;
    final items = itemsIter.toList();
    final hasDivider = divider != null;
    final count = hasDivider ? ((items.length * 2) - 1) : items.length;
    // log.info("Sliver list count = ${count}");
    return items.isEmpty
        ? sliverEmptyBox
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, idx) {
                if (idx.isOdd && hasDivider) {
                  return divider;
                }
                idx = hasDivider ? idx ~/ 2 : idx.toInt();
                final item = items[idx];
                if (item == null) return null;
                return builder(context, item);
              },
              addSemanticIndexes: false,

              // addRepaintBoundaries: true,
              childCount: count,
            ),
          );
  }
}
