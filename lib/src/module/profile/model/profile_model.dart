class ProfileModel {
  String? id;
  String? username;
  String? email;
  String? phone;
  String? address;
  String? role;
  String? location;
  String? nationality;
  String? avatarUrl;
  String? status;
  String? isDeleted;
  String? name;

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
    this.name,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    role = json['role'];
    location = json['location'];
    nationality = json['nationality'];
    avatarUrl = json['avatarUrl'];
    status = json['status'];
    isDeleted = json['isDeleted'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['role'] = role;
    data['location'] = location;
    data['nationality'] = nationality;
    data['avatarUrl'] = avatarUrl;
    data['status'] = status;
    data['isDeleted'] = isDeleted;
    data['name'] = name;
    return data;
  }
  // fromMap
  static ProfileModel fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      role: map['role'],
      location: map['location'],
      nationality: map['nationality'],
      avatarUrl: map['avatarUrl'],
      status: map['status'],
      isDeleted: map['isDeleted'],
      name: map['name'],
    );
  }
}
