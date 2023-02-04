import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension BuildContextProvidesExtension on BuildContext {
  T? consume<T>([void exec(T value)?]) {
    try {
      final t = Provider.of<T>(this, listen: false);
      exec?.call(t);
      return t;
    } on ProviderNotFoundException {
      return null;
    }
  }

  void rebox<T>(T value) {
    Provided.update(this, value);
  }

  T sub<T>() => Provider.of(this);

  T get<T>() {
    return Provided.get<T>(this);
  }

  T listen<T>() {
    final listenable = Provided.get<ValueNotifier<T>>(this);
    return listenable.value;
  }

  T? tryListen<T>() {
    final listenable = Provided.find<ValueNotifier<T>>(this);
    return listenable?.value;
  }

  void put<T>(T value) {
    final listenable = Provided.find<ValueNotifier<T>>(this) ??
        Provided.find<ValueNotifier<T?>>(this);
    assert(listenable != null, "No ValueNotifier could be found");
    listenable!.value = value;
  }

  void remove<T>() {
    put<T?>(null);
  }

  T? find<T>() {
    return Provided.find<T>(this);
  }

  bool exists<T>() {
    return find<T>() != null;
  }
}

Widget Reprovide<T>(BuildContext context,
    {bool listen = true, required Widget child}) {
  return Provider<T>.value(
      value: Provider.of<T>(context, listen: listen), child: child);
}

class ProvidedList<T, R> {
  final List<R> items;
  ProvidedList(this.items);
}

class Provided {
  static List<T> getList<R, T>(BuildContext context) {
    return get<ProvidedList<R, T>>(context).items;
  }

  static T get<T>(BuildContext context, {bool? listen}) {
    try {
      final t = Provider.of<T>(context, listen: listen ?? false);
      return t;
    } on ProviderNotFoundException {
      print("##################################  ${T} was found under ${T}?");
      print("##################################");
      final t = Provider.of<T?>(context, listen: false);
      if (t == null) {
        rethrow;
      }
      // ignore: unnecessary_cast
      return t as T;
    }
  }

  static F cast<T, F extends T>(BuildContext context) {
    try {
      final t = Provider.of<T>(context, listen: false);
      if (t is F) {
        return t;
      }
      throw 'Invalid cast!  Found ${t.runtimeType} but expected $F';
    } on ProviderNotFoundException {
      print("##################################  ${T} was found under ${T}?");
      print("##################################");
      final t = Provider.of<T?>(context, listen: false);
      if (t is! T) {
        rethrow;
      }
      // ignore: unnecessary_cast
      if (t is F) {
        return t;
      }
      throw 'Invalid cast!  Found ${t.runtimeType} but expected $F';
    }
  }

  static T? find<T>(BuildContext context, {bool? listen}) {
    try {
      final t = Provider.of<T>(context, listen: listen ?? false);
      return t;
    } on ProviderNotFoundException {
      return null;
    }
  }

  static void update<T>(BuildContext context, T value) {
    Provided.get<ProvidedBox<T>>(context).value = value;
  }

  // static T unbox<T>(BuildContext context) {
  //   return Provided.get<ProvidedBox<T>>(context).value;
  // }
  //
  // static T tryUnbox<T>(BuildContext context) {
  //   return Provided.get<ProvidedBox<T>>(context).valueOrNull;
  // }
}

T? consume<T>(BuildContext context, [void exec(T value)?]) {
  try {
    final t = Provider.of<T>(context, listen: false);
    exec?.call(t);
    return t;
  } on ProviderNotFoundException {
    return null;
  }
}

/// A container that sits at the top of the provider tree that can be updated from
/// within the tree.
class ProvidedBox<T> {
  T? _value;

  ProvidedBox([this._value]);

  set value(T t) {
    _value = t;
  }

  T? get valueOrNull {
    return _value;
  }

  T get value {
    return _value ??
        (throw Exception("No value $T could be found.  Was it set?"));
  }
}

class ProvidedWrapper<X> extends Equatable {
  final X value;

  const ProvidedWrapper(this.value);

  @override
  List<Object?> get props => [value];
}
