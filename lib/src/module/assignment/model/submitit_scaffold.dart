import 'dart:io';

import 'package:dio/dio.dart';

class SubmititScaffoldModel {
  final String jobid;
  final String description;
  final bool methodStatementAgreed;
  final bool riskAssessmentAgreed;
  final bool termsAccepted;
  final List<File> photos;
  final File? signature;
  final String? scaffoldStatus;

  SubmititScaffoldModel({
    required this.jobid,
    required this.description,
    required this.methodStatementAgreed,
    required this.riskAssessmentAgreed,
    required this.termsAccepted,
    required this.photos,
    required this.signature,
    this.scaffoldStatus,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     'job': jobid,
  //     'description': description,
  //     'methodStatementAgreed': methodStatementAgreed,
  //     'riskAssessmentAgreed': riskAssessmentAgreed,
  //     'termsAccepted': termsAccepted,
  //     'photos': photos,
  //     'signatureUrl': signature,
  //     'scaffoldStatus': scaffoldStatus,
  //   };
  // }

  Future<FormData> toFormData() async {
    final formData = FormData();
    formData.fields.addAll([
      MapEntry('job', jobid),
      MapEntry('description', description),
      MapEntry('methodStatementAgreed', methodStatementAgreed.toString()),
      MapEntry('riskAssessmentAgreed', riskAssessmentAgreed.toString()),
      MapEntry('termsAccepted', termsAccepted.toString()),
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
