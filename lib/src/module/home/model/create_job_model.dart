class CreateJobModel {
  final String? companyName;
  final String? title;
  final String? location;
  final String? description;
  final String? price;

  final String? staffId;
  final List<String> assignedTo;

  final String? methodStatement;
  final String? riskAssessment;

  // ✅ NEW
  final String? quotationNo;
  final double? lat;
  final double? lang; // backend uses "lang"

  const CreateJobModel({
    this.companyName,
    this.title,
    this.location,
    this.description,
    this.price,
    this.staffId,
    this.assignedTo = const [],
    this.methodStatement,
    this.riskAssessment,

    // ✅ NEW
    this.quotationNo,
    this.lat,
    this.lang,
  });

  Map<String, dynamic> toJson({bool includeBracketCoordinates = true}) {
    final map = <String, dynamic>{
      "companyName": companyName,
      "title": title,
      "location": location,
      "description": description,
      "price": price,
      "quotationNo": quotationNo,
    };

    if (staffId != null) {
      map["assigneTo"] = staffId;
      map["assignedTo"] = [staffId];
    } else if (assignedTo.isNotEmpty) {
      map["assignedTo"] = assignedTo;
    }

    // JSON style
    if (lat != null || lang != null) {
      map["coordinates"] = {"lat": lat, "lang": lang};
    }

    // multipart safe style
    if (includeBracketCoordinates) {
      if (lat != null) map["coordinates[lat]"] = lat;
      if (lang != null) map["coordinates[lang]"] = lang;

      // dot fallback
      if (lat != null) map["coordinates.lat"] = lat;
      if (lang != null) map["coordinates.lang"] = lang;
    }

    if (methodStatement != null) map["methodStatement"] = methodStatement;
    if (riskAssessment != null) map["riskAssessment"] = riskAssessment;

    return map;
  }

  factory CreateJobModel.fromJson(Map<String, dynamic> json) {
    final assigned = (json["assignedTo"] as List?)
        ?.map((e) => e.toString())
        .toList() ??
        const <String>[];

    double? _toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    final coords = json["coordinates"];
    final lat = (coords is Map) ? _toDouble(coords["lat"]) : null;
    final lang = (coords is Map) ? _toDouble(coords["lang"]) : null;

    return CreateJobModel(
      companyName: json["companyName"]?.toString(),
      title: json["title"]?.toString(),
      location: json["location"]?.toString(),
      description: json["description"]?.toString(),
      price: json["price"]?.toString(),
      staffId: assigned.isNotEmpty ? assigned.first : null,
      assignedTo: assigned,
      methodStatement: json["methodStatement"]?.toString(),
      riskAssessment: json["riskAssessment"]?.toString(),

      quotationNo: json["quotationNo"]?.toString(),
      lat: lat,
      lang: lang,
    );
  }

  CreateJobModel copyWith({
    String? companyName,
    String? title,
    String? location,
    String? description,
    String? price,
    String? staffId,
    List<String>? assignedTo,
    String? methodStatement,
    String? riskAssessment,
    String? quotationNo,
    double? lat,
    double? lang,
  }) {
    return CreateJobModel(
      companyName: companyName ?? this.companyName,
      title: title ?? this.title,
      location: location ?? this.location,
      description: description ?? this.description,
      price: price ?? this.price,
      staffId: staffId ?? this.staffId,
      assignedTo: assignedTo ?? this.assignedTo,
      methodStatement: methodStatement ?? this.methodStatement,
      riskAssessment: riskAssessment ?? this.riskAssessment,
      quotationNo: quotationNo ?? this.quotationNo,
      lat: lat ?? this.lat,
      lang: lang ?? this.lang,
    );
  }
}
