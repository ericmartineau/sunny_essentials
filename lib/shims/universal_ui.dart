library universal_ui;

import 'package:flutter/foundation.dart';

import 'fake_ui.dart' if (dart.library.html) 'real_ui.dart' as ui_instance;

class PlatformViewRegistryFix {
  registerViewFactory(Object x, dynamic y) {
    if (kIsWeb) {
      // ignore: undefined_prefixed_name
      ui_instance.platformViewRegistry.registerViewFactory(
        x.toString(),
        y,
      );
    } else {}
  }

  const PlatformViewRegistryFix();
}

class UniversalUI {
  final PlatformViewRegistryFix platformViewRegistry =
      const PlatformViewRegistryFix();

  const UniversalUI();
}

const ui = UniversalUI();
