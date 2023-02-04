import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:info_x/sunny_get.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:sunny_essentials/cards/platform_overlay_theme.dart';
import 'package:sunny_essentials/sunny_essentials.dart';
import 'package:sunny_essentials/theme/theme_token.dart';

export 'theme_extensions.dart';

typedef ThemeDataBuilder = ThemeData Function(
    Brightness brightness, TextStyle inputStyle, TextStyle placeholder1);

abstract class ThemesResolver {
  Themes resolve(ThemeToken? key);
}

/// Default mapper which echoes the provided [ThemeKey]
ThemeToken _defaultTokenConverter(ThemeToken? input) => input!;

/// For a given app, there may be subsections that have different themes.  These
/// themes are described by a key (typically a ThemeKey), which produces a set
/// of Themes for different platforms/brightness.
class ThemesProvider implements ThemesResolver {
  /// Maps the requested ThemeKey to a known ThemeKey.
  final ThemeToken Function(ThemeToken? source) themeKeyMapper;
  final Map<ThemeToken, Themes> _allThemes;

  const ThemesProvider({
    this.themeKeyMapper = _defaultTokenConverter,
    required Map<ThemeToken, Themes> allThemes,
  }) : _allThemes = allThemes;

  static ThemesProvider of(BuildContext context) {
    return sunny.get<ThemesProvider>(context: context);
  }

  void check() {
    for (var o in _allThemes.entries) {
      assert(o.key == o.value.key,
          'Key must match what was set for the theme: ${o.key} != ${o.value.key}');
    }
  }

  Themes resolve(ThemeToken? key) {
    final ThemeToken actualKey = themeKeyMapper(key);
    var theme = _allThemes[actualKey];
    if (theme == null) {
      // Fallback theme resolution...
      for (var parentToken in actualKey.resolveTokens) {
        theme = _allThemes[parentToken];
        if (theme != null) break;
      }
      assert(theme != null,
          "No theme found for $key (mapped to $actualKey, but found ${_allThemes.keys})");
      return theme!;
    } else {
      return theme;
    }
  }
}

class Themes<T extends ThemeName> with EquatableMixin {
  final String? debugLabel;
  final ThemeToken<T> key;
  final Brightness brightness;
  final ThemeData materialTheme;
  final CupertinoVisualStyle visualStyle;
  final CupertinoThemeData cupertinoTheme;
  final PlatformOverlayTheme platformOverlayTheme;
  final SunnyFormSubmitThemeData submitButtonTheme;
  final SunnyColors colors;
  final SunnyTextTheme textTheme;
  final MacosThemeData macosTheme;

  const Themes({
    required this.key,
    required this.brightness,
    required this.colors,
    required this.textTheme,
    required this.macosTheme,
    required this.materialTheme,
    required this.visualStyle,
    this.debugLabel,
    this.submitButtonTheme = const SunnyFormSubmitThemeData(),
    this.platformOverlayTheme = const PlatformOverlayTheme(),
    required this.cupertinoTheme,
  });

  @override
  List<Object> get props => [key];

  @override
  String toString() {
    return 'Themes{key: $key, debugLabel: $debugLabel}';
  }

  static Themes of(BuildContext context) {
    return Provided.get<Themes>(context);
  }
}

extension ButtonThemeToButtonStyleExt on ThemeData {
  ButtonStyle toElevatedButtonStyle() {
    var bt = buttonTheme;
    var tt = textTheme;

    return ButtonStyle();
  }

  ElevatedButtonThemeData toElevatedButtonTheme() {
    return ElevatedButtonThemeData(style: toElevatedButtonStyle());
  }
}

extension ThemeDataToMacOsTheme on ThemeData {
  ThemeData copyUsing({
    bool? applyElevationOverlayColor,
    NoDefaultCupertinoThemeData cupertinoOverrideTheme(
        NoDefaultCupertinoThemeData existing)?,
    Iterable<ThemeExtension<dynamic>> extensions(
        Iterable<ThemeExtension<dynamic>> existing)?,
    InputDecorationTheme inputDecorationTheme(InputDecorationTheme existing)?,
    MaterialTapTargetSize materialTapTargetSize(
        MaterialTapTargetSize existing)?,
    PageTransitionsTheme pageTransitionsTheme(PageTransitionsTheme existing)?,
    TargetPlatform platform(TargetPlatform existing)?,
    ScrollbarThemeData scrollbarTheme(ScrollbarThemeData existing)?,
    InteractiveInkFeatureFactory splashFactory(
        InteractiveInkFeatureFactory existing)?,
    bool? useMaterial3,
    VisualDensity visualDensity(VisualDensity existing)?,

    // COLOR
    // [colorScheme] is the preferred way to configure colors. The other color
    // properties will gradually be phased out, see
    // https://github.com/flutter/flutter/issues/91772.
    Color? backgroundColor,
    Color? bottomAppBarColor,
    Brightness? brightness,
    Color? canvasColor,
    Color? cardColor,
    ColorScheme colorScheme(ColorScheme existing)?,
    Color? dialogBackgroundColor,
    Color? disabledColor,
    Color? dividerColor,
    Color? errorColor,
    Color? focusColor,
    Color? highlightColor,
    Color? hintColor,
    Color? hoverColor,
    Color? indicatorColor,
    Color? primaryColor,
    Color? primaryColorDark,
    Color? primaryColorLight,
    Color? scaffoldBackgroundColor,
    Color? secondaryHeaderColor,
    Color? selectedRowColor,
    Color? shadowColor,
    Color? splashColor,
    Color? toggleableActiveColor,
    Color? unselectedWidgetColor,

    // TYPOGRAPHY & ICONOGRAPHY
    IconThemeData iconTheme(IconThemeData existing)?,
    IconThemeData primaryIconTheme(IconThemeData existing)?,
    TextTheme primaryTextTheme(TextTheme existing)?,
    TextTheme textTheme(TextTheme existing)?,
    Typography typography(Typography existing)?,

    // COMPONENT THEMES
    AppBarTheme appBarTheme(AppBarTheme existing)?,
    MaterialBannerThemeData bannerTheme(MaterialBannerThemeData existing)?,
    BottomAppBarTheme bottomAppBarTheme(BottomAppBarTheme existing)?,
    BottomNavigationBarThemeData bottomNavigationBarTheme(
        BottomNavigationBarThemeData existing)?,
    BottomSheetThemeData bottomSheetTheme(BottomSheetThemeData existing)?,
    ButtonBarThemeData buttonBarTheme(ButtonBarThemeData existing)?,
    ButtonThemeData buttonTheme(ButtonThemeData existing)?,
    CardTheme cardTheme(CardTheme existing)?,
    CheckboxThemeData checkboxTheme(CheckboxThemeData existing)?,
    ChipThemeData chipTheme(ChipThemeData existing)?,
    DataTableThemeData dataTableTheme(DataTableThemeData existing)?,
    DialogTheme dialogTheme(DialogTheme existing)?,
    DividerThemeData dividerTheme(DividerThemeData existing)?,
    DrawerThemeData drawerTheme(DrawerThemeData existing)?,
    ButtonStyle elevatedButtonTheme(ButtonStyle existing)?,
    ExpansionTileThemeData expansionTileTheme(ExpansionTileThemeData existing)?,
    FloatingActionButtonThemeData floatingActionButtonTheme(
        FloatingActionButtonThemeData existing)?,
    ListTileThemeData listTileTheme(ListTileThemeData existing)?,
    NavigationBarThemeData navigationBarTheme(NavigationBarThemeData existing)?,
    NavigationRailThemeData navigationRailTheme(
        NavigationRailThemeData existing)?,
    ButtonStyle outlinedButtonTheme(ButtonStyle existing)?,
    PopupMenuThemeData popupMenuTheme(PopupMenuThemeData existing)?,
    ProgressIndicatorThemeData progressIndicatorTheme(
        ProgressIndicatorThemeData existing)?,
    RadioThemeData radioTheme(RadioThemeData existing)?,
    SliderThemeData sliderTheme(SliderThemeData existing)?,
    SnackBarThemeData snackBarTheme(SnackBarThemeData existing)?,
    SwitchThemeData switchTheme(SwitchThemeData existing)?,
    TabBarTheme tabBarTheme(TabBarTheme existing)?,
    ButtonStyle textButtonTheme(ButtonStyle existing)?,
    TextSelectionThemeData textSelectionTheme(TextSelectionThemeData existing)?,
    TimePickerThemeData timePickerTheme(TimePickerThemeData existing)?,
    ToggleButtonsThemeData toggleButtonsTheme(ToggleButtonsThemeData existing)?,
    TooltipThemeData tooltipTheme(TooltipThemeData existing)?,
  }) {
    return this.copyWith(
      applyElevationOverlayColor: applyElevationOverlayColor,
      cupertinoOverrideTheme: cupertinoOverrideTheme == null
          ? null
          : cupertinoOverrideTheme(this.cupertinoOverrideTheme!),
      inputDecorationTheme: inputDecorationTheme == null
          ? null
          : inputDecorationTheme(this.inputDecorationTheme),
      materialTapTargetSize: materialTapTargetSize == null
          ? null
          : materialTapTargetSize(this.materialTapTargetSize),
      pageTransitionsTheme: pageTransitionsTheme == null
          ? null
          : pageTransitionsTheme(this.pageTransitionsTheme),
      platform: platform == null ? null : platform(this.platform),
      scrollbarTheme:
          scrollbarTheme == null ? null : scrollbarTheme(this.scrollbarTheme),
      splashFactory:
          splashFactory == null ? null : splashFactory(this.splashFactory),
      useMaterial3: useMaterial3,
      visualDensity:
          visualDensity == null ? null : visualDensity(this.visualDensity),
      // COLOR
      // [colorScheme] is the preferred way to configure colors. The other color
      // properties will gradually be phased out, see
      // https://github.com/flutter/flutter/issues/91772.
      backgroundColor: backgroundColor,
      bottomAppBarColor: bottomAppBarColor,
      brightness: brightness,
      canvasColor: canvasColor,
      cardColor: cardColor,
      colorScheme: colorScheme == null ? null : colorScheme(this.colorScheme),
      dialogBackgroundColor: dialogBackgroundColor,
      disabledColor: disabledColor,
      dividerColor: dividerColor,
      errorColor: errorColor,
      focusColor: focusColor,
      highlightColor: highlightColor,
      hintColor: hintColor,
      hoverColor: hoverColor,
      indicatorColor: indicatorColor,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      secondaryHeaderColor: secondaryHeaderColor,
      selectedRowColor: selectedRowColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      toggleableActiveColor: toggleableActiveColor,
      unselectedWidgetColor: unselectedWidgetColor,
      // TYPOGRAPHY & ICONOGRAPHY
      iconTheme: iconTheme == null ? null : iconTheme(this.iconTheme),
      primaryIconTheme: primaryIconTheme == null
          ? null
          : primaryIconTheme(this.primaryIconTheme),
      primaryTextTheme: primaryTextTheme == null
          ? null
          : primaryTextTheme(this.primaryTextTheme),
      textTheme: textTheme == null ? null : textTheme(this.textTheme),
      typography: typography == null ? null : typography(this.typography),
      // COMPONENT THEMES
      appBarTheme: appBarTheme == null ? null : appBarTheme(this.appBarTheme),
      bannerTheme: bannerTheme == null ? null : bannerTheme(this.bannerTheme),
      bottomAppBarTheme: bottomAppBarTheme == null
          ? null
          : bottomAppBarTheme(this.bottomAppBarTheme),
      bottomNavigationBarTheme: bottomNavigationBarTheme == null
          ? null
          : bottomNavigationBarTheme(this.bottomNavigationBarTheme),
      bottomSheetTheme: bottomSheetTheme == null
          ? null
          : bottomSheetTheme(this.bottomSheetTheme),
      buttonBarTheme:
          buttonBarTheme == null ? null : buttonBarTheme(this.buttonBarTheme),
      buttonTheme: buttonTheme == null ? null : buttonTheme(this.buttonTheme),
      cardTheme: cardTheme == null ? null : cardTheme(this.cardTheme),
      checkboxTheme:
          checkboxTheme == null ? null : checkboxTheme(this.checkboxTheme),
      chipTheme: chipTheme == null ? null : chipTheme(this.chipTheme),
      dataTableTheme:
          dataTableTheme == null ? null : dataTableTheme(this.dataTableTheme),
      dialogTheme: dialogTheme == null ? null : dialogTheme(this.dialogTheme),
      dividerTheme:
          dividerTheme == null ? null : dividerTheme(this.dividerTheme),
      drawerTheme: drawerTheme == null ? null : drawerTheme(this.drawerTheme),
      elevatedButtonTheme: elevatedButtonTheme == null
          ? null
          : ElevatedButtonThemeData(
              style: elevatedButtonTheme(
                this.elevatedButtonTheme.style ?? ButtonStyle(),
              ),
            ),
      expansionTileTheme: expansionTileTheme == null
          ? null
          : expansionTileTheme(this.expansionTileTheme),
      floatingActionButtonTheme: floatingActionButtonTheme == null
          ? null
          : floatingActionButtonTheme(this.floatingActionButtonTheme),
      listTileTheme:
          listTileTheme == null ? null : listTileTheme(this.listTileTheme),
      navigationBarTheme: navigationBarTheme == null
          ? null
          : navigationBarTheme(this.navigationBarTheme),
      navigationRailTheme: navigationRailTheme == null
          ? null
          : navigationRailTheme(this.navigationRailTheme),
      outlinedButtonTheme: outlinedButtonTheme == null
          ? null
          : OutlinedButtonThemeData(
              style: outlinedButtonTheme(
                  this.outlinedButtonTheme.style ?? ButtonStyle())),
      popupMenuTheme:
          popupMenuTheme == null ? null : popupMenuTheme(this.popupMenuTheme),
      progressIndicatorTheme: progressIndicatorTheme == null
          ? null
          : progressIndicatorTheme(this.progressIndicatorTheme),
      radioTheme: radioTheme == null ? null : radioTheme(this.radioTheme),
      sliderTheme: sliderTheme == null ? null : sliderTheme(this.sliderTheme),
      snackBarTheme:
          snackBarTheme == null ? null : snackBarTheme(this.snackBarTheme),
      switchTheme: switchTheme == null ? null : switchTheme(this.switchTheme),
      tabBarTheme: tabBarTheme == null ? null : tabBarTheme(this.tabBarTheme),
      textButtonTheme: textButtonTheme == null
          ? null
          : TextButtonThemeData(
              style:
                  textButtonTheme(this.textButtonTheme.style ?? ButtonStyle()),
            ),
      textSelectionTheme: textSelectionTheme == null
          ? null
          : textSelectionTheme(this.textSelectionTheme),
      timePickerTheme: timePickerTheme == null
          ? null
          : timePickerTheme(this.timePickerTheme),
      toggleButtonsTheme: toggleButtonsTheme == null
          ? null
          : toggleButtonsTheme(this.toggleButtonsTheme),
      tooltipTheme:
          tooltipTheme == null ? null : tooltipTheme(this.tooltipTheme),
    );
  }

  T nullPointer<T>([String? msg]) {
    throw Exception(msg ?? 'Null reference');
  }

  MacosThemeData toMacosTheme() {
    var starting =
        this.brightness.dark ? MacosThemeData.dark() : MacosThemeData.light();

    ButtonStyle buttonScheme = elevatedButtonTheme.style ??
        nullPointer("Conversion to MacosTheme requires elevatedButton styles");

    var pushButtonTheme = starting.pushButtonTheme.copyWith(
      color: buttonScheme.backgroundColor.require(),
      secondaryColor: buttonScheme.foregroundColor.require(),
      disabledColor: buttonScheme.backgroundDisabledColor,
    );

    var macosIconButtonTheme = starting.iconButtonTheme.copyWith(
        backgroundColor: buttonScheme.backgroundColor.require(),
        hoverColor: buttonScheme.backgroundHoverColor,
        padding: buttonScheme.padding.tryGet(),
        disabledColor: buttonScheme.backgroundDisabledColor,
        iconTheme: MacosIconThemeData(
          color: buttonScheme.foregroundColor.require(),
        ));
    return starting.copyWith(
      brightness: this.brightness,
      primaryColor: primaryColor,
      iconTheme: starting.iconTheme.copyWith(
        color: iconTheme.color,
        size: iconTheme.size,
        opacity: iconTheme.opacity,
      ),
      canvasColor: colorScheme.background,
      dividerColor: dividerColor,
      menuItemTheme: starting.menuItemTheme.merge(
        DefaultMacosMenuItemThemeData(
          hoverColor: hoverColor,
          backgroundColor: primaryColor,
          style: this.textTheme.labelMedium!.copyWith(color: textColor),
        ),
      ),
      iconButtonTheme: macosIconButtonTheme,
      textFieldTheme: MacosTextFieldThemeData(
        style: textTheme.bodyLarge!,
        placeholderStyle: textTheme.bodyLarge!
            .copyWith(color: textTheme.bodyMedium!.color!.withOpacity(0.8)),
        cursorColor: textTheme.bodyMedium!.color,
      ),
      pushButtonTheme: pushButtonTheme,
      typography: starting.typography.merge(
        MacosTypography(
          color: textTheme.bodyMedium!.color!,
          body: textTheme.bodyMedium!,
          callout: textTheme.bodySmall!,
          caption1: textTheme.labelMedium,
          caption2: textTheme.labelLarge,
          footnote: textTheme.labelMedium,
          headline: textTheme.displaySmall,
          largeTitle: textTheme.displayLarge,
          subheadline: textTheme.labelLarge,
          title1: textTheme.headlineMedium,
          title2: textTheme.titleMedium,
          title3: textTheme.titleSmall,
        ),
      ),
    );
  }
}
