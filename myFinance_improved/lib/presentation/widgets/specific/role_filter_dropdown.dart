// lib/presentation/widgets/specific/role_filter_dropdown.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../domain/entities/role.dart';
import '../../providers/delegate_role_provider.dart';
import '../toss/toss_dropdown.dart';
import '../../../core/utils/role_color_utils.dart';

class RoleFilterDropdown extends ConsumerWidget {
  final String companyId;
  
  const RoleFilterDropdown({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(availableRolesProvider(companyId));
    final selectedRoleId = ref.watch(selectedRoleFilterProvider);
    
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        TossSpacing.space5,
        0,
        TossSpacing.space5,
        TossSpacing.space2,
      ),
      child: Row(
        children: [
          // Show current filter label or "Filter by role" text
          if (selectedRoleId != null)
            Expanded(
              child: rolesAsync.when(
                data: (roles) {
                  final selectedRole = roles.firstWhere(
                    (role) => role.roleId == selectedRoleId,
                    orElse: () => roles.first,
                  );
                  return Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space1,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedRole.roleName,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: TossSpacing.space1),
                            InkWell(
                              onTap: () {
                                ref.read(selectedRoleFilterProvider.notifier).clearFilter();
                              },
                              child: Icon(
                                Icons.close,
                                color: TossColors.primary,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            )
          else
            Expanded(
              child: Text(
                'Filter by role',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ),
          
          // Filter button with three-line icon on the right
          rolesAsync.when(
            data: (roles) {
              // Create dropdown items with "All Roles" option
              final dropdownItems = [
                TossDropdownItem<String?>(
                  value: null,
                  label: 'All Roles',
                  subtitle: 'Show all users',
                ),
                ...roles.map((role) => TossDropdownItem<String?>(
                  value: role.roleId,
                  label: role.roleName,
                  subtitle: '${role.displayRoleType} role',
                )),
              ];
              
              final selectedItem = selectedRoleId != null 
                  ? dropdownItems.firstWhere(
                      (item) => item.value == selectedRoleId,
                      orElse: () => dropdownItems.first,
                    )
                  : null;
              
              return InkWell(
                onTap: () => _showRoleSelectionSheet(context, selectedRoleId, dropdownItems, (value) {
                  if (value == null) {
                    ref.read(selectedRoleFilterProvider.notifier).clearFilter();
                  } else {
                    ref.read(selectedRoleFilterProvider.notifier).selectRole(value);
                  }
                }),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.filter_list,
                    color: selectedRoleId != null ? TossColors.primary : TossColors.gray600,
                    size: 24,
                  ),
                ),
              );
            },
            loading: () => Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.gray400),
                ),
              ),
            ),
            error: (error, _) => Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.error_outline,
                color: TossColors.error,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showRoleSelectionSheet(
    BuildContext context,
    String? selectedRoleId,
    List<TossDropdownItem<String?>> items,
    ValueChanged<String?> onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Row(
                children: [
                  Text(
                    'Select Role',
                    style: TossTextStyles.h3,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Options
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item.value == selectedRoleId;
                  
                  return InkWell(
                    onTap: () {
                      onChanged(item.value);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space5,
                        vertical: TossSpacing.space3,
                      ),
                      child: Row(
                        children: [
                          // Role indicator
                          if (item.value != null)
                            Container(
                              width: 8,
                              height: 8,
                              margin: EdgeInsets.only(right: TossSpacing.space2),
                              decoration: BoxDecoration(
                                color: RoleColorUtils.getRoleColor(item.label),
                                shape: BoxShape.circle,
                              ),
                            ),
                          
                          // Label
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.label,
                                  style: TossTextStyles.body.copyWith(
                                    color: isSelected ? TossColors.primary : TossColors.gray900,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                                if (item.subtitle != null)
                                  Text(
                                    item.subtitle!,
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          
                          // Check icon
                          if (isSelected)
                            Icon(
                              Icons.check,
                              color: TossColors.primary,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}