class ResatePasswordModel {
  final String email;
  final String password;
  final String otp;

  ResatePasswordModel({
    required this.email,
    required this.password,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'otp': otp
  };
}