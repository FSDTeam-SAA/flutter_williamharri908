// file: lib/src/module/home/model/create_job_model.dart

class CreateJobModel {
  final String companyName;
  final String title;
  final String location;
  final String description;
  final String price;
  final String? staffId;

  CreateJobModel({
    required this.companyName,
    required this.title,
    required this.location,
    required this.description,
    required this.price,
    this.staffId,
  });

  Map<String, dynamic> toJson() {
    return {
      "companyName": companyName,
      "title": title,
      "location": location,
      "description": description,
      "price": price,
      // 👇 backend expects "staff" not "staffId"
      "staff": staffId,
    };
  }

  CreateJobModel copyWith({
    String? companyName,
    String? title,
    String? location,
    String? description,
    String? price,
    String? staffId,
  }) {
    return CreateJobModel(
      companyName: companyName ?? this.companyName,
      title: title ?? this.title,
      location: location ?? this.location,
      description: description ?? this.description,
      price: price ?? this.price,
      staffId: staffId ?? this.staffId,
    );
  }
}
