import 'package:williamharri/src/module/profile/model/profile_model.dart';

class JobModel {
  final String id;
  final String companyName;
  final String title;
  final String location;
  final String description;
  final num price;
  final List<String> photos;
  final String methodStatementUrl;
  final String riskAssessmentUrl;
  final String status;
  final bool isDeleted;
  final ProfileModel postedBy;
  final List<ProfileModel> assignedTo;
  final Client client;
  final Coordinates coordinates;
  final String scaffoldStatus;
  final String targetDate;
  final String createdAt;
  final String updatedAt;
  final String signatureUrl;

  /// URL of the main thumbnail image
  final String? thumbnail;
  final String? methodStatement;
  final String? riskAssessment;

  JobModel({
    required this.id,
    required this.companyName,
    required this.title,
    required this.location,
    required this.description,
    required this.price,
    required this.photos,
    required this.methodStatementUrl,
    required this.riskAssessmentUrl,
    required this.status,
    required this.isDeleted,
    required this.postedBy,
    required this.assignedTo,
    required this.scaffoldStatus,
    required this.targetDate,
    required this.createdAt,
    required this.updatedAt,
    required this.signatureUrl,
    this.thumbnail,
    this.methodStatement,
    this.riskAssessment,
    required this.client,
    required this.coordinates,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? "",
      companyName: json['companyName'] ?? "",
      title: json['title'] ?? "",
      location: json['location'] ?? "",
      description: json['description'] ?? "",
      price: json['price'] ?? 0,
      photos: List<String>.from(json['photos'] ?? []),
      methodStatementUrl: json['methodStatementUrl'] ?? "",
      riskAssessmentUrl: json['riskAssessmentUrl'] ?? "",
      status: json['jobStatus'] ?? "",
      isDeleted: json['isDeleted'] ?? false,

      postedBy: (json['postedBy'] is String)
          ? ProfileModel(id: json['postedBy'])
          : ProfileModel.fromMap(json['postedBy'] ?? {}),

      assignedTo: (json['assignedTo'] as List<dynamic>? ?? [])
          .map(
            (e) => e is String
                ? ProfileModel(id: e)
                : ProfileModel.fromMap(e ?? {}),
          )
          .toList(),

      scaffoldStatus: json['scaffoldStatus'] ?? "",
      targetDate: json['targetDate'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      signatureUrl: json['signatureUrl'] ?? "",
      // if your backend uses "thumbnailUrl" or "image", change it here.
      thumbnail: json['thumbnail']?.toString(),
      methodStatement: json['methodStatement'],
      riskAssessment: json['riskAssessment'],
      client: Client.fromJson(json['client'] ?? {}),
      coordinates: Coordinates.fromJson(
        json['coordinates'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class Client {
  final String clientName;
  final String clientEmail;
  final String clientPhoneNo;
  final bool isDeleted;
  final String id;

  Client({
    required this.clientName,
    required this.clientEmail,
    required this.clientPhoneNo,
    required this.isDeleted,
    required this.id,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      clientName: json['clientName'] ?? "",
      clientEmail: json['clientEmail'] ?? "",
      clientPhoneNo: json['clientPhoneNo'] ?? "",
      isDeleted: json['isDeleted'] ?? false,
      id: json['id'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientPhoneNo': clientPhoneNo,
      'isDeleted': isDeleted,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'Client{clientName: $clientName, clientEmail: $clientEmail, clientPhoneNo: $clientPhoneNo, isDeleted: $isDeleted, id: $id}';
  }
}

// class Coordinates {
//   double? lat;
//   double? lang;

//   Coordinates({this.lat, this.lang});

//   Coordinates.fromJson(Map<String, dynamic> json) {
//     lat = json['lat'];
//     lang = json['lang'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['lat'] = lat;
//     data['lang'] = lang;
//     return data;
//   }

//   @override
//   String toString() {
//     return 'Coordinates{lat: $lat, lang: $lang}';
//   }

//   //tomap
//   Map<String, dynamic> toMap() {
//     return {
//       'lat': lat,
//       'lang': lang,
//     };
//   }
// }
class Coordinates {
  double? lat;
  double? lang;

  Coordinates({this.lat, this.lang});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: (json['lat'] as num?)?.toDouble(),
      lang: (json['lang'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lang': lang};
  }

  @override
  String toString() {
    return 'Coordinates{lat: $lat, lang: $lang}';
  }
}
