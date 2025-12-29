import 'dart:io';

import 'package:dio/dio.dart';

class UpdateStaffScafoldParam {
  final String jobId;
  final String? description;
  final List<File> photos;
  final File? signature;

  UpdateStaffScafoldParam({
    required this.jobId,
    required this.description,
    required this.photos,
    required this.signature,
  });

  //   factory UpdateStaffScafoldParam.fromJson(Map<String, dynamic> json) {
  //     return UpdateStaffScafoldParam(
  //       jobId: json['jobId'] ?? "",
  //       description: json['description'] ?? "",
  //       photos: List<String>.from(json['photos'] ?? []),
  //       signatureUrl: json['signatureUrl'] ?? "",
  //     );
  //   }

  Future<FormData> toFormData() async {
    final formData = FormData();
    formData.fields.addAll([
      if (description != null) MapEntry('description', description ?? ''),
    ]);
    for (var photo in photos) {
      formData.files.add(
        MapEntry(
          'photos',
          await MultipartFile.fromFile(
            photo.path,
            filename: photo.path.split('/').last,
          ),
        ),
      );
    }

    if (signature != null) {
      formData.files.add(
        MapEntry(
          'signature',
          await MultipartFile.fromFile(
            signature!.path,
            filename: signature!.path.split('/').last,
          ),
        ),
      );
    }
    return formData;
  }

}



class UpdateManagerStaffScafoldParam {
  final String jobId;
  final String? description;
  final List<File> photos;
  final File? signature;

  UpdateManagerStaffScafoldParam({
    required this.jobId,
    required this.description,
    required this.photos,
    required this.signature,
  });

  //   factory UpdateStaffScafoldParam.fromJson(Map<String, dynamic> json) {
  //     return UpdateStaffScafoldParam(
  //       jobId: json['jobId'] ?? "",
  //       description: json['description'] ?? "",
  //       photos: List<String>.from(json['photos'] ?? []),
  //       signatureUrl: json['signatureUrl'] ?? "",
  //     );
  //   }

  Future<FormData> toFormData() async {
    final formData = FormData();
    formData.fields.addAll([
      if (description != null) MapEntry('description', description ?? ''),
    ]);
    for (var photo in photos) {
      formData.files.add(
        MapEntry(
          'photos',
          await MultipartFile.fromFile(
            photo.path,
            filename: photo.path.split('/').last,
          ),
        ),
      );
    }

    if (signature != null) {
      formData.files.add(
        MapEntry(
          'signature',
          await MultipartFile.fromFile(
            signature!.path,
            filename: signature!.path.split('/').last,
          ),
        ),
      );
    }
    return formData;
  }

}

