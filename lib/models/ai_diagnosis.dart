class AIDiagnosis {
  final int diagnosisId;
  final int? plantId;
  final String? plantName;
  final String sampleImageUrl;
  final String diseaseName;
  final double confidenceRate;
  final String? organicTreatment;
  final DateTime diagnosisDate;

  AIDiagnosis({
    required this.diagnosisId,
    this.plantId,
    this.plantName,
    required this.sampleImageUrl,
    required this.diseaseName,
    required this.confidenceRate,
    this.organicTreatment,
    required this.diagnosisDate,
  });

  factory AIDiagnosis.fromJson(Map<String, dynamic> json) {
    return AIDiagnosis(
      diagnosisId: json['diagnosisId'] ?? 0,
      plantId: json['plantId'],
      plantName: json['plantName'],
      sampleImageUrl: json['sampleImageUrl'] ?? '',
      diseaseName: json['diseaseName'] ?? 'مرض غير محدد',
      confidenceRate: (json['confidenceRate'] ?? 0.0).toDouble(),
      organicTreatment: json['organicTreatment'],
      diagnosisDate: json['diagnosisDate'] != null
          ? DateTime.parse(json['diagnosisDate'])
          : DateTime.now(),
    );
  }
}
