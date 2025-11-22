class AppUserInfo {
  final int id;
  final String email;
  final String name;
  final String userRole;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppUserInfo({
    required this.id,
    required this.email,
    required this.name,
    required this.userRole,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUserInfo.fromJson(Map<String, dynamic> json) {
    return AppUserInfo(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      userRole: json['userRole'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
