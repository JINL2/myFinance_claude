// lib/domain/entities/user_role_info.dart

class UserRoleInfo {
  final String userRoleId;
  final String userId;
  final String roleId;
  final String roleName;
  final String companyId;
  final String fullName;
  final String email;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  const UserRoleInfo({
    required this.userRoleId,
    required this.userId,
    required this.roleId,
    required this.roleName,
    required this.companyId,
    required this.fullName,
    required this.email,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  // Business logic
  bool get canEditRole => roleName.toLowerCase() != 'owner';
  bool get hasProfileImage => profileImage != null && profileImage!.isNotEmpty;
  
  String get displayName => fullName.isNotEmpty ? fullName : email;
  String get initials {
    if (fullName.isNotEmpty) {
      final parts = fullName.split(' ');
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return fullName[0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleInfo &&
          runtimeType == other.runtimeType &&
          userRoleId == other.userRoleId;

  @override
  int get hashCode => userRoleId.hashCode;

  @override
  String toString() => 'UserRoleInfo(userRoleId: $userRoleId, fullName: $fullName, roleName: $roleName)';
}