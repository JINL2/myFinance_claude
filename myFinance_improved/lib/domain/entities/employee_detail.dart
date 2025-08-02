// lib/domain/entities/employee_detail.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_detail.freezed.dart';

@freezed
class EmployeeDetail with _$EmployeeDetail {
  const factory EmployeeDetail({
    required String userId,
    required String fullName,
    String? email, // Making optional as it's not in v_user_salary
    String? profileImage,
    String? roleId, // Making optional as it might be null
    String? roleName, // Making optional as it might be null
    required String companyId,
    String? salaryId,
    double? salaryAmount,
    String? salaryType,
    String? currencyId,
    String? currencySymbol,
    DateTime? hireDate,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Additional fields from v_user_salary view
    String? firstName,
    String? lastName,
    String? companyName,
    String? storeName,
    String? storeId,
    String? currencyName,
    String? currencyCode,
    double? bonusAmount,
  }) = _EmployeeDetail;

  const EmployeeDetail._();

  // Computed properties
  String get initials {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '';
  }

  String get displaySalary {
    if (salaryAmount == null) return 'Not set';
    final amount = salaryAmount!.toStringAsFixed(
      salaryAmount! % 1 == 0 ? 0 : 2,
    );
    final symbol = currencySymbol ?? '\$';
    final type = salaryType == 'hourly' ? '/hr' : '/mo';
    return '$symbol$amount$type';
  }

  String get status {
    if (!isActive) return 'Inactive';
    // Add more status logic here if needed
    return 'Active';
  }
}