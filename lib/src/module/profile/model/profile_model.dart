// class ProfileModel {
//   String? id;
//   String? username;
//   String? email;
//   String? phone;
//   String? address;
//   String? role;
//   String? location;
//   String? nationality;
//   String? avatarUrl;
//   String? status;
//   String? isDeleted;
//   String? name;

//   ProfileModel({
//     this.id,
//     this.username,
//     this.email,
//     this.phone,
//     this.address,
//     this.role,
//     this.location,
//     this.nationality,
//     this.avatarUrl,
//     this.status,
//     this.isDeleted,
//     this.name,
//   });

//   ProfileModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     username = json['username'];
//     email = json['email'];
//     phone = json['phone'];
//     address = json['address'];
//     role = json['role'];
//     location = json['location'];
//     nationality = json['nationality'];
//     avatarUrl = json['avatarUrl'];
//     status = json['status'];
//     isDeleted = json['isDeleted'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['username'] = username;
//     data['email'] = email;
//     data['phone'] = phone;
//     data['address'] = address;
//     data['role'] = role;
//     data['location'] = location;
//     data['nationality'] = nationality;
//     data['avatarUrl'] = avatarUrl;
//     data['status'] = status;
//     data['isDeleted'] = isDeleted;
//     data['name'] = name;
//     return data;
//   }
//   // fromMap
//   static ProfileModel fromMap(Map<String, dynamic> map) {
//     return ProfileModel(
//       id: map['id'],
//       username: map['username'],
//       email: map['email'],
//       phone: map['phone'],
//       address: map['address'],
//       role: map['role'],
//       location: map['location'],
//       nationality: map['nationality'],
//       avatarUrl: map['avatarUrl'],
//       status: map['status'],
//       isDeleted: map['isDeleted'],
//       name: map['name'],
//     );
//   }
// }


class ProfileModel {
  String? id;
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

