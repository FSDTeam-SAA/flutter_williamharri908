import 'package:williamharri/src/module/profile/model/profile_model.dart';

class GetMyScaffoldModel {
  final String id;
  final Job job;
  final num price;
  final List<String> photos;
  final String methodStatementUrl;
  final String riskAssessmentUrl;
  final String status;
  final bool isDeleted;
  final ProfileModel postedBy;
  final List<ProfileModel> assignedTo;
  final String scaffoldStatus;
  final String targetDate;
  final String createdAt;
  final String updatedAt;

  GetMyScaffoldModel({
    required this.id,
    required this.job,
    required this.price,
    required this.photos,
    required this.methodStatementUrl,
    required this.riskAssessmentUrl,
    required this.status,
    required this.isDeleted,
    required this.postedBy,
    required this.assignedTo,
    required this.scaffoldStatus,
    required this.targetDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetMyScaffoldModel.fromJson(Map<String, dynamic> json) {
    return GetMyScaffoldModel(
      id: json['id'] ?? "",
      job: Job(
        companyName: json['job']['companyName'] ?? "",
        title: json['job']['title'] ?? "",
        location: json['job']['location'] ?? "",
        scaffoldStatus: json['job']['scaffoldStatus'] ?? "",
        targetDate: json['job']['targetDate'] ?? "",
        id: json['job']['id'] ?? "",
      ),
      price: json['price'] ?? 0,
      photos: List<String>.from(json['photos'] ?? []),
      methodStatementUrl: json['methodStatementUrl'] ?? "",
      riskAssessmentUrl: json['riskAssessmentUrl'] ?? "",
      status: json['status'] ?? "",
      isDeleted: json['isDeleted'] ?? false,

      postedBy: (json['postedBy'] is String)
          ? ProfileModel(id: json['postedBy'])
          : ProfileModel.fromMap(json['postedBy'] ?? {}),

      assignedTo: (json['assignedTo'] as List<dynamic>? ?? [])
          .map(
            (e) => e is String
                ? ProfileModel(id: e)
                : ProfileModel.fromMap(e ?? {}),
          )
          .toList(),

      scaffoldStatus: json['scaffoldStatus'] ?? "",
      targetDate: json['targetDate'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }
}

class Job {
  String companyName;
  String title;
  String location;
  String scaffoldStatus;
  String targetDate;
  String id;

  Job({
    required this.companyName,
    required this.title,
    required this.location,
    required this.scaffoldStatus,
    required this.targetDate,
    required this.id,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      companyName: json['companyName'] ?? "",
      title: json['title'] ?? "",
      location: json['location'] ?? "",
      scaffoldStatus: json['scaffoldStatus'] ?? "",
      targetDate: json['targetDate'] ?? "",
      id: json['id'] ?? "",
    );
  }

  //tojson
}
