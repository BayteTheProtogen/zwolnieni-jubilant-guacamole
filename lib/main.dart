import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/user_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/loading_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const CyberSprytApp(),
    ),
  );
}

class CyberSprytApp extends StatelessWidget {
  const CyberSprytApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return MaterialApp(
      title: 'CyberSpryt',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(context, userProvider),
      home: _getHome(userProvider),
    );
  }

  Widget _getHome(UserProvider userProvider) {
    if (!userProvider.isInitialFetchDone) {
      return const LoadingScreen();
    }
    if (userProvider.isFirstRun) {
      return const OnboardingScreen();
    }
    return const HomeScreen();
  }

  ThemeData _buildTheme(BuildContext context, UserProvider provider) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        primary: Colors.blue.shade800,
        secondary: Colors.orange.shade700,
        surface: provider.highContrast ? Colors.white : Colors.blue.shade50,
      ),
      textTheme: GoogleFonts.lexendTextTheme(
        Theme.of(context).textTheme,
      ).apply(
        fontSizeFactor: provider.fontSizeMultiplier,
        bodyColor: provider.highContrast ? Colors.black : Colors.blue.shade900,
        displayColor: provider.highContrast ? Colors.black : Colors.blue.shade900,
      ),
    );

    return baseTheme.copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: elevatedButtonFrom(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Helper for backward compatibility or simpler theme extension
  ButtonStyle elevatedButtonFrom({required Color backgroundColor, required Color foregroundColor, required TextStyle textStyle}) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textStyle: textStyle,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
