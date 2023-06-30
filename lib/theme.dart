import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const secondary = Colors.blue;
  static const accent = Color.fromARGB(255, 255, 60, 0);
  static const textDark = Color.fromARGB(255, 0, 0, 0);
  static const textlight = Color.fromARGB(255, 241, 239, 239);
  static const textfaded = Color.fromARGB(255, 196, 193, 193);
  static const iconLight = Color.fromARGB(255, 168, 168, 168);
  static const iconDark = Color.fromARGB(255, 117, 114, 114);
  static const textHighlight = secondary;
  static const cardLight = Colors.white;
  static const cardDark = Color.fromARGB(255, 43, 42, 42);
}

abstract class _DarkColors {
  static const backgrond = Colors.black;
  static const card = AppColors.cardDark;
}

abstract class AppTheme {
  static const accentColor = AppColors.accent;
  static final visualdensity = VisualDensity.adaptivePlatformDensity;

  static ThemeData dark() => ThemeData(
      brightness: Brightness.dark,
      visualDensity: visualdensity,
      textTheme:
          GoogleFonts.mulishTextTheme().apply(bodyColor: AppColors.textlight),
      scaffoldBackgroundColor: _DarkColors.backgrond,
      cardColor: _DarkColors.card,
      primaryTextTheme:
          const TextTheme(titleLarge: TextStyle(color: AppColors.textlight)),
      iconTheme: const IconThemeData(color: AppColors.iconLight),
      colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          background: _DarkColors.backgrond,
          primary: _DarkColors.backgrond,
          surface: AppColors.cardDark,
          error: Colors.red,
          onBackground: _DarkColors.backgrond,
          onError: Colors.redAccent,
          onPrimary: AppColors.textlight,
          onSecondary: _DarkColors.backgrond,
          secondary: AppColors.secondary,
          onSurface: AppColors.textlight));
}
