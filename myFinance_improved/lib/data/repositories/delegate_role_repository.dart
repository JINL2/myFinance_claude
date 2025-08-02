// lib/data/repositories/delegate_role_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_role_info.dart';
import '../../domain/entities/role.dart';
import '../models/user_role_info_model.dart';
import '../models/role_model.dart';

class DelegateRoleRepository {
  final SupabaseClient _supabase;

  DelegateRoleRepository({SupabaseClient? supabase}) 
      : _supabase = supabase ?? Supabase.instance.client;

  /// Fetch all user role information for a company
  /// Uses the v_user_role_info view from your Supabase database
  Future<List<UserRoleInfo>> getUserRolesByCompany(String companyId) async {
    try {
      final response = await _supabase
          .from('v_user_role_info')
          .select()
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .order('full_name');

      return (response as List)
          .map((json) => UserRoleInfoModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user roles: $e');
    }
  }

  /// Fetch available roles for a company (excluding owner role)
  /// Uses the roles table from your Supabase database
  Future<List<Role>> getAvailableRoles(String companyId) async {
    try {
      final response = await _supabase
          .from('roles')
          .select()
          .eq('company_id', companyId)
          .neq('role_type', 'owner')
          .eq('is_deletable', true)
          .order('created_at');

      return (response as List)
          .map((json) => RoleModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch available roles: $e');
    }
  }

  /// Update user's role assignment
  /// Updates the user_roles table
  Future<UserRoleInfo> updateUserRole({
    required String userRoleId,
    required String newRoleId,
  }) async {
    try {
      // Update the user_roles table
      final updateResponse = await _supabase
          .from('user_roles')
          .update({
            'role_id': newRoleId,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_role_id', userRoleId)
          .select()
          .single();

      // Fetch updated user role info from the view
      final userRoleResponse = await _supabase
          .from('v_user_role_info')
          .select()
          .eq('user_role_id', userRoleId)
          .single();

      return UserRoleInfoModel.fromJson(userRoleResponse).toEntity();
    } catch (e) {
      throw Exception('Failed to update user role: $e');
    }
  }

  /// Get specific role information by role ID
  Future<Role> getRoleById(String roleId) async {
    try {
      final response = await _supabase
          .from('roles')
          .select()
          .eq('role_id', roleId)
          .single();

      return RoleModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Failed to fetch role: $e');
    }
  }

  /// Check if a user can edit roles (based on their own role)
  Future<bool> canUserEditRoles({
    required String userId,
    required String companyId,
  }) async {
    try {
      final response = await _supabase
          .from('v_user_role_info')
          .select('role_name, role_type')
          .eq('user_id', userId)
          .eq('company_id', companyId)
          .single();

      final roleName = response['role_name'] as String;
      final roleType = response['role_type'] as String;
      
      // Only owners and managers can edit roles
      return roleName.toLowerCase() == 'owner' || 
             roleType.toLowerCase() == 'manager';
    } catch (e) {
      return false; // Default to no permission on error
    }
  }

  /// Get user role statistics for a company
  Future<Map<String, int>> getUserRoleStats(String companyId) async {
    try {
      final response = await _supabase
          .from('v_user_role_info')
          .select('role_name')
          .eq('company_id', companyId)
          .eq('is_deleted', false);

      final Map<String, int> stats = {};
      for (final item in response as List) {
        final roleName = item['role_name'] as String;
        stats[roleName] = (stats[roleName] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      throw Exception('Failed to fetch role statistics: $e');
    }
  }

  /// Search users by name or email within a company
  Future<List<UserRoleInfo>> searchUsers({
    required String companyId,
    required String query,
  }) async {
    try {
      final searchQuery = '%$query%';
      final response = await _supabase
          .from('v_user_role_info')
          .select()
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .or('full_name.ilike.$searchQuery,email.ilike.$searchQuery')
          .order('full_name');

      return (response as List)
          .map((json) => UserRoleInfoModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  /// Real-time subscription to user role changes
  Stream<List<UserRoleInfo>> watchUserRoles(String companyId) {
    return _supabase
        .from('v_user_role_info')
        .stream(primaryKey: ['user_role_id'])
        .eq('company_id', companyId)
        .eq('is_deleted', false)
        .order('full_name')
        .map((data) => data
            .map((json) => UserRoleInfoModel.fromJson(json).toEntity())
            .toList());
  }

  /// Bulk update multiple user roles
  Future<List<UserRoleInfo>> bulkUpdateUserRoles(
    List<({String userRoleId, String newRoleId})> updates,
  ) async {
    try {
      final List<UserRoleInfo> updatedUsers = [];
      
      // Process updates in batch
      for (final update in updates) {
        final result = await updateUserRole(
          userRoleId: update.userRoleId,
          newRoleId: update.newRoleId,
        );
        updatedUsers.add(result);
      }

      return updatedUsers;
    } catch (e) {
      throw Exception('Failed to bulk update user roles: $e');
    }
  }
}