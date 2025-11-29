import 'dart:io';

import 'package:dio/dio.dart';

class UpdateProfileReqParam {
  final String? name;
  final String? phone;
  final String? address;
  final String? nationality;
  final File? avatar;

  UpdateProfileReqParam({
    this.name,
    this.phone,
    this.address,
    this.nationality,
    this.avatar,
  });

  Map<String, dynamic> toUpdateProfileDetailsData() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'nationality': nationality,
    };
  }

  Future<FormData> toUpdateAvatarData() async {
    final formData = FormData();
    if (avatar != null) {
      formData.files.add(
        MapEntry(
          'avatar',
          await MultipartFile.fromFile(
            avatar!.path,
            filename: avatar!.path.split('/').last,
          ),
        ),
      );
    }
    return formData;
  }
}
