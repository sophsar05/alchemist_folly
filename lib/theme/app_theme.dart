import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFDB8D),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'JMH Cthulhumbus Arcade',
        fontSize: 32,
        height: 0.9,
        letterSpacing: -1.5,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Pixel Game',
        fontSize: 24,
        height: 0.9,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Pixel Game',
        fontSize: 18,
        height: 1.0,
        color: Colors.black,
      ),
    ),
  );
}
