import 'package:flutter/material.dart';

class AppTheme {
  static final Color accent = Colors.blueAccent;

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: accent,
    scaffoldBackgroundColor: Colors.black,

    // Elevated Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Outlined Buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accent,
        side: BorderSide(color: accent),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Text Buttons
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accent,
      ),
    ),

    // App Bar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.blueAccent,
      centerTitle: true,
      elevation: 0,
    ),

    // Text
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.blueAccent),
      bodyMedium: TextStyle(color: Colors.blueAccent),
    ),

    // Input Fields
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.blueAccent),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
    ),

    // Bottom Navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey.shade900,
      selectedItemColor: accent,
      unselectedItemColor: Colors.white70,
    ),
  );
}
