import 'package:williamharri/src/module/home/model/job_cart_model.dart';

class UpdateJobModel {
  final String? companyName;
  final String? title;
  final String? location;
  final String? description;
  final num? price;

  /// URL string (if you ever send existing thumb URL as text)
  /// For new thumbnail image files you will still use FormData.
  final String? thumbnail;

  /// Existing photo URLs you want to keep (optional).
  /// New images you upload as files in FormData.
  final List<String>? photos;

  /// RAMS docs (if you allow editing them from UI)
  final String? methodStatementUrl;
  final String? riskAssessmentUrl;

  /// List of staff IDs assigned to this job
  final List<String>? assignedToIds;

  final String? jobStatus;        // e.g. "active", "assignedToStaffs"
  final DateTime? targetDate;     // "2026-01-15T00:00:00.000Z"
  final bool? isDeleted;

  UpdateJobModel({
    this.companyName,
    this.title,
    this.location,
    this.description,
    this.price,
    this.thumbnail,
    this.photos,
    this.methodStatementUrl,
    this.riskAssessmentUrl,
    this.assignedToIds,
    this.jobStatus,
    this.targetDate,
    this.isDeleted,
  });

  /// Handy constructor: create an UpdateJobModel from an existing JobModel
  /// and then change only what you want before calling toJson().
  factory UpdateJobModel.fromJob(JobModel job) {
    return UpdateJobModel(
      companyName: job.companyName,
      title: job.title,
      location: job.location,
      description: job.description,
      price: num.tryParse(job.price.toString()),
      thumbnail: job.thumbnail,
      photos: job.photos,
      // if you add assignedTo list & jobStatus/targetDate to JobModel,
      // you can map them here too.
    );
  }

  /// Convert to JSON for PATCH /jobs/{id}
  ///
  /// Important: we remove all `null` fields so PATCH only sends
  /// what you actually want to update.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (companyName != null) data['companyName'] = companyName;
    if (title != null) data['title'] = title;
    if (location != null) data['location'] = location;
    if (description != null) data['description'] = description;
    if (price != null) data['price'] = price;
    if (thumbnail != null) data['thumbnail'] = thumbnail;
    if (photos != null) data['photos'] = photos;
    if (methodStatementUrl != null) {
      data['methodStatementUrl'] = methodStatementUrl;
    }
    if (riskAssessmentUrl != null) {
      data['riskAssessmentUrl'] = riskAssessmentUrl;
    }
    if (assignedToIds != null) {
      data['assignedTo'] = assignedToIds;
    }
    if (jobStatus != null) data['jobStatus'] = jobStatus;
    if (targetDate != null) {
      data['targetDate'] = targetDate!.toUtc().toIso8601String();
    }
    if (isDeleted != null) data['isDeleted'] = isDeleted;

    return data;
  }

  UpdateJobModel copyWith({
    String? companyName,
    String? title,
    String? location,
    String? description,
    num? price,
    String? thumbnail,
    List<String>? photos,
    String? methodStatementUrl,
    String? riskAssessmentUrl,
    List<String>? assignedToIds,
    String? jobStatus,
    DateTime? targetDate,
    bool? isDeleted,
  }) {
    return UpdateJobModel(
      companyName: companyName ?? this.companyName,
      title: title ?? this.title,
      location: location ?? this.location,
      description: description ?? this.description,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
      photos: photos ?? this.photos,
      methodStatementUrl: methodStatementUrl ?? this.methodStatementUrl,
      riskAssessmentUrl: riskAssessmentUrl ?? this.riskAssessmentUrl,
      assignedToIds: assignedToIds ?? this.assignedToIds,
      jobStatus: jobStatus ?? this.jobStatus,
      targetDate: targetDate ?? this.targetDate,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
