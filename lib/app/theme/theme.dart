import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AppTheme {
  AppTheme._();

  // Slate Color Palette
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate950 = Color(0xFF020617);

  // Semantic Colors
  static const Color primary = slate900;
  static const Color primaryForeground = slate50;
  static const Color secondary = slate100;
  static const Color secondaryForeground = slate900;
  static const Color muted = slate100;
  static const Color mutedForeground = slate500;
  static const Color accent = slate100;
  static const Color accentForeground = slate900;
  static const Color destructive = Color(0xFFEF4444);
  static const Color destructiveForeground = slate50;
  static const Color border = slate200;
  static const Color input = slate200;
  static const Color ring = slate950;

  // Dark Mode Colors
  static const Color darkPrimary = slate50;
  static const Color darkPrimaryForeground = slate900;
  static const Color darkSecondary = slate800;
  static const Color darkSecondaryForeground = slate50;
  static const Color darkMuted = slate800;
  static const Color darkMutedForeground = slate400;
  static const Color darkAccent = slate800;
  static const Color darkAccentForeground = slate50;
  static const Color darkDestructive = Color(0xFF7F1D1D);
  static const Color darkDestructiveForeground = slate50;
  static const Color darkBorder = slate800;
  static const Color darkInput = slate800;
  static const Color darkRing = slate300;

  static InputDecorationTheme _baseInputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
    required Color focusedBorderColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: focusedBorderColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: destructive, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: destructive, width: 2),
      ),
    );
  }

  static ElevatedButtonThemeData _baseElevatedButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  static OutlinedButtonThemeData _baseOutlinedButtonTheme({
    required Color borderColor,
    required Color foregroundColor,
  }) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        side: BorderSide(color: borderColor, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Light Theme
  static ThemeData lightTheme({String fontFamily = 'GeistMono'}) {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: fontFamily,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: primaryForeground,
        secondary: secondary,
        onSecondary: secondaryForeground,
        surface: slate50,
        onSurface: slate900,
        error: destructive,
        onError: destructiveForeground,
      ),
      scaffoldBackgroundColor: slate50,
      cardColor: Colors.white,

      inputDecorationTheme: _baseInputDecorationTheme(
        fillColor: Colors.transparent,
        borderColor: border,
        focusedBorderColor: ring,
      ),
      elevatedButtonTheme: _baseElevatedButtonTheme(
        backgroundColor: primary,
        foregroundColor: primaryForeground,
      ),
      outlinedButtonTheme: _baseOutlinedButtonTheme(
        borderColor: border,
        foregroundColor: slate900,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: slate50,
        foregroundColor: slate900,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: mutedForeground,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primary.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        iconTheme: WidgetStateProperty.all(
          IconThemeData(color: mutedForeground),
        ),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      useMaterial3: true,
    );
  }

  // Dark Theme
  static ThemeData darkTheme({String fontFamily = 'GeistMono'}) {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      primaryColor: darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        onPrimary: darkPrimaryForeground,
        secondary: darkSecondary,
        onSecondary: darkSecondaryForeground,
        surface: slate950,
        onSurface: slate50,
        error: destructive,
        onError: darkDestructiveForeground,
      ),
      scaffoldBackgroundColor: slate950,
      cardColor: slate900,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
        color: slate900,
      ),
      inputDecorationTheme: _baseInputDecorationTheme(
        fillColor: Colors.transparent,
        borderColor: darkBorder,
        focusedBorderColor: darkRing,
      ),
      elevatedButtonTheme: _baseElevatedButtonTheme(
        backgroundColor: darkPrimary,
        foregroundColor: darkPrimaryForeground,
      ),
      outlinedButtonTheme: _baseOutlinedButtonTheme(
        borderColor: darkBorder,
        foregroundColor: slate50,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: slate950,
        foregroundColor: slate50,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: slate900,
        selectedItemColor: darkPrimary,
        unselectedItemColor: darkMutedForeground,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: slate900,
        indicatorColor: darkPrimary.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        iconTheme: WidgetStateProperty.all(
          IconThemeData(color: darkMutedForeground),
        ),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      useMaterial3: true,
    );
  }
}
