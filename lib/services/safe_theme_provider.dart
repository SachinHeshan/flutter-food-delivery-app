import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A safe theme provider that works without SharedPreferences
/// Falls back to in-memory storage if SharedPreferences fails
class SafeThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  static const bool _debugMode = false; // Set to true for development debugging

  bool _isDarkMode = false;
  bool _isInitialized = false;
  SharedPreferences? _prefs;
  bool _prefsAvailable = false;

  bool get isDarkMode => _isDarkMode;
  bool get isInitialized => _isInitialized;
  bool get prefsAvailable => _prefsAvailable;

  SafeThemeProvider() {
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    // Try to load from SharedPreferences, but don't fail if it's not available
    try {
      _prefs = await SharedPreferences.getInstance();
      _isDarkMode = _prefs?.getBool(_themeKey) ?? false;
      _prefsAvailable = true;
    } catch (e) {
      // SharedPreferences not available - use default theme
      _isDarkMode = false;
      _prefs = null;
      _prefsAvailable = false;

      // Debug logging only in development
      if (_debugMode) {
        assert(() {
          debugPrint(
            'SafeThemeProvider: SharedPreferences not available, using default theme',
          );
          return true;
        }());
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;

    // Try to save to SharedPreferences if available
    if (_prefs != null && _prefsAvailable) {
      try {
        await _prefs!.setBool(_themeKey, _isDarkMode);
      } catch (e) {
        // Mark as unavailable if save fails
        _prefsAvailable = false;

        // Debug logging only in development
        if (_debugMode) {
          assert(() {
            debugPrint('SafeThemeProvider: Could not save theme preference');
            return true;
          }());
        }
      }
    }

    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
    primarySwatch: Colors.orange,
    fontFamily: 'Poppins',
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF6F7FB),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
    ),
    cardColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black87),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    primarySwatch: Colors.orange,
    fontFamily: 'Poppins',
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: const Color(0xFF1E1E1E),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
    ),
  );
}
