class GetMyScaffoldModel {
  final String id;
  final Job job;
  final String description;
  final List<String> photos;
  final String signatureUrl;
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

  /// copyWith for immutability
  GetMyScaffoldModel copyWith({
    String? description,
    List<String>? photos,
    String? signatureUrl,
    String? scaffoldStatus,
    bool? methodStatementAgreed,
    bool? riskAssessmentAgreed,
    bool? termsAccepted,
    Job? job,
  }) {
    return GetMyScaffoldModel(
      id: id,
      job: job ?? this.job,
      description: description ?? this.description,
      photos: photos ?? this.photos,
      signatureUrl: signatureUrl ?? this.signatureUrl,
      scaffoldStatus: scaffoldStatus ?? this.scaffoldStatus,
      methodStatementAgreed:
          methodStatementAgreed ?? this.methodStatementAgreed,
      riskAssessmentAgreed: riskAssessmentAgreed ?? this.riskAssessmentAgreed,
      termsAccepted: termsAccepted ?? this.termsAccepted,
    );
  }

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
  final String thumbnail;

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
    required this.thumbnail,
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
      thumbnail: json['thumbnail'] ?? "",
    );
  }
}
