part of 'themes.dart';

class DInputDecorationTheme {
  DInputDecorationTheme._(); // Private constructor

  // Light InputDecorationTheme
  static InputDecorationTheme lightTheme = InputDecorationTheme(
    prefixIconConstraints: BoxConstraints(
      minWidth: 16,
      minHeight: 16,
      // maxHeight: 16,
      // maxWidth: 16,
    ),
    // suffixIconConstraints: BoxConstraints(
    //   minWidth: 55,
    //   minHeight: 55,
    // ),
    //filled: true,
    //contentPadding: const EdgeInsets.only(left: 4, right: 4),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    fillColor: Colors.transparent,
    focusColor: AppColors.light().textColor,
    hoverColor: AppColors.light().textColor,
    hintStyle: TextStyle(color: AppColors.light().hintColor),
    labelStyle: TextStyle(color: AppColors.light().labelColor),
    outlineBorder: BorderSide(color: AppColors.light().textColor),
    border: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.light().enabledBorderColor,
        ),
        borderRadius: AppSizes.textFieldBorderRadius),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.light().enabledBorderColor,
        ),
        borderRadius: AppSizes.textFieldBorderRadius),
    focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: AppColors.light().focusedBorderColor, width: 2),
        borderRadius: AppSizes.textFieldBorderRadius),
  );

  // Dark InputDecorationTheme
  static InputDecorationTheme darkTheme = InputDecorationTheme(
    //filled: true,
    //contentPadding: const EdgeInsets.only(left: 4, right: 4),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    fillColor: Colors.transparent,
    focusColor: AppColors.dark().textColor,
    hoverColor: AppColors.dark().textColor,
    hintStyle: TextStyle(color: AppColors.dark().hintColor),
    labelStyle: TextStyle(color: AppColors.dark().labelColor),
    outlineBorder: BorderSide(color: AppColors.dark().textColor),
    border: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.dark().enabledBorderColor,
        ),
        borderRadius: AppSizes.textFieldBorderRadius),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.dark().enabledBorderColor,
        ),
        borderRadius: AppSizes.textFieldBorderRadius),
    focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: AppColors.dark().focusedBorderColor, width: 2),
        borderRadius: AppSizes.textFieldBorderRadius),
  );
}
