// lib/presentation/pages/employee_settings/widgets/employee_card.dart

import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_shadows.dart';
import '../../../../core/utils/role_color_utils.dart';
import '../../../../domain/entities/employee_detail.dart';

class EmployeeCard extends StatelessWidget {
  final EmployeeDetail employee;
  final VoidCallback onTap;
  final VoidCallback? onMorePressed;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onTap,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          boxShadow: TossShadows.shadow2,
        ),
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Row(
            children: [
              // Profile Image
              _buildProfileImage(),
              SizedBox(width: TossSpacing.space4),
              
              // Employee Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Name
                    Text(
                      employee.fullName,
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: TossSpacing.space1),
                    
                    // Role and Store
                    Row(
                      children: [
                        _buildRoleChip(),
                        if (employee.storeName != null) ...[
                          SizedBox(width: TossSpacing.space2),
                          Flexible(
                            child: Text(
                              employee.storeName!,
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: TossSpacing.space2),
                    
                    // Salary and Status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            employee.displaySalary,
                            style: TossTextStyles.bodyLarge.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'JetBrains Mono',
                            ),
                          ),
                        ),
                        _buildStatusIndicator(),
                      ],
                    ),
                  ],
                ),
              ),
              
              // More Options
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: TossColors.gray600,
                ),
                onPressed: onMorePressed ?? () => _showQuickActions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (employee.profileImage != null && employee.profileImage!.isNotEmpty) {
      return CircleAvatar(
        radius: 32,
        backgroundImage: NetworkImage(employee.profileImage!),
        backgroundColor: TossColors.gray200,
      );
    } else {
      return CircleAvatar(
        radius: 32,
        backgroundColor: TossColors.primary.withOpacity(0.1),
        child: Text(
          employee.initials,
          style: TossTextStyles.h3.copyWith(
            color: TossColors.primary,
          ),
        ),
      );
    }
  }

  Widget _buildRoleChip() {
    final roleColor = RoleColorUtils.getRoleColor(employee.roleName ?? 'Unknown');
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: roleColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        employee.roleName ?? 'Unknown',
        style: TossTextStyles.labelSmall.copyWith(
          color: roleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    final isActive = employee.isActive;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? TossColors.success : TossColors.gray400,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: TossSpacing.space1),
        Text(
          isActive ? 'Active' : 'Inactive',
          style: TossTextStyles.labelSmall.copyWith(
            color: isActive ? TossColors.success : TossColors.gray600,
          ),
        ),
      ],
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: TossSpacing.space3,
          bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
            ),
            SizedBox(height: TossSpacing.space4),
            
            // Employee info header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Row(
                children: [
                  _buildProfileImage(),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.fullName,
                          style: TossTextStyles.h3,
                        ),
                        Text(
                          employee.roleName ?? 'Unknown',
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
            
            SizedBox(height: TossSpacing.space4),
            Divider(color: TossColors.gray200),
            
            // Quick actions
            _buildActionItem(
              icon: Icons.edit_outlined,
              label: 'Edit Details',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement edit
              },
            ),
            _buildActionItem(
              icon: Icons.attach_money,
              label: 'Adjust Salary',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement salary adjustment
              },
            ),
            _buildActionItem(
              icon: Icons.swap_horiz,
              label: 'Change Role',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement role change
              },
            ),
            _buildActionItem(
              icon: Icons.event_note,
              label: 'View Attendance',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement attendance view
              },
            ),
            Divider(color: TossColors.gray200),
            _buildActionItem(
              icon: employee.isActive ? Icons.block : Icons.check_circle_outline,
              label: employee.isActive ? 'Deactivate' : 'Activate',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement status toggle
              },
              isDestructive: employee.isActive,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? TossColors.error : TossColors.gray700;
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(width: TossSpacing.space3),
            Text(
              label,
              style: TossTextStyles.bodyLarge.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}