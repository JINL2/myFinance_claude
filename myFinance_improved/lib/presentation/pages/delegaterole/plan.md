# Delegate Role Page Implementation Plan

## Page Analysis Summary

### Current FlutterFlow Role Permission Page Analysis

**Purpose**: Role-based access control (RBAC) management system for companies
- View all company roles (excluding owner roles)
- Create custom roles with specific permissions
- Edit existing roles and permissions
- Delete roles when permitted
- Manage feature-based permissions through hierarchical categories

**Data Source**: `view_roles_with_permissions` Supabase view
**RPC Functions**: `create_role`, `update_role`, `delete_role`
**State Management**: FFAppState with company selection and permission categories

## Enhanced Implementation Plan

### 1. Architecture Design

```
lib/presentation/pages/delegaterole/
├── plan.md                          # This file
├── delegate_role_page.dart          # Main page
├── models/
│   ├── delegate_role_state.dart     # State management
│   └── role_form_data.dart          # Form models
├── widgets/
│   ├── role_list_widget.dart        # Role list display
│   ├── role_card_widget.dart        # Individual role cards
│   ├── role_form_modal.dart         # Create/Edit role modal
│   ├── permission_selector.dart     # Permission selection widget
│   └── role_insights_widget.dart    # Analytics and insights
└── providers/
    ├── delegate_role_providers.dart  # Riverpod providers
    └── role_analytics_provider.dart  # Usage analytics
```

### 2. Core Features Implementation

#### A. Role Management Core
- **View Roles**: Display company roles with enhanced information
- **Create Role**: Modal form with permission selection
- **Edit Role**: Update role name and permissions
- **Delete Role**: With safety checks and user confirmation
- **Role Duplication**: Clone existing roles for quick setup

#### B. Enhanced Permission System
- **Hierarchical Categories**: Organized permission structure
- **Permission Descriptions**: Tooltips explaining each feature
- **Risk Indicators**: Visual cues for critical permissions
- **Dependency Mapping**: Show related permissions
- **Bulk Operations**: Select multiple permissions at once

#### C. User Experience Enhancements
- **Real-time Search**: Filter roles by name or permissions
- **Usage Analytics**: Show role assignment statistics
- **Change History**: Track role modifications
- **Role Templates**: Predefined role configurations
- **Smart Suggestions**: Recommend permissions based on role type

### 3. Data Layer Design

#### A. Domain Entities

```dart
// lib/domain/entities/role_entity.dart
class RoleEntity {
  final RoleId id;
  final CompanyId companyId;
  final RoleName name;
  final RoleType type;
  final List<PermissionId> permissions;
  final RoleMetadata metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Business Logic
  bool canBeDeleted();
  bool hasPermission(PermissionId permissionId);
  int getUserCount();
  bool isSystemRole();
}

// lib/domain/entities/permission_entity.dart
class PermissionEntity {
  final PermissionId id;
  final PermissionName name;
  final String description;
  final PermissionCategory category;
  final PermissionRiskLevel riskLevel;
  final List<PermissionId> dependencies;
  final List<PermissionId> conflicts;
}
```

#### B. Repository Interface

```dart
// lib/domain/repositories/i_role_repository.dart
abstract class IRoleRepository {
  Future<Either<Failure, List<RoleEntity>>> getCompanyRoles(CompanyId companyId);
  Future<Either<Failure, RoleEntity>> createRole(CreateRoleCommand command);
  Future<Either<Failure, RoleEntity>> updateRole(UpdateRoleCommand command);
  Future<Either<Failure, Unit>> deleteRole(RoleId roleId);
  Future<Either<Failure, List<PermissionEntity>>> getAvailablePermissions();
  Future<Either<Failure, RoleUsageStats>>> getRoleUsageStats(RoleId roleId);
  Stream<List<RoleEntity>> watchCompanyRoles(CompanyId companyId);
}
```

#### C. Supabase Integration

```sql
-- Enhanced role management views and functions
CREATE OR REPLACE VIEW view_roles_with_analytics AS
SELECT 
  r.*,
  COUNT(ur.user_id) as user_count,
  MAX(ur.assigned_at) as last_assigned,
  COALESCE(ra.usage_stats, '{}') as analytics
FROM roles r
LEFT JOIN user_roles ur ON r.id = ur.role_id
LEFT JOIN role_analytics ra ON r.id = ra.role_id
GROUP BY r.id, ra.usage_stats;

-- Role creation with enhanced metadata
CREATE OR REPLACE FUNCTION create_role_enhanced(
  p_company_id UUID,
  p_role_name TEXT,
  p_role_type TEXT,
  p_permissions JSONB,
  p_metadata JSONB DEFAULT '{}'
) RETURNS UUID AS $$
-- Implementation
$$ LANGUAGE plpgsql;
```

### 4. State Management Design

#### A. Riverpod Providers

```dart
// Core role state
final roleStateProvider = StateNotifierProvider<RoleStateNotifier, RoleState>((ref) {
  return RoleStateNotifier(
    getRolesUseCase: ref.watch(getRolesUseCaseProvider),
    createRoleUseCase: ref.watch(createRoleUseCaseProvider),
    updateRoleUseCase: ref.watch(updateRoleUseCaseProvider),
    deleteRoleUseCase: ref.watch(deleteRoleUseCaseProvider),
  );
});

// Permission categories
final permissionCategoriesProvider = FutureProvider<List<PermissionCategory>>((ref) async {
  final useCase = ref.watch(getPermissionCategoriesUseCaseProvider);
  final result = await useCase.execute();
  return result.fold((failure) => throw failure, (categories) => categories);
});

// Role analytics
final roleAnalyticsProvider = FutureProvider.family<RoleUsageStats, RoleId>((ref, roleId) async {
  final useCase = ref.watch(getRoleAnalyticsUseCaseProvider);
  final result = await useCase.execute(roleId);
  return result.fold((failure) => throw failure, (stats) => stats);
});

// Search and filter
final roleSearchProvider = StateProvider<String>((ref) => '');
final roleFilterProvider = StateProvider<RoleFilter>((ref) => RoleFilter.all);
```

#### B. State Management

```dart
@freezed
class RoleState with _$RoleState {
  const factory RoleState.initial() = RoleStateInitial;
  const factory RoleState.loading() = RoleStateLoading;
  const factory RoleState.loaded({
    required List<RoleEntity> roles,
    required List<PermissionCategory> categories,
    RoleEntity? selectedRole,
    String searchQuery,
    RoleFilter filter,
  }) = RoleStateLoaded;
  const factory RoleState.error(Failure failure) = RoleStateError;
}
```

### 5. UI Component Design

#### A. Main Page Layout

```dart
class DelegateRolePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TossScaffold(
      appBar: TossAppBar(
        title: 'Role Management',
        subtitle: ref.watch(selectedCompanyProvider)?.name ?? '',
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchAndFilter(context, ref),
          
          // Quick Actions
          _buildQuickActions(context, ref),
          
          // Role List
          Expanded(
            child: _buildRoleList(context, ref),
          ),
        ],
      ),
      floatingActionButton: TossFAB(
        icon: Icons.add,
        label: 'Create Role',
        onPressed: () => _showCreateRoleModal(context, ref),
      ),
    );
  }
}
```

#### B. Enhanced Role Card

```dart
class RoleCard extends ConsumerWidget {
  final RoleEntity role;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(roleAnalyticsProvider(role.id));
    
    return TossCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with role info
          _buildRoleHeader(context, role),
          
          // Permission summary
          _buildPermissionSummary(context, role),
          
          // Usage analytics
          analytics.when(
            data: (stats) => _buildAnalytics(context, stats),
            loading: () => const TossShimmer(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          
          // Actions
          _buildActions(context, ref, role),
        ],
      ),
    );
  }
}
```

#### C. Permission Selector Widget

```dart
class PermissionSelector extends ConsumerWidget {
  final List<PermissionId> selectedPermissions;
  final ValueChanged<List<PermissionId>> onChanged;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(permissionCategoriesProvider);
    
    return categories.when(
      data: (cats) => Column(
        children: cats.map((category) => 
          PermissionCategoryTile(
            category: category,
            selectedPermissions: selectedPermissions,
            onPermissionToggle: (permissionId, selected) {
              // Handle permission selection with dependency checking
              _handlePermissionToggle(permissionId, selected);
            },
          ),
        ).toList(),
      ),
      loading: () => const TossLoadingGrid(),
      error: (error, _) => TossErrorWidget(error: error),
    );
  }
}
```

### 6. Advanced Features

#### A. Role Templates

```dart
class RoleTemplateSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TossText.subtitle('Quick Setup'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: RoleTemplate.predefined.map((template) =>
            TossChip(
              label: template.name,
              icon: template.icon,
              onTap: () => _applyTemplate(template),
            ),
          ).toList(),
        ),
      ],
    );
  }
}

enum RoleTemplate {
  manager('Manager', Icons.supervisor_account, [
    Permission.viewReports,
    Permission.manageInventory,
    Permission.viewTransactions,
  ]),
  cashier('Cashier', Icons.point_of_sale, [
    Permission.processSales,
    Permission.viewProducts,
    Permission.handleReturns,
  ]),
  accountant('Accountant', Icons.account_balance, [
    Permission.viewFinancials,
    Permission.manageAccounts,
    Permission.generateReports,
  ]);
}
```

#### B. Permission Risk Indicators

```dart
class PermissionTile extends StatelessWidget {
  final PermissionEntity permission;
  final bool isSelected;
  final ValueChanged<bool> onChanged;
  
  @override
  Widget build(BuildContext context) {
    return TossListTile(
      leading: _buildRiskIndicator(permission.riskLevel),
      title: permission.name,
      subtitle: permission.description,
      trailing: TossCheckbox(
        value: isSelected,
        onChanged: onChanged,
      ),
      onTap: () => _showPermissionDetails(permission),
    );
  }
  
  Widget _buildRiskIndicator(PermissionRiskLevel level) {
    return Container(
      width: 4,
      height: 40,
      decoration: BoxDecoration(
        color: _getRiskColor(level),
        borderRadius: BorderRadius.circular(2),
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
        return TossColors.critical;
    }
  }
}
```

#### C. Role Usage Analytics

```dart
class RoleInsightsWidget extends ConsumerWidget {
  final RoleEntity role;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(roleAnalyticsProvider(role.id));
    
    return analytics.when(
      data: (stats) => TossCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TossText.subtitle('Role Usage'),
            const SizedBox(height: 12),
            
            // User count
            _buildStatRow(
              icon: Icons.people,
              label: 'Assigned Users',
              value: '${stats.userCount}',
            ),
            
            // Last activity
            _buildStatRow(
              icon: Icons.access_time,
              label: 'Last Activity',
              value: _formatLastActivity(stats.lastActivity),
            ),
            
            // Most used permissions
            _buildTopPermissions(stats.topPermissions),
          ],
        ),
      ),
      loading: () => const TossShimmer(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
```

### 7. Error Handling & Validation

#### A. Form Validation

```dart
class RoleFormValidator {
  static ValidationResult validateRoleName(String name) {
    if (name.isEmpty) {
      return ValidationResult.error('Role name is required');
    }
    if (name.length < 2) {
      return ValidationResult.error('Role name must be at least 2 characters');
    }
    if (name.length > 50) {
      return ValidationResult.error('Role name must be less than 50 characters');
    }
    if (!RegExp(r'^[a-zA-Z0-9\s\-_]+$').hasMatch(name)) {
      return ValidationResult.error('Role name contains invalid characters');
    }
    return ValidationResult.success();
  }
  
  static ValidationResult validatePermissions(List<PermissionId> permissions) {
    if (permissions.isEmpty) {
      return ValidationResult.error('At least one permission must be selected');
    }
    
    // Check for permission conflicts
    final conflicts = _findPermissionConflicts(permissions);
    if (conflicts.isNotEmpty) {
      return ValidationResult.error('Conflicting permissions selected: ${conflicts.join(', ')}');
    }
    
    return ValidationResult.success();
  }
}
```

#### B. Safety Checks

```dart
class RoleDeletionSafetyCheck {
  static Future<DeletionSafetyResult> checkCanDelete(RoleEntity role) async {
    final warnings = <String>[];
    
    // Check if role has assigned users
    if (role.getUserCount() > 0) {
      warnings.add('${role.getUserCount()} users are assigned to this role');
    }
    
    // Check if role is referenced in other systems
    final references = await _checkRoleReferences(role.id);
    if (references.isNotEmpty) {
      warnings.add('Role is referenced in ${references.length} other locations');
    }
    
    // Check if it's a system role
    if (role.isSystemRole()) {
      return DeletionSafetyResult.blocked('System roles cannot be deleted');
    }
    
    if (warnings.isEmpty) {
      return DeletionSafetyResult.safe();
    } else {
      return DeletionSafetyResult.warnings(warnings);
    }
  }
}
```

### 8. Testing Strategy

#### A. Unit Tests
- Role entity business logic
- Permission validation
- Form validation
- Use case implementations
- State management

#### B. Widget Tests
- Role list rendering
- Permission selector interactions
- Form submission flows
- Error handling displays

#### C. Integration Tests
- Complete role creation flow
- Role editing and deletion
- Permission inheritance
- Real-time updates

### 9. Performance Considerations

#### A. Optimization Strategies
- **Pagination**: Load roles in batches for large organizations
- **Caching**: Cache permission categories and role analytics
- **Debounced Search**: Optimize search performance
- **Optimistic Updates**: Immediate UI feedback
- **Background Sync**: Update analytics in background

#### B. Memory Management
- **Widget Disposal**: Proper cleanup of controllers and subscriptions
- **Image Caching**: Optimize role avatar images
- **State Cleanup**: Clear unnecessary state on navigation

### 10. Accessibility & Internationalization

#### A. Accessibility
- Screen reader support for all interactive elements
- Keyboard navigation for form inputs
- High contrast mode support
- Semantic labels for complex widgets

#### B. Internationalization
- Localized role names and descriptions
- RTL language support
- Cultural considerations for role hierarchies
- Date/time formatting

### 11. Implementation Timeline

#### Phase 1 (Week 1): Foundation
- [ ] Set up folder structure
- [ ] Create domain entities and repositories
- [ ] Implement basic use cases
- [ ] Set up Riverpod providers

#### Phase 2 (Week 2): Core UI
- [ ] Build main page layout
- [ ] Implement role list and cards
- [ ] Create role form modal
- [ ] Add basic CRUD operations

#### Phase 3 (Week 3): Enhanced Features
- [ ] Implement permission selector
- [ ] Add role templates
- [ ] Create analytics widgets
- [ ] Add search and filtering

#### Phase 4 (Week 4): Polish & Testing
- [ ] Error handling and validation
- [ ] Performance optimization
- [ ] Comprehensive testing
- [ ] Documentation

#### Phase 5 (Week 5): Advanced Features
- [ ] Role usage insights
- [ ] Audit trail
- [ ] Bulk operations
- [ ] Export/import functionality

### 12. Success Metrics

- **Functionality**: All CRUD operations working
- **Performance**: Page loads < 1s, search < 300ms
- **Usability**: Intuitive role creation flow
- **Reliability**: < 0.1% error rate
- **Accessibility**: WCAG 2.1 AA compliance

This plan provides a comprehensive roadmap for implementing an enhanced role management system that improves upon the current FlutterFlow implementation while maintaining usability and adding valuable new features.