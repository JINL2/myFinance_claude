// lib/presentation/widgets/specific/role_update_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_role_info.dart';
import '../../../domain/entities/role.dart';
import '../../providers/delegate_role_provider.dart';
import '../../providers/app_state_provider.dart';
import '../toss/toss_primary_button.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';

class RoleUpdateModal extends ConsumerStatefulWidget {
  final UserRoleInfo user;
  final VoidCallback? onRoleUpdated;

  const RoleUpdateModal({
    super.key,
    required this.user,
    this.onRoleUpdated,
  });

  @override
  ConsumerState<RoleUpdateModal> createState() => _RoleUpdateModalState();
}

class _RoleUpdateModalState extends ConsumerState<RoleUpdateModal> {
  String? selectedRoleId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedRoleId = widget.user.roleId;
  }

  @override
  Widget build(BuildContext context) {
    final companyId = ref.watch(selectedCompanyIdProvider);
    if (companyId == null) {
      return _buildError('No company selected');
    }

    final availableRolesAsync = ref.watch(availableRolesProvider(companyId));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            margin: EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: TossSpacing.space5),

          // Title
          Text(
            'Update User Role',
            style: TossTextStyles.h3,
          ),
          SizedBox(height: TossSpacing.space4),

          // User Info
          Container(
            margin: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Avatar
                _buildUserAvatar(),
                SizedBox(width: TossSpacing.space3),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.displayName,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        widget.user.email,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: TossSpacing.space5),

          // Role Selection
          availableRolesAsync.when(
            data: (roles) => _buildRoleSelection(roles),
            loading: () => Padding(
              padding: EdgeInsets.all(TossSpacing.space8),
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => _buildError(error.toString()),
          ),

          SizedBox(height: TossSpacing.space5),

          // Action Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Row(
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: TossColors.gray300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                    ),
                    child: Text(
                      'Cancel',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                // Update Button
                Expanded(
                  child: TossPrimaryButton(
                    text: isLoading ? 'Updating...' : 'Update Role',
                    isLoading: isLoading,
                    isEnabled: selectedRoleId != null && 
                              selectedRoleId != widget.user.roleId,
                    onPressed: _updateRole,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space5),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    if (widget.user.hasProfileImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          widget.user.profileImage!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
        ),
      );
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: TossColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          widget.user.initials,
          style: TossTextStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelection(List<Role> roles) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select New Role',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ), 
          SizedBox(height: TossSpacing.space3),
          ...roles.map((role) => _buildRoleOption(role)).toList(),
        ],
      ),
    );
  }

  Widget _buildRoleOption(Role role) {
    final isSelected = selectedRoleId == role.roleId;
    final isCurrent = role.roleId == widget.user.roleId;

    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : () {
            setState(() {
              selectedRoleId = role.roleId;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected 
                    ? TossColors.primary 
                    : TossColors.gray200,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected 
                  ? TossColors.primary.withOpacity(0.05)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                // Radio button
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected 
                          ? TossColors.primary 
                          : TossColors.gray300,
                      width: 2,
                    ),
                    color: isSelected 
                        ? TossColors.primary 
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        )
                      : null,
                ),
                SizedBox(width: TossSpacing.space3),
                
                // Role info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            role.roleName,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected 
                                  ? TossColors.primary 
                                  : TossColors.gray900,
                            ),
                          ),
                          if (isCurrent) ...[
                            SizedBox(width: TossSpacing.space2),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: TossSpacing.space2,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Current',
                                style: TossTextStyles.caption.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        role.displayRoleType,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Padding(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: TossColors.error,
          ),
          SizedBox(height: TossSpacing.space3),
          Text(
            'Error',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.error,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            message,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _updateRole() async {
    if (selectedRoleId == null || selectedRoleId == widget.user.roleId) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // TODO: Implement actual role update via Supabase
      // For now just simulate success
      await Future.delayed(const Duration(milliseconds: 1000));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh the provider
        ref.refresh(companyUserRolesProvider(widget.user.companyId));
        widget.onRoleUpdated?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update role: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}