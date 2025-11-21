import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ElevatedButtonThemes {
  static ElevatedButtonThemeData light = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: AppColors.light().primaryColor,
      backgroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16),
    ),
  );

  static ElevatedButtonThemeData dark = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: AppColors.dark().primaryColor,
      backgroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16),
    ),
  );
}