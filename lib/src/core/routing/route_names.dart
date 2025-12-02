class RouteNames {
  //static const home = '/';
  static const splash = '/';
  static const login = '/login';
  // static const signup = '/signup';
  static const forgotPassword = '/forgot_password';
  static const resetPassword = '/reset_password';
  static const appground = '/AppGround';
  static const profile = '/profile';
  static const terms = '/terms';
}



/* 


class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String dashboardScreen = '/dashboardScreen';
  static const String home = '/home';
  static const String selectLoginOption = '/select-login-option';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String collectInformation = '/collect-information';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerify = '/otp-verify';
  static const String resetPassword = '/reset-password';
  static const String welcomeScreen = '/welcome-screen';
  static const String dashboard = '/dashboard';
  static const String notification = '/notification';
  static const String selectOrigin = '/select-origin';
  static const String selectDestination = '/select-destination';
  static const String selectDate = '/select-date';

  static getInitialRoute() => splash;
  static getSplashRoute() => splash;
  static getOnboardingRoute() => onboarding;

  static getSelectLoginOptionRoute() => selectLoginOption;
  static getSignInRoute() => signIn;
  static getSignUpRoute() => signUp;
  static getCollectInformationRoute() => collectInformation;
  static getHomeRoute() => home;
  static getForgotPassword() => forgotPassword;
  static getOTPVerify() => otpVerify;
  static getResetPassword() => resetPassword;
  static getWelcomeScreen() => welcomeScreen;
  static getDashboardRoute() => dashboard;
  static getNotificationRoute() => notification;
  static getSelectOriginRoute() => selectOrigin;
  static getSelectDestinationRoute() => selectDestination;
  static getSelectDateRoute() => selectDate;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const SplashScreenView()),
    GetPage(name: splash, page: () => const SplashScreenView()),
    GetPage(name: onboarding, page: () => const OnboardingScreenView()),
    GetPage(name: selectLoginOption, page: () => const SelectLoginOptionScreen()),
    GetPage(name: signIn, page: () => const SignInScreen()),
    GetPage(name: signUp, page: () => const SignUpScreen()),
    GetPage(name: collectInformation, page: () => const CollectUserInformationScreen()),
    GetPage(name: home, page: () => const HomeScreenView()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: otpVerify, page: () => const OTPVerifyScreen()),
    GetPage(name: resetPassword, page: () => const ResetPasswordScreen()),
    GetPage(name: welcomeScreen, page: () => const WelcomeScreen()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: notification, page: () => const NotificationScreenView()),

  ];
}
 */