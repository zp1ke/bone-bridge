import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

const _scheme = FlexScheme.hippieBlue;
const fontFamily = 'Lato';
const _surfaceMode = FlexSurfaceMode.levelSurfacesLowScaffold;
final _visualDensity = FlexColorScheme.comfortablePlatformDensity;
const _pageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
  },
);

// https://docs.flexcolorscheme.com/installing
final appTheme = AppTheme(
  light: FlexThemeData.light(
    scheme: _scheme,
    surfaceMode: _surfaceMode,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
    ),
    visualDensity: _visualDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    pageTransitionsTheme: _pageTransitionsTheme,
    fontFamily: fontFamily,
  ),
  dark: FlexThemeData.dark(
    scheme: _scheme,
    surfaceMode: _surfaceMode,
    blendLevel: 13,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
    ),
    visualDensity: _visualDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    pageTransitionsTheme: _pageTransitionsTheme,
    fontFamily: fontFamily,
  ),
);

class AppTheme {
  final ThemeData light;
  final ThemeData dark;

  AppTheme({
    required this.light,
    required this.dark,
  });
}
