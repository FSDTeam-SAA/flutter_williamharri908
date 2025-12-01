import 'dart:convert';

JobsResponse jobsResponseFromJson(String str) =>
    JobsResponse.fromJson(json.decode(str));

class JobsResponse {
  final bool success;
  final String message;
  final JobsData data;

  JobsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory JobsResponse.fromJson(Map<String, dynamic> json) => JobsResponse(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: JobsData.fromJson(json["data"] ?? {}),
  );
}

// ----------------------------
// DATA (RESULTS + PAGINATION)
// ----------------------------
class JobsData {
  final List<JobModelManager> results;
  final Pagination pagination;

  JobsData({required this.results, required this.pagination});

  factory JobsData.fromJson(Map<String, dynamic> json) => JobsData(
    results: (json["results"] as List<dynamic>? ?? [])
        .map((x) => JobModelManager.fromJson(x))
        .toList(),
    pagination: Pagination.fromJson(json["pagination"] ?? {}),
  );
}

// ----------------------------
// PAGINATION
// ----------------------------
class Pagination {
  final int page;
  final int limit;
  final int totalDocs;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  Pagination({
    required this.page,
    required this.limit,
    required this.totalDocs,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"] ?? 0,
    limit: json["limit"] ?? 0,
    totalDocs: json["totalDocs"] ?? 0,
    totalPages: json["totalPages"] ?? 0,
    hasNext: json["hasNext"] ?? false,
    hasPrev: json["hasPrev"] ?? false,
  );
}

// ----------------------------
// JOB MODEL
// ----------------------------
class JobModelManager {
  final String companyName;
  final String title;
  final String location;
  final String description;
  final int price;
  final List<String> photos;
  final bool isDeleted;
  final String thumbnail;

  final UserModel? postedBy;
  final List<UserModel> assignedTo;

  final String? scaffoldStatus;
  final String? methodStatementUrl;
  final String? riskAssessmentUrl;

  final String? targetDate;
  final String createdAt;
  final String updatedAt;
  final String id;
  final String jobStatus;

  final ScaffoldModel? latestScaffold;
  final ScaffoldModel? scaffoldApplication;

  JobModelManager({
    required this.companyName,
    required this.title,
    required this.location,
    required this.description,
    required this.price,
    required this.photos,
    required this.isDeleted,
    required this.assignedTo,
    required this.postedBy,
    required this.scaffoldStatus,
    required this.id,
    required this.jobStatus,
    required this.createdAt,
    required this.updatedAt,
    this.latestScaffold,
    this.scaffoldApplication,
    this.methodStatementUrl,
    this.riskAssessmentUrl,
    this.targetDate,
    required this.thumbnail,
  });

  factory JobModelManager.fromJson(Map<String, dynamic> json) =>
      JobModelManager(
        companyName: json["companyName"] ?? "",
        title: json["title"] ?? "",
        location: json["location"] ?? "",
        description: json["description"] ?? "",
        price: json["price"] ?? 0,
        photos: List<String>.from(json["photos"] ?? []),
        isDeleted: json["isDeleted"] ?? false,
        postedBy: json["postedBy"] != null
            ? UserModel.fromJson(json["postedBy"])
            : null,
        assignedTo: (json["assignedTo"] as List<dynamic>? ?? [])
            .map((x) => UserModel.fromJson(x))
            .toList(),
        scaffoldStatus: json["scaffoldStatus"] ?? "",
        id: json["id"] ?? "",
        jobStatus: json["jobStatus"] ?? "",
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        targetDate: json["targetDate"],
        thumbnail: json["thumbnail"] ?? "",
        methodStatementUrl: json["methodStatementUrl"],
        riskAssessmentUrl: json["riskAssessmentUrl"],
        latestScaffold: json["latestScaffold"] != null
            ? ScaffoldModel.fromJson(json["latestScaffold"])
            : null,
        scaffoldApplication: json["scaffoldApplication"] != null
            ? ScaffoldModel.fromJson(json["scaffoldApplication"])
            : null,
      );
}

// ----------------------------
// USER MODEL (postedBy / assignedTo)
// ----------------------------
class UserModel {
  final String email;
  final String username;
  final String role;
  final String? phone;
  final String avatarUrl;
  final String uniqueId;
  final String? name;
  final String id;

  UserModel({
    required this.email,
    required this.username,
    required this.role,
    required this.phone,
    required this.avatarUrl,
    required this.uniqueId,
    required this.id,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json["email"] ?? "",
    username: json["username"] ?? "",
    role: json["role"] ?? "",
    phone: json["phone"],
    avatarUrl: json["avatarUrl"] ?? "",
    uniqueId: json["uniqueId"] ?? "",
    name: json["name"],
    id: json["id"] ?? "",
  );
}

// ----------------------------
// SCAFFOLD MODEL (latestScaffold / scaffoldApplication)
// ----------------------------
class ScaffoldModel {
  final String job;
  final UserModel applicant;

  final String title;
  final String description;
  final List<String> photos;
  final List<String> ramsDocs;

  final bool termsAccepted;
  final bool methodStatementAgreed;
  final bool riskAssessmentAgreed;

  final String signatureUrl;

  final int revision;
  final bool isDeleted;

  final String createdAt;
  final String updatedAt;
  final String id;

  final String scaffoldStatus;

  ScaffoldModel({
    required this.job,
    required this.applicant,
    required this.title,
    required this.description,
    required this.photos,
    required this.ramsDocs,
    required this.termsAccepted,
    required this.methodStatementAgreed,
    required this.riskAssessmentAgreed,
    required this.signatureUrl,
    required this.revision,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.scaffoldStatus,
  });

  factory ScaffoldModel.fromJson(Map<String, dynamic> json) => ScaffoldModel(
    job: json["job"] ?? "",
    applicant: UserModel.fromJson(json["applicant"] ?? {}),
    title: json["title"] ?? "",
    description: json["description"] ?? "",
    photos: List<String>.from(json["photos"] ?? []),
    ramsDocs: List<String>.from(json["ramsDocs"] ?? []),
    termsAccepted: json["termsAccepted"] ?? false,
    methodStatementAgreed: json["methodStatementAgreed"] ?? false,
    riskAssessmentAgreed: json["riskAssessmentAgreed"] ?? false,
    signatureUrl: json["signatureUrl"] ?? "",
    revision: json["revision"] ?? 0,
    isDeleted: json["isDeleted"] ?? false,
    createdAt: json["createdAt"] ?? "",
    updatedAt: json["updatedAt"] ?? "",
    id: json["id"] ?? "",
    scaffoldStatus: json["scaffoldStatus"] ?? "",
  );
}
