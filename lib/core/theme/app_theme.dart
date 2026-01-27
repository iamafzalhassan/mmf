import 'package:flutter/material.dart';

class AppTheme {
  /* Colors */
  static const Color black = Color(0xFF1A1A1A);

  static final Color gray1 = Colors.grey[100]!;
  static final Color gray2 = Colors.grey[300]!;
  static const Color gray3 = Color(0xFFE0E0E0);
  static final Color gray4 = Colors.grey[400]!;
  static final Color gray5 = Colors.grey[600]!;
  static final Color gray6 = Colors.grey[600]!;

  static const Color green1 = Color(0xFF6BC747);
  static const Color green2 = Color(0xFF7ED957);
  static const Color green3 = Color(0xFF7ED957);

  static const Color orange = Colors.orange;
  static const Color red = Color(0xFFE74C3C);

  static const Color transparent = Colors.transparent;

  static const Color white1 = Colors.white;
  static const Color white2 = Color(0xFFF8F9FA);
  static const Color white3 = Color(0xFFF5F3E8);
  static const Color white4 = Color(0xFFD4EDD4);
  static const Color white5 = Color(0xFFE8F5E8);

  /* Gradients */
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    colors: [white4, white3],
    end: Alignment.bottomCenter,
  );

  /* Themes */
  static ThemeData get lightTheme {
    const fontFamily = 'SFProDisplay';

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        primary: green2,
        secondary: green1,
        seedColor: green2,
      ),
      fontFamily: fontFamily,
      scaffoldBackgroundColor: white5,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: black,
          fontFamily: fontFamily,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: black,
          fontFamily: fontFamily,
          fontSize: 14,
        ),
        bodySmall: TextStyle(fontFamily: fontFamily),
        displayLarge: TextStyle(fontFamily: fontFamily),
        displayMedium: TextStyle(fontFamily: fontFamily),
        displaySmall: TextStyle(fontFamily: fontFamily),
        headlineLarge: TextStyle(fontFamily: fontFamily),
        headlineMedium: TextStyle(fontFamily: fontFamily),
        headlineSmall: TextStyle(fontFamily: fontFamily),
        labelLarge: TextStyle(fontFamily: fontFamily),
        labelMedium: TextStyle(fontFamily: fontFamily),
        labelSmall: TextStyle(fontFamily: fontFamily),
        titleLarge: TextStyle(
          color: black,
          fontFamily: fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: black,
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(fontFamily: fontFamily),
      ),
      useMaterial3: true,
      cardTheme: CardThemeData(
        color: white1,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(white1),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return green2;
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: const BorderSide(color: gray3, width: 2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: green2,
          elevation: 0,
          foregroundColor: white1,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
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
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gray3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: red),
        ),
        fillColor: white1,
        filled: true,
        floatingLabelStyle: const TextStyle(
          color: green2,
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: green2, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: red, width: 2),
        ),
        hintStyle: TextStyle(
          color: gray4,
          fontFamily: fontFamily,
          fontSize: 16,
        ),
        labelStyle: TextStyle(
          color: gray5,
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gray3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: gray3, width: 1.5),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}