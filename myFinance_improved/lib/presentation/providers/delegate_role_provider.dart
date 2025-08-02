// lib/presentation/providers/delegate_role_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_role_info.dart';
import '../../domain/entities/role.dart';
import 'app_state_provider.dart';

// Simple provider for user roles without code generation
final companyUserRolesProvider = FutureProvider.family<List<UserRoleInfo>, String>((ref, companyId) async {
  try {
    final supabase = Supabase.instance.client;
    
    // Fetch user roles from v_user_role_info view
    final response = await supabase
        .from('v_user_role_info')
        .select()
        .eq('company_id', companyId)
        .eq('is_deleted', false)
        .order('role_name')
        .order('full_name');
    
    print('Delegate Role: Fetched ${response.length} user roles for company $companyId');
    
    // Convert response to UserRoleInfo entities
    return response.map<UserRoleInfo>((json) => UserRoleInfo(
      userRoleId: json['user_role_id'] as String,
      userId: json['user_id'] as String,
      roleId: json['role_id'] as String,
      roleName: json['role_name'] as String,
      companyId: json['company_id'] as String,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImage: json['profile_image'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : DateTime.parse(json['created_at'] as String), // Use created_at if updated_at is null
      isDeleted: json['is_deleted'] as bool? ?? false,
    )).toList();
  } catch (e) {
    print('Delegate Role Error: Failed to fetch user roles - $e');
    throw Exception('Failed to fetch user roles: $e');
  }
});

// Available roles provider
final availableRolesProvider = FutureProvider.family<List<Role>, String>((ref, companyId) async {
  try {
    final supabase = Supabase.instance.client;
    
    // Fetch available roles from roles table (excluding owner role)
    final response = await supabase
        .from('roles')
        .select()
        .eq('company_id', companyId)
        .neq('role_type', 'owner') // Exclude owner role from assignment
        .order('role_name');
    
    print('Delegate Role: Fetched ${response.length} available roles for company $companyId');
    
    // Convert response to Role entities
    return response.map<Role>((json) => Role(
      roleId: json['role_id'] as String,
      roleName: json['role_name'] as String,
      roleType: json['role_type'] as String? ?? 'custom',
      companyId: json['company_id'] as String,
      parentRoleId: json['parent_role_id'] as String?,
      isDeletable: json['is_deletable'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    )).toList();
  } catch (e) {
    print('Delegate Role Error: Failed to fetch available roles - $e');
    throw Exception('Failed to fetch available roles: $e');
  }
});

// Search query provider
final userSearchProvider = StateNotifierProvider<UserSearchNotifier, String>((ref) {
  return UserSearchNotifier();
});

class UserSearchNotifier extends StateNotifier<String> {
  UserSearchNotifier() : super('');

  void updateQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

// Role filter provider
final selectedRoleFilterProvider = StateNotifierProvider<SelectedRoleFilterNotifier, String?>((ref) {
  return SelectedRoleFilterNotifier();
});

class SelectedRoleFilterNotifier extends StateNotifier<String?> {
  SelectedRoleFilterNotifier() : super(null);

  void selectRole(String? roleId) {
    state = roleId;
  }

  void clearFilter() {
    state = null;
  }
}

// Selected users for bulk operations
final selectedUsersProvider = StateNotifierProvider<SelectedUsersNotifier, Set<String>>((ref) {
  return SelectedUsersNotifier();
});

class SelectedUsersNotifier extends StateNotifier<Set<String>> {
  SelectedUsersNotifier() : super(<String>{});

  void toggleUser(String userRoleId) {
    if (state.contains(userRoleId)) {
      state = {...state}..remove(userRoleId);
    } else {
      state = {...state, userRoleId};
    }
  }

  void clearSelection() {
    state = <String>{};
  }
}

// Role update loading states
final roleUpdateLoadingProvider = StateNotifierProvider<RoleUpdateLoadingNotifier, Set<String>>((ref) {
  return RoleUpdateLoadingNotifier();
});

class RoleUpdateLoadingNotifier extends StateNotifier<Set<String>> {
  RoleUpdateLoadingNotifier() : super(<String>{});

  void setLoading(String userRoleId) {
    state = {...state, userRoleId};
  }

  void clearLoading(String userRoleId) {
    state = {...state}..remove(userRoleId);
  }
}

// Filtered user roles based on search and role filter
final filteredUserRolesProvider = FutureProvider.family<List<UserRoleInfo>, String>((ref, companyId) async {
  final users = await ref.watch(companyUserRolesProvider(companyId).future);
  final searchQuery = ref.watch(userSearchProvider);
  final selectedRoleId = ref.watch(selectedRoleFilterProvider);

  var filteredUsers = users;

  // Apply role filter if selected
  if (selectedRoleId != null) {
    filteredUsers = filteredUsers.where((user) => user.roleId == selectedRoleId).toList();
  }

  // Apply search filter if query exists
  if (searchQuery.isNotEmpty) {
    final query = searchQuery.toLowerCase();
    filteredUsers = filteredUsers.where((user) {
      return user.fullName.toLowerCase().contains(query) ||
             user.email.toLowerCase().contains(query) ||
             user.roleName.toLowerCase().contains(query);
    }).toList();
  }

  return filteredUsers;
});

// Permission check for current user
final canEditRolesProvider = FutureProvider.family<bool, (String, String)>((ref, params) async {
  final (userId, companyId) = params;
  
  // TODO: Implement proper permission check
  // For now, return true to allow editing for testing
  return true;
  
  /*
  try {
    final supabase = Supabase.instance.client;
    
    // Check if user has permission to edit roles
    // Usually this would check for admin/owner role or specific permissions
    final response = await supabase
        .from('user_roles')
        .select('role_id, roles!inner(role_type, permissions)')
        .eq('user_id', userId)
        .eq('company_id', companyId)
        .single();
    
    // Check if user is owner or has role management permission
    final roleType = response['roles']['role_type'] as String?;
    final permissions = response['roles']['permissions'] as List?;
    
    return roleType == 'owner' || 
           roleType == 'admin' ||
           (permissions?.contains('manage_roles') ?? false);
  } catch (e) {
    print('Delegate Role Error: Failed to check permissions - $e');
    // Return false if permission check fails
    return false;
  }
  */
});

// Current user ID provider - reuse from app state
final currentUserIdProvider = Provider<String?>((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.userWithCompanies?.userId;
});