// lib/domain/entities/role.dart

class Role {
  final String roleId;
  final String roleName;
  final String roleType;
  final String companyId;
  final String? parentRoleId;
  final bool isDeletable;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Role({
    required this.roleId,
    required this.roleName,
    required this.roleType,
    required this.companyId,
    this.parentRoleId,
    this.isDeletable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  // Business logic
  bool get isOwnerRole => roleType.toLowerCase() == 'owner';
  bool get canBeAssigned => !isOwnerRole && isDeletable;
  bool get isSystemRole => roleType.toLowerCase() == 'system';
  bool get isCustomRole => roleType.toLowerCase() == 'custom';

  String get displayRoleType {
    switch (roleType.toLowerCase()) {
      case 'owner':
        return 'Owner';
      case 'manager':
        return 'Manager';
      case 'employee':
        return 'Employee';
      case 'custom':
        return 'Custom';
      default:
        return roleType;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Role &&
          runtimeType == other.runtimeType &&
          roleId == other.roleId;

  @override
  int get hashCode => roleId.hashCode;

  @override
  String toString() => 'Role(roleId: $roleId, roleName: $roleName, roleType: $roleType)';
}