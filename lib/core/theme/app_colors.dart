import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color accent = Color(0xFFFF6D00);

  // Figma design — purple/lavender palette
  static const Color publishBar = Color(0xFFE8D5FF);
  static const Color publishBarDark = Color(0xFF3D2060);
  static const Color fabPurple = Color(0xFF9B59B6);
  static const Color attachButton = Color(0xFFCFB8F0);

  // Backgrounds
  static const Color bgLight = Color(0xFFF8F9FA);
  static const Color bgDark = Color(0xFF0F1117);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1C1E26);
  static const Color cardDark = Color(0xFF252730);

  // Text
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFF1F3F5);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // Category chip colors
  static const Color chipGeneral = Color(0xFF6C757D);
  static const Color chipTechnology = Color(0xFF0078D4);
  static const Color chipSports = Color(0xFF28A745);
  static const Color chipBusiness = Color(0xFFFF8C00);
  static const Color chipEntertainment = Color(0xFF9B59B6);
  static const Color chipHealth = Color(0xFFE74C3C);
  static const Color chipScience = Color(0xFF00B4D8);

  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'technology': return chipTechnology;
      case 'sports': return chipSports;
      case 'business': return chipBusiness;
      case 'entertainment': return chipEntertainment;
      case 'health': return chipHealth;
      case 'science': return chipScience;
      default: return chipGeneral;
    }
  }
}
