import 'package:flutter/widgets.dart';
import 'package:sunny_dart/sunny_dart.dart';

import 'spaced.dart';

Widget sliverBox(Widget widget, [bool wrap = true]) =>
    wrap == true ? SliverToBoxAdapter(child: widget) : widget;

Widget slivers({Widget? child}) => SliverToBoxAdapter(child: child);

WidgetBuilder buildSliverBox(WidgetBuilder builder) =>
    (context) => sliverBox(builder(context));

List<Widget> sliverBoxes(Iterable<Widget> widgets) =>
    widgets.map((widget) => SliverToBoxAdapter(child: widget)).toList();

class SimpleSliverList<W> extends StatelessWidget with LoggingMixin {
  final Iterable<W> itemsIter;
  final Widget Function(BuildContext context, W item)? builder;

  const SimpleSliverList(this.itemsIter, {Key? key, this.divider, this.builder})
      : super(key: key);

  static SimpleSliverList<T> of<T>(Iterable<T> itemsIter,
      {Key? key,
      Widget? divider,
      Widget builder(BuildContext context, T item)?}) {
    return SimpleSliverList(itemsIter,
        key: key, divider: divider, builder: builder);
  }

  final Widget? divider;

  @override
  Widget build(BuildContext context) {
    final Iterable<W> itemsIter = this.itemsIter;
    final items = itemsIter.toList();
    final hasDivider = divider != null;
    final count = hasDivider ? ((items.length * 2) - 1) : items.length;
    log.info("Sliver list count = ${count}");
    return items.isEmpty
        ? sliverEmptyBox
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, idx) {
                log.info("Building $idx");
                if (idx.isOdd && hasDivider) {
                  return divider;
                }
                idx = hasDivider ? idx ~/ 2 : idx.toInt();
                final item = items[idx];
                if (item == null) return null;
                return builder!(context, item);
              },
              addRepaintBoundaries: true,
              childCount: count,

              // addAutomaticKeepAlives: false,
            ),
          );
  }
}
