# Role Management Implementation Guide

## 📋 Analysis Summary

### Current FlutterFlow Implementation
- **Purpose**: RBAC system for company role management
- **Data**: `view_roles_with_permissions` Supabase view  
- **RPCs**: `create_role`, `update_role`, `delete_role`
- **Features**: View, create, edit, delete roles with permissions

### Enhanced Features Planned
- **Real-time Search** - Filter roles by name
- **Usage Analytics** - Role assignment statistics  
- **Role Templates** - Quick setup templates
- **Permission Risk Indicators** - Color-coded permission levels
- **Bulk Operations** - Multiple permission selection

## 📁 File Structure (Following PAGE_SETUP_GUIDE.md)

```
lib/presentation/pages/delegaterole/
├── delegate_role_page.dart          # Main role list page (역할 목록)
├── delegate_role_create_page.dart   # Create new role (역할 생성)  
└── delegate_role_detail_page.dart   # Edit role details (역할 편집)

lib/presentation/widgets/specific/
├── role_list_item.dart              # Individual role display
├── role_permission_selector.dart    # Permission checkboxes
├── role_template_selector.dart      # Quick templates
└── role_analytics_card.dart         # Usage statistics

lib/presentation/providers/
├── delegate_role_provider.dart      # Main state management
└── role_permissions_provider.dart   # Permission categories

lib/domain/entities/
├── role.dart                        # Role entity
└── permission_category.dart         # Permission structure

lib/data/models/
├── role_model.dart                  # Supabase model
└── permission_model.dart            # Permission structure
```

## 🎨 UI Design (Using Toss Components)

### Main Page: Role Management
```dart
class DelegateRolePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(companyRolesProvider);
    
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        title: Text('Role Management', style: TossTextStyles.h2),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(TossSpacing.space5),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search roles...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: BorderSide(color: TossColors.gray300),
                ),
              ),
              onChanged: (value) {
                ref.read(roleSearchProvider.notifier).state = value;
              },
            ),
          ),
          
          // Role List
          Expanded(
            child: rolesAsync.when(
              data: (roles) => _buildRoleList(roles),
              loading: () => const AppLoading(),
              error: (error, stack) => AppError(
                message: error.toString(),
                onRetry: () => ref.refresh(companyRolesProvider),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateRoleSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Create Role'),
        backgroundColor: TossColors.primary,
      ),
    );
  }
  
  Widget _buildRoleList(List<Role> roles) {
    if (roles.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.separated(
      padding: EdgeInsets.all(TossSpacing.space5),
      itemCount: roles.length,
      separatorBuilder: (_, __) => SizedBox(height: TossSpacing.space3),
      itemBuilder: (context, index) {
        final role = roles[index];
        return RoleListItem(
          role: role,
          onTap: () => _navigateToRoleDetail(context, role),
          onEdit: () => _showEditRoleSheet(context, ref, role),
          onDelete: role.canBeDeleted 
              ? () => _showDeleteConfirmation(context, ref, role)
              : null,
        );
      },
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.admin_panel_settings_outlined,
            size: 64,
            color: TossColors.gray300,
          ),
          SizedBox(height: TossSpacing.space4),
          Text(
            'No roles found',
            style: TossTextStyles.h3,
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            'Create your first role to get started',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Role List Item (Toss Card Style)
```dart
class RoleListItem extends StatelessWidget {
  final Role role;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  @override
  Widget build(BuildContext context) {
    return TossCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Role Icon & Info
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _getRoleColor(role.roleType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  _getRoleIcon(role.roleType),
                  color: _getRoleColor(role.roleType),
                  size: 24,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.roleName,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      '${role.permissions.length} permissions',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // User Count Badge
              if (role.userCount > 0)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '${role.userCount} users',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              
              // More Options
              IconButton(
                onPressed: () => _showActionSheet(context),
                icon: Icon(Icons.more_vert, color: TossColors.gray400),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Permission Preview
          Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space1,
            children: role.permissions.take(3).map((permission) =>
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: Text(
                  _getPermissionDisplayName(permission),
                  style: TossTextStyles.caption,
                ),
              ),
            ).toList()
              ..add(
                if (role.permissions.length > 3)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    child: Text(
                      '+${role.permissions.length - 3} more',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ),
              ),
          ),
        ],
      ),
    );
  }
}
```

### Create/Edit Role Sheet
```dart
void _showCreateRoleSheet(BuildContext context, WidgetRef ref) {
  TossBottomSheet.show(
    context: context,
    title: 'Create New Role',
    isScrollControlled: true,
    content: DependsOn(
      builder: (context, ref) {
        return CreateRoleForm(
          onSubmit: (roleName, permissions) async {
            // Create role logic
            Navigator.pop(context);
          },
        );
      },
    ),
  );
}

class CreateRoleForm extends ConsumerStatefulWidget {
  final Function(String roleName, List<String> permissions) onSubmit;
  
  @override
  ConsumerState<CreateRoleForm> createState() => _CreateRoleFormState();
}

class _CreateRoleFormState extends ConsumerState<CreateRoleForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final Set<String> _selectedPermissions = {};
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    final permissionCategories = ref.watch(permissionCategoriesProvider);
    
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role Name Input
          Text('Role Name', style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          )),
          SizedBox(height: TossSpacing.space2),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'e.g. Manager, Employee, Accountant',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a role name';
              }
              return null;
            },
          ),
          
          SizedBox(height: TossSpacing.space6),
          
          // Role Templates
          Text('Quick Setup', style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          )),
          SizedBox(height: TossSpacing.space2),
          RoleTemplateSelector(
            onTemplateSelected: (permissions) {
              setState(() {
                _selectedPermissions.clear();
                _selectedPermissions.addAll(permissions);
              });
            },
          ),
          
          SizedBox(height: TossSpacing.space6),
          
          // Permission Selection
          Text('Permissions', style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          )),
          SizedBox(height: TossSpacing.space2),
          
          permissionCategories.when(
            data: (categories) => RolePermissionSelector(
              categories: categories,
              selectedPermissions: _selectedPermissions,
              onPermissionsChanged: (permissions) {
                setState(() {
                  _selectedPermissions.clear();
                  _selectedPermissions.addAll(permissions);
                });
              },
            ),
            loading: () => const AppLoading(),
            error: (error, _) => Text('Unable to load permissions'),
          ),
          
          SizedBox(height: TossSpacing.space6),
          
          // Submit Button
          TossPrimaryButton(
            text: _isLoading ? 'Creating...' : 'Create Role',
            isLoading: _isLoading,
            isEnabled: _nameController.text.isNotEmpty && 
                      _selectedPermissions.isNotEmpty,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;
                });
                
                try {
                  await widget.onSubmit(
                    _nameController.text,
                    _selectedPermissions.toList(),
                  );
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
```

## 🔄 State Management (Riverpod)

```dart
// lib/presentation/providers/delegate_role_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/role.dart';
import '../../data/services/supabase_service.dart';

part 'delegate_role_provider.g.dart';

// Company roles provider
@riverpod
class CompanyRoles extends _$CompanyRoles {
  @override
  Future<List<Role>> build() async {
    final companyId = ref.watch(selectedCompanyIdProvider);
    if (companyId == null) return [];
    
    final supabase = ref.watch(supabaseServiceProvider);
    
    // Fetch from view_roles_with_permissions
    final response = await supabase.client
        .from('view_roles_with_permissions')
        .select()
        .eq('company_id', companyId)
        .neq('role_type', 'owner')
        .order('created_at');
    
    return response.map((json) => RoleModel.fromJson(json).toEntity()).toList();
  }
  
  Future<void> createRole({
    required String roleName,
    required List<String> permissions,
  }) async {
    final companyId = ref.read(selectedCompanyIdProvider);
    if (companyId == null) throw Exception('Please select a company');
    
    final supabase = ref.read(supabaseServiceProvider);
    
    await supabase.client.rpc('create_role', {
      'p_company_id': companyId,
      'p_role_name': roleName,
      'p_role_type': 'custom',
      'p_permissions': permissions,
    });
    
    // Refresh the list
    ref.invalidateSelf();
  }
  
  Future<void> updateRole({
    required String roleId,
    required String roleName,
    required List<String> permissions,
  }) async {
    final companyId = ref.read(selectedCompanyIdProvider);
    if (companyId == null) throw Exception('Please select a company');
    
    final supabase = ref.read(supabaseServiceProvider);
    
    await supabase.client.rpc('update_role', {
      'p_role_id': roleId,
      'p_role_name': roleName,
      'p_role_type': 'custom',
      'p_permissions': permissions,
      'p_company_id': companyId,
    });
    
    ref.invalidateSelf();
  }
  
  Future<void> deleteRole(String roleId) async {
    final supabase = ref.read(supabaseServiceProvider);
    
    await supabase.client.rpc('delete_role', {
      'p_role_id': roleId,
    });
    
    ref.invalidateSelf();
  }
}

// Search functionality
@riverpod
class RoleSearch extends _$RoleSearch {
  @override
  String build() => '';
  
  void updateQuery(String query) {
    state = query;
  }
}

// Filtered roles
@riverpod
List<Role> filteredRoles(FilteredRolesRef ref) {
  final roles = ref.watch(companyRolesProvider).valueOrNull ?? [];
  final searchQuery = ref.watch(roleSearchProvider);
  
  if (searchQuery.isEmpty) return roles;
  
  return roles.where((role) {
    return role.roleName.toLowerCase().contains(searchQuery.toLowerCase());
  }).toList();
}

// Permission categories
@riverpod
class PermissionCategories extends _$PermissionCategories {
  @override
  Future<List<PermissionCategory>> build() async {
    // Get from app state or fetch from Supabase
    final appState = ref.watch(appStateProvider);
    return appState.valueOrNull?.categoryFeatures ?? [];
  }
}
```

## 📱 Navigation & Router Updates

```dart
// lib/presentation/app/app_router.dart
// Add these routes:

GoRoute(
  path: '/role-management',
  name: 'role-management',
  builder: (context, state) => const DelegateRolePage(),
  routes: [
    GoRoute(
      path: '/create',
      name: 'role-create',
      builder: (context, state) => const DelegateRoleCreatePage(),
    ),
    GoRoute(
      path: '/:roleId',
      name: 'role-detail',
      builder: (context, state) {
        final roleId = state.pathParameters['roleId']!;
        return DelegateRoleDetailPage(roleId: roleId);
      },
    ),
  ],
),
```

## 🎯 Key Features Implementation

### 1. Role Templates (Quick Setup)
```dart
class RoleTemplateSelector extends StatelessWidget {
  final Function(List<String>) onTemplateSelected;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: RoleTemplate.templates.map((template) =>
            OutlinedButton.icon(
              onPressed: () => onTemplateSelected(template.permissions),
              icon: Icon(template.icon, size: 16),
              label: Text(template.name),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: TossColors.gray300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
              ),
            ),
          ).toList(),
        ),
      ],
    );
  }
}

class RoleTemplate {
  final String name;
  final IconData icon;
  final List<String> permissions;
  
  const RoleTemplate({
    required this.name,
    required this.icon,
    required this.permissions,
  });
  
  static const List<RoleTemplate> templates = [
    RoleTemplate(
      name: 'Manager',
      icon: Icons.supervisor_account,
      permissions: ['view_reports', 'manage_inventory', 'view_transactions'],
    ),
    RoleTemplate(
      name: 'Cashier',
      icon: Icons.point_of_sale,
      permissions: ['process_sales', 'view_products', 'handle_returns'],
    ),
    RoleTemplate(
      name: 'Accountant',
      icon: Icons.account_balance,
      permissions: ['view_financials', 'manage_accounts', 'generate_reports'],
    ),
  ];
}
```

### 2. Permission Risk Indicators
```dart
class PermissionItem extends StatelessWidget {
  final Permission permission;
  final bool isSelected;
  final ValueChanged<bool> onChanged;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? TossColors.primary : TossColors.gray200,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Risk indicator
            Container(
              width: 4,
              height: 32,
              decoration: BoxDecoration(
                color: _getRiskColor(permission.riskLevel),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Icon(
              _getPermissionIcon(permission.categoryId),
              color: TossColors.gray600,
            ),
          ],
        ),
        title: Text(
          permission.name,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          permission.description,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: onChanged,
          activeColor: TossColors.primary,
        ),
        onTap: () => onChanged(!isSelected),
      ),
    );
  }
  
  Color _getRiskColor(PermissionRiskLevel level) {
    switch (level) {
      case PermissionRiskLevel.low:
        return TossColors.success;
      case PermissionRiskLevel.medium:
        return TossColors.warning;
      case PermissionRiskLevel.high:
        return TossColors.error;
      case PermissionRiskLevel.critical:
        return TossColors.error;
    }
  }
}
```

## ✅ Implementation Checklist

### Phase 1: Core Structure (Week 1)
- [ ] Create folder structure following PAGE_SETUP_GUIDE.md
- [ ] Set up domain entities (Role, Permission)
- [ ] Create data models with freezed
- [ ] Set up basic Riverpod providers

### Phase 2: Main UI (Week 2)  
- [ ] Build DelegateRolePage with Toss components
- [ ] Create RoleListItem widget with Korean labels
- [ ] Implement search functionality
- [ ] Add empty state handling

### Phase 3: CRUD Operations (Week 3)
- [ ] Create role creation bottom sheet
- [ ] Implement role editing functionality
- [ ] Add role deletion with confirmation
- [ ] Connect to existing Supabase RPCs

### Phase 4: Enhanced Features (Week 4)
- [ ] Add role templates for quick setup
- [ ] Implement permission risk indicators
- [ ] Add user count analytics
- [ ] Implement bulk permission operations

### Phase 5: Polish & Testing (Week 5)
- [ ] Error handling and loading states
- [ ] Form validation
- [ ] Navigation integration
- [ ] English text refinement

## 🎨 UI Text Labels

```dart
class RoleStrings {
  static const String pageTitle = 'Role Management';
  static const String createRole = 'Create Role';
  static const String editRole = 'Edit Role';
  static const String roleName = 'Role Name';
  static const String permissions = 'Permissions';
  static const String userCount = 'User Count';
  static const String quickSetup = 'Quick Setup';
  static const String searchPlaceholder = 'Search roles...';
  static const String noRoles = 'No roles found';
  static const String createNewRole = 'Create your first role to get started';
  static const String deleteConfirm = 'Are you sure you want to delete this role?';
  static const String cannotDelete = 'System roles cannot be deleted';
}
```

This implementation plan follows MyFinance project guidelines:
- ✅ Uses only existing Toss components
- ✅ English UI labels throughout
- ✅ Follows PAGE_SETUP_GUIDE.md structure
- ✅ Uses Riverpod for state management
- ✅ Integrates with existing Supabase setup
- ✅ Maintains Toss design system consistency
- ✅ Handles loading, error, and empty states