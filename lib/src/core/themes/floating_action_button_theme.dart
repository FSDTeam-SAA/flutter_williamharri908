import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class FloatingActionButtonThemes {
  static FloatingActionButtonThemeData lightTheme = FloatingActionButtonThemeData(
    backgroundColor: AppColors.light().primaryColor,
    shape: CircleBorder(),
    elevation: 6.0,
    iconSize: AppSizes.extraLargeIconSize,
  );

  static FloatingActionButtonThemeData darkTheme = FloatingActionButtonThemeData(
    backgroundColor: AppColors.dark().tileColor,
    shape: CircleBorder(),
    elevation: 6.0,
    iconSize: AppSizes.largeIconSize
  );
}