import 'package:flutter/material.dart';

enum AppTheme {
  light,
  dark,
  highContrastDark,
  yellowOnDarkBlue,
}

class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.light;

  AppTheme get currentTheme => _currentTheme;

  ThemeData get themeData {
    switch (_currentTheme) {

      // ---------------- HIGH CONTRAST DARK ----------------
      case AppTheme.highContrastDark:
        return ThemeData(
          brightness: Brightness.dark,

          // ⚠️ NO PURE BLACK
          scaffoldBackgroundColor: const Color(0xFF2C2C2C),

          colorScheme: const ColorScheme.dark(
            background: Color(0xFF2C2C2C),
            surface: Color(0xFF3A3A3A),
            primary: Colors.white,
            secondary: Colors.yellow,
            onBackground: Colors.white,
            onSurface: Colors.white,
          ),

          textTheme: _largeTextTheme(Colors.white),

          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF3A3A3A),
            foregroundColor: Colors.white,
          ),

          elevatedButtonTheme: _largeButtonTheme(
            background: Colors.white,
            foreground: Colors.black,
          ),
        );

      // ---------------- YELLOW ON DARK BLUE (RECOMMENDED) ----------------
      case AppTheme.yellowOnDarkBlue:
        return ThemeData(
          brightness: Brightness.dark,

          // ✅ NOT BLACK — Braille dots remain visible
          scaffoldBackgroundColor: const Color(0xFF1E3A5F),

          colorScheme: const ColorScheme.dark(
            background: Color(0xFF1E3A5F),
            surface: Color(0xFF27496D),
            primary: Colors.yellow,
            secondary: Colors.amber,
            onBackground: Colors.yellow,
            onSurface: Colors.yellow,
            onPrimary: Color(0xFF1E3A5F),
            onSecondary: Color(0xFF1E3A5F),
          ),

          textTheme: _largeTextTheme(Colors.yellow),

          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF27496D),
            foregroundColor: Colors.yellow,
            titleTextStyle: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          listTileTheme: const ListTileThemeData(
            textColor: Colors.yellow,
            iconColor: Colors.yellow,
          ),

          elevatedButtonTheme: _largeButtonTheme(
            background: Colors.yellow,
            foreground: Color(0xFF1E3A5F),
          ),
        );

      // ---------------- BASIC DARK ----------------
      case AppTheme.dark:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF303030),
          textTheme: _largeTextTheme(Colors.white),
        );

      // ---------------- LIGHT ----------------
      case AppTheme.light:
      default:
        return ThemeData.light().copyWith(
          textTheme: _largeTextTheme(Colors.black),
          elevatedButtonTheme: _largeButtonTheme(
            background: Colors.blue,
            foreground: Colors.white,
          ),
        );
    }
  }

  // ---------------- BIG TEXT THEME ----------------
  TextTheme _largeTextTheme(Color color) {
    return TextTheme(
      bodyLarge: TextStyle(color: color, fontSize: 24),
      bodyMedium: TextStyle(color: color, fontSize: 20),
      bodySmall: TextStyle(color: color, fontSize: 18),
      titleLarge: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(color: color, fontSize: 22),
    );
  }

  // ---------------- BIG BUTTONS ----------------
  ElevatedButtonThemeData _largeButtonTheme({
    required Color background,
    required Color foreground,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        minimumSize: const Size(double.infinity, 60),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
