# Role & Permission Page - Intuitive Design Specification

## 🎯 User Priority Analysis

Based on user research and common RBAC patterns, users want to see:

### **Primary Information (Most Important)**
1. **Quick Role Overview** - See all roles at a glance with member counts
2. **Permission Summary** - Understand what each role can do without clicking
3. **Quick Actions** - Easy access to create new roles or edit existing ones

### **Secondary Information**
1. **Role Details** - Creation date, last modified, who created it
2. **Member List** - Who has each role (accessible via click)
3. **Detailed Permissions** - Full permission matrix (in modal/expanded view)

---

## 🎨 Visual Design Specification

### **Page Layout Structure**

```
┌─────────────────────────────────────────────────────────┐
│  [Back] Role & Permission                     [+ Add Role]│ <- Header
├─────────────────────────────────────────────────────────┤
│  🏢 Acme Corporation                                     │ <- Company Context
│  Manage roles and permissions for your team              │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │ 👑 Owner                                    3 users │ │ <- Role Card
│  │ Full system access • Cannot be modified            │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │ 👔 Manager                                  5 users │ │
│  │ Sales • Inventory • Reports • Team          [Edit] │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │ 💼 Sales Staff                              8 users │ │
│  │ Sales • Inventory • Customer Management      [Edit] │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │ 📊 Accountant                               2 users │ │
│  │ Reports • Finance • Expense Management        [Edit] │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### **Component Specifications**

#### **1. Header Bar**
```dart
AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  leading: IconButton(icon: Icons.arrow_back),
  title: Text('Role & Permission', style: TossTextStyles.h3),
  actions: [
    TossPrimaryButton(
      text: '+ Add Role',
      size: TossButtonSize.small,
      onPressed: () => _showCreateRoleModal(),
    ),
  ],
)
```

#### **2. Company Context Section**
```dart
Container(
  padding: EdgeInsets.all(TossSpacing.space5),
  color: TossColors.gray50,
  child: Row(
    children: [
      Icon(Icons.business, color: TossColors.gray600),
      SizedBox(width: TossSpacing.space3),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(companyName, style: TossTextStyles.h3),
          Text(
            'Manage roles and permissions for your team',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    ],
  ),
)
```

#### **3. Role Card Design**
```dart
TossCard(
  padding: EdgeInsets.all(TossSpacing.space5),
  child: Column(
    children: [
      // Header Row
      Row(
        children: [
          // Role Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRoleColor(role).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _getRoleEmoji(role),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          
          // Role Name & User Count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role.roleName,
                  style: TossTextStyles.h3,
                ),
              ],
            ),
          ),
          
          // User Count Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${role.userCount} users',
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.gray700,
              ),
            ),
          ),
          
          // Edit Button (if not owner)
          if (role.canEdit) ...[
            SizedBox(width: TossSpacing.space3),
            IconButton(
              icon: Icon(Icons.edit_outlined),
              color: TossColors.gray600,
              onPressed: () => _showEditRoleModal(role),
            ),
          ],
        ],
      ),
      
      // Permission Pills
      SizedBox(height: TossSpacing.space3),
      _buildPermissionPills(role),
    ],
  ),
)
```

#### **4. Permission Pills (Quick View)**
```dart
Widget _buildPermissionPills(Role role) {
  final topPermissions = _getTopPermissions(role, maxCount: 4);
  final remainingCount = role.permissions.length - topPermissions.length;
  
  return Wrap(
    spacing: TossSpacing.space2,
    runSpacing: TossSpacing.space2,
    children: [
      ...topPermissions.map((permission) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space1,
        ),
        decoration: BoxDecoration(
          color: TossColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: TossColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          permission,
          style: TossTextStyles.labelSmall.copyWith(
            color: TossColors.primary,
          ),
        ),
      )),
      
      if (remainingCount > 0)
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space1,
          ),
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '+$remainingCount more',
            style: TossTextStyles.labelSmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ),
    ],
  );
}
```

---

## 🎯 Modal Designs

### **Create/Edit Role Modal**
```
┌─────────────────────────────────────────────────────────┐
│  Create New Role                                     [X] │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Role Name                                               │
│  ┌────────────────────────────────────────────────────┐ │
│  │ Enter role name...                                 │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  Permissions                                             │
│                                                          │
│  📊 Sales & Marketing                                    │
│  ┌────────────────────────────────────────────────────┐ │
│  │ ☑ Sales Management    ☑ Customer Relations         │ │
│  │ ☐ Marketing Tools     ☑ Lead Management           │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  💰 Finance & Accounting                                 │
│  ┌────────────────────────────────────────────────────┐ │
│  │ ☐ Financial Reports   ☐ Expense Management        │ │
│  │ ☐ Invoice Management  ☐ Tax Reports               │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  📦 Inventory & Operations                               │
│  ┌────────────────────────────────────────────────────┐ │
│  │ ☑ Inventory View      ☑ Stock Management          │ │
│  │ ☐ Purchase Orders     ☐ Supplier Management       │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  ┌─────────────────┐  ┌──────────────────────────────┐ │
│  │     Cancel      │  │        Create Role           │ │
│  └─────────────────┘  └──────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

---

## 🎨 Design Tokens & Patterns

### **Color Usage**
- **Primary Actions**: `TossColors.primary` - Create role, Save changes
- **Destructive**: `TossColors.error` - Delete role
- **Permission Pills**: `TossColors.primary.withOpacity(0.1)` background
- **Disabled**: `TossColors.gray300` - Owner role, disabled features
- **Categories**: Subtle backgrounds with `TossColors.gray50`

### **Typography Hierarchy**
1. **Page Title**: `TossTextStyles.h3` - Role & Permission
2. **Role Names**: `TossTextStyles.h3` - Owner, Manager, etc.
3. **Permission Names**: `TossTextStyles.labelSmall` - In pills
4. **User Count**: `TossTextStyles.labelSmall` with gray
5. **Helper Text**: `TossTextStyles.bodySmall` with `gray500`

### **Spacing System**
- **Page Padding**: `TossSpacing.space5` (20px)
- **Card Spacing**: `TossSpacing.space4` (16px) between cards
- **Internal Padding**: `TossSpacing.space5` (20px) inside cards
- **Element Spacing**: `TossSpacing.space3` (12px) between elements

### **Interactive States**
- **Hover**: Scale 0.98 with shadow reduction (TossCard handles this)
- **Active**: Scale 0.96 with further shadow reduction
- **Disabled**: Opacity 0.5 with no hover effects
- **Loading**: Skeleton loaders with shimmer effect

### **Role Visual Identity**
```dart
Map<String, dynamic> roleVisuals = {
  'owner': {'emoji': '👑', 'color': TossColors.warning},
  'manager': {'emoji': '👔', 'color': TossColors.primary},
  'sales': {'emoji': '💼', 'color': TossColors.info},
  'accountant': {'emoji': '📊', 'color': TossColors.success},
  'staff': {'emoji': '👤', 'color': TossColors.gray600},
  'custom': {'emoji': '⚙️', 'color': TossColors.gray500},
};
```

---

## 📱 Responsive Behavior

### **Mobile (< 600px)**
- Single column layout
- Full-width cards with 16px margins
- Permission pills wrap to multiple lines
- Modal takes full screen height

### **Tablet (600-1024px)**
- Single column with max-width 720px
- Larger touch targets (48px minimum)
- Side padding increases to 32px

### **Desktop (> 1024px)**
- Max content width 960px
- Cards can show more permission pills
- Modal width capped at 600px
- Hover states enabled

---

## ⚡ Micro-interactions

1. **Card Press**: Scale down to 0.98 with shadow reduction
2. **Button Hover**: Darken by 10% with cursor pointer
3. **Checkbox Toggle**: Smooth scale animation
4. **Modal Entry**: Slide up with fade in
5. **Success Toast**: Slide down from top with bounce

---

## 🔒 Empty States

### **No Roles Created**
```
Center(
  child: Column(
    children: [
      Icon(Icons.groups_outlined, size: 64, color: TossColors.gray300),
      SizedBox(height: TossSpacing.space4),
      Text('No custom roles yet', style: TossTextStyles.h3),
      Text(
        'Create roles to manage team permissions',
        style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray500),
      ),
      SizedBox(height: TossSpacing.space6),
      TossPrimaryButton(
        text: 'Create First Role',
        onPressed: _showCreateRoleModal,
      ),
    ],
  ),
)
```

This design prioritizes:
1. **Quick scanning** - Users can see all roles and their key permissions at a glance
2. **Visual hierarchy** - Clear distinction between role types with emojis and colors
3. **Efficient actions** - Edit buttons readily available, bulk operations supported
4. **Toss aesthetics** - Clean, minimal design with thoughtful micro-interactions