import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/di/controller_dependency_injection.dart';
import 'package:williamharri/src/core/di/external_service_di.dart';
import 'package:williamharri/src/core/di/interface_dependency_injection.dart';
import 'package:williamharri/src/core/routing/route_names.dart';
import 'package:williamharri/src/module/auth/ui/view/login_view.dart';
import 'package:williamharri/src/module/auth/ui/view/sign_up_view.dart';
import 'package:williamharri/src/module/nabber_screen.dart';
import 'app/splash_view.dart';
import 'src/core/themes/themes.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initControllers();
  externalServiceDI();
  initInterfaces();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
            return MaterialPageRoute(builder: (_) => SplashView());
          case RouteNames.login:
            return MaterialPageRoute(builder: (_) => LoginView());
          case RouteNames.signup:
            return MaterialPageRoute(builder: (_) => SignUpView());
          case RouteNames.appground:
            return MaterialPageRoute(builder: (_) => const AppGround());
          // case RouteNames.terms:
          //   return MaterialPageRoute(
          //       builder: (_) => const TermsConditionView());
          // case RouteNames.forgotPassword:
          //   return MaterialPageRoute(
          //       builder: (_) => const ForgotPasswordView());
          // case RouteNames.resetPassword:
          //   return MaterialPageRoute(builder: (_) => const ResetPasswordView());

          //return MaterialPageRoute(builder: (_) => const HomeView());
          default:
            return null;
        }
      },
      home: const SplashView(),
    );
  }
}
