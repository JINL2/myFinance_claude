# Role & Permission Page Implementation Plan

## 📋 **Analysis Summary**

### **1. What is this page for?**
The Role & Permission page is a **Role-Based Access Control (RBAC) management system** that allows:
- **Company Owners/Admins** to create custom roles with specific permissions
- **Permission Assignment** by selecting which features/modules each role can access
- **Role Management** - create, edit, and delete roles within a company
- **Feature-Level Access Control** - granular permissions based on system features organized by categories

### **2. Information to Display**
- **Company Context**: Current selected company name and info
- **Role List**: All custom roles in the company (excluding owner role)
- **Role Details**: Role name, type, creation date, permissions count
- **Permission Matrix**: Features organized by categories with checkboxes
- **Role Actions**: Create, Edit, Delete (except for owner roles)

### **3. Database Integration**

#### **Primary Data Sources**
```sql
-- Main view for role listing
view_roles_with_permissions (
  role_id,           -- Primary key
  role_name,         -- Display name
  role_type,         -- Type (custom, owner, etc.)
  company_id,        -- Company scope  
  parent_role_id,    -- Hierarchy
  created_at,        -- Creation date
  updated_at,        -- Last modified
  is_deletable,      -- Protection flag
  permissions        -- JSON array of feature IDs
)

-- Categories and features for permission assignment
categories (category_id, category_name, company_id)
features (feature_id, feature_name, category_id, feature_route)
```

#### **4. RPC Functions Used**
- **create_role** - Create new custom role with permissions
- **update_role** - Update role name and permissions  
- **delete_role** - Remove role (if deletable)

#### **5. Query Patterns**
```sql
-- Get roles for company (excluding owner)
SELECT * FROM view_roles_with_permissions 
WHERE company_id = ? AND role_type != 'owner'
ORDER BY created_at ASC

-- Get categories and features for permission selection
SELECT c.*, f.* FROM categories c 
LEFT JOIN features f ON c.category_id = f.category_id
WHERE c.company_id = ? 
ORDER BY c.category_name, f.feature_name
```

### **6. Page State Management**
- **Loading States**: Role list, create/edit modal, delete confirmation
- **Form States**: Role name input, permission checkboxes
- **Error States**: Network errors, validation errors, duplicate names
- **Success States**: Role created/updated/deleted confirmations

### **7. Widget Structure**

#### **Main Page Layout**
```
AppBar (Company name + Add Role button)
└── Role List (ListView)
    ├── Role Card 1 (name + edit button)
    ├── Role Card 2 (name + edit button)  
    └── Role Card N (name + edit button)

Modals:
├── Create Role Modal (name input + permission matrix)
├── Edit Role Modal (name input + permission matrix) 
└── Delete Confirmation Modal
```

---

## 🎨 **UI/UX Design Strategy**

### **Design Philosophy**
- **Clean & Professional**: Toss design system with modern cards and spacing
- **Intuitive Permissions**: Visual matrix with clear category grouping
- **Quick Actions**: Prominent create button, inline edit/delete actions
- **Error Prevention**: Form validation, confirmation dialogs, loading states
- **Mobile Responsive**: Touch-friendly design with proper spacing

### **Visual Hierarchy**
1. **Company Header** - Context and primary action (Add Role)
2. **Role Cards** - Clean list with hover states and actions
3. **Permission Matrix** - Organized by categories with visual grouping
4. **Action Buttons** - Clear primary/secondary button distinction

### **Color System**
- **Primary Actions**: Toss primary color for create/save buttons
- **Secondary Actions**: Neutral colors for edit/cancel actions
- **Destructive Actions**: Error color for delete actions
- **Categories**: Subtle background colors to group permissions

---

## 🏗️ **Architecture Implementation Plan**

### **File Structure**
```
lib/presentation/pages/rolepermission/
├── plan.md                           # This plan file
├── role_permission_page.dart         # Main page
├── widgets/
│   ├── role_card.dart               # Individual role display
│   ├── create_role_modal.dart       # Role creation modal
│   ├── edit_role_modal.dart         # Role editing modal
│   ├── delete_role_modal.dart       # Delete confirmation
│   └── permission_matrix.dart       # Category/feature permission grid
├── providers/
│   └── role_permission_provider.dart # Riverpod state management
├── models/
│   ├── role_permission_model.dart    # Data model
│   └── permission_category_model.dart # Category grouping
└── repositories/
    └── role_permission_repository.dart # Supabase integration
```

### **Domain Layer**
```dart
// lib/domain/entities/role_permission.dart
class RolePermission {
  final String roleId;
  final String roleName;
  final String roleType;
  final String companyId;
  final List<String> permissions;
  final DateTime createdAt;
  final bool isDeletable;
  
  // Business logic
  bool get canEdit => roleType != 'owner';
  bool get canDelete => isDeletable && roleType != 'owner';
  int get permissionCount => permissions.length;
}

// lib/domain/entities/permission_category.dart
class PermissionCategory {
  final String categoryId;
  final String categoryName; 
  final List<Feature> features;
  
  // Business logic
  List<String> get featureIds => features.map((f) => f.featureId).toList();
  bool hasPermission(List<String> rolePermissions) => 
    features.any((f) => rolePermissions.contains(f.featureId));
}
```

### **Data Layer**
```dart
// lib/data/repositories/role_permission_repository.dart
class RolePermissionRepository {
  final SupabaseClient _supabase;
  
  // Get roles for company
  Future<List<RolePermission>> getRolesByCompany(String companyId);
  
  // Get categories with features for permission matrix
  Future<List<PermissionCategory>> getPermissionCategories(String companyId);
  
  // CRUD operations using RPC functions
  Future<RolePermission> createRole({
    required String companyId,
    required String roleName, 
    required String roleType,
    required List<String> permissions,
  });
  
  Future<RolePermission> updateRole({
    required String roleId,
    required String roleName,
    required List<String> permissions,
  });
  
  Future<void> deleteRole(String roleId);
}
```

### **Presentation Layer**
```dart
// lib/presentation/providers/role_permission_provider.dart
@riverpod
class CompanyRoles extends _$CompanyRoles {
  Future<List<RolePermission>> build(String companyId) async {
    final repository = ref.watch(rolePermissionRepositoryProvider);
    return repository.getRolesByCompany(companyId);
  }
  
  Future<void> createRole({
    required String roleName,
    required List<String> permissions,
  }) async {
    // Create role and refresh list
  }
  
  Future<void> updateRole({
    required String roleId, 
    required String roleName,
    required List<String> permissions,
  }) async {
    // Update role and refresh list
  }
  
  Future<void> deleteRole(String roleId) async {
    // Delete role and refresh list
  }
}

@riverpod
class PermissionCategories extends _$PermissionCategories {
  Future<List<PermissionCategory>> build(String companyId) async {
    final repository = ref.watch(rolePermissionRepositoryProvider);
    return repository.getPermissionCategories(companyId);
  }
}

// Form state management
@riverpod
class SelectedPermissions extends _$SelectedPermissions {
  List<String> build() => [];
  
  void toggle(String featureId) {
    if (state.contains(featureId)) {
      state = state.where((id) => id != featureId).toList();
    } else {
      state = [...state, featureId];
    }
  }
  
  void setPermissions(List<String> permissions) {
    state = permissions;
  }
  
  void clear() {
    state = [];
  }
}
```

---

## 🎯 **Implementation Steps**

### **Phase 1: Foundation** 
1. Create domain entities for RolePermission and PermissionCategory
2. Build data models with Freezed
3. Implement repository with Supabase RPC integration
4. Set up Riverpod providers for state management

### **Phase 2: Core UI**
1. Build main RolePermissionPage with company header
2. Create RoleCard widget for individual role display
3. Implement role listing with loading/error states
4. Add navigation routing integration

### **Phase 3: Permission System**
1. Build PermissionMatrix widget with category grouping
2. Implement checkbox selection with visual feedback
3. Create permission summary and validation
4. Add search/filter capabilities

### **Phase 4: CRUD Operations**
1. Build CreateRoleModal with form validation
2. Implement EditRoleModal with pre-filled data
3. Add DeleteRoleModal with confirmation
4. Integrate all modals with state management

### **Phase 5: Polish & Optimization**
1. Add animations and micro-interactions
2. Implement error handling and retry logic
3. Add success/error toast notifications
4. Performance optimization and testing

---

## 🔒 **Security Considerations**

- **Owner Role Protection**: Never allow editing/deleting owner roles
- **Company Scoping**: All operations scoped to selected company
- **Permission Validation**: Validate permissions against available features
- **User Authorization**: Check if current user can manage roles
- **Input Sanitization**: Validate role names and permission data

---

## 📱 **Mobile Responsiveness**

- **Touch-Friendly**: 44pt minimum touch targets
- **Scrollable Lists**: Proper scroll behavior for long role lists
- **Modal Sizing**: Responsive modals that work on all screen sizes
- **Permission Matrix**: Collapsible categories on small screens
- **Keyboard Support**: Proper focus management and keyboard navigation

---

## 🚀 **Performance Strategy**

- **Lazy Loading**: Load permissions only when creating/editing roles
- **Optimistic Updates**: Update UI immediately, sync with server async
- **Caching**: Cache frequently accessed data like categories/features
- **Batch Operations**: Group multiple permission changes together
- **Error Recovery**: Robust error handling with retry mechanisms

This implementation will provide a professional, user-friendly role management system that scales well with the business needs while maintaining security and performance standards.