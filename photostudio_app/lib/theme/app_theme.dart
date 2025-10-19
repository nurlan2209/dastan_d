import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _primary = Color(0xFF0D47A1);
  static const Color _secondary = Color(0xFFFFAB00);
  static const Color _lightGrey = Color(0xFFF5F5F5);
  static const Color _darkGrey = Color(0xFF303030);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: _primary,
    scaffoldBackgroundColor: _lightGrey,
    colorScheme: const ColorScheme.light(
      primary: _primary,
      onPrimary: Colors.white,
      secondary: _secondary,
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white,
      // 1. ИСПРАВЛЕНЫ УСТАРЕВШИЕ НАЗВАНИЯ
      surface: Colors.white,
      onSurface: _darkGrey,
    ),
    textTheme: GoogleFonts.nunitoSansTextTheme(
      ThemeData.light().textTheme.apply(
        bodyColor: _darkGrey,
        displayColor: _darkGrey,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: _darkGrey,
      elevation: 1,
      titleTextStyle: GoogleFonts.nunitoSans(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _darkGrey,
      ),
      iconTheme: const IconThemeData(color: _darkGrey),
    ),
    // 2. ИСПРАВЛЕНА ОШИБКА ТИПА: CardTheme -> CardThemeData
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primary, width: 2),
      ),
      labelStyle: GoogleFonts.nunitoSans(color: Colors.grey.shade600),
      hintStyle: GoogleFonts.nunitoSans(color: Colors.grey.shade400),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primary,
        textStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _secondary,
      foregroundColor: Colors.black,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _primary.withOpacity(0.1),
      labelStyle: GoogleFonts.nunitoSans(
        color: _primary,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
    useMaterial3: true,
  );
}
