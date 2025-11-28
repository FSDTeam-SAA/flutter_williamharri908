class ProfileModel {

  String? id;
  String? name;
  String? username;
  String? email;
  String? phone;
  String? address;
  String? role;
  dynamic location;
  String? nationality;
  String? avatarUrl;
  String? status;
  bool? isDeleted;
  String? uniqueId;
  String? refreshToken;
  String? passwordResetToken;
  VerificationInfo? verificationInfo;
  String? createdAt;
  String? updatedAt;

  ProfileModel({
    this.id,
    this.username,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.role,
    this.location,
    this.nationality,
    this.avatarUrl,
    this.status,
    this.isDeleted,
    this.uniqueId,
    this.refreshToken,
    this.passwordResetToken,
    this.verificationInfo,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      role: json['role'],
      location: json['location'],
      nationality: json['nationality'],
      avatarUrl: json['avatarUrl'],
      status: json['status'],
      isDeleted: json['isDeleted'],
      uniqueId: json['uniqueId'],
      refreshToken: json['refreshToken'],
      passwordResetToken: json['password_reset_token'],
      verificationInfo: json['verificationInfo'] != null
          ? VerificationInfo.fromJson(json['verificationInfo'])
          : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "role": role,
        "location": location,
        "nationality": nationality,
        "avatarUrl": avatarUrl,
        "status": status,
        "isDeleted": isDeleted,
        "uniqueId": uniqueId,
        "refreshToken": refreshToken,
        "password_reset_token": passwordResetToken,
        "verificationInfo": verificationInfo?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  static ProfileModel fromMap(Map<String, dynamic> map) => ProfileModel.fromJson(map);
}




class VerificationInfo {
  bool? verified;
  String? token;

  VerificationInfo({this.verified, this.token});

  factory VerificationInfo.fromJson(Map<String, dynamic> json) {
    return VerificationInfo(
      verified: json['verified'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "token": token,
      };
}

