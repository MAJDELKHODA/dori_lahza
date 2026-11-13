class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String roleLabel;
  final String? avatar;
  final String initials;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.roleLabel,
    this.avatar,
    required this.initials,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      roleLabel: json['role_label'] ?? '',
      avatar: json['avatar'],
      initials: json['initials'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }
}
