import 'package:bird_migration_ai/routeWidget.dart';
import 'package:bird_migration_ai/splashScreen.dart';
import 'package:bird_migration_ai/constants/app_colors.dart';
import 'package:bird_migration_ai/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  static Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = themeMode.value == ThemeMode.dark;
    themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;
    await prefs.setBool('isDarkMode', !isDark);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.loadTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
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
            scaffoldBackgroundColor: AppColors.backgroundPrimary,
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
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: AppColors.backgroundSecondary,
              selectedItemColor: AppColors.sageGreen,
              unselectedItemColor: AppColors.textLightSecondary,
              type: BottomNavigationBarType.fixed,
              elevation: 8,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.darkBackgroundPrimary,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            fontFamily: 'Courier',
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.darkBackgroundSecondary,
              foregroundColor: AppColors.darkTextPrimary,
              elevation: 2,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: AppColors.darkTextPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                fontFamily: 'Courier',
              ),
            ),
            scaffoldBackgroundColor: AppColors.darkBackgroundPrimary,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sageGreen,
                foregroundColor: AppColors.darkTextLight,
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
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.darkCardBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.darkTextSecondary),
              ),
              labelStyle: const TextStyle(
                color: AppColors.darkTextPrimary,
                fontFamily: 'Courier',
              ),
              hintStyle: const TextStyle(
                color: AppColors.darkTextSecondary,
                fontFamily: 'Courier',
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: AppColors.darkBackgroundSecondary,
              selectedItemColor: AppColors.sageGreen,
              unselectedItemColor: AppColors.darkTextLightSecondary,
              type: BottomNavigationBarType.fixed,
              elevation: 8,
            ),
          ),
          themeMode: mode,
          home: const SplashScreen(),
        );
      },
    );
  }
}