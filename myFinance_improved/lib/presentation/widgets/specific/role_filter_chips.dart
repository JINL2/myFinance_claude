// lib/presentation/widgets/specific/role_filter_chips.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../domain/entities/role.dart';
import '../../providers/delegate_role_provider.dart';

class RoleFilterChips extends ConsumerWidget {
  final String companyId;
  
  const RoleFilterChips({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(availableRolesProvider(companyId));
    final selectedRoleId = ref.watch(selectedRoleFilterProvider);
    
    return rolesAsync.when(
      data: (roles) {
        if (roles.isEmpty) {
          return const SizedBox.shrink();
        }
        
        // Add "All" option at the beginning
        final allRoles = [
          Role(
            roleId: 'all',
            roleName: 'All Roles',
            roleType: 'all',
            companyId: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          ...roles,
        ];
        
        return Container(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            itemCount: allRoles.length,
            separatorBuilder: (_, __) => SizedBox(width: TossSpacing.space2),
            itemBuilder: (context, index) {
              final role = allRoles[index];
              final isSelected = role.roleId == 'all' 
                  ? selectedRoleId == null
                  : selectedRoleId == role.roleId;
                  
              return FilterChip(
                selected: isSelected,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (role.roleId != 'all') ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getRoleColor(role.roleType),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space1),
                    ],
                    Text(
                      role.roleName,
                      style: TossTextStyles.caption.copyWith(
                        color: isSelected ? Colors.white : TossColors.gray700,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                backgroundColor: TossColors.gray100,
                selectedColor: TossColors.primary,
                checkmarkColor: Colors.white,
                onSelected: (selected) {
                  if (role.roleId == 'all') {
                    ref.read(selectedRoleFilterProvider.notifier).clearFilter();
                  } else {
                    ref.read(selectedRoleFilterProvider.notifier).selectRole(
                      selected ? role.roleId : null
                    );
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? TossColors.primary : TossColors.gray300,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                showCheckmark: false,
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space1,
                ),
              );
            },
          ),
        );
      },
      loading: () => Container(
        height: 40,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(TossColors.gray400),
            ),
          ),
        ),
      ),
      error: (error, _) => const SizedBox.shrink(),
    );
  }
  
  Color _getRoleColor(String roleType) {
    switch (roleType.toLowerCase()) {
      case 'owner':
        return TossColors.error;
      case 'admin':
        return TossColors.warning;
      case 'manager':
        return TossColors.primary;
      case 'employee':
        return TossColors.success;
      default:
        return TossColors.gray500;
    }
  }
}