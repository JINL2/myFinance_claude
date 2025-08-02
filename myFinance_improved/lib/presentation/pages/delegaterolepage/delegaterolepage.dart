// lib/presentation/pages/delegaterole/delegate_role_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/toss/toss_card.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/app_error.dart';
import '../../widgets/specific/user_role_list_item.dart';
import '../../widgets/specific/role_update_modal.dart';
import '../../widgets/specific/role_filter_dropdown.dart';
import '../../providers/delegate_role_provider.dart';
import '../../providers/app_state_provider.dart';
import '../../../domain/entities/user_role_info.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/utils/role_color_utils.dart';
import '../../../domain/entities/role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DelegateRolePage extends ConsumerWidget {
  const DelegateRolePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCompanyId = ref.watch(selectedCompanyIdProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);
    
    if (selectedCompanyId == null) {
      return _buildNoCompanySelected();
    }

    final userRolesAsync = ref.watch(filteredUserRolesProvider(selectedCompanyId));
    final searchQuery = ref.watch(userSearchProvider);
    final selectedUsers = ref.watch(selectedUsersProvider);
    final currentUserId = ref.watch(currentUserIdProvider) ?? '';
    final canEdit = ref.watch(canEditRolesProvider((currentUserId, selectedCompanyId)));

    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: const Color(0xFF1A1A1A),
          surface: Colors.white,
          background: Colors.white,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
        title: Text(
          'Delegate Role',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: TossColors.gray900,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TossColors.gray900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (selectedUsers.isNotEmpty)
            IconButton(
              icon: Icon(Icons.more_vert, color: TossColors.gray900),
              onPressed: () => _showBulkActions(context, ref),
            ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
          // Company Header
          if (selectedCompany != null)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                TossSpacing.space5,
                TossSpacing.space3,
                TossSpacing.space5,
                TossSpacing.space4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCompany.companyName,
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    'Manage user roles and permissions',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  // Show edit hint if user has permission
                  if (canEdit.valueOrNull == true) ...[
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      'Click user row to change their role',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // Search Bar
          Container(
            color: Colors.white,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.fromLTRB(
              TossSpacing.space5,
              0,
              TossSpacing.space5,
              TossSpacing.space3,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: TossColors.gray500,
                  size: 20,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: TossColors.gray500,
                          size: 20,
                        ),
                        onPressed: () => ref.read(userSearchProvider.notifier).clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: TossColors.gray300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: TossColors.gray300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: TossColors.gray400, width: 1.5),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space2,
                ),
                fillColor: TossColors.gray50,
                filled: true,
              ),
              style: TossTextStyles.body,
              onChanged: (value) {
                ref.read(userSearchProvider.notifier).updateQuery(value);
              },
            ),
          ),

          // Role Filter Dropdown
          RoleFilterDropdown(companyId: selectedCompanyId),

          // User List
          Expanded(
            child: userRolesAsync.when(
              data: (users) => _buildUserList(context, ref, users, canEdit),
              loading: () => const AppLoading(),
              error: (error, stack) => AppError(
                message: error.toString(),
                onRetry: () => ref.refresh(companyUserRolesProvider(selectedCompanyId)),
              ),
            ),
          ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildNoCompanySelected() {
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        title: Text(
          'Delegate Role',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business,
              size: 64,
              color: TossColors.gray300,
            ),
            SizedBox(height: TossSpacing.space4),
            Text(
              'No Company Selected',
              style: TossTextStyles.h3,
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Please select a company to manage user roles',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(
    BuildContext context,
    WidgetRef ref,
    List<UserRoleInfo> users,
    AsyncValue<bool> canEditAsync,
  ) {
    if (users.isEmpty) {
      return _buildEmptyState();
    }

    final canEdit = canEditAsync.valueOrNull ?? false;
    final selectedUsers = ref.watch(selectedUsersProvider);

    return RefreshIndicator(
      color: TossColors.primary,
      backgroundColor: Colors.white,
      onRefresh: () async {
        final companyId = ref.read(selectedCompanyIdProvider);
        if (companyId != null) {
          await ref.refresh(companyUserRolesProvider(companyId).future);
        }
      },
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        child: ListView.separated(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            TossSpacing.space5,
            TossSpacing.space2,
            TossSpacing.space5,
            TossSpacing.space5,
          ),
          itemCount: users.length,
          separatorBuilder: (_, __) => SizedBox(height: TossSpacing.space3),
          itemBuilder: (context, index) {
            final user = users[index];
            final isLoading = ref.watch(roleUpdateLoadingProvider).contains(user.userRoleId);
            final isSelected = selectedUsers.contains(user.userRoleId);

            return UserRoleListItem(
              user: user,
              canEdit: canEdit,
              isLoading: isLoading,
              isSelected: isSelected,
              onTap: () => _showRoleSelectionSheet(context, ref, user),
              onLongPress: canEdit 
                  ? () => ref.read(selectedUsersProvider.notifier).toggleUser(user.userRoleId)
                  : null,
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: TossColors.gray300,
          ),
          SizedBox(height: TossSpacing.space4),
          Text(
            'No Users Found',
            style: TossTextStyles.h3,
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            'No users match your search criteria',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  void _showRoleSelectionSheet(
    BuildContext context,
    WidgetRef ref,
    UserRoleInfo user,
  ) async {
    final availableRolesAsync = ref.read(availableRolesProvider(user.companyId));
    
    if (!availableRolesAsync.hasValue) {
      // Load roles if not available
      return;
    }
    
    final roles = availableRolesAsync.value!;
    String? selectedRoleId = user.roleId;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
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
                
                // User info header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                  child: Row(
                    children: [
                      // Avatar
                      _buildUserAvatar(user),
                      SizedBox(width: TossSpacing.space3),
                      
                      // User details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName,
                              style: TossTextStyles.h3,
                            ),
                            SizedBox(height: TossSpacing.space1),
                            Text(
                              user.email,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: TossSpacing.space5),
                
                // Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                  child: Row(
                    children: [
                      Text(
                        'Select New Role',
                        style: TossTextStyles.h3,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: TossSpacing.space4),
                
                // Role options
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                    itemCount: roles.length,
                    itemBuilder: (context, index) {
                      final role = roles[index];
                      final isSelected = selectedRoleId == role.roleId;
                      final isCurrentRole = role.roleId == user.roleId;
                      
                      return GestureDetector(
                        onTap: user.canEditRole ? () {
                          setModalState(() {
                            selectedRoleId = role.roleId;
                          });
                        } : null,
                        child: Container(
                          margin: EdgeInsets.only(bottom: TossSpacing.space3),
                          padding: EdgeInsets.all(TossSpacing.space4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? TossColors.primary : TossColors.gray300,
                              width: 2,
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
                                groupValue: selectedRoleId,
                                onChanged: user.canEditRole ? (value) {
                                  setModalState(() {
                                    selectedRoleId = value;
                                  });
                                } : null,
                                activeColor: TossColors.primary,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Warning message for owner role
                if (!user.canEditRole)
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
                
                // Update button
                Padding(
                  padding: EdgeInsets.all(TossSpacing.space5),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedRoleId != null && 
                                selectedRoleId != user.roleId && 
                                user.canEditRole
                          ? () => _updateUserRole(context, ref, user, selectedRoleId!)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                        disabledBackgroundColor: TossColors.gray300,
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Update Role',
                        style: TossTextStyles.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildUserAvatar(UserRoleInfo user) {
    if (user.hasProfileImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          user.profileImage!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(user),
        ),
      );
    }
    return _buildDefaultAvatar(user);
  }

  Widget _buildDefaultAvatar(UserRoleInfo user) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: TossColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          user.initials,
          style: TossTextStyles.body.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  
  Future<void> _updateUserRole(
    BuildContext context,
    WidgetRef ref,
    UserRoleInfo user,
    String newRoleId,
  ) async {
    try {
      final supabase = Supabase.instance.client;
      
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      // Update user role
      await supabase
          .from('user_roles')
          .update({
            'role_id': newRoleId,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_role_id', user.userRoleId);
      
      // Dismiss loading
      Navigator.pop(context);
      // Dismiss bottom sheet
      Navigator.pop(context);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Role updated successfully'),
          backgroundColor: TossColors.success,
        ),
      );
      
      // Refresh the user list
      ref.refresh(companyUserRolesProvider(user.companyId));
      
    } catch (e) {
      // Dismiss loading
      Navigator.pop(context);
      
      print('Failed to update role: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update role: ${e.toString()}'),
          backgroundColor: TossColors.error,
        ),
      );
    }
  }

  void _showBulkActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              'Bulk Actions',
              style: TossTextStyles.h3,
            ),
            SizedBox(height: TossSpacing.space4),

            // Actions
            ListTile(
              leading: Icon(Icons.swap_horiz, color: TossColors.primary),
              title: const Text('Change Role'),
              subtitle: Text('${ref.read(selectedUsersProvider).length} users selected'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement bulk role change
              },
            ),
            ListTile(
              leading: Icon(Icons.clear, color: TossColors.gray600),
              title: const Text('Clear Selection'),
              onTap: () {
                ref.read(selectedUsersProvider.notifier).clearSelection();
                Navigator.pop(context);
              },
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space3),
          ],
        ),
      ),
    );
  }
}

