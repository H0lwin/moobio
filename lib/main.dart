
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myapp/navigation/router.dart';

// Constants for the FitCore color palette
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

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark mode as per spec

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
    void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using Manrope as a close alternative to SF Pro / Google Sans
    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.manrope(fontSize: 36, fontWeight: FontWeight.w700, color: FitCoreColors.textPrimary),
      headlineMedium: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w600, color: FitCoreColors.textPrimary),
      headlineSmall: GoogleFonts.manrope(fontSize: 17, fontWeight: FontWeight.w600, color: FitCoreColors.textPrimary),
      bodyLarge: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w400, color: FitCoreColors.textPrimary),
      bodyMedium: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w400, color: FitCoreColors.textSecondary),
    ).apply(
      bodyColor: FitCoreColors.textPrimary,
      displayColor: FitCoreColors.textPrimary,
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: FitCoreColors.background,
      primaryColor: FitCoreColors.accentViolet,
      textTheme: appTextTheme,
      colorScheme: const ColorScheme.dark(
        primary: FitCoreColors.accentViolet,
        secondary: FitCoreColors.accentCoral,
        background: FitCoreColors.background,
        surface: FitCoreColors.surface,
        error: FitCoreColors.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: FitCoreColors.textPrimary,
        onSurface: FitCoreColors.textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: FitCoreColors.surface,
        elevation: 0,
        titleTextStyle: appTextTheme.headlineMedium,
        centerTitle: true,
        iconTheme: const IconThemeData(color: FitCoreColors.accentViolet),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FitCoreColors.accentCoral,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: FitCoreColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: FitCoreColors.borderSubtle, width: 1),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: FitCoreColors.surface,
        selectedItemColor: FitCoreColors.accentViolet,
        unselectedItemColor: FitCoreColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );

    // A basic light theme for completeness
    final ThemeData lightTheme = ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: FitCoreColors.accentViolet,
        textTheme: appTextTheme.apply(
            bodyColor: Colors.black87, displayColor: Colors.black87),
        colorScheme: ColorScheme.fromSeed(seedColor: FitCoreColors.accentViolet)
    );


    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          routerConfig: router,
          title: 'FitCore',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('fa', ''), // Persian, no country code
          ],
          locale: const Locale('fa', ''), // Force Persian for demonstration
        );
      },
    );
  }
}
