import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ---- Premium Pallete ----
  static const Color _primaryBackground = Color(0xFF121212);
  static const Color _secondaryBackground = Color(0xFF1E1E1E);
  static const Color _accentColor = Color(0xFFFFC107);
  static const Color _primaryText = Color(0xFFEAEAEA);
  static const Color _secondaryText = Color(0xFF8A8A8A);
  static const Color _errorColor = Color(0xFFFF5252);

  static ThemeData buildTheme() {
    final baseTheme = ThemeData.dark();

    final baseTextTheme = GoogleFonts.montserratTextTheme(baseTheme.textTheme).copyWith(
      bodyLarge: const TextStyle(color: _primaryText),
      bodyMedium: const TextStyle(color: _secondaryText),
      headlineSmall: const TextStyle(color: _primaryText, fontWeight: FontWeight.bold),
      titleMedium: const TextStyle(color: _primaryText),
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: _primaryBackground,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: _accentColor,
        secondary: _accentColor,
        surface: _secondaryBackground,
        onPrimary: _primaryBackground,
        onSurface: _primaryText,
        error: _errorColor,
      ),
      textTheme: baseTextTheme,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          foregroundColor: _primaryBackground,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _secondaryText,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _secondaryBackground,
        labelStyle: const TextStyle(color: _secondaryText),
        hintStyle: const TextStyle(color: _secondaryText),
        prefixIconColor: _secondaryText,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: _accentColor, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: _errorColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: _errorColor, width: 2),
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryBackground,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}