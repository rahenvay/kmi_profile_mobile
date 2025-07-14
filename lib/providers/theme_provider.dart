import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  Color _accentColor = const Color(0xFF2A9D01);

  bool get isDarkMode => _isDarkMode;
  Color get accentColor => _accentColor;

  // Theme colors based on current mode
  Color get backgroundColor => _isDarkMode ? const Color(0xFF121212) : Colors.grey[50]!;
  Color get cardColor => _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  Color get textColor => _isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryTextColor => _isDarkMode ? Colors.white70 : Colors.black54;

  ThemeData get themeData {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _accentColor,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        bodySmall: TextStyle(color: secondaryTextColor),
        headlineLarge: TextStyle(color: textColor),
        headlineMedium: TextStyle(color: textColor),
        headlineSmall: TextStyle(color: textColor),
        titleLarge: TextStyle(color: textColor),
        titleMedium: TextStyle(color: textColor),
        titleSmall: TextStyle(color: textColor),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: _isDarkMode ? 8 : 2,
        shadowColor: _isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.2),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: _accentColor,
        unselectedItemColor: secondaryTextColor,
        elevation: 8,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: _accentColor,
        unselectedLabelColor: secondaryTextColor,
        indicatorColor: _accentColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _accentColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondaryTextColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _accentColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          foregroundColor: Colors.white,
          elevation: _isDarkMode ? 8 : 2,
          shadowColor: _isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.2),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _accentColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      notifyListeners();
    }
  }

  void setAccentColor(Color color) {
    if (_accentColor != color) {
      _accentColor = color;
      notifyListeners();
    }
  }

  // Helper method to get appropriate color for status
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'approved':
      case 'completed':
        return Colors.green;
      case 'pending':
      case 'in progress':
        return Colors.orange;
      case 'inactive':
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return _accentColor;
    }
  }

  // Helper method to get card decoration
  BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: _accentColor.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: _isDarkMode 
              ? Colors.black.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          spreadRadius: 0,
          blurRadius: _isDarkMode ? 15 : 8,
          offset: Offset(0, _isDarkMode ? 8 : 4),
        ),
      ],
    );
  }

  // Helper method to get modern card decoration with glass effect
  BoxDecoration get modernCardDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _isDarkMode 
            ? [cardColor, cardColor.withOpacity(0.8)]
            : [Colors.white, Colors.grey[50]!],
      ),
      border: Border.all(
        color: _accentColor.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: _isDarkMode 
              ? Colors.black.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          spreadRadius: 0,
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: _accentColor.withOpacity(0.1),
          spreadRadius: 0,
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}
