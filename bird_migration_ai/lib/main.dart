import 'package:bird_migration_ai/routeWidget.dart';
import 'package:bird_migration_ai/splashScreen.dart';
import 'package:bird_migration_ai/constants/app_colors.dart';
import 'package:bird_migration_ai/constants/app_strings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBeige,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Courier',
        
        // App Bar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundSecondary,
          foregroundColor: AppColors.textPrimary,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            fontFamily: 'Courier',
          ),
        ),
        
        // Scaffold Theme
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        
        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.sageGreen,
            foregroundColor: AppColors.textLight,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Courier',
            ),
          ),
        ),
        
        // Text Field Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.textSecondary),
          ),
          labelStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Courier',
          ),
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontFamily: 'Courier',
          ),
        ),
        
        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundSecondary,
          selectedItemColor: AppColors.sageGreen,
          unselectedItemColor: AppColors.textLightSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}