// lib/presentation/pages/employee_settings/widgets/tabs/permissions_tab.dart

import 'package:flutter/material.dart';
import '../../../../../core/themes/toss_colors.dart';
import '../../../../../core/themes/toss_spacing.dart';
import '../../../../../core/themes/toss_text_styles.dart';
import '../../../../../core/themes/toss_border_radius.dart';
import '../../../../../core/themes/toss_shadows.dart';
import '../../../../../domain/entities/employee_detail.dart';

class PermissionsTab extends StatelessWidget {
  final EmployeeDetail employee;

  const PermissionsTab({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Role
          _buildRoleCard(),
          SizedBox(height: TossSpacing.space4),

          // Feature Permissions
          _buildPermissionsCard(),
        ],
      ),
    );
  }

  Widget _buildRoleCard() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.shadow2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Role',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              TextButton.icon(
                icon: Icon(Icons.swap_horiz, size: 18),
                label: Text('Change Role'),
                onPressed: () {
                  // TODO: Implement role change
                },
                style: TextButton.styleFrom(
                  foregroundColor: TossColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space3),
          
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user,
                  color: TossColors.primary,
                  size: 32,
                ),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.roleName ?? 'Unknown',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Role ID: ${employee.roleId ?? ''}',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsCard() {
    // Mock permissions - in real app, fetch from role_permissions
    final permissions = [
      {'name': 'View Dashboard', 'allowed': true},
      {'name': 'Manage Inventory', 'allowed': true},
      {'name': 'Process Transactions', 'allowed': true},
      {'name': 'View Reports', 'allowed': false},
      {'name': 'Manage Employees', 'allowed': false},
      {'name': 'System Settings', 'allowed': false},
    ];

    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.shadow2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feature Permissions',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          ...permissions.map((permission) => _buildPermissionItem(
            permission['name'] as String,
            permission['allowed'] as bool,
          )),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(String name, bool allowed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          Icon(
            allowed ? Icons.check_circle : Icons.cancel,
            color: allowed ? TossColors.success : TossColors.gray400,
            size: 20,
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Text(
              name,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
          ),
          Text(
            allowed ? 'Allowed' : 'Restricted',
            style: TossTextStyles.label.copyWith(
              color: allowed ? TossColors.success : TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}