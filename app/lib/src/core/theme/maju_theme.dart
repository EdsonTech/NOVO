import 'package:flutter/material.dart';

import 'maju_colors.dart';

/// Central Material 3 theme for MAJU. Spacing/radius tokens live here too.
abstract class MajuTheme {
  // Spacing scale
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;

  // Radius scale
  static const double rSm = 12;
  static const double rMd = 16;
  static const double rLg = 22;

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: MajuColors.blue700,
      primary: MajuColors.blue700,
      secondary: MajuColors.orange500,
      surface: MajuColors.card,
      error: MajuColors.red500,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: scheme);

    return base.copyWith(
      scaffoldBackgroundColor: MajuColors.bg,
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: MajuColors.card,
        foregroundColor: MajuColors.blue800,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 17,
          color: MajuColors.blue800,
        ),
      ),
      cardTheme: CardTheme(
        color: MajuColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rMd),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: MajuColors.orange500,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MajuColors.card,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: MajuColors.line, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: MajuColors.line, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: MajuColors.blue500, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: MajuColors.card,
        indicatorColor: MajuColors.blue100,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      displaySmall: _m(base.displaySmall, 30, FontWeight.w800),
      headlineSmall: _m(base.headlineSmall, 24, FontWeight.w800),
      titleLarge: _m(base.titleLarge, 18, FontWeight.w700),
      titleMedium: _i(base.titleMedium, 15, FontWeight.w600),
      bodyMedium: _i(base.bodyMedium, 14, FontWeight.w400),
      bodySmall: _i(base.bodySmall, 12, FontWeight.w400),
    ).apply(bodyColor: MajuColors.ink, displayColor: MajuColors.ink);
  }

  static TextStyle? _m(TextStyle? s, double size, FontWeight w) =>
      s?.copyWith(fontFamily: 'Montserrat', fontSize: size, fontWeight: w);

  static TextStyle? _i(TextStyle? s, double size, FontWeight w) =>
      s?.copyWith(fontFamily: 'Inter', fontSize: size, fontWeight: w);
}
