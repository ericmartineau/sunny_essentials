import 'dart:async';

import 'package:flutter/widgets.dart';

typedef FutureBuildCallback<T> = FutureOr<T> Function(BuildContext context);
typedef SimpleFutureBuildCallback<T> = FutureOr<T> Function();

extension MapDeepMergeExt on Map<String, dynamic> {
  ///
  /// Deep merges two dynamic maps
  Map<String, dynamic> deepMerge(Map<String, dynamic> object,
      {bool skipNulls = false}) {
    final result = <String, dynamic>{...this};
    for (var entry in object.entries) {
      final newValue = entry.value;
      if (newValue == null && skipNulls) continue;

      dynamic target = newValue;
      if (newValue is Map<String, dynamic>) {
        final source = result[entry.key];
        if (source is Map<String, dynamic>) {
          target = source.deepMerge(newValue);
        }
      }
      result[entry.key] = target;
    }
    return result;
  }
}
