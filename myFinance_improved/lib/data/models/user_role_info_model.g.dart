// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRoleInfoModelImpl _$$UserRoleInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserRoleInfoModelImpl(
      userRoleId: json['user_role_id'] as String,
      userId: json['user_id'] as String,
      roleId: json['role_id'] as String,
      roleName: json['role_name'] as String,
      companyId: json['company_id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      profileImage: json['profile_image'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isDeleted: json['is_deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserRoleInfoModelImplToJson(
        _$UserRoleInfoModelImpl instance) =>
    <String, dynamic>{
      'user_role_id': instance.userRoleId,
      'user_id': instance.userId,
      'role_id': instance.roleId,
      'role_name': instance.roleName,
      'company_id': instance.companyId,
      'full_name': instance.fullName,
      'email': instance.email,
      'profile_image': instance.profileImage,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'is_deleted': instance.isDeleted,
    };
