import 'dart:ui';

import 'package:dartxx/dartxx.dart';
import 'package:equatable/equatable.dart';

import '../sorted.dart';

abstract class ThemeName {
  List<ThemeName> get parentThemes => const [];
}

extension ThemeNameDefaultExt on ThemeName {
  List<ThemeName> get themeHierarchy {
    return {
      for (final p in parentThemes) ...p.themeHierarchy,
      this,
    }.toList();
  }
}

enum ThemePart { typography, color }

class ThemeToken<T extends ThemeName> extends Equatable with Sorted {
  final T? name;
  final Brightness? brightness;
  final String key;
  final double sortOrder;

  static final ThemeToken light = ThemeToken(brightness: Brightness.light);
  static final ThemeToken dark = ThemeToken(brightness: Brightness.dark);
  static final ThemeToken fallback = ThemeToken();

  ThemeToken.resolve(T name, Brightness brightness)
      : this(
          name: name,
          brightness: brightness,
        );

  ThemeToken({this.name, this.brightness})
      : key = _themeStringGenerator(
          name,
          null,
          brightness,
        ),
        sortOrder = _calculateThemeWeight(
          name,
          null,
          brightness,
        );

  List<Object?> get props => [name, brightness];

  ThemeToken<TT> cast<TT extends ThemeName>() {
    return ThemeToken<TT>(name: name as TT, brightness: brightness);
  }

  @override
  String toString() => key;

  ///
  /// Creates a cartesian product of resolvers
  static List<ThemeToken<T>> cartesianProduct<T extends ThemeName>({
    List<T> themeNames = const [],
    List<Brightness> brightness = const [],
  }) {
    final names = themeNames.isEmpty ? [null] : themeNames;
    return [
      for (final n in names)
        for (final b in brightness) ThemeToken(name: n, brightness: b)
    ];
  }

  static ThemeToken<T> withDefaults<T extends ThemeName>(
    ThemeToken? start, {
    required T name,
    Brightness brightness = Brightness.light,
  }) {
    if (start?.name != null && start?.brightness != null)
      return start! as ThemeToken<T>;
    return ThemeToken(
      name: (start?.name ?? name) as T?,
      brightness: start?.brightness ?? brightness,
    );
  }

  ThemeToken<TT> copyWith<TT extends ThemeName>({
    TT? name,
    Brightness? brightness,
  }) {
    return ThemeToken<TT>(
      name: name ?? this.name as TT?,
      brightness: brightness ?? this.brightness,
    );
  }
}

String _themeStringGenerator<T extends ThemeName>(
    T? themeName, ThemePart? part, Brightness? brightness) {
  final parts = [
    if (themeName != null) themeName,
    if (part != null) part,
    if (brightness != null) brightness,
  ].map((e) => e is Enum ? e.name : e.toString());

  return parts.isEmpty ? "theme" : parts.join("_");
}

extension BrightnessThemeToken on Brightness {
  ThemeToken get themeToken => ThemeToken(brightness: this);
}

double _calculateThemeWeight<T extends ThemeName>(
    T? themeName, ThemePart? part, Brightness? brightness) {
  double score = 0;
  if (themeName != null) score -= 1.2;
  if (part != null) score -= 1.1;
  if (brightness != null) score -= 1.0;

  return score;
}

extension ThemeTokenExpandExt<T extends ThemeName> on ThemeToken<T> {
  /// Expands this token to include all possible sub-variants that might contribute
  /// to it, sorted in the order of importance.
  List<ThemeFragment> get fragments {
    final themeHierarchy = name == null ? <ThemeName>[] : name!.themeHierarchy;
    final result = [
      ThemeFragment.fallback,
      if (brightness != null) ThemeFragment(brightness: brightness!),
      for (final part in ThemePart.values) ThemeFragment(part: part),
      if (brightness != null)
        for (final part in ThemePart.values)
          ThemeFragment(part: part, brightness: brightness!),
      for (final pName in themeHierarchy) ThemeFragment(name: pName),
      if (brightness != null)
        for (final pName in themeHierarchy)
          ThemeFragment(
            name: pName,
            brightness: brightness,
          ),
    ];

    return result;
  }

  /// Expands this token to include a hierarchy of tokens that may be used
  /// to build a desired theme
  List<ThemeToken> get resolveTokens {
    return {
      if (name != null)
        for (final p in name!.themeHierarchy) ...[
          this.copyWith(name: p),
        ],
      ThemeToken(brightness: brightness),
      ThemeToken(),
    }.sorted();
  }
}

class ThemeFragment extends Equatable with Sorted {
  final ThemeName? name;
  final Brightness? brightness;
  final ThemePart? part;
  final String key;
  final double sortOrder;

  const ThemeFragment._(
    this.key,
    this.sortOrder, [
    this.brightness,
    this.part,
    this.name,
  ]);

  static const fallback = ThemeFragment._('theme', 0);
  static const light = ThemeFragment._('light', -1.0, Brightness.light);
  static const dark = ThemeFragment._('dark', -1.0, Brightness.dark);

  ThemeFragment({this.name, this.part, this.brightness})
      : key = _themeStringGenerator(name, part, brightness),
        sortOrder = -_calculateThemeWeight(name, part, brightness);

  @override
  List<Object?> get props => [name, brightness, part];

  @override
  String toString() {
    return key;
  }

  static List<ThemeFragment> cartesianProduct({
    List<ThemeName> names = const [],
    List<Brightness> brightness = const [],
    List<ThemePart> part = const [],
    bool includeNull = true,
  }) {
    /// Creates a cartesian product of tokens, by default including null for each
    /// type

    return [
      for (final name in [...names, if (includeNull) null])
        for (final brightness in [...brightness, if (includeNull) null])
          for (final part in [...part, null])
            ThemeFragment(
              name: name,
              brightness: brightness,
              part: part,
            ),
    ].sorted();
  }
}
