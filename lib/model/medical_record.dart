class MedicalRecord {
  final int id;
  final int patientId;
  final int therapistId;
  final String? description;
  final String? patientComment;
  final DateTime consultationDate;
  final String? diagnosis;
  final int? moca;
  final int? mmse;
  final int? faq;
  final int? ldelTotal;
  final int? adas13;
  final double? abeta;
  final double? ptau;
  final double? ecogPtMem;
  final double? ecogPtTotal;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicalRecord({
    required this.id,
    required this.patientId,
    required this.therapistId,
    required this.description,
    required this.patientComment,
    required this.consultationDate,
    required this.diagnosis,
    required this.moca,
    required this.mmse,
    required this.faq,
    required this.ldelTotal,
    required this.adas13,
    required this.abeta,
    required this.ptau,
    required this.ecogPtMem,
    required this.ecogPtTotal,
    required this.createdAt,
    required this.updatedAt,
  });
  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    double? parseNullableDouble(dynamic value) =>
        value == null ? null : (value as num).toDouble();

    return MedicalRecord(
      id: json['id'],
      patientId: json['patientId'],
      therapistId: json['therapistId'],
      description: json['description'],
      patientComment: json['patientComment'],
      consultationDate: DateTime.parse(json['consultationDate']),
      diagnosis: json['diagnosis'],
      moca: json['moca'],
      mmse: json['mmse'],
      faq: json['faq'],
      ldelTotal: json['ldelTotal'],
      adas13: json['adas13'],
      abeta: parseNullableDouble(json['abeta']),
      ptau: parseNullableDouble(json['ptau']),
      ecogPtMem: parseNullableDouble(json['ecogPtMem']),
      ecogPtTotal: parseNullableDouble(json['ecogPtTotal']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
