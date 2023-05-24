import 'package:flutter/widgets.dart';

import 'state_observer.dart';

abstract class StateExtension<S extends BaseState> {
  const StateExtension(this.state);

  final S state;

  void safeState(VoidCallback callback) {
    state.safeState(callback);
  }

  void dispose();
}
