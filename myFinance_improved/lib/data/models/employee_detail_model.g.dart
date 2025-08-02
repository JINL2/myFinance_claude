// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeDetailModelImpl _$$EmployeeDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EmployeeDetailModelImpl(
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String?,
      profileImage: json['profile_image'] as String?,
      roleId: json['role_id'] as String?,
      roleName: json['role_name'] as String?,
      companyId: json['company_id'] as String,
      salaryId: json['salary_id'] as String?,
      salaryAmount: (json['salary_amount'] as num?)?.toDouble(),
      salaryType: json['salary_type'] as String?,
      currencyId: json['currency_id'] as String?,
      currencySymbol: json['symbol'] as String?,
      hireDate: json['hire_date'] == null
          ? null
          : DateTime.parse(json['hire_date'] as String),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      companyName: json['company_name'] as String?,
      storeName: json['store_name'] as String?,
      storeId: json['store_id'] as String?,
      currencyName: json['currency_name'] as String?,
      currencyCode: json['currency_code'] as String?,
      bonusAmount: (json['bonus_amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$EmployeeDetailModelImplToJson(
        _$EmployeeDetailModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'full_name': instance.fullName,
      'email': instance.email,
      'profile_image': instance.profileImage,
      'role_id': instance.roleId,
      'role_name': instance.roleName,
      'company_id': instance.companyId,
      'salary_id': instance.salaryId,
      'salary_amount': instance.salaryAmount,
      'salary_type': instance.salaryType,
      'currency_id': instance.currencyId,
      'symbol': instance.currencySymbol,
      'hire_date': instance.hireDate?.toIso8601String(),
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'company_name': instance.companyName,
      'store_name': instance.storeName,
      'store_id': instance.storeId,
      'currency_name': instance.currencyName,
      'currency_code': instance.currencyCode,
      'bonus_amount': instance.bonusAmount,
    };
