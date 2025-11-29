// file: lib/src/module/home/model/create_job_model.dart

// file: lib/src/module/home/model/create_job_model.dart

class CreateJobModel {
  final String companyName;
  final String title;
  final String location;
  final String description;
  final String price;

  /// convenience: first assigned staff id (used by the form dropdown)
  final String? staffId;

  /// full list from the backend: "assignedTo": ["id1", "id2", ...]
  final List<String> assignedTo;

  CreateJobModel({
    required this.companyName,
    required this.title,
    required this.location,
    required this.description,
    required this.price,
    this.staffId,
    this.assignedTo = const [],
  });

  /// Use this when CALLING the API (create / update).
  /// Backend complains about "assigneTo" AND returns "assignedTo".
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "companyName": companyName,
      "title": title,
      "location": location,
      "description": description,
      "price": price,
    };

    if (staffId != null) {
      // 👇 send both; one for validation, one for persistence
      map["assigneTo"] = staffId;
      map["assignedTo"] = [staffId];
    }

    return map;
  }

  /// Use this when READING a job from the API
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
  }) {
    return CreateJobModel(
      companyName: companyName ?? this.companyName,
      title: title ?? this.title,
      location: location ?? this.location,
      description: description ?? this.description,
      price: price ?? this.price,
      staffId: staffId ?? this.staffId,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}


// // file: lib/src/module/home/model/create_job_model.dart
//
// class CreateJobModel {
//   final String companyName;
//   final String title;
//   final String location;
//   final String description;
//   final String price;
//   final String? staffId;
//
//   final List<String> assignedTo;
//
//   CreateJobModel({
//     required this.companyName,
//     required this.title,
//     required this.location,
//     required this.description,
//     required this.price,
//     this.staffId,
//     this.assignedTo = const [],
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       "companyName": companyName,
//       "title": title,
//       "location": location,
//       "description": description,
//       "price": price,
//       // 👇 backend expects "staff" not "staffId"
//       "staff": staffId,
//     };
//   }
//
//   CreateJobModel copyWith({
//     String? companyName,
//     String? title,
//     String? location,
//     String? description,
//     String? price,
//     String? staffId,
//   }) {
//     return CreateJobModel(
//       companyName: companyName ?? this.companyName,
//       title: title ?? this.title,
//       location: location ?? this.location,
//       description: description ?? this.description,
//       price: price ?? this.price,
//       staffId: staffId ?? this.staffId,
//     );
//   }
// }
