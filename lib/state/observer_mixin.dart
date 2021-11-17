import 'dart:async';

import 'package:dartxx/dartxx.dart';
import 'package:flutter/widgets.dart';

import '../logging.dart';

typedef DisposeFn = FutureOr Function();

mixin ObserverMixin implements LoggingMixin, HasDisposers {
  bool _isDisposing = false;
  bool get isDisposing => _isDisposing;
  final List<DisposeFn> disposers = <DisposeFn>[];
  final List<StreamSubscription> subscriptions = <StreamSubscription>[];

  void onObserve({name});

  // ValueStreamController<X> streamController<X>(
  //     {String? debugLabel, X? initialValue, bool isUnique = true}) {
  //   final controller = ValueStream.controller(debugLabel,
  //       initialValue: initialValue, isUnique: isUnique);
  //   disposers.add(controller.dispose);
  //   return controller;
  // }

  void registerDisposer(DisposeFn dispose) {
    disposers.add(dispose);
  }

  void removeDisposer(DisposeFn dispose) {
    disposers.add(dispose);
  }

  void stream<T>(Stream<T> stream, [void listen(T next)?]) {
    subscriptions.add(stream.listen(
      (val) {
        if (!_isDisposing) {
          listen?.call(val);
        }
      },
      cancelOnError: false,
      onError: (error, stack) {
        log.info(error);
        log.info(stack);
      },
    ));
  }

  TextEditingController streamText(Stream<String> stream) {
    final TextEditingController controller = TextEditingController();
    subscriptions.add(stream.listen(
      (val) {
        if (!_isDisposing) {
          controller.text = val;
        }
      },
      cancelOnError: false,
      onError: (error, stack) {
        log.info(error);
        log.info(stack);
      },
    ));
    disposers.add(controller.dispose);
    return controller;
  }

  Stream<String> streamTextEdit(TextEditingController cont, [StreamController<String>? controller]) {
    final streamer = controller ?? StreamController<String>.broadcast();
    final listener = () {
      streamer.add(cont.text);
    };
    cont.addListener(listener);
    disposers.add(() => streamer.close());
    return streamer.stream;
  }

  void subscribe<T>(StreamController<T> controller, void listen(T next)) {
    subscriptions.add(controller.stream.listen(
      (val) {
        if (!_isDisposing) {
          listen(val);
        }
      },
      onError: (error, stack) {
        log.info(error);
        log.info(stack);
      },
    ));
  }

//  void watchMap(ObservableMap map, {Consumer<MapChange> onChange, String name}) {
//    if (map == null) return;
//    disposers.add(map.observe((change) {
//      onChange?.call(change);
//      onObserve?.call(name: name);
//    }));
//  }
//
//  void watchList(mobx.ObservableList list, {String name, Consumer<mobx.ListChange> onChange}) {
//    if (list == null) return;
//    disposers.add(list.observe((change) {
//      onChange == null ? onObserve?.call(name: name) : onChange(change);
//    }));
//  }

//  watchStream(SunnyObservableList list, {String name, Consumer<ListChanges> onChange}) {
//    if (list == null) return;
//    disposers.add(list.changeStream.listen((change) {
//      onChange?.call(change);
//    }).cancel);
//  }

  // SyncStream<V> watchVStream<V>(ValueStream<V> stream,
  //     {String name, Consumer<V> onChange}) {
  //   assert(stream != null);
  //   final syncStream = stream.toSyncStream(
  //       onChange == null
  //           ? null
  //           : (input) {
  //               if (!_isDisposing) {
  //                 onChange(input);
  //               }
  //             },
  //       name);
  //   disposers.add(syncStream.disposeAll);
  //   return syncStream;
  // }

//  void watchDiffStream<V>(ValueStream<ListDiffs<V>> stream, {String name, Consumer<ListDiffs<V>> onChange}) {
//    if (stream == null) return;
//    subscriptions.add(stream.listen(onChange));
//  }

  // void watchFutureStream<V>(ValueStream<V> stream,
  //     {String name, Consumer<V> onChange}) {
  //   if (stream == null) return;
  //   stream.get().thenOr((item) {
  //     if (!_isDisposing) {
  //       onChange?.call(item);
  //     }
  //   });
  //   subscriptions.add(stream.listen((_) {
  //     if (!_isDisposing) {
  //       onChange?.call(_);
  //     }
  //   }));
  // }

//  SingleValue<T> watchSingleValue<T>(T initialValue,
//      {String name, Stream<T> updater, Consumer<T> onChange, int delay}) {
//    final value = SingleValue<T>(initialValue);
//    reactions.add(mobx.reaction(
//      (_) => value.get(),
//      (T value) {
//        if (onChange != null) {
//          onChange(value);
//        } else {
//          onObserve?.call(name: name);
//        }
//      },
//      delay: delay,
//    ));
//
//    updater?.forEach((v) {
//      value.update(v);
//    });
//
//    return value;
//  }
//
//  /// Watches for any changes to the specified key in a map
//  watchKey<K, V>(SunnyObservableMap<K, V> map, K key, {name, Consumer<V> onChange, bool fireImmediately}) {
//    disposers.add(map.observeKey(key, (value) {
//      onChange?.call(value);
//      onObserve?.call(name: name);
//    }, fireImmediately: fireImmediately));
//  }

  /// Synchronizes this widget's state to a [SingleValue] observable.  This assumes that the
  /// value contained within [observable] is already being read by the widget builder, and this
  /// just ensures that [setState] is called each time [observable] is mutated.
//  void sync<T>(SingleValue<T> observable, {int delay}) {
//    Future.microtask(() => reactions.add(mobx.reaction(
//          (_) => observable.value,
//          (_) => onObserve,
//          delay: delay,
//        )));
//  }

  Future disposeObservations() async {
    _isDisposing = true;
    for (var dispose in [...disposers]) {
      await dispose();
    }
    disposers.clear();
    for (var subscription in [...subscriptions]) {
      await subscription.cancel();
    }
    subscriptions.clear();
  }
}
