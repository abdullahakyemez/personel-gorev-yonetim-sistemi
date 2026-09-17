import 'user_role.dart';

class AppUser {
  final int id;
  final String username;
  final String fullName;
  final UserRole role;
  final int? personnelId;
  final String? groupName;
  final bool isActive;
  final bool requiresPasswordChange;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const AppUser({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    this.personnelId,
    this.groupName,
    this.isActive = true,
    this.requiresPasswordChange = false,
    required this.createdAt,
    this.lastLoginAt,
  });

  AppUser copyWith({
    int? id,
    String? username,
    String? fullName,
    UserRole? role,
    int? personnelId,
    String? groupName,
    bool? isActive,
    bool? requiresPasswordChange,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      personnelId: personnelId ?? this.personnelId,
      groupName: groupName ?? this.groupName,
      isActive: isActive ?? this.isActive,
      requiresPasswordChange:
          requiresPasswordChange ?? this.requiresPasswordChange,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          role == other.role &&
          requiresPasswordChange == other.requiresPasswordChange;

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      role.hashCode ^
      requiresPasswordChange.hashCode;
}
