class HomeScreenModel {
  final String jobTitle;
  final String status;
  final String category;
  final String jobId;
  final String location;
  final String profileImage;

  HomeScreenModel({
    required this.jobTitle,
    required this.status,
    required this.category,
    required this.jobId,
    required this.location,
    required this.profileImage,
  });

  factory HomeScreenModel.fromJson(Map<String, dynamic> json) {
    return HomeScreenModel(
      jobTitle: json['jobTitle'] ?? "",
      status: json['status'] ?? "",
      category: json['category'] ?? "",
      jobId: json['jobId']?.toString() ?? "",
      location: json['location'] ?? "",
      profileImage: json['profileImage'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "jobTitle": jobTitle,
      "status": status,
      "category": category,
      "jobId": jobId,
      "location": location,
      "profileImage": profileImage,
    };
  }
}
