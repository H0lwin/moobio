import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FitCoreColors {
  static const Color background = Color(0xFF0A0A0E);
  static const Color surface = Color(0xFF13131A);
  static const Color surfaceElevated = Color(0xFF1C1C26);
  static const Color accentViolet = Color(0xFF8B6FFF);
  static const Color accentCoral = Color(0xFFFF5F3D);
  static const Color accentAmber = Color(0xFFFFB547);
  static const Color success = Color(0xFF3DDC97);
  static const Color danger = Color(0xFFFF4D6D);
  static const Color textPrimary = Color(0xFFF0F0F5);
  static const Color textSecondary = Color(0xFF72728A);
  static const Color borderSubtle = Color(0xFF22222E);
}

class FitCoreMotion {
  static const Duration screenPush = Duration(milliseconds: 280);
  static const Duration accordionExpand = Duration(milliseconds: 220);
  static const Duration setTick = Duration(milliseconds: 150);
  static const Duration badgeEarned = Duration(milliseconds: 600);
  static const Duration bottomSheetSpring = Duration(milliseconds: 300);
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode value) {
    if (_themeMode == value) {
      return;
    }
    _themeMode = value;
    notifyListeners();
  }
}

class FitCoreTheme {
  static TextTheme textTheme() {
    final base = GoogleFonts.manropeTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: FitCoreColors.textPrimary,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: FitCoreColors.textPrimary,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: FitCoreColors.textPrimary,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: FitCoreColors.textPrimary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: FitCoreColors.textPrimary,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: FitCoreColors.textSecondary,
      ),
    );
  }

  static ThemeData dark() {
    final text = textTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: FitCoreColors.background,
      colorScheme: const ColorScheme.dark(
        primary: FitCoreColors.accentViolet,
        secondary: FitCoreColors.accentCoral,
        surface: FitCoreColors.surface,
        onSurface: FitCoreColors.textPrimary,
        error: FitCoreColors.danger,
      ),
      textTheme: text,
      dividerColor: Colors.transparent,
      cardTheme: CardThemeData(
        elevation: 0,
        color: FitCoreColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: FitCoreColors.borderSubtle, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FitCoreColors.accentCoral,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: FitCoreColors.accentViolet),
          foregroundColor: FitCoreColors.accentViolet,
          minimumSize: const Size.fromHeight(46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: FitCoreColors.surfaceElevated,
        selectedColor: FitCoreColors.accentViolet.withOpacity(0.18),
        labelStyle: text.bodySmall?.copyWith(color: FitCoreColors.textPrimary),
        secondaryLabelStyle: text.bodySmall?.copyWith(
          color: FitCoreColors.accentViolet,
        ),
        side: const BorderSide(color: FitCoreColors.borderSubtle),
        shape: const StadiumBorder(),
      ),
    );
  }

  static ThemeData light() {
    final text = textTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: FitCoreColors.accentViolet),
      textTheme: text.apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
    );
  }
}
