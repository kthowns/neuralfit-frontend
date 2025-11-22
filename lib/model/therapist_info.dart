import 'package:neuralfit_frontend/model/app_user_info.dart';

class TherapistInfo extends AppUserInfo {
  final String organization;
  final String therapistType;

  TherapistInfo({
    required super.id,
    required super.email,
    required super.name,
    required super.userRole,
    required super.createdAt,
    required super.updatedAt,
    required this.organization,
    required this.therapistType,
  });

  factory TherapistInfo.fromJson(Map<String, dynamic> json) {
    return TherapistInfo(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      userRole: json['userRole'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      organization: json['organization'],
      therapistType: json['therapistType'],
    );
  }
}
