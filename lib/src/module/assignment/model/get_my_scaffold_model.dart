// import 'package:williamharri/src/module/profile/model/profile_model.dart';

// class GetMyScaffoldModel {
//   final String id;
//   final Job job;
//   final num price;
//   final List<String> photos;
//   final String methodStatementUrl;
//   final String riskAssessmentUrl;
//   final String status;
//   final bool isDeleted;
//   final ProfileModel postedBy;
//   final List<ProfileModel> assignedTo;
//   final String scaffoldStatus;
//   final String targetDate;
//   final String createdAt;
//   final String updatedAt;
//   final String description;
//   final String signatureUrl;

//   GetMyScaffoldModel({
//     required this.id,
//     required this.job,
//     required this.price,
//     required this.photos,
//     required this.methodStatementUrl,
//     required this.riskAssessmentUrl,
//     required this.status,
//     required this.isDeleted,
//     required this.postedBy,
//     required this.assignedTo,
//     required this.scaffoldStatus,
//     required this.targetDate,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.description,
//     required this.signatureUrl,
//   });

//   factory GetMyScaffoldModel.fromJson(Map<String, dynamic> json) {
//     return GetMyScaffoldModel(
//       id: json['id'] ?? "",
//       job: Job.fromJson(json['job'] ?? {}),
//       price: json['price'] ?? 0,
//       photos: List<String>.from(json['photos'] ?? []),
//       methodStatementUrl: json['methodStatementUrl'] ?? "",
//       riskAssessmentUrl: json['riskAssessmentUrl'] ?? "",
//       status: json['jobStatus'] ?? "",
//       isDeleted: json['isDeleted'] ?? false,

//       postedBy: (json['postedBy'] is String)
//           ? ProfileModel(id: json['postedBy'])
//           : ProfileModel.fromMap(json['postedBy'] ?? {}),

//       assignedTo: (json['assignedTo'] as List<dynamic>? ?? [])
//           .map(
//             (e) => e is String
//                 ? ProfileModel(id: e)
//                 : ProfileModel.fromMap(e ?? {}),
//           )
//           .toList(),

//       scaffoldStatus: json['scaffoldStatus'] ?? "",
//       targetDate: json['targetDate'] ?? "",
//       createdAt: json['createdAt'] ?? "",
//       updatedAt: json['updatedAt'] ?? "",
//       description: json['description'] ?? "",
//       signatureUrl: json['signatureUrl']?.toString() ?? "",
//     );
//   }
// }

// class Job {
//   final String companyName;
//   final String title;
//   final String location;
//   final String methodStatementUrl;
//   final String riskAssessmentUrl;
//   final String scaffoldStatus;
//   final String targetDate;
//   final String id;
//   final String jobStatus;

//   Job({
//     required this.companyName,
//     required this.title,
//     required this.location,
//     required this.methodStatementUrl,
//     required this.riskAssessmentUrl,
//     required this.scaffoldStatus,
//     required this.targetDate,
//     required this.id,
//     required this.jobStatus,
//   });

//   factory Job.fromJson(Map<String, dynamic> json) {
//     return Job(
//       companyName: json['companyName'] ?? "",
//       title: json['title'] ?? "",
//       location: json['location'] ?? "",
//       methodStatementUrl: json['methodStatementUrl'] ?? "",
//       riskAssessmentUrl: json['riskAssessmentUrl'] ?? "",
//       scaffoldStatus: json['scaffoldStatus'] ?? "",
//       targetDate: json['targetDate'] ?? "",
//       id: json['id'] ?? "",
//       jobStatus: json['jobStatus'] ?? "",
//     );
//   }
//   //tojson
// }


// get_my_scaffold_model.dart

class GetMyScaffoldModel {
  final String id;
  final Job job;
  final String description;
  final List<String> photos;        // Now contains Cloudinary URLs OR local paths (we'll handle both)
  final String signatureUrl;        // Same: Cloudinary URL or local path
  final String scaffoldStatus;
  final bool methodStatementAgreed;
  final bool riskAssessmentAgreed;
  final bool termsAccepted;

  GetMyScaffoldModel({
    required this.id,
    required this.job,
    required this.description,
    required this.photos,
    required this.signatureUrl,
    required this.scaffoldStatus,
    required this.methodStatementAgreed,
    required this.riskAssessmentAgreed,
    required this.termsAccepted,
  });

  factory GetMyScaffoldModel.fromJson(Map<String, dynamic> json) {
    var photosList = json['photos'] as List<dynamic>? ?? [];
    var photoStrings = photosList.map((e) => e.toString()).toList();

    return GetMyScaffoldModel(
      id: json['id'] ?? "",
      job: Job.fromJson(json['job'] ?? {}),
      description: json['description'] ?? "",
      photos: photoStrings,
      signatureUrl: json['signatureUrl']?.toString() ?? "",
      scaffoldStatus: json['scaffoldStatus'] ?? "",
      methodStatementAgreed: json['methodStatementAgreed'] ?? false,
      riskAssessmentAgreed: json['riskAssessmentAgreed'] ?? false,
      termsAccepted: json['termsAccepted'] ?? false,
    );
  }
}

class Job {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String methodStatementUrl;
  final String riskAssessmentUrl;
  final String scaffoldStatus;
  final String targetDate;
  final String jobStatus;

  Job({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.methodStatementUrl,
    required this.riskAssessmentUrl,
    required this.scaffoldStatus,
    required this.targetDate,
    required this.jobStatus,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? "",
      title: json['title'] ?? "",
      companyName: json['companyName'] ?? "",
      location: json['location'] ?? "",
      methodStatementUrl: json['methodStatementUrl'] ?? "",
      riskAssessmentUrl: json['riskAssessmentUrl'] ?? "",
      scaffoldStatus: json['scaffoldStatus'] ?? "",
      targetDate: json['targetDate'] ?? "",
      jobStatus: json['jobStatus'] ?? "",
    );
  }
}