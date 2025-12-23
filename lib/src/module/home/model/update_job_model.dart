import 'package:williamharri/src/module/home/model/job_cart_model.dart';

class UpdateJobModel {
  final String? companyName;
  final String? title;
  final String? location;
  final String? description;
  final num? price;

  final String? thumbnail; // url text only
  final List<String>? photos; // url list only

  final String? methodStatementUrl;
  final String? riskAssessmentUrl;

  final List<String>? assignedToIds;

  final String? jobStatus;
  final DateTime? targetDate;
  final bool? isDeleted;

  // ✅ NEW
  final String? quotationNo;
  final double? lat;
  final double? lang; // backend uses "lang"

  const UpdateJobModel({
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

    // ✅ NEW
    this.quotationNo,
    this.lat,
    this.lang,
  });

  factory UpdateJobModel.fromJob(JobModel job) {
    double? _toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    String? qNo;
    double? lat;
    double? lang;

    try {
      final dynamic j = job;

      qNo = j.quotationNo?.toString();

      final dynamic coords = j.coordinates;
      if (coords is Map) {
        lat = _toDouble(coords['lat']);
        lang = _toDouble(coords['lang']);
      } else {
        try {
          lat = _toDouble(coords?.lat);
          lang = _toDouble(coords?.lang);
        } catch (_) {}
      }
    } catch (_) {}

    return UpdateJobModel(
      companyName: job.companyName,
      title: job.title,
      location: job.location,
      description: job.description,
      price: num.tryParse(job.price.toString()),
      thumbnail: job.thumbnail,
      photos: job.photos,

      quotationNo: qNo,
      lat: lat,
      lang: lang,
    );
  }

  /// ✅ Remove nulls so PATCH updates only sent fields
  /// includeBracketCoordinates=true makes it safe for multipart patch too.
  Map<String, dynamic> toJson({bool includeBracketCoordinates = true}) {
    final Map<String, dynamic> data = {};

    if (companyName != null) data['companyName'] = companyName;
    if (title != null) data['title'] = title;
    if (location != null) data['location'] = location;
    if (description != null) data['description'] = description;
    if (price != null) data['price'] = price;

    if (thumbnail != null) data['thumbnail'] = thumbnail;
    if (photos != null) data['photos'] = photos;

    if (methodStatementUrl != null) data['methodStatementUrl'] = methodStatementUrl;
    if (riskAssessmentUrl !=null) data['riskAssessmentUrl'] = riskAssessmentUrl;

    if (assignedToIds != null) data['assignedTo'] = assignedToIds;

    if (jobStatus != null) data['jobStatus'] = jobStatus;
    if (targetDate != null) data['targetDate'] = targetDate!.toUtc().toIso8601String();
    if (isDeleted != null) data['isDeleted'] = isDeleted;

    // ✅ NEW
    if (quotationNo != null) data['quotationNo'] = quotationNo;

    // JSON style
    if (lat != null || lang != null) {
      data['coordinates'] = {
        'lat': lat,
        'lang': lang,
      };
    }

    // multipart-safe style
    if (includeBracketCoordinates) {
      if (lat != null) {
        data['coordinates[lat]'] = lat;
        data['coordinates.lat'] = lat; // fallback
      }
      if (lang != null) {
        data['coordinates[lang]'] = lang;
        data['coordinates.lang'] = lang; // fallback
      }
    }

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

    // ✅ NEW
    String? quotationNo,
    double? lat,
    double? lang,
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

      quotationNo: quotationNo ?? this.quotationNo,
      lat: lat ?? this.lat,
      lang: lang ?? this.lang,
    );
  }
}
