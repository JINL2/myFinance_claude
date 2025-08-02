// lib/domain/entities/employee_filter.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_filter.freezed.dart';

@freezed
class EmployeeFilter with _$EmployeeFilter {
  const factory EmployeeFilter({
    @Default('') String searchQuery,
    @Default(true) bool activeOnly,
    String? selectedRoleId,
    String? selectedStoreId,
    @Default(EmployeeSortBy.name) EmployeeSortBy sortBy,
    @Default(true) bool sortAscending,
  }) = _EmployeeFilter;
}

enum EmployeeSortBy {
  name,
  role,
  salary,
  joinDate,
}