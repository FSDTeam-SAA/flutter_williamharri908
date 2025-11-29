class UpdateStaffScafold {
  final String description;
  final List<String> photos;
  final String signatureUrl;

  UpdateStaffScafold({
    required this.description,
    required this.photos,
    required this.signatureUrl,
  });

  factory UpdateStaffScafold.fromJson(Map<String, dynamic> json) {
    return UpdateStaffScafold(
      description: json['description'] ?? "",
      photos: List<String>.from(json['photos'] ?? []),
      signatureUrl: json['signatureUrl'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'photos': photos,
      'signatureUrl': signatureUrl,
    };
  }
}
