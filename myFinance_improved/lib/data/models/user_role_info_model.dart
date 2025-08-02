// lib/data/models/user_role_info_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_role_info.dart';

part 'user_role_info_model.freezed.dart';
part 'user_role_info_model.g.dart';

@freezed
class UserRoleInfoModel with _$UserRoleInfoModel {
  const factory UserRoleInfoModel({
    @JsonKey(name: 'user_role_id') required String userRoleId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'role_id') required String roleId,
    @JsonKey(name: 'role_name') required String roleName,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
  }) = _UserRoleInfoModel;

  factory UserRoleInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserRoleInfoModelFromJson(json);

  const UserRoleInfoModel._();

  // Convert to domain entity
  UserRoleInfo toEntity() {
    return UserRoleInfo(
      userRoleId: userRoleId,
      userId: userId,
      roleId: roleId,
      roleName: roleName,
      companyId: companyId,
      fullName: fullName,
      email: email,
      profileImage: profileImage,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }

  // Create from domain entity
  factory UserRoleInfoModel.fromEntity(UserRoleInfo entity) {
    return UserRoleInfoModel(
      userRoleId: entity.userRoleId,
      userId: entity.userId,
      roleId: entity.roleId,
      roleName: entity.roleName,
      companyId: entity.companyId,
      fullName: entity.fullName,
      email: entity.email,
      profileImage: entity.profileImage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isDeleted: entity.isDeleted,
    );
  }
}