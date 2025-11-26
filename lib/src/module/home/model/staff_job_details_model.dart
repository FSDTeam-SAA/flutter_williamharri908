class StaffJobDetailModel {
  final String title;
  final String description;

  final List<String> photos;

  StaffJobDetailModel({
    required this.title,
    required this.description,

    required this.photos,
  });

  factory StaffJobDetailModel.fromJson(Map<String, dynamic> json) {
    return StaffJobDetailModel(
      title: json['title'] ?? "",
      description: json['description'] ?? "",

      photos: List<String>.from(json['photos'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "description": description, "photos": photos};
  }
}