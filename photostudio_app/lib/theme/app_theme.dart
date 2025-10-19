import 'package:flutter/material.dart';

class AppTheme {
  // --- Цветовая палитра ---
  static const Color primaryDark = Color(
    0xFF111827,
  ); // Основной темный для кнопок и акцентов
  static const Color backgroundLight = Color(
    0xFFF9FAFB,
  ); // Светло-серый фон для экранов
  static const Color borderGrey = Color(
    0xFFD1D5DB,
  ); // Серый для границ полей ввода
  static const Color cardBorderGrey = Color(
    0xFFE5E7EB,
  ); // Очень светлый серый для границ карточек
  static const Color textPrimary = Color(0xFF111827); // Основной цвет текста
  static const Color textSecondary = Color(
    0xFF6B7280,
  ); // Вторичный (серый) цвет текста

  // --- Светлая тема ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundLight,
    fontFamily: 'Inter', // Используем шрифт Inter как в макете
    // --- Стили AppBar ---
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      surfaceTintColor: Colors.transparent, // Убирает оттенок в Material 3
      iconTheme: IconThemeData(color: textPrimary),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),

    // --- Стили кнопок ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    ),

    // --- Стили полей ввода ---
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: borderGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: borderGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: primaryDark, width: 2.0),
      ),
      labelStyle: TextStyle(
        color: textSecondary,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
      ),
    ),

    // --- Стили карточек ---
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: cardBorderGrey),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),

    // --- Стили текста ---
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Inter',
        color: textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        color: textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        color: Color(0xFF374151),
        fontSize: 16,
        height: 1.5,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        color: textSecondary,
        fontSize: 14,
        letterSpacing: 0.1,
      ),
    ).apply(bodyColor: const Color(0xFF374151), displayColor: textPrimary),

    // --- Стили для Chip (фильтры) ---
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: borderGrey),
      ),
      showCheckmark: false,
      backgroundColor: Colors.white,
      selectedColor: primaryDark,
      labelStyle: const TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    ),

    // --- Стили для TextButton ---
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
