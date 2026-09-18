import 'package:flutter/material.dart';

abstract class AppTheme {
  static const String fontFamily = 'SFProDisplay';

  static const Color black = Color(0xFF1A1A1A);
  static const Color gray1 = Color(0xFFF5F5F5);
  static const Color gray3 = Color(0xFFE0E0E0);
  static const Color gray4 = Color(0xFFBDBDBD);
  static const Color gray5 = Color(0xFF757575);
  static const Color green1 = Color(0xFF6BC747);
  static const Color green2 = Color(0xFF7ED957);
  static const Color red = Color(0xFFE74C3C);
  static const Color white1 = Colors.white;
  static const Color white3 = Color(0xFFF5F3E8);
  static const Color white4 = Color(0xFFD4EDD4);
  static const Color white5 = Color(0xFFE8F5E8);

  static const LinearGradient backgroundGradient = LinearGradient(begin: Alignment.topCenter, colors: [white4, white3], end: Alignment.bottomCenter);

  static ThemeData get lightTheme => ThemeData(
        cardTheme: CardThemeData(color: white1, elevation: 1, shadowColor: Colors.black.withValues(alpha: 0.05), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        checkboxTheme: CheckboxThemeData(
          checkColor: const WidgetStatePropertyAll(white1),
          fillColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? green2 : Colors.transparent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: gray3, width: 2),
        ),
        colorScheme: ColorScheme.fromSeed(primary: green2, secondary: green1, seedColor: green2),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: green2,
            elevation: 0,
            foregroundColor: white1,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
        ),
        fontFamily: fontFamily,
        inputDecorationTheme: InputDecorationTheme(
          border: outline(gray3),
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: outline(gray3),
          errorBorder: outline(red),
          fillColor: white1,
          filled: true,
          floatingLabelStyle: const TextStyle(color: green2, fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w500),
          focusedBorder: outline(green2, 2),
          focusedErrorBorder: outline(red, 2),
          hintStyle: const TextStyle(color: gray4, fontFamily: fontFamily, fontSize: 16),
          labelStyle: const TextStyle(color: gray5, fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: gray3, width: 1.5),
            textStyle: const TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        scaffoldBackgroundColor: white5,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: black, fontSize: 16),
          bodyMedium: TextStyle(color: black, fontSize: 14),
          titleLarge: TextStyle(color: black, fontSize: 28, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        useMaterial3: true,
      );

  static OutlineInputBorder outline(Color color, [double width = 1]) => OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: color, width: width));
}
