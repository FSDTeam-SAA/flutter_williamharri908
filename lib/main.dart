import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/splash_view.dart';
import 'src/core/routing/route_names.dart';
import 'src/core/themes/themes.dart';
import 'src/module/account/ui/terms_condition_view.dart';
import 'src/module/auth/ui/view/forgot_password.dart';
import 'src/module/auth/ui/view/login_view.dart';
import 'src/module/auth/ui/view/reset_password_view.dart';
import 'src/module/auth/ui/view/sign_up_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'williamharri',
      navigatorKey: navigatorKey,
      //initialRoute: RouteHelper.getInitialRoute(),
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      themeMode: ThemeMode.dark,

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteNames.splash:
            return MaterialPageRoute(builder: (_) => const SplashView());
          case RouteNames.login:
            return MaterialPageRoute(builder: (_) => LoginView());
          case RouteNames.signup:
            return MaterialPageRoute(builder: (_) => const SignUpView());
          case RouteNames.terms:
            return MaterialPageRoute(
              builder: (_) => const TermsConditionView(),
            );
          case RouteNames.forgotPassword:
            return MaterialPageRoute(
              builder: (_) => const ForgotPasswordView(),
            );
          case RouteNames.resetPassword:
            return MaterialPageRoute(builder: (_) => const ResetPasswordView());

          //return MaterialPageRoute(builder: (_) => const HomeView());
          default:
            return null;
        }
      },
      home: const SplashView(),
    );
  }
}
