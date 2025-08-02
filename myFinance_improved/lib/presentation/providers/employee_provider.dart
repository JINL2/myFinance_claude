// lib/presentation/providers/employee_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/employee_detail.dart';
import '../../domain/entities/employee_filter.dart';
import '../../data/repositories/employee_repository.dart';
import '../providers/app_state_provider.dart';
import '../providers/supabase_provider.dart';

// Employee repository provider
final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return EmployeeRepository(supabase: supabase);
});

// Stream provider for real-time employee updates
final employeesStreamProvider = StreamProvider<List<EmployeeDetail>>((ref) {
  final repository = ref.watch(employeeRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.selectedCompanyId ?? '';
  
  if (companyId.isEmpty) {
    return Stream.value([]);
  }
  
  return repository.streamEmployees(companyId);
});

// Employee filter state provider
final employeeFilterProvider = StateNotifierProvider<EmployeeFilterNotifier, EmployeeFilter>(
  (ref) => EmployeeFilterNotifier(),
);

class EmployeeFilterNotifier extends StateNotifier<EmployeeFilter> {
  EmployeeFilterNotifier() : super(const EmployeeFilter());

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleActiveOnly(bool value) {
    state = state.copyWith(activeOnly: value);
  }

  void setRoleFilter(String? roleId) {
    state = state.copyWith(selectedRoleId: roleId);
  }

  void setStoreFilter(String? storeId) {
    state = state.copyWith(selectedStoreId: storeId);
  }

  void setSortBy(EmployeeSortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void toggleSortOrder() {
    state = state.copyWith(sortAscending: !state.sortAscending);
  }

  void clearFilters() {
    state = const EmployeeFilter();
  }
}

// Filtered employees provider
final filteredEmployeesProvider = Provider<List<EmployeeDetail>>((ref) {
  final employeesAsync = ref.watch(employeesStreamProvider);
  final filter = ref.watch(employeeFilterProvider);
  
  return employeesAsync.when(
    data: (employees) {
      var filtered = employees;
      
      // Apply search filter
      if (filter.searchQuery.isNotEmpty) {
        final query = filter.searchQuery.toLowerCase();
        filtered = filtered.where((e) =>
          e.fullName.toLowerCase().contains(query) ||
          (e.email?.toLowerCase().contains(query) ?? false) ||
          (e.roleName?.toLowerCase().contains(query) ?? false)
        ).toList();
      }
      
      // Apply active filter
      if (filter.activeOnly) {
        filtered = filtered.where((e) => e.isActive).toList();
      }
      
      // Apply role filter
      if (filter.selectedRoleId != null) {
        filtered = filtered.where((e) => e.roleId == filter.selectedRoleId).toList();
      }
      
      // Apply store filter
      if (filter.selectedStoreId != null) {
        filtered = filtered.where((e) => e.storeId == filter.selectedStoreId).toList();
      }
      
      // Apply sorting
      filtered.sort((a, b) {
        int comparison;
        switch (filter.sortBy) {
          case EmployeeSortBy.name:
            comparison = a.fullName.compareTo(b.fullName);
            break;
          case EmployeeSortBy.role:
            comparison = (a.roleName ?? '').compareTo(b.roleName ?? '');
            break;
          case EmployeeSortBy.salary:
            final aSalary = a.salaryAmount ?? 0;
            final bSalary = b.salaryAmount ?? 0;
            comparison = aSalary.compareTo(bSalary);
            break;
          case EmployeeSortBy.joinDate:
            final aDate = a.createdAt ?? DateTime.now();
            final bDate = b.createdAt ?? DateTime.now();
            comparison = aDate.compareTo(bDate);
            break;
        }
        return filter.sortAscending ? comparison : -comparison;
      });
      
      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provider for fetching attendance data
final employeeAttendanceProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, userId) async {
    final repository = ref.watch(employeeRepositoryProvider);
    return repository.getEmployeeAttendance(userId);
  },
);

// Provider for fetching currencies
final currenciesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(employeeRepositoryProvider);
  return repository.getCurrencies();
});

// Provider for fetching company roles
final companyRolesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(employeeRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.selectedCompanyId ?? '';
  
  if (companyId.isEmpty) {
    return [];
  }
  
  return repository.getCompanyRoles(companyId);
});

// Provider for fetching company stores
final companyStoresProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(employeeRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.selectedCompanyId ?? '';
  
  if (companyId.isEmpty) {
    return [];
  }
  
  return repository.getCompanyStores(companyId);
});

// Selected employee provider for detail view
final selectedEmployeeProvider = StateProvider<EmployeeDetail?>((ref) => null);