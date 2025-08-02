// lib/presentation/pages/employee_settings/widgets/employee_filter_panel.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/utils/role_color_utils.dart';
import '../../../../domain/entities/employee_filter.dart';
import '../../../providers/employee_provider.dart';

class EmployeeFilterPanel extends ConsumerWidget {
  final bool isMobile;

  const EmployeeFilterPanel({
    super.key,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(employeeFilterProvider);
    final rolesAsync = ref.watch(companyRolesProvider);
    final storesAsync = ref.watch(companyStoresProvider);
    final employees = ref.watch(employeesStreamProvider);

    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                if (filter != const EmployeeFilter())
                  TextButton(
                    onPressed: () {
                      ref.read(employeeFilterProvider.notifier).clearFilters();
                    },
                    child: Text(
                      'Clear All',
                      style: TossTextStyles.label.copyWith(
                        color: TossColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: TossSpacing.space4),

            // Status Filter
            _buildStatusFilter(context, ref, filter),
            SizedBox(height: TossSpacing.space4),

            // Role Filter
            _buildRoleFilter(context, ref, filter, rolesAsync),
            SizedBox(height: TossSpacing.space4),

            // Store Filter
            _buildStoreFilter(context, ref, filter, storesAsync),
            SizedBox(height: TossSpacing.space4),

            // Sort Options
            _buildSortOptions(context, ref, filter),
            
            if (isMobile) SizedBox(height: TossSpacing.space8),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter(
    BuildContext context,
    WidgetRef ref,
    EmployeeFilter filter,
  ) {
    return _buildFilterSection(
      title: 'Status',
      child: Column(
        children: [
          _buildCheckboxItem(
            'Active Only',
            filter.activeOnly,
            (value) {
              ref.read(employeeFilterProvider.notifier).toggleActiveOnly(value!);
            },
            TossColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleFilter(
    BuildContext context,
    WidgetRef ref,
    EmployeeFilter filter,
    AsyncValue<List<Map<String, dynamic>>> rolesAsync,
  ) {
    return _buildFilterSection(
      title: 'Role',
      child: rolesAsync.when(
        data: (roles) => Column(
          children: [
            _buildRadioItem(
              'All',
              null,
              filter.selectedRoleId,
              (value) {
                ref.read(employeeFilterProvider.notifier).setRoleFilter(null);
              },
            ),
            ...roles.map((role) => _buildRadioItem(
              role['role_name'] as String,
              role['role_id'] as String,
              filter.selectedRoleId,
              (value) {
                ref.read(employeeFilterProvider.notifier).setRoleFilter(value);
              },
              RoleColorUtils.getRoleColor(role['role_name'] as String),
            )),
          ],
        ),
        loading: () => _buildLoadingPlaceholder(),
        error: (_, __) => _buildErrorPlaceholder('Failed to load roles'),
      ),
    );
  }

  Widget _buildStoreFilter(
    BuildContext context,
    WidgetRef ref,
    EmployeeFilter filter,
    AsyncValue<List<Map<String, dynamic>>> storesAsync,
  ) {
    return _buildFilterSection(
      title: 'Store',
      child: storesAsync.when(
        data: (stores) => Column(
          children: [
            _buildRadioItem(
              'All Stores',
              null,
              filter.selectedStoreId,
              (value) {
                ref.read(employeeFilterProvider.notifier).setStoreFilter(null);
              },
            ),
            ...stores.map((store) => _buildRadioItem(
              store['store_name'] as String,
              store['store_id'] as String,
              filter.selectedStoreId,
              (value) {
                ref.read(employeeFilterProvider.notifier).setStoreFilter(value);
              },
            )),
          ],
        ),
        loading: () => _buildLoadingPlaceholder(),
        error: (_, __) => _buildErrorPlaceholder('Failed to load stores'),
      ),
    );
  }

  Widget _buildSortOptions(
    BuildContext context,
    WidgetRef ref,
    EmployeeFilter filter,
  ) {
    return _buildFilterSection(
      title: 'Sort By',
      child: Column(
        children: [
          ...EmployeeSortBy.values.map((sortBy) => _buildRadioItem(
            _getSortByLabel(sortBy),
            sortBy,
            filter.sortBy,
            (value) {
              ref.read(employeeFilterProvider.notifier).setSortBy(value!);
            },
          )),
          SizedBox(height: TossSpacing.space2),
          Row(
            children: [
              Text(
                'Order:',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              IconButton(
                icon: Icon(
                  filter.sortAscending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                  color: TossColors.primary,
                  size: 20,
                ),
                onPressed: () {
                  ref.read(employeeFilterProvider.notifier).toggleSortOrder();
                },
              ),
              Text(
                filter.sortAscending ? 'Ascending' : 'Descending',
                style: TossTextStyles.label.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        child,
      ],
    );
  }

  Widget _buildCheckboxItem(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
    Color? color,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: color ?? TossColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                label,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioItem<T>(
    String label,
    T value,
    T? groupValue,
    ValueChanged<T?> onChanged,
    [Color? indicatorColor]
  ) {
    final isSelected = value == groupValue;
    
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space2,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.gray100 : Colors.transparent,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Radio<T>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: TossColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            if (indicatorColor != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: TossSpacing.space2),
            ],
            Expanded(
              child: Text(
                label,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Text(
        message,
        style: TossTextStyles.bodySmall.copyWith(
          color: TossColors.error,
        ),
      ),
    );
  }

  String _getSortByLabel(EmployeeSortBy sortBy) {
    switch (sortBy) {
      case EmployeeSortBy.name:
        return 'Name';
      case EmployeeSortBy.role:
        return 'Role';
      case EmployeeSortBy.salary:
        return 'Salary';
      case EmployeeSortBy.joinDate:
        return 'Join Date';
    }
  }
}