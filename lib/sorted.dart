import 'package:dartxx/dartxx.dart';

extension SortedSort<T extends Sorted> on Iterable<T> {
  List<T> get inSortOrder => sortedUsing((item) => item.sortOrder);
}

mixin Sorted implements Comparable<Sorted> {
  num get sortOrder;

  @override
  int compareTo(Sorted other) {
    return sortOrder.compareTo(other.sortOrder);
  }
}
