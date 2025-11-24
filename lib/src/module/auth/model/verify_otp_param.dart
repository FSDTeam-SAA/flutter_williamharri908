class VerifyOtpParam {
  final String email;
  final String otp;

  VerifyOtpParam({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}