import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../extensions/textstyle_ext.dart';

class AppButtonStyles {
  static ButtonStyle get filledButtonStyle {
    return ButtonStyle(
      animationDuration: Duration(milliseconds: 300),
        backgroundColor: WidgetStateColor.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.light().softGrey;
            }
            return AppColors.light().primaryColor;
          },
        ),
        elevation: WidgetStateProperty.resolveWith<double>(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                return 8.0; // or any other value you want
              }
              return 0.0; // or any other value you want
            },
          ),
        textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white).w500.regular),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: Colors.transparent), borderRadius: AppSizes.rectangleButtonRadius))
      );
  }

  static ButtonStyle get filledRoundedButtonStyle {
    return filledButtonStyle.copyWith(
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: Colors.transparent), borderRadius: AppSizes.maxCircularRadius))
    );
  }

  static ButtonStyle get onlyBorderButtonStyle {
    return ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white).w500.regular),
        foregroundColor: WidgetStatePropertyAll(AppColors.light().primaryColor),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: AppColors.light().primaryColor, width: 1), borderRadius: AppSizes.rectangleButtonRadius))
      );
  }
}