import 'dart:convert';

import 'package:dartxx/dartxx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:sunny_essentials/logging.dart';
import 'package:sunny_essentials/sunny_essentials.dart';
import 'package:sunny_essentials/theme/theme_token.dart';

typedef RawThemeMap = Map<ThemeFragment, Map<String, dynamic>>;

/// Holds a collection of partial theme json data, supports merging these
/// together in overlays to build different varying themes.
class RawThemeData with LoggingMixin {
  final RawThemeMap _themeData;
  final String baseLoadPath;

  RawThemeData({this.baseLoadPath = 'assets/theme/'}) : _themeData = {};

  Future<void> load(Iterable<ThemeFragment> fragments) async {
    log.info("LOADING FRAGMENTS: ${fragments.map((e) => e.key).toList()}");
    await fragments.forEachAsync((item) async {
      var loadedFile = '$baseLoadPath${item.key}.json';
      try {
        final themeData = await rootBundle.loadString(loadedFile);
        final decodedJson = jsonDecode(themeData) as Map<String, dynamic>;
        _themeData[item] = decodedJson;
        log.info('  - [$item}]: loaded "${loadedFile}"');
      } catch (e) {
        log.warning('  - [$item]: no file $loadedFile');
      }
    });
  }

  Iterable<ThemeFragment> get tokens => _themeData.keys;

  ThemeData buildTheme<T extends ThemeName>(ThemeToken<T> finalToken) {
    var allFragments = finalToken.fragments;
    final foundFragments = allFragments.mapNotNull((name) {
      final res = this._themeData[name];
      return res == null ? null : Tuple(name, res);
    });

    final usedNames = foundFragments.map((e) => e.first).toList();
    final jsonThemeData = foundFragments.map((e) => e.second).toList();
    late ThemeData startTheme;
    var brightnessOrLight = finalToken.brightness ?? Brightness.light;
    if (jsonThemeData.isEmpty) {
      startTheme = brightnessOrLight.defaultTheme();
    } else {
      var mergedData =
          jsonThemeData.reduce((value, element) => value!.deepMerge(element));
      startTheme = ThemeDecoder.decodeThemeData(mergedData)!.copyWith();
    }

    return startTheme;
  }

  Map<ThemeToken<TT>, ThemeData> buildThemes<TT extends ThemeName>(
    List<ThemeToken<TT>> tokens,
  ) {
    return {
      for (final token in tokens) token: buildTheme(token),
    };
  }
}
