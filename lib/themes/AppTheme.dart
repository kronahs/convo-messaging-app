
import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class AppTheme{
  final Color primaryColor, tertiaryColor, neutralColor;

  const AppTheme({
    this.primaryColor = const Color(0xff356859),
    this.tertiaryColor = const Color(0xffff5722),
    this.neutralColor = const Color(0xffffbe6),
});

  ThemeData toThemeData(){
    return ThemeData(useMaterial3: true);
  }
}