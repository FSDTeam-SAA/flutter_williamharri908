class ClientModel {
  final String id;
  final String clientName;
  final String clientEmail;
  final String clientPhoneNo;

  ClientModel({
    required this.id,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhoneNo,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      clientName: json['clientName'],
      clientEmail: json['clientEmail'],
      clientPhoneNo: json['clientPhoneNo'],
    );
  }
}
