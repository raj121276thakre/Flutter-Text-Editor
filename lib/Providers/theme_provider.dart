import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = _defaultTheme;

  // Default custom theme with color 0xFFC80F4F
  static final ThemeData _defaultTheme = ThemeData(
    primaryColor: const Color(0xFFC80F4F),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: MaterialColor(
        0xFFC80F4F,
        {
          50: const Color(0xFFFFE6EB),
          100: const Color(0xFFFFB3C2),
          200: const Color(0xFFFF8098),
          300: const Color(0xFFFF4D6E),
          400: const Color(0xFFFF264E),
          500: const Color(0xFFC80F4F),
          600: const Color(0xFF9F0C3E),
          700: const Color(0xFF76082E),
          800: const Color(0xFF4E051E),
          900: const Color(0xFF26030F),
        },
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFC80F4F),
      foregroundColor: Colors.white,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFFC80F4F),
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // Other themes
  static final ThemeData _lightTheme = ThemeData.light();
  static final ThemeData _darkTheme = ThemeData.dark();
  static final ThemeData _blueTheme = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.light(primary: Colors.blue),
  );
  static final ThemeData _greenTheme = ThemeData.light().copyWith(
    primaryColor: Colors.green,
    colorScheme: ColorScheme.light(primary: Colors.green),
  );
  static final ThemeData _yellowTheme = ThemeData.light().copyWith(
    primaryColor: Colors.yellow,
    colorScheme: ColorScheme.light(primary: Colors.yellow),
  );
  static final ThemeData _orangeTheme = ThemeData.light().copyWith(
    primaryColor: Colors.orange,
    colorScheme: ColorScheme.light(primary: Colors.orange),
  );
  static final ThemeData _pinkTheme = ThemeData.light().copyWith(
    primaryColor: Colors.pink,
    colorScheme: ColorScheme.light(primary: Colors.pink),
  );

  // Public getters for themes
  ThemeData get defaultTheme => _defaultTheme;
  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;
  ThemeData get blueTheme => _blueTheme;
  ThemeData get greenTheme => _greenTheme;
  ThemeData get yellowTheme => _yellowTheme;
  ThemeData get orangeTheme => _orangeTheme;
  ThemeData get pinkTheme => _pinkTheme;

  ThemeData get currentTheme => _currentTheme;

  // Toggle the theme between Light and Dark modes (you can add more themes)
  void setTheme(ThemeData theme) async {
    _currentTheme = theme;
    await _saveThemeToPrefs(theme);
    notifyListeners();
  }

  bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

  // Save the selected theme to SharedPreferences
  Future<void> _saveThemeToPrefs(ThemeData theme) async {
    final prefs = await SharedPreferences.getInstance();
    String themeString = "default";

    if (theme == _lightTheme) {
      themeString = "light";
    } else if (theme == _darkTheme) {
      themeString = "dark";
    } else if (theme == _blueTheme) {
      themeString = "blue";
    } else if (theme == _greenTheme) {
      themeString = "green";
    } else if (theme == _yellowTheme) {
      themeString = "yellow";
    } else if (theme == _orangeTheme) {
      themeString = "orange";
    } else if (theme == _pinkTheme) {
      themeString = "pink";
    }

    await prefs.setString('selected_theme', themeString);
  }

  // Load the theme from SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String themeString = prefs.getString('selected_theme') ?? "default";

    switch (themeString) {
      case "light":
        _currentTheme = _lightTheme;
        break;
      case "dark":
        _currentTheme = _darkTheme;
        break;
      case "blue":
        _currentTheme = _blueTheme;
        break;
      case "green":
        _currentTheme = _greenTheme;
        break;
      case "yellow":
        _currentTheme = _yellowTheme;
        break;
      case "orange":
        _currentTheme = _orangeTheme;
        break;
      case "pink":
        _currentTheme = _pinkTheme;
        break;
      default:
        _currentTheme = _defaultTheme;
    }

    notifyListeners();
  }

  // Call this function in your main widget to load the theme on startup
  Future<void> init() async {
    await _loadThemeFromPrefs();
  }
}
