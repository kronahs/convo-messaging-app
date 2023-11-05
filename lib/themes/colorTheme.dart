// import 'package:flutter/material.dart';
//
// ColorScheme lightThemeColors(context) {
//   return const ColorScheme(
//     brightness: Brightness.light,
//     primary: Color(0xFF202020),
//     onPrimary: Color(0xFF505050),
//     secondary: Color(0xFFBBBBBB),
//     onSecondary: Color(0xFFEAEAEA),
//     error: Color(0xFFF32424),
//     onError: Color(0xFFF32424),
//     background: Color(0xFFF1F2F3),
//     onBackground: Color(0xFFFFFFFF),
//     surface: Color(0xFF54B435),
//     onSurface: Color(0xFF54B435),
//   );
// }
//
// ColorScheme darkThemeColors(context) {
//   return const ColorScheme(
//     brightness: Brightness.dark,
//     primary: Color(0xFFF1F2F3),
//     onPrimary: Color(0xFFFFFFFF),
//     secondary: Color(0xFFBBBBBB),
//     onSecondary: Color(0xFFEAEAEA),
//     error: Color(0xFFF32424),
//     onError: Color(0xFFF32424),
//     background: Color(0xFF202020),
//     onBackground: Color(0xFF505050),
//     surface: Color(0xFF54B435),
//     onSurface: Color(0xFF54B435),
//   );
// }

import 'package:flutter/material.dart';

Color _seedColor = Color(0xFF54B435); // Replace this with your seed color

ColorScheme generateColorScheme(Color seedColor) {
  Brightness brightness = ThemeData.estimateBrightnessForColor(seedColor);

  // Light Theme Colors
  Color lightPrimary = seedColor;
  Color lightOnPrimary = Colors.white;
  Color lightBackground = Colors.white;
  Color lightOnBackground = Colors.black;

  // Dark Theme Colors
  Color darkPrimary = seedColor;
  Color darkOnPrimary = Colors.white;
  Color darkBackground = Colors.black;
  Color darkOnBackground = Colors.white;

  return brightness == Brightness.light
      ? ColorScheme.light(
    primary: lightPrimary,
    onPrimary: lightOnPrimary,
    background: lightBackground,
    onBackground: lightOnBackground,
  )
      : ColorScheme.dark(
    primary: darkPrimary,
    onPrimary: darkOnPrimary,
    background: darkBackground,
    onBackground: darkOnBackground,
  );
}