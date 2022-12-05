import 'dart:async';

import 'package:dartxx/dartxx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sunny_essentials/state.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

// import 'package:sunny_dart/sunny_dart.dart';

import '../logging.dart';
import 'observer_mixin.dart';

int counter = 1;

/// A base class
abstract class BaseState<T extends StatefulWidget> extends State<T>
    with ObserverMixin, LoggingMixin {
  final int stateCounter = counter++;

  String get stateId => "${runtimeType.simpleName}$stateCounter";
  Object? pageError;

  ThemeData? _theme;
  SunnyColors? _sunnyColors;

  SunnyColors get sunnyColors => _sunnyColors ??= context.sunnyColors;
  ThemeData get theme => _theme ??= Theme.of(context);

  Map<Type, Object> _cachedProviders = {};

  T provide<T extends Object>() {
    return _cachedProviders.putIfAbsent(T, () => Provided.get<T>(context)) as T;
  }

  void safeState([VoidCallback? callback]) {
    if (mounted) {
      setState(callback ?? () {});
    } else {
      callback?.call();
    }
  }

  @mustCallSuper
  @override
  void initState() {
    super.initState();
  }

  FocusNode createFocusNode({String? debugLabel, bool watch = false}) {
    var node = FocusNode(debugLabel: debugLabel);
    disposers.add(node.dispose);

    if (watch) {
      node.addListener(() {
        safeState(() {});
      });
    }
    return node;
  }

  void watchFocusNode(FocusNode focusNode) {
    var updateState = () => safeState(() {});
    focusNode.addListener(updateState);
    disposers.add(() {
      focusNode.removeListener(updateState);
    });
  }

  void listen(ChangeNotifier? notifier, VoidCallback listener) {
    if (notifier == null) return;
    notifier.addListener(listener);
    disposers.add(() {
      notifier.removeListener(listener);
    });
  }

  T createNotifier<T extends ChangeNotifier>({T create()?, T? instance}) {
    instance ??= create!();
    disposers.add(instance.dispose);
    return instance;
  }

  ScrollController scrollController() {
    final controller = ScrollController();
    disposers.add(controller.dispose);
    return controller;
  }

  Future asyncState(AsyncCallback callback) async {
    await callback.call();
    safeState(() {});
  }

  Future trying(AsyncCallback fn) async {
    try {
      await fn();
    } catch (e, stack) {
      log.severe("Error in widget: $e", e, stack);
      setState(() {
        pageError = e;
      });
    }
  }

  void showKeyboard(BuildContext context) {}

  Key childKey(String name) {
    return Key("$stateId$name");
  }

  @override
  @mustCallSuper
  void dispose() {
    disposeObservations();
    super.dispose();
  }

  onObserve({name}) {
    print("OBSERVED!");
    setState(() {});
  }
}

extension StateObserverStream<T> on StreamSubscription<T> {
  void watch(HasDisposers obs) {
    obs.registerDisposer(this.cancel);
  }
}

extension StreamReader<T> on Stream<T> {
  void watch(BaseState obs) {
    this.listen((_) {}, cancelOnError: false).watch(obs);
  }
}
