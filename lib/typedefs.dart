import 'dart:async';

import 'package:flutter/widgets.dart';

typedef FutureBuildCallback<T> = FutureOr<T> Function(BuildContext context);
typedef SimpleFutureBuildCallback<T> = FutureOr<T> Function();
