// lib/data/models/role_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/role.dart';

part 'role_model.freezed.dart';
part 'role_model.g.dart';

@freezed
class RoleModel with _$RoleModel {
  const factory RoleModel({
    @JsonKey(name: 'role_id') required String roleId,
    @JsonKey(name: 'role_name') required String roleName,
    @JsonKey(name: 'role_type') required String roleType,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'parent_role_id') String? parentRoleId,
    @JsonKey(name: 'is_deletable') @Default(true) bool isDeletable,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  const RoleModel._();

  // Convert to domain entity
  Role toEntity() {
    return Role(
      roleId: roleId,
      roleName: roleName,
      roleType: roleType,
      companyId: companyId,
      parentRoleId: parentRoleId,
      isDeletable: isDeletable,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Create from domain entity
  factory RoleModel.fromEntity(Role entity) {
    return RoleModel(
      roleId: entity.roleId,
      roleName: entity.roleName,
      roleType: entity.roleType,
      companyId: entity.companyId,
      parentRoleId: entity.parentRoleId,
      isDeletable: entity.isDeletable,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}