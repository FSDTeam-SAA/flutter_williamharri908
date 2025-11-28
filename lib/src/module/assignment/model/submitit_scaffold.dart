class SubmititScaffoldModel {
  final String jobid;
  final String description;
  final bool methodStatementAgreed;
  final bool riskAssessmentAgreed;
  final bool termsAccepted;
  final List<String> photos;
  final String signature;

  SubmititScaffoldModel({
    required this.jobid,
    required this.description,
    required this.methodStatementAgreed,
    required this.riskAssessmentAgreed,
    required this.termsAccepted,
    required this.photos,
    required this.signature,
  });

  Map<String, dynamic> toJson() {
    return {
      'job': jobid,
      'description': description,
      'methodStatementAgreed': methodStatementAgreed,
      'riskAssessmentAgreed': riskAssessmentAgreed,
      'termsAccepted': termsAccepted,
      'photos': photos,
      'signatureUrl': signature,
    };
  }
}
