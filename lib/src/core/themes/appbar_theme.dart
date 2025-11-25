part of 'themes.dart';

class DAppBarTheme {
  DAppBarTheme._(); // Private constructor

  // Light AppBarTheme
  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.light().primaryColor,

    //foregroundColor: AppColors.light().primaryColor,
    surfaceTintColor:
        AppColors.light().backgroundColor, //AppColors.light().backgroundColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: AppColors.light().primaryColor,
      statusBarIconBrightness: Brightness.light,
    ),
    //elevation: 0,
    //titleSpacing: 0,
    iconTheme: IconThemeData(color: AppColors.light().iconColor),
    actionsIconTheme: IconThemeData(color: AppColors.light().iconColor),
    toolbarTextStyle: TextStyle(color: AppColors.light().textColor),
    titleTextStyle: TextStyle(color: AppColors.light().textColor).w600.h6,
    centerTitle: true,
  );

  // Dark AppBarTheme
  static AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.dark().tileColor,
    surfaceTintColor: AppColors.dark().dividerColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: AppColors.light().primaryColor,
      statusBarIconBrightness: Brightness.light,
    ),
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.dark().iconColor),
    actionsIconTheme: IconThemeData(color: AppColors.dark().iconColor),
    toolbarTextStyle: TextStyle(color: AppColors.dark().textColor),
    titleTextStyle: TextStyle(color: AppColors.dark().textColor).w600.h6,
    centerTitle: true,
    // bottom: PreferredSize(
    //   preferredSize: Size.fromHeight(kToolbarHeight),
    //   child: Container(),
    // ),
  );

  static AppBarTheme getAppBarTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightAppBarTheme : darkAppBarTheme;
  }
}
