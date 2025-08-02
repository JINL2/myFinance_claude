# Employee Settings Page - Implementation Guide 🛠️

## Overview

This guide provides a step-by-step approach to implementing the improved Employee Settings page for the myFinance application, transforming it from a basic salary viewer to a comprehensive employee management system.

## Project Structure

```
lib/presentation/pages/employee_settings/
├── employee_settings_page.dart          # Main page widget
├── models/
│   ├── employee_detail.dart            # Employee data models
│   └── employee_filter.dart            # Filter options model
├── providers/
│   ├── employee_provider.dart          # State management
│   └── employee_filter_provider.dart   # Filter state
├── widgets/
│   ├── employee_card.dart              # List item component
│   ├── employee_detail_modal.dart      # Detail view modal
│   ├── employee_filter_panel.dart      # Filter sidebar
│   ├── salary_update_form.dart         # Salary edit form
│   ├── attendance_summary.dart         # Attendance widget
│   └── performance_chart.dart          # Performance visuals
└── services/
    └── employee_service.dart           # Data access layer
```

## Phase 1: Basic Implementation (Week 1-2)

### 1.1 Create Data Models

```dart
// lib/domain/entities/employee_detail.dart
class EmployeeDetail {
  final String userId;
  final String fullName;
  final String email;
  final String? profileImage;
  final String roleId;
  final String roleName;
  final String companyId;
  final String? salaryId;
  final double? salaryAmount;
  final String? salaryType;
  final String? currencyId;
  final String? currencySymbol;
  final DateTime? hireDate;
  final bool isActive;
  
  // Constructor, copyWith, fromJson, etc.
}
```

### 1.2 Set Up Repository

```dart
// lib/data/repositories/employee_repository.dart
class EmployeeRepository {
  final SupabaseClient _supabase;
  
  Future<List<EmployeeDetail>> getEmployees(String companyId) async {
    final response = await _supabase
      .from('v_user_salary')
      .select('*')
      .eq('company_id', companyId)
      .order('full_name');
      
    return response.map((e) => EmployeeDetail.fromJson(e)).toList();
  }
  
  Future<void> updateSalary(UpdateSalaryParams params) async {
    await _supabase.rpc('update_user_salary', params: params.toJson());
  }
}
```

### 1.3 Create Provider

```dart
// lib/presentation/providers/employee_provider.dart
@riverpod
class EmployeeNotifier extends _$EmployeeNotifier {
  @override
  Future<List<EmployeeDetail>> build() async {
    final companyId = ref.watch(selectedCompanyProvider);
    return ref.watch(employeeRepositoryProvider).getEmployees(companyId);
  }
  
  Future<void> updateEmployeeSalary(String salaryId, double amount) async {
    // Implementation
  }
}
```

### 1.4 Build Main Page

```dart
// lib/presentation/pages/employee_settings/employee_settings_page.dart
class EmployeeSettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(employeeNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      body: Row(
        children: [
          // Filter Panel
          EmployeeFilterPanel(),
          
          // Employee List
          Expanded(
            child: employeesAsync.when(
              data: (employees) => ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) => EmployeeCard(
                  employee: employees[index],
                  onTap: () => _showEmployeeDetail(context, employees[index]),
                ),
              ),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => ErrorWidget(error),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addNewEmployee(context),
        label: Text('Add Employee'),
        icon: Icon(Icons.person_add),
      ),
    );
  }
}
```

### 1.5 Create Employee Card Widget

```dart
// lib/presentation/widgets/employee_card.dart
class EmployeeCard extends StatelessWidget {
  final EmployeeDetail employee;
  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        margin: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space2,
        ),
        padding: EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          boxShadow: TossShadows.shadow2,
        ),
        child: Row(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 32,
              backgroundImage: employee.profileImage != null
                ? NetworkImage(employee.profileImage!)
                : null,
              child: employee.profileImage == null
                ? Text(employee.initials)
                : null,
            ),
            SizedBox(width: TossSpacing.space4),
            
            // Employee Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(employee.fullName, style: TossTextStyles.h3),
                  SizedBox(height: TossSpacing.space1),
                  RoleChip(roleName: employee.roleName),
                  SizedBox(height: TossSpacing.space2),
                  SalaryDisplay(
                    amount: employee.salaryAmount,
                    type: employee.salaryType,
                    currency: employee.currencySymbol,
                  ),
                ],
              ),
            ),
            
            // Quick Actions
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => _showQuickActions(context, employee),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Phase 2: Employee Detail Modal (Week 2-3)

### 2.1 Create Detail Modal

```dart
// lib/presentation/widgets/employee_detail_modal.dart
class EmployeeDetailModal extends StatelessWidget {
  final EmployeeDetail employee;
  
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(TossBorderRadius.xxl),
          ),
        ),
        child: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(employee),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    ProfileTab(employee: employee),
                    CompensationTab(employee: employee),
                    AttendanceTab(employee: employee),
                    PermissionsTab(employee: employee),
                    HistoryTab(employee: employee),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 2.2 Implement Compensation Tab

```dart
// lib/presentation/widgets/tabs/compensation_tab.dart
class CompensationTab extends ConsumerWidget {
  final EmployeeDetail employee;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Salary Section
          _SalaryCard(employee: employee),
          SizedBox(height: TossSpacing.space4),
          
          // Salary History
          _SalaryHistoryTimeline(userId: employee.userId),
          SizedBox(height: TossSpacing.space4),
          
          // Total Compensation Breakdown
          _CompensationBreakdown(employee: employee),
        ],
      ),
    );
  }
}

class _SalaryCard extends StatelessWidget {
  final EmployeeDetail employee;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Current Salary', style: TossTextStyles.h3),
                TextButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                  onPressed: () => _showSalaryEditDialog(context),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            Text(
              '${employee.currencySymbol}${employee.salaryAmount}',
              style: TossTextStyles.amount,
            ),
            Text(
              employee.salaryType == 'monthly' ? 'per month' : 'per hour',
              style: TossTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
```

## Phase 3: Advanced Features (Week 3-4)

### 3.1 Implement Attendance Integration

```dart
// lib/presentation/widgets/attendance_summary.dart
class AttendanceSummary extends ConsumerWidget {
  final String userId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceProvider(userId));
    
    return attendanceAsync.when(
      data: (stats) => Card(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Last 30 Days', style: TossTextStyles.h3),
              SizedBox(height: TossSpacing.space3),
              _buildMetricRow('Attendance Rate', '${stats.attendanceRate}%'),
              _buildMetricRow('Late Arrivals', '${stats.lateCount}'),
              _buildMetricRow('Overtime Hours', '${stats.overtimeHours}h'),
              _buildMetricRow('Leaves Taken', '${stats.leavesTaken}'),
            ],
          ),
        ),
      ),
      loading: () => ShimmerCard(),
      error: (error, stack) => ErrorCard(error: error),
    );
  }
}
```

### 3.2 Add Real-time Updates

```dart
// lib/presentation/providers/employee_realtime_provider.dart
@riverpod
Stream<List<EmployeeDetail>> employeeRealtime(
  EmployeeRealtimeRef ref,
  String companyId,
) {
  final supabase = ref.watch(supabaseClientProvider);
  
  return supabase
    .from('v_user_salary:company_id=eq.$companyId')
    .stream(primaryKey: ['user_id'])
    .map((data) => data.map((e) => EmployeeDetail.fromJson(e)).toList());
}
```

### 3.3 Implement Search & Filter

```dart
// lib/presentation/providers/employee_filter_provider.dart
@riverpod
class EmployeeFilter extends _$EmployeeFilter {
  @override
  EmployeeFilterState build() => EmployeeFilterState();
  
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
  
  void toggleActiveOnly(bool value) {
    state = state.copyWith(activeOnly: value);
  }
  
  void setRoleFilter(String? roleId) {
    state = state.copyWith(selectedRoleId: roleId);
  }
}

// Apply filters
@riverpod
List<EmployeeDetail> filteredEmployees(FilteredEmployeesRef ref) {
  final employees = ref.watch(employeeNotifierProvider).valueOrNull ?? [];
  final filter = ref.watch(employeeFilterProvider);
  
  return employees.where((employee) {
    // Search query
    if (filter.searchQuery.isNotEmpty) {
      final query = filter.searchQuery.toLowerCase();
      if (!employee.fullName.toLowerCase().contains(query) &&
          !employee.email.toLowerCase().contains(query)) {
        return false;
      }
    }
    
    // Active filter
    if (filter.activeOnly && !employee.isActive) {
      return false;
    }
    
    // Role filter
    if (filter.selectedRoleId != null && 
        employee.roleId != filter.selectedRoleId) {
      return false;
    }
    
    return true;
  }).toList();
}
```

## Phase 4: Performance & Polish (Week 4)

### 4.1 Add Loading States

```dart
// lib/presentation/widgets/shimmer_loading.dart
class EmployeeCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: TossColors.gray200,
      highlightColor: TossColors.gray100,
      child: Container(
        height: 120,
        margin: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
      ),
    );
  }
}
```

### 4.2 Implement Error Handling

```dart
// lib/presentation/widgets/error_handling.dart
class EmployeeErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: TossColors.error),
          SizedBox(height: TossSpacing.space4),
          Text(
            'Unable to load employees',
            style: TossTextStyles.h3,
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            _getErrorMessage(error),
            style: TossTextStyles.body,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: TossSpacing.space4),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh),
            label: Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
```

### 4.3 Add Analytics

```dart
// lib/presentation/widgets/employee_analytics.dart
class EmployeeAnalyticsDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(employeeAnalyticsProvider);
    
    return analyticsAsync.when(
      data: (analytics) => Column(
        children: [
          _SalaryDistributionChart(data: analytics.salaryDistribution),
          _DepartmentBreakdown(data: analytics.departmentStats),
          _RetentionMetrics(data: analytics.retentionStats),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

## Testing Strategy

### Unit Tests
```dart
// test/repositories/employee_repository_test.dart
void main() {
  group('EmployeeRepository', () {
    test('getEmployees returns list of employees', () async {
      // Test implementation
    });
    
    test('updateSalary calls RPC function correctly', () async {
      // Test implementation
    });
  });
}
```

### Widget Tests
```dart
// test/widgets/employee_card_test.dart
void main() {
  testWidgets('EmployeeCard displays employee information', (tester) async {
    // Test implementation
  });
}
```

### Integration Tests
```dart
// integration_test/employee_settings_test.dart
void main() {
  testWidgets('Full employee settings flow', (tester) async {
    // Test implementation
  });
}
```

## Deployment Checklist

- [ ] All features implemented and tested
- [ ] Performance optimized (< 3s load time)
- [ ] Error handling comprehensive
- [ ] Accessibility standards met
- [ ] Responsive design verified
- [ ] Security review completed
- [ ] Documentation updated
- [ ] User training materials prepared

## Next Steps

1. **Immediate Actions**:
   - Create project structure
   - Implement basic employee list
   - Set up state management

2. **Short-term Goals** (1 month):
   - Complete Phase 1 & 2
   - Begin user testing
   - Gather feedback

3. **Long-term Vision** (3-6 months):
   - Implement advanced analytics
   - Add AI-powered insights
   - Integrate with external HR systems

## Support & Resources

- Design Specifications: `EMPLOYEE_SETTINGS_DESIGN_SPEC.md`
- Database Guide: `DATABASE_GUIDE_FOR_BEGINNERS.md`
- Enhanced Features: `ENHANCED_FEATURES_RESEARCH.md`
- Toss Design System: `docs/design-system/`

Remember: Start simple, iterate based on user feedback, and maintain the clean Toss-style aesthetic throughout!