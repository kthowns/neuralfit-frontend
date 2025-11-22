import 'package:neuralfit_frontend/model/app_user_info.dart';

class PatientInfo extends AppUserInfo {
  final String gender;
  final DateTime birthDate;

  PatientInfo({
    required super.id,
    required super.email,
    required super.name,
    required super.userRole,
    required super.createdAt,
    required super.updatedAt,
    required this.gender,
    required this.birthDate,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      userRole: json['userRole'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      gender: json['gender'],
      birthDate: DateTime.parse(json['birthDate']),
    );
  }
}
