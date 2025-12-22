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

  CreateJobModel({
    this.companyName,
    this.title,
    this.location,
    this.description,
    this.price,
    this.staffId,
    this.assignedTo = const [],
    this.methodStatement,
    this.riskAssessment,
  });
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "companyName": companyName,
      "title": title,
      "location": location,
      "description": description,
      "price": price,
    };

    if (staffId != null) {
      map["assigneTo"] = staffId;
      map["assignedTo"] = [staffId];
    }

    if (methodStatement != null) {
      map["methodStatement"] = methodStatement;
    }
    if (riskAssessment != null) {
      map["riskAssessment"] = riskAssessment;
    }

    return map;
  }

  factory CreateJobModel.fromJson(Map<String, dynamic> json) {
    final List<String> assigned =
        (json["assignedTo"] as List?)
            ?.map((e) => e.toString())
            .toList() ??
            const [];

    return CreateJobModel(
      companyName: json["companyName"]?.toString() ?? "",
      title: json["title"]?.toString() ?? "",
      location: json["location"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      price: json["price"]?.toString() ?? "",
      staffId: assigned.isNotEmpty ? assigned.first : null,
      assignedTo: assigned,
      methodStatement: json["methodStatement"]?.toString(),
      riskAssessment: json["riskAssessment"]?.toString(),
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
    );
  }
}
