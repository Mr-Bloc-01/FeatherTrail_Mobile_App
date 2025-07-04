import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBeige = Color(0xFFe6e6dd);
  static const Color secondaryBeige = Color(0xFFd4d4c8);
  
  // Accent Colors
  static const Color sageGreen = Color(0xFF629584);
  static const Color darkGreen = Color(0xFF387478);
  static const Color lightGreen = Color(0xFF9ec1b8);
  
  // Text Colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color textLight = Colors.white;
  static const Color textLightSecondary = Colors.white70;
  
  // Background Colors
  static const Color backgroundPrimary = Color(0xFFe6e6dd);
  static const Color backgroundSecondary = Color(0xFFd4d4c8);
  static const Color cardBackground = Colors.white;
  
  // Shadow Colors
  static const Color shadowLight = Color(0x0D000000); // 5% opacity
  static const Color shadowMedium = Color(0x1A000000); // 10% opacity
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF629584),
    Color(0xFF387478),
  ];
  
  static const List<Color> backgroundGradient = [
    Color(0xFFe6e6dd),
    Color(0xFFd4d4c8),
    Color(0x1A629584), // 10% opacity
  ];

  // DARK MODE COLORS
  static const Color darkBackgroundPrimary = Color(0xFF23272A);
  static const Color darkBackgroundSecondary = Color(0xFF2C2F33);
  static const Color darkCardBackground = Color(0xFF36393F);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFB9BBBE);
  static const Color darkTextLight = Colors.white;
  static const Color darkTextLightSecondary = Color(0xFFB9BBBE);
  static const List<Color> darkBackgroundGradient = [
    Color(0xFF23272A),
    Color(0xFF2C2F33),
    Color(0xFF387478),
  ];
} 