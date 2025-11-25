 class ProfileModel {
  String? name;
  String? email;
  String? phone;
  String? address;
  String? image;
  ProfileModel({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.image,
  });

ProfileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    image = json['image'];
  }
  ProfileModel.toJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    image = json['image'];
  }

  ProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? image,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      image: image ?? this.image,
    );
  }

 }
