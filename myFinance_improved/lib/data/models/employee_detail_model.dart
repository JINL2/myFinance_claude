// lib/data/models/employee_detail_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/employee_detail.dart';

part 'employee_detail_model.freezed.dart';
part 'employee_detail_model.g.dart';

@freezed
class EmployeeDetailModel with _$EmployeeDetailModel {
  const factory EmployeeDetailModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'full_name') required String fullName,
    // Note: email is not in v_user_salary view, making it optional
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'profile_image') String? profileImage,
    // Making these optional as they might be null in the database
    @JsonKey(name: 'role_id') String? roleId,
    @JsonKey(name: 'role_name') String? roleName,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'salary_id') String? salaryId,
    @JsonKey(name: 'salary_amount') double? salaryAmount,
    @JsonKey(name: 'salary_type') String? salaryType,
    // Note: currency_id is not in v_user_salary view
    @JsonKey(name: 'currency_id') String? currencyId,
    @JsonKey(name: 'symbol') String? currencySymbol,
    // Note: hire_date is not in v_user_salary view
    @JsonKey(name: 'hire_date') DateTime? hireDate,
    // Note: is_active is not in v_user_salary view
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Note: updated_at is not in v_user_salary view
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    // Note: company_name is not in v_user_salary view
    @JsonKey(name: 'company_name') String? companyName,
    // Note: store_name is not in v_user_salary view
    @JsonKey(name: 'store_name') String? storeName,
    // Note: store_id is not in v_user_salary view
    @JsonKey(name: 'store_id') String? storeId,
    // Add fields that exist in v_user_salary
    @JsonKey(name: 'currency_name') String? currencyName,
    @JsonKey(name: 'currency_code') String? currencyCode,
    @JsonKey(name: 'bonus_amount') double? bonusAmount,
  }) = _EmployeeDetailModel;

  factory EmployeeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeDetailModelFromJson(json);

  const EmployeeDetailModel._();

  // Convert to domain entity
  EmployeeDetail toEntity() {
    return EmployeeDetail(
      userId: userId,
      fullName: fullName,
      email: email,
      profileImage: profileImage,
      roleId: roleId,
      roleName: roleName,
      companyId: companyId,
      salaryId: salaryId,
      salaryAmount: salaryAmount,
      salaryType: salaryType,
      currencyId: currencyId,
      currencySymbol: currencySymbol,
      hireDate: hireDate,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      firstName: firstName,
      lastName: lastName,
      companyName: companyName,
      storeName: storeName,
      storeId: storeId,
      currencyName: currencyName,
      currencyCode: currencyCode,
      bonusAmount: bonusAmount,
    );
  }

  // Create from domain entity
  factory EmployeeDetailModel.fromEntity(EmployeeDetail entity) {
    return EmployeeDetailModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      profileImage: entity.profileImage,
      roleId: entity.roleId,
      roleName: entity.roleName,
      companyId: entity.companyId,
      salaryId: entity.salaryId,
      salaryAmount: entity.salaryAmount,
      salaryType: entity.salaryType,
      currencyId: entity.currencyId,
      currencySymbol: entity.currencySymbol,
      hireDate: entity.hireDate,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      firstName: entity.firstName,
      lastName: entity.lastName,
      companyName: entity.companyName,
      storeName: entity.storeName,
      storeId: entity.storeId,
      currencyName: entity.currencyName,
      currencyCode: entity.currencyCode,
      bonusAmount: entity.bonusAmount,
    );
  }
}