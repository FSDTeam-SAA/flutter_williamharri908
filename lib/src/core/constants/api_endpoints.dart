import 'package:flutter/foundation.dart';

base class ApiEndpoints {
  static const String socketUrl = _LocalHostWifi.socketUrl;

  static const String baseUrl = _LocalHostWifi.baseUrl;
  
  // ---------------------- AUTH -----------------------------
  static const String login = _Auth.login;
  static const String signup = _Auth.signup;
  static const String emailverify = _Auth.emailverify;
  static const String verifyCode = _Auth.verifyCode;
  static const String forgetPassword = _Auth.forgetPassword;
  static const String changePassword = _Auth.changePassword;
  static const String createNewPassword = _Auth.resetPassword;
  static const String refreshToken = _Auth.refreshToken;

  // ---------------------- USER -----------------------------
  /// ### get

  // ---------------------- Message -----------------------------

}

class _RemoteServer {
  static const String socketUrl =
      '';

  static const String baseUrl =
      '';
}

class _LocalHostWifi {
  static const String socketUrl = 'http://10.10.5.46:8001';

  static const String baseUrl = 'http://10.10.5.46:8001/api';
}


class _Auth {
  @protected
  static const String _authRoute = '${ApiEndpoints.baseUrl}/auth';
  static const String login = '$_authRoute/login';
  static const String signup = '$_authRoute/register';
  static const String forgetPassword = '$_authRoute/forgot-password';
  static const String refreshToken = '$_authRoute/refresh-token';
  static const String emailverify = '$_authRoute/verify-email';
  static const String verifyCode = '$_authRoute/verify-reset-otp';
  //static const String registerVerify = '$_authRoute/verify-otp';
  static const String changePassword = '$_authRoute/change-password';
  static const String resetPassword = '$_authRoute/reset-password';
}



// ---------------------- Notification -----------------------------
class _Notification {
  static const String _notificationRoute =
      '${ApiEndpoints.baseUrl}/notification';
}

class _User {
  static const String _userRoute = '${ApiEndpoints.baseUrl}/user';
}

// ---------------------- MESSAGE -----------------------------
class _Message {
  static const String _messageRoute = '${ApiEndpoints.baseUrl}/message';
}

