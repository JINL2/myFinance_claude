import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Role service provider
final roleServiceProvider = Provider<RoleService>((ref) {
  return RoleService();
});

// Roles provider for specific company
final companyRolesProvider = FutureProvider.family<List<RoleWithPermissions>, String>((ref, companyId) async {
  final service = ref.read(roleServiceProvider);
  return service.getRolesForCompany(companyId);
});

// Features provider
final featuresProvider = FutureProvider<List<Feature>>((ref) async {
  final service = ref.read(roleServiceProvider);
  return service.getAllFeatures();
});

// Categories provider
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final service = ref.read(roleServiceProvider);
  return service.getAllCategories();
});

// Users in role provider
final usersInRoleProvider = FutureProvider.family<List<RoleUser>, String>((ref, roleId) async {
  final service = ref.read(roleServiceProvider);
  return service.getUsersInRole(roleId);
});

class RoleService {
  final _supabase = Supabase.instance.client;

  /// Get all roles for a specific company with permissions and user count
  Future<List<RoleWithPermissions>> getRolesForCompany(String companyId) async {
    try {
      // Get roles directly from roles table
      final rolesResponse = await _supabase
          .from('roles')
          .select('*')
          .eq('company_id', companyId)
          .order('role_type', ascending: true)
          .order('role_name', ascending: true);

      final roles = <RoleWithPermissions>[];
      
      for (var roleJson in rolesResponse as List) {
        // Get permissions for this role
        final permissionsResponse = await _supabase
            .from('role_permissions')
            .select('feature_id')
            .eq('role_id', roleJson['role_id'])
            .eq('can_access', true);
        
        // Create role with permissions
        final role = RoleWithPermissions(
          roleId: roleJson['role_id'] as String,
          roleName: roleJson['role_name'] as String,
          roleType: roleJson['role_type'] as String,
          companyId: roleJson['company_id'] as String,
          parentRoleId: roleJson['parent_role_id'] as String?,
          isDeletable: roleJson['is_deletable'] ?? true,
          createdAt: DateTime.parse(roleJson['created_at'] as String),
          updatedAt: roleJson['updated_at'] != null 
              ? DateTime.parse(roleJson['updated_at'] as String) 
              : null,
          permissions: permissionsResponse as List,
          tags: roleJson['tags'] != null 
              ? Map<String, dynamic>.from(roleJson['tags']) 
              : null,
          description: roleJson['description'] as String?,
          permissionCount: (permissionsResponse as List).length,
        );
        
        // Get user count for this role
        final userCountResponse = await _supabase
            .from('user_roles')
            .select('user_id')
            .eq('role_id', role.roleId)
            .eq('is_deleted', false);
        
        role.userCount = (userCountResponse as List).length;
        
        roles.add(role);
      }

      return roles;
    } catch (e) {
      print('RoleService Error: Failed to get roles: $e');
      return [];
    }
  }

  /// Get all features grouped by category
  Future<List<Feature>> getAllFeatures() async {
    try {
      final response = await _supabase
          .from('features')
          .select('*, categories!inner(category_id, name, icon)')
          .order('category_id')
          .order('feature_name');
      
      return (response as List).map((json) => Feature.fromJson(json)).toList();
    } catch (e) {
      print('RoleService Error: Failed to get features: $e');
      return [];
    }
  }

  /// Get all categories
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _supabase
          .from('categories')
          .select('*')
          .order('name');
      
      return (response as List).map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('RoleService Error: Failed to get categories: $e');
      return [];
    }
  }

  /// Create a new role
  Future<String?> createRole({
    required String companyId,
    required String roleName,
    required String roleType,
    required List<String> featureIds,
    String? description,
  }) async {
    try {
      // Create role
      final roleResponse = await _supabase
          .from('roles')
          .insert({
            'role_name': roleName,
            'role_type': roleType,
            'company_id': companyId,
            'description': description,
            'is_deletable': true,
          })
          .select()
          .single();

      final roleId = roleResponse['role_id'];

      // Create permissions
      if (featureIds.isNotEmpty) {
        final permissions = featureIds.map((featureId) => {
          'role_id': roleId,
          'feature_id': featureId,
          'can_access': true,
        }).toList();

        await _supabase.from('role_permissions').insert(permissions);
      }

      return roleId;
    } catch (e) {
      print('RoleService Error: Failed to create role: $e');
      return null;
    }
  }

  /// Update role
  Future<bool> updateRole({
    required String roleId,
    required String roleName,
    required List<String> featureIds,
    String? description,
    Map<String, dynamic>? tags,
  }) async {
    try {
      // Update role info
      await _supabase
          .from('roles')
          .update({
            'role_name': roleName,
            'description': description,
            'tags': tags,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('role_id', roleId);

      // Delete existing permissions
      await _supabase
          .from('role_permissions')
          .delete()
          .eq('role_id', roleId);

      // Create new permissions
      if (featureIds.isNotEmpty) {
        final permissions = featureIds.map((featureId) => {
          'role_id': roleId,
          'feature_id': featureId,
          'can_access': true,
        }).toList();

        await _supabase.from('role_permissions').insert(permissions);
      }

      return true;
    } catch (e) {
      print('RoleService Error: Failed to update role: $e');
      return false;
    }
  }

  /// Delete role
  Future<bool> deleteRole(String roleId) async {
    try {
      // Check if role has users
      final userCount = await _supabase
          .from('user_roles')
          .select('user_role_id')
          .eq('role_id', roleId)
          .eq('is_deleted', false);

      if ((userCount as List).isNotEmpty) {
        throw Exception('Cannot delete role with active users');
      }

      // Delete permissions first
      await _supabase
          .from('role_permissions')
          .delete()
          .eq('role_id', roleId);

      // Delete role
      await _supabase
          .from('roles')
          .delete()
          .eq('role_id', roleId);

      return true;
    } catch (e) {
      print('RoleService Error: Failed to delete role: $e');
      return false;
    }
  }

  /// Get users in a specific role
  Future<List<RoleUser>> getUsersInRole(String roleId) async {
    try {
      final response = await _supabase
          .from('user_roles')
          .select('*, users!inner(*)')
          .eq('role_id', roleId)
          .eq('is_deleted', false);
      
      return (response as List).map((json) => RoleUser.fromJson(json)).toList();
    } catch (e) {
      print('RoleService Error: Failed to get users in role: $e');
      return [];
    }
  }
}

// Models
class RoleWithPermissions {
  final String roleId;
  final String roleName;
  final String roleType;
  final String companyId;
  final String? parentRoleId;
  final bool isDeletable;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<dynamic> permissions;
  final Map<String, dynamic>? tags;
  final String? description;
  int userCount;
  int permissionCount;

  RoleWithPermissions({
    required this.roleId,
    required this.roleName,
    required this.roleType,
    required this.companyId,
    this.parentRoleId,
    required this.isDeletable,
    required this.createdAt,
    this.updatedAt,
    required this.permissions,
    this.tags,
    this.description,
    this.userCount = 0,
    this.permissionCount = 0,
  });

  factory RoleWithPermissions.fromJson(Map<String, dynamic> json) {
    // Handle permissions which might be null or different types
    List<dynamic> permissionsList = [];
    if (json['permissions'] != null) {
      if (json['permissions'] is List) {
        permissionsList = json['permissions'] as List;
      } else if (json['permissions'] is String) {
        // If it's a JSON string, try to parse it
        try {
          permissionsList = [];
        } catch (e) {
          print('Failed to parse permissions: ${json['permissions']}');
        }
      }
    }
    
    return RoleWithPermissions(
      roleId: json['role_id'] as String,
      roleName: json['role_name'] as String,
      roleType: json['role_type'] as String,
      companyId: json['company_id'] as String,
      parentRoleId: json['parent_role_id'] as String?,
      isDeletable: json['is_deletable'] ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      permissions: permissionsList,
    );
  }

  // Get permission feature IDs
  List<String> get featureIds {
    if (permissions is List) {
      return permissions.map((p) {
        if (p is Map && p['feature_id'] != null) {
          return p['feature_id'].toString();
        }
        return '';
      }).where((id) => id.isNotEmpty).toList();
    }
    return [];
  }

  // Check if role can be edited
  bool get canEdit => isDeletable && roleType != 'owner';
}

class Feature {
  final String featureId;
  final String featureName;
  final String? icon;
  final String? route;
  final String categoryId;
  final Map<String, dynamic>? category;

  Feature({
    required this.featureId,
    required this.featureName,
    this.icon,
    this.route,
    required this.categoryId,
    this.category,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      featureId: json['feature_id'] as String,
      featureName: json['feature_name'] as String,
      icon: json['icon'] as String?,
      route: json['route'] as String?,
      categoryId: json['category_id'] as String,
      category: json['categories'] as Map<String, dynamic>?,
    );
  }

  String get categoryName => category?['name'] ?? 'Unknown';
  String get categoryIcon => category?['icon'] ?? '📦';
}

class Category {
  final String categoryId;
  final String name;
  final String? icon;

  Category({
    required this.categoryId,
    required this.name,
    this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
    );
  }
}

class RoleUser {
  final String userRoleId;
  final String userId;
  final String roleId;
  final Map<String, dynamic> user;
  final DateTime? createdAt;

  RoleUser({
    required this.userRoleId,
    required this.userId,
    required this.roleId,
    required this.user,
    this.createdAt,
  });

  factory RoleUser.fromJson(Map<String, dynamic> json) {
    return RoleUser(
      userRoleId: json['user_role_id'] as String,
      userId: json['user_id'] as String,
      roleId: json['role_id'] as String,
      user: json['users'] as Map<String, dynamic>,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  String get firstName => user['first_name'] ?? '';
  String get lastName => user['last_name'] ?? '';
  String get email => user['email'] ?? '';
  String? get profileImage => user['profile_image'];
  
  String get fullName => '$firstName $lastName'.trim();
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }
}