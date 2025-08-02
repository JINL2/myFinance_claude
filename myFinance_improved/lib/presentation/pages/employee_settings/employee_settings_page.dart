// lib/presentation/pages/employee_settings/employee_settings_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../providers/employee_provider.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/toss/toss_button.dart';
import 'widgets/employee_card.dart';
import 'widgets/employee_filter_panel.dart';
import 'widgets/employee_search_bar.dart';
import 'widgets/employee_detail_modal.dart';
import 'widgets/employee_loading_shimmer.dart';

class EmployeeSettingsPage extends ConsumerStatefulWidget {
  const EmployeeSettingsPage({super.key});

  static const String routeName = 'employeeSettings';
  static const String routePath = '/employeeSettings';

  @override
  ConsumerState<EmployeeSettingsPage> createState() => _EmployeeSettingsPageState();
}

class _EmployeeSettingsPageState extends ConsumerState<EmployeeSettingsPage> {
  bool _isFilterPanelOpen = true;

  void _toggleFilterPanel() {
    setState(() {
      _isFilterPanelOpen = !_isFilterPanelOpen;
    });
  }

  void _showEmployeeDetail(BuildContext context, employee) {
    ref.read(selectedEmployeeProvider.notifier).state = employee;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EmployeeDetailModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.selectedCompanyId;
    
    // Debug logging
    print('Employee Settings - Company ID: $companyId');
    print('Employee Settings - Has Company: ${companyId != null && companyId.isNotEmpty}');
    
    final employees = ref.watch(filteredEmployeesProvider);
    final employeesAsync = ref.watch(employeesStreamProvider);
    final isTablet = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        backgroundColor: TossColors.background,
        elevation: 0,
        title: Text(
          'Employee Settings',
          style: TossTextStyles.h2.copyWith(
            color: TossColors.gray900,
          ),
        ),
        actions: [
          if (!isTablet)
            IconButton(
              icon: Icon(
                _isFilterPanelOpen ? Icons.filter_list_off : Icons.filter_list,
                color: TossColors.gray700,
              ),
              onPressed: _toggleFilterPanel,
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: TossColors.gray700),
            onPressed: () {
              ref.invalidate(employeesStreamProvider);
            },
          ),
          const SizedBox(width: TossSpacing.space2),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space2,
            ),
            child: const EmployeeSearchBar(),
          ),
          
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Filter Panel (Desktop/Tablet)
                if (isTablet && _isFilterPanelOpen)
                  SizedBox(
                    width: 280,
                    child: Container(
                      color: TossColors.gray50,
                      child: const EmployeeFilterPanel(),
                    ),
                  ),
                
                // Employee List
                Expanded(
                  child: Container(
                    color: TossColors.background,
                    child: employeesAsync.when(
                      data: (_) {
                        if (companyId == null || companyId.isEmpty) {
                          return _buildNoCompanyState();
                        }
                        return employees.isEmpty 
                          ? _buildEmptyState()
                          : _buildEmployeeList(employees);
                      },
                      loading: () => const EmployeeLoadingShimmer(),
                      error: (error, stack) {
                        print('Employee Settings Error: $error');
                        print('Stack trace: $stack');
                        return _buildErrorState(error);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement add employee
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Add employee feature coming soon'),
              backgroundColor: TossColors.primary,
            ),
          );
        },
        backgroundColor: TossColors.primary,
        icon: const Icon(Icons.person_add),
        label: Text(
          'Add Employee',
          style: TossTextStyles.labelLarge.copyWith(color: Colors.white),
        ),
      ),
      
      // Mobile Filter Drawer
      drawer: !isTablet 
        ? Drawer(
            child: Container(
              color: TossColors.background,
              child: const EmployeeFilterPanel(isMobile: true),
            ),
          )
        : null,
    );
  }

  Widget _buildEmployeeList(List<dynamic> employees) {
    return ListView.builder(
      padding: EdgeInsets.all(TossSpacing.space4),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return Padding(
          padding: EdgeInsets.only(bottom: TossSpacing.space3),
          child: EmployeeCard(
            employee: employee,
            onTap: () => _showEmployeeDetail(context, employee),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final filter = ref.watch(employeeFilterProvider);
    final hasFilters = filter.searchQuery.isNotEmpty || 
                      filter.selectedRoleId != null || 
                      filter.selectedStoreId != null ||
                      !filter.activeOnly;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.search_off : Icons.people_outline,
              size: 64,
              color: TossColors.gray400,
            ),
            SizedBox(height: TossSpacing.space4),
            Text(
              hasFilters ? 'No employees match your filters' : 'No employees found',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray700,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              hasFilters 
                ? 'Try adjusting your search or filters'
                : 'Add your first employee to get started',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              SizedBox(height: TossSpacing.space6),
              TextButton(
                onPressed: () {
                  ref.read(employeeFilterProvider.notifier).clearFilters();
                },
                child: Text(
                  'Clear Filters',
                  style: TossTextStyles.labelLarge.copyWith(
                    color: TossColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNoCompanyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
              size: 64,
              color: TossColors.gray400,
            ),
            SizedBox(height: TossSpacing.space4),
            Text(
              'No company selected',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray700,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Please select a company from the homepage first',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: TossSpacing.space6),
            TossButton(
              text: 'Go to Homepage',
              onPressed: () {
                context.go('/homepage');
              },
              size: TossButtonSize.medium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: TossColors.error,
            ),
            SizedBox(height: TossSpacing.space4),
            Text(
              'Unable to load employees',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Please check your internet connection and try again',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: TossSpacing.space6),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(employeesStreamProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space6,
                  vertical: TossSpacing.space3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}