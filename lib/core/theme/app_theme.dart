import 'package:flutter/material.dart';

class AppColors {
  // iOS Light Backgrounds & Surfaces
  static const Color background = Color(0xFFF2F2F7); // iOS System Grouped Background
  static const Color surface = Color(0xFFFFFFFF); // iOS Pure White Card Surface
  static const Color surfaceElevated = Color(0xFFF8F9FA); // iOS Secondary Surface / Light Gray
  static const Color surfaceBorder = Color(0xFFE5E5EA); // iOS Hairline Separator
  static const Color navyDark = Color(0xFF1C1C1E); // iOS Deep Charcoal Label

  // iOS Signature Blue Palette
  static const Color iosBlue = Color(0xFF007AFF); // Apple System Blue
  static const Color iosBlueLight = Color(0xFFE5F1FF); // Light Blue Tint for Badges
  static const Color iosBlueDark = Color(0xFF0056B3); // Deep Apple Blue
  static const Color iosBlueSubtle = Color(0xFFF0F6FF);

  // Remapped aliases to maintain full backwards compatibility with widgets
  static const Color primaryPurple = Color(0xFF007AFF); // Remapped to iOS Blue
  static const Color primaryPurpleLight = Color(0xFF0A84FF);
  static const Color primaryPurplePastel = Color(0xFF007AFF);
  static const Color indigoAccent = Color(0xFF007AFF);
  static const Color violetAccent = Color(0xFF5856D6); // iOS Indigo

  // iOS System Accents
  static const Color neonCyan = Color(0xFF007AFF); // iOS Signature Blue
  static const Color emeraldGreen = Color(0xFF34C759); // iOS System Green
  static const Color rosePink = Color(0xFFFF3B30); // iOS System Red
  static const Color amberOrange = Color(0xFFFF9500); // iOS System Orange

  // Fund Category Colors (iOS Aesthetic)
  static const Color danaPanas = Color(0xFFFF9500); // iOS System Orange (Api/Pengeluaran aktif)
  static const Color danaDarurat = Color(0xFFFF2D55); // iOS System Pink (Jaga-jaga darurat)
  static const Color danaTabungan = Color(0xFF007AFF); // iOS System Blue (Tabungan masa depan)

  // iOS Typography Colors
  static const Color textPrimary = Color(0xFF1C1C1E); // iOS Primary Label
  static const Color textSecondary = Color(0xFF6C6C70); // iOS Secondary Label
  static const Color textMuted = Color(0xFF8E8E93); // iOS Tertiary/Quaternary Label

  // iOS Premium Gradients
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A84FF), // iOS Vibrant Blue
      Color(0xFF007AFF), // iOS Signature Blue
      Color(0xFF0056C6), // iOS Deep Royal Blue
    ],
  );

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF0A84FF),
      Color(0xFF007AFF),
    ],
  );

  static const LinearGradient expenseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF453A),
      Color(0xFFFF3B30),
    ],
  );

  static const LinearGradient incomeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF32D74B),
      Color(0xFF34C759),
    ],
  );
}

class AppTheme {
  static const String _fontFamily = 'SF Pro Display';
  static const List<String> _fontFamilyFallback = [
    'SF Pro Text',
    'SF Pro',
    '.SF Pro Text',
    '-apple-system',
    'BlinkMacSystemFont',
    'system-ui',
    'sans-serif',
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: _fontFamily,
      fontFamilyFallback: _fontFamilyFallback,
      colorScheme: const ColorScheme.light(
        primary: AppColors.iosBlue,
        secondary: AppColors.emeraldGreen,
        surface: AppColors.surface,
        error: AppColors.rosePink,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFamilyFallback,
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.4,
        ),
        iconTheme: IconThemeData(color: AppColors.iosBlue),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.surfaceBorder, width: 0.8),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.iosBlue,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.surfaceBorder, width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.surfaceBorder, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.iosBlue, width: 1.6),
        ),
        labelStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFamilyFallback,
          color: AppColors.textSecondary,
        ),
        hintStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFamilyFallback,
          color: AppColors.textMuted,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.iosBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontFamilyFallback: _fontFamilyFallback,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }

  // Fallback alias so existing references to darkTheme automatically get the iOS light theme
  static ThemeData get darkTheme => lightTheme;
}
