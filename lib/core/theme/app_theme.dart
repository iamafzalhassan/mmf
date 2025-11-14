import 'package:flutter/material.dart';

class AppTheme {
  // App Colors
  static const Color primaryColor = Color(0xFF667EEA);
  static const Color secondaryColor = Color(0xFF764BA2);

  // Background Colors
  static final Color scaffoldBackground = Colors.grey[100]!;
  static const Color cardBackground = Colors.white;
  static final Color inputFillColor = Colors.grey[50]!;
  static final Color checkboxUnselectedBackground = Colors.grey[100]!;

  // Border Colors
  static final Color borderColor = Colors.grey[300]!;
  static final Color dividerColor = Colors.grey[300]!;

  // Text Colors
  static const Color textPrimary = Colors.black87;
  static final Color textSecondary = Colors.grey[600]!;
  static const Color textOnPrimary = Colors.white;

  // Status Colors
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color warningColor = Colors.orange;

  // Icon Colors
  static final Color iconSecondary = Colors.grey[600]!;

  // Special Colors
  static const Color transparent = Colors.transparent;

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: scaffoldBackground,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: transparent,
        foregroundColor: textOnPrimary,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}