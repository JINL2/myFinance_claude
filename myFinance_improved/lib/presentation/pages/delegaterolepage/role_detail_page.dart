// lib/presentation/pages/delegaterolepage/role_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../domain/entities/user_role_info.dart';
import '../../../domain/entities/role.dart';
import '../../providers/delegate_role_provider.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/app_error.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../../core/utils/role_color_utils.dart';

class RoleDetailPage extends ConsumerStatefulWidget {
  final UserRoleInfo user;
  
  const RoleDetailPage({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<RoleDetailPage> createState() => _RoleDetailPageState();
}

class _RoleDetailPageState extends ConsumerState<RoleDetailPage> {
  String? _selectedRoleId;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _selectedRoleId = widget.user.roleId;
  }

  @override
  Widget build(BuildContext context) {
    final availableRolesAsync = ref.watch(availableRolesProvider(widget.user.companyId));
    
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        title: Text('Edit User Role', style: TossTextStyles.h2),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information Card
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(TossSpacing.space5),
              child: Row(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: TossColors.primary.withOpacity(0.1),
                    backgroundImage: widget.user.hasProfileImage
                        ? NetworkImage(widget.user.profileImage!)
                        : null,
                    child: !widget.user.hasProfileImage
                        ? Text(
                            widget.user.initials,
                            style: TossTextStyles.h3.copyWith(
                              color: TossColors.primary,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: TossSpacing.space4),
                  
                  // User Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.displayName,
                          style: TossTextStyles.h3,
                        ),
                        SizedBox(height: TossSpacing.space1),
                        Text(
                          widget.user.email,
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        SizedBox(height: TossSpacing.space2),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: TossSpacing.space1,
                          ),
                          decoration: BoxDecoration(
                            color: RoleColorUtils.getRoleColor(widget.user.roleName).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Current: ${widget.user.roleName}',
                            style: TossTextStyles.caption.copyWith(
                              color: RoleColorUtils.getRoleColor(widget.user.roleName),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space3),
            
            // Role Selection Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(TossSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select New Role',
                    style: TossTextStyles.h3,
                  ),
                  SizedBox(height: TossSpacing.space4),
                  
                  availableRolesAsync.when(
                    data: (roles) => _buildRoleList(roles),
                    loading: () => const Center(child: AppLoading()),
                    error: (error, _) => AppError(
                      message: error.toString(),
                      onRetry: () => ref.refresh(availableRolesProvider(widget.user.companyId)),
                    ),
                  ),
                ],
              ),
            ),
            
            // Warning Message
            if (!widget.user.canEditRole)
              Container(
                margin: EdgeInsets.all(TossSpacing.space5),
                padding: EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TossColors.warning.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: TossColors.warning,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: Text(
                        'Owner roles cannot be changed for security reasons.',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.all(TossSpacing.space5),
        child: SafeArea(
          child: TossPrimaryButton(
            text: _isLoading ? 'Updating...' : 'Update Role',
            isLoading: _isLoading,
            isEnabled: _selectedRoleId != null && 
                       _selectedRoleId != widget.user.roleId && 
                       widget.user.canEditRole &&
                       !_isLoading,
            onPressed: _updateUserRole,
          ),
        ),
      ),
    );
  }
  
  Widget _buildRoleList(List<Role> roles) {
    return Column(
      children: roles.map((role) => _buildRoleOption(role)).toList(),
    );
  }
  
  Widget _buildRoleOption(Role role) {
    final isSelected = _selectedRoleId == role.roleId;
    final isCurrentRole = role.roleId == widget.user.roleId;
    
    return GestureDetector(
      onTap: widget.user.canEditRole ? () {
        setState(() {
          _selectedRoleId = role.roleId;
        });
      } : null,
      child: Container(
        margin: EdgeInsets.only(bottom: TossSpacing.space3),
        padding: EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? TossColors.primary.withOpacity(0.05) : Colors.white,
        ),
        child: Row(
          children: [
            // Role Color Indicator
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: RoleColorUtils.getRoleColor(role.roleName),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            
            // Role Info
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
                          color: isSelected ? TossColors.primary : TossColors.gray900,
                        ),
                      ),
                      if (isCurrentRole) ...[
                        SizedBox(width: TossSpacing.space2),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Current',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.success,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    role.displayRoleType,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Radio Button
            Radio<String>(
              value: role.roleId,
              groupValue: _selectedRoleId,
              onChanged: widget.user.canEditRole ? (value) {
                setState(() {
                  _selectedRoleId = value;
                });
              } : null,
              activeColor: TossColors.primary,
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _updateUserRole() async {
    if (_selectedRoleId == null || _selectedRoleId == widget.user.roleId) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final supabase = Supabase.instance.client;
      
      // Update user role
      await supabase
          .from('user_roles')
          .update({
            'role_id': _selectedRoleId,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_role_id', widget.user.userRoleId);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role updated successfully'),
            backgroundColor: TossColors.success,
          ),
        );
        
        // Refresh the user list
        ref.refresh(companyUserRolesProvider(widget.user.companyId));
        
        // Navigate back
        context.pop();
      }
    } catch (e) {
      print('Role Detail Error: Failed to update role - $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update role: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
}