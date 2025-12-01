class AddMedicalRecordRequest {
  final String? consultationType;
  final String? description;
  final DateTime? consultationDate;
  final String? diagnosis;
  final String? patientComment;
  final int? moca;
  final int? mmse;
  final int? faq;
  final int? ldelTotal;
  final int? adas13;
  final double? abeta;
  final double? ptau;
  final double? ecogPtMem;
  final double? ecogPtTotal;

  AddMedicalRecordRequest({
    this.consultationType,
    this.description,
    this.consultationDate,
    this.diagnosis,
    this.patientComment,
    this.moca,
    this.mmse,
    this.faq,
    this.ldelTotal,
    this.adas13,
    this.abeta,
    this.ptau,
    this.ecogPtMem,
    this.ecogPtTotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'consultationType': consultationType,
      'description': description,
      'consultationDate': consultationDate?.toIso8601String(),
      'diagnosis': diagnosis,
      'patientComment': patientComment,
      'moca': moca,
      'mmse': mmse,
      'faq': faq,
      'ldelTotal': ldelTotal,
      'adas13': adas13,
      'abeta': abeta,
      'ptau': ptau,
      'ecogPtMem': ecogPtMem,
      'ecogPtTotal': ecogPtTotal,
    };
  }
}
