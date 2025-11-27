class JobModel {
  final String id;
  final String companyName;
  final String title;
  final String location;
  final String description;
  final num price;
  final List<String> photos;
  final String methodStatementUrl;
  final String riskAssessmentUrl;
  final String status;
  final bool isDeleted;
  final String postedBy;
  final List<String> assignedTo;
  final String scaffoldStatus;
  final String targetDate;
  final String createdAt;
  final String updatedAt;

  JobModel({
    required this.id,
    required this.companyName,
    required this.title,
    required this.location,
    required this.description,
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

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? "",
      companyName: json['companyName'] ?? "",
      title: json['title'] ?? "",
      location: json['location'] ?? "",
      description: json['description'] ?? "",
      price: json['price'] ?? 0,
      photos: List<String>.from(json['photos'] ?? []),
      methodStatementUrl: json['methodStatementUrl'] ?? "",
      riskAssessmentUrl: json['riskAssessmentUrl'] ?? "",
      status: json['status'] ?? "",
      isDeleted: json['isDeleted'] ?? false,
      postedBy: json['postedBy'] ?? "",
      assignedTo: List<String>.from(json['assignedTo'] ?? []),
      scaffoldStatus: json['scaffoldStatus'] ?? "",
      targetDate: json['targetDate'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }
}
