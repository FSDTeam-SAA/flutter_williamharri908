class LoginRequestParams {
  final String email;
  final String password;

  LoginRequestParams({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class LoginResponse {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final String role;
  final User user;

  LoginResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.user,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    final data = map['data'] ?? {};
    final userMap = data['user'] ?? {};

    return LoginResponse(
      userId: data['_id'] ?? '',
      accessToken: data['accessToken'] ?? '',
      refreshToken: data['refreshToken'] ?? '',
      role: data['role'] ?? '',
      user: User.fromMap(userMap),
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String username;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      role: map['role'] ?? '',
    );
  }
}
