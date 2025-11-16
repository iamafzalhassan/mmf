import 'package:flutter/material.dart';

class AppTheme {
  // App Colors - Updated for modern design
  static const Color primaryColor = Color(0xFF7ED957); // Vibrant green
  static const Color secondaryColor = Color(0xFF6BC747);

  // Background Colors - Soft gradient
  static const Color gradientStart = Color(0xFFD4EDD4); // Mint green
  static const Color gradientEnd = Color(0xFFF5F3E8); // Light cream
  static const Color scaffoldBackground = Color(0xFFE8F5E8);
  static const Color cardBackground = Colors.white;
  static final Color inputFillColor = const Color(0xFFF8F9FA);
  static final Color checkboxUnselectedBackground = Colors.grey[100]!;

  // Border Colors
  static final Color borderColor = const Color(0xFFE0E0E0);
  static final Color dividerColor = Colors.grey[300]!;

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static final Color textSecondary = Colors.grey[600]!;
  static const Color textOnPrimary = Colors.white;
  static final Color textPlaceholder = Colors.grey[400]!;

  // Status Colors
  static const Color successColor = Color(0xFF7ED957);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color warningColor = Colors.orange;

  // Icon Colors
  static final Color iconSecondary = Colors.grey[600]!;

  // Special Colors
  static const Color transparent = Colors.transparent;

  // Gradient for background
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Light Theme
  static ThemeData get lightTheme {
    const fontFamily = 'SFProDisplay';

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: scaffoldBackground,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: transparent,
        foregroundColor: textPrimary,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        filled: true,
        fillColor: cardBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: fontFamily,
          color: primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          color: textPlaceholder,
          fontSize: 15,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnPrimary,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Text Theme - THIS IS CRUCIAL
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: fontFamily),
        displayMedium: TextStyle(fontFamily: fontFamily),
        displaySmall: TextStyle(fontFamily: fontFamily),
        headlineLarge: TextStyle(fontFamily: fontFamily),
        headlineMedium: TextStyle(fontFamily: fontFamily),
        headlineSmall: TextStyle(fontFamily: fontFamily),
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleSmall: TextStyle(fontFamily: fontFamily),
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          color: textPrimary,
        ),
        bodySmall: TextStyle(fontFamily: fontFamily),
        labelLarge: TextStyle(fontFamily: fontFamily),
        labelMedium: TextStyle(fontFamily: fontFamily),
        labelSmall: TextStyle(fontFamily: fontFamily),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(textOnPrimary),
        side: BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}