import 'package:flutter/material.dart';
import 'package:sunny_essentials/sunny_essentials.dart';
import '../provided.dart';
import 'themes.dart';

extension ThemeExtractionExt on ThemeData {
  Color? get textColor => textTheme.bodyMedium?.color;
}

// final x = colorExtension();
extension BuildContextThemes on BuildContext {
  Themes get themes {
    return Provided.get(this);
  }

  ThemeData get theme {
    return Theme.of(this);
  }

  ThemesProvider get themesProvider {
    return Provided.get(this);
  }

  ThemeData get materialTheme {
    return themes.materialTheme;
  }

  Brightness get brightness {
    return MediaQuery.of(this).platformBrightness;
  }

  ThemeData get currentTheme {
    return materialTheme;
  }

  ThemeData get invertedTheme {
    return themesProvider.resolve(brightness.inverse).materialTheme;
  }
}
