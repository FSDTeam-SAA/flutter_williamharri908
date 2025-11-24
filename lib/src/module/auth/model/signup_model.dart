import 'package:williamharri/src/module/auth/model/login_request_params.dart';

class SignupRequestParam {
  final String? fullName;
  final String? email;
  final String? number;
  final String address;
  final String? password;
  final String? confirmPassword;

  SignupRequestParam({
    required this.fullName,
    required this.email,
    required this.number,
    required this.address,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'number': number,
        'address': address,
        'password': password,
        'confirmPassword': confirmPassword,
      };
}


class SignupResponse {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final String role;
  final User user;

  SignupResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.user,
  });

  factory SignupResponse.fromMap(Map<String, dynamic> map) {
    final data = map['data'] ?? {};
    return SignupResponse(
      userId: data['id'] ?? data['_id'] ?? '',
      accessToken: data['accessToken'] ?? '',
      refreshToken: data['refreshToken'] ?? '',
      role: data['role'] ?? '',
      user: User.fromMap(data),
    );
  }
}
