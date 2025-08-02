# Employee Settings Page - Design Specification

## 1. Page Purpose & Overview

### What is this page for?
The Employee Settings page is a comprehensive employee management interface that allows administrators and HR managers to:
- View and manage employee information
- Configure salary and compensation details
- Track employment history and performance
- Manage roles and permissions
- Monitor attendance and work patterns

### Why do we need this page?
- **Centralized Management**: Single location for all employee-related settings
- **Data Accuracy**: Ensure accurate salary calculations and payroll processing
- **Compliance**: Track employment records for legal and regulatory compliance
- **Performance Management**: Monitor employee metrics and make data-driven decisions
- **Role-Based Access**: Configure what each employee can see and do in the system

## 2. Information Architecture

### Primary Information Categories

#### 2.1 Employee Profile
- **Personal Information**
  - Full name (first_name + last_name)
  - Email address
  - Profile image
  - Contact information
  - Employee ID/Code

#### 2.2 Employment Details
- **Company & Store Assignment**
  - Company name and ID
  - Assigned stores (can be multiple)
  - Department/Division
  - Employment start date
  - Employment status (Active/Inactive/On Leave)

#### 2.3 Role & Permissions
- **Current Role**
  - Role name and description
  - Hierarchy level
  - Direct reports (if manager)
  - Permissions summary
- **Role History**
  - Previous roles with dates
  - Promotion/demotion history

#### 2.4 Compensation & Benefits
- **Salary Information**
  - Base salary amount
  - Salary type (Monthly/Hourly)
  - Currency
  - Bonus structure
  - Last salary update date
- **Benefits**
  - Leave balance
  - Insurance status
  - Other benefits

#### 2.5 Attendance & Performance
- **Attendance Summary**
  - Average attendance rate
  - Late arrivals count
  - Overtime hours
  - Leave taken
- **Performance Metrics**
  - KPI scores
  - Recent evaluations
  - Achievement badges

#### 2.6 Financial Integration
- **Accounting Links**
  - Linked expense account
  - Payment method
  - Bank details (masked)
  - Tax information

## 3. UI/UX Design Specifications

### 3.1 Layout Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                         App Bar                                  │
│  ← Back    Employee Settings                         Search 🔍   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────┐  ┌────────────────────────────────────┐  │
│  │                  │  │                                      │  │
│  │  Filter Panel    │  │      Employee List/Grid             │  │
│  │                  │  │                                      │  │
│  │  □ Active Only   │  │  ┌────────────────────────────┐    │  │
│  │  □ By Store      │  │  │   Employee Card 1          │    │  │
│  │  □ By Role       │  │  └────────────────────────────┘    │  │
│  │  □ By Department │  │  ┌────────────────────────────┐    │  │
│  │                  │  │  │   Employee Card 2          │    │  │
│  │  Sort By:        │  │  └────────────────────────────┘    │  │
│  │  ○ Name          │  │                                      │  │
│  │  ○ Role          │  │                                      │  │
│  │  ○ Salary        │  │                                      │  │
│  │  ○ Join Date     │  │                                      │  │
│  │                  │  │                                      │  │
│  └──────────────────┘  └────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    Floating Action Button                  │  │
│  │                    + Add New Employee                      │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 Employee Card Design (Toss-Style)

```dart
// Employee Card Component Structure
Container(
  height: 120,
  decoration: BoxDecoration(
    color: TossColors.surface,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
    boxShadow: TossShadows.shadow2,
  ),
  child: Padding(
    padding: EdgeInsets.all(TossSpacing.space4),
    child: Row(
      children: [
        // Profile Image
        CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(profileImage),
        ),
        SizedBox(width: TossSpacing.space4),
        
        // Employee Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Name & Role
              Text(fullName, style: TossTextStyles.h3),
              SizedBox(height: TossSpacing.space1),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Text(
                      roleName,
                      style: TossTextStyles.labelSmall.copyWith(
                        color: roleColor,
                      ),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(storeName, style: TossTextStyles.caption),
                ],
              ),
              SizedBox(height: TossSpacing.space2),
              // Salary & Status
              Row(
                children: [
                  Text(
                    '${formatCurrency(salary)}',
                    style: TossTextStyles.amountSmall,
                  ),
                  Text(
                    ' / ${salaryType}',
                    style: TossTextStyles.caption,
                  ),
                  Spacer(),
                  StatusIndicator(status: employmentStatus),
                ],
              ),
            ],
          ),
        ),
        
        // Actions
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () => showEmployeeDetailModal(),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => showMoreOptions(),
            ),
          ],
        ),
      ],
    ),
  ),
)
```

### 3.3 Employee Detail Modal (Bottom Sheet)

```dart
// Full-screen modal with tabs for different sections
showModalBottomSheet(
  isScrollControlled: true,
  context: context,
  builder: (context) => DraggableScrollableSheet(
    initialChildSize: 0.9,
    minChildSize: 0.5,
    maxChildSize: 0.95,
    builder: (context, scrollController) => Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xxl),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),
          
          // Header with employee info
          EmployeeDetailHeader(employee: employee),
          
          // Tab navigation
          TabBar(
            tabs: [
              Tab(text: 'Profile'),
              Tab(text: 'Compensation'),
              Tab(text: 'Attendance'),
              Tab(text: 'Permissions'),
              Tab(text: 'History'),
            ],
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                ProfileTab(),
                CompensationTab(),
                AttendanceTab(),
                PermissionsTab(),
                HistoryTab(),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
)
```

### 3.4 Key UI Components

#### Search & Filter Bar
- Real-time search by name, email, or employee ID
- Advanced filters: store, role, department, status
- Sort options: name, role, salary, join date

#### Status Indicators
- **Active**: Green dot with "Active" label
- **Inactive**: Gray dot with "Inactive" label
- **On Leave**: Orange dot with "On Leave" label

#### Quick Actions Menu
- Edit employee details
- View attendance report
- Adjust salary
- Change role
- Deactivate/Activate employee
- Generate payslip

## 4. Database Interactions (Supabase)

### 4.1 Data Fetching

#### Main Employee List Query
```dart
// Fetch employees with all related data using views
Future<List<EmployeeDetail>> fetchEmployees(String companyId) async {
  // Using v_user_salary view which joins:
  // users + user_salaries + user_roles + roles + user_companies + companies
  
  final response = await supabase
    .from('v_user_salary')
    .select('*')
    .eq('company_id', companyId)
    .order('full_name', ascending: true);
    
  return response.map((e) => EmployeeDetail.fromJson(e)).toList();
}
```

#### Employee Detail Query
```dart
// Fetch comprehensive employee information
Future<EmployeeFullDetail> fetchEmployeeDetail(String userId) async {
  // Parallel queries for better performance
  final futures = await Future.wait([
    // Basic info from v_user_salary
    supabase.from('v_user_salary').select('*').eq('user_id', userId).single(),
    
    // Role history
    supabase.from('user_roles')
      .select('*, roles(role_name, description)')
      .eq('user_id', userId)
      .order('created_at', ascending: false),
    
    // Store assignments
    supabase.from('user_stores')
      .select('*, stores(store_name, store_code)')
      .eq('user_id', userId)
      .eq('is_deleted', false),
    
    // Recent attendance (last 30 days)
    supabase.from('shift_requests')
      .select('*')
      .eq('user_id', userId)
      .gte('request_date', DateTime.now().subtract(Duration(days: 30)))
      .order('request_date', ascending: false),
  ]);
  
  return EmployeeFullDetail.fromQueries(futures);
}
```

### 4.2 Data Updates

#### Update Salary RPC Function
```dart
// RPC function call with proper error handling
Future<bool> updateEmployeeSalary({
  required String salaryId,
  required double salaryAmount,
  required String salaryType,
  required String currencyId,
  required String editedBy,
}) async {
  try {
    // Call the RPC function
    final response = await supabase.rpc('update_user_salary', params: {
      'p_salary_id': salaryId,
      'p_salary_amount': salaryAmount,
      'p_salary_type': salaryType,
      'p_currency_id': currencyId,
    });
    
    // Log the change for audit
    await supabase.from('salary_change_logs').insert({
      'salary_id': salaryId,
      'old_amount': currentAmount,
      'new_amount': salaryAmount,
      'changed_by': editedBy,
      'change_reason': reason,
      'created_at': DateTime.now().toIso8601String(),
    });
    
    return true;
  } catch (e) {
    // Handle errors appropriately
    print('Error updating salary: $e');
    return false;
  }
}
```

#### Update Employee Role
```dart
Future<bool> updateEmployeeRole({
  required String userId,
  required String newRoleId,
  required String updatedBy,
}) async {
  // Use transaction for data consistency
  try {
    // Deactivate current role
    await supabase
      .from('user_roles')
      .update({'is_deleted': true, 'deleted_at': DateTime.now().toIso8601String()})
      .eq('user_id', userId)
      .eq('is_deleted', false);
    
    // Create new role assignment
    await supabase.from('user_roles').insert({
      'user_id': userId,
      'role_id': newRoleId,
      'created_at': DateTime.now().toIso8601String(),
    });
    
    return true;
  } catch (e) {
    print('Error updating role: $e');
    return false;
  }
}
```

### 4.3 Real-time Updates
```dart
// Subscribe to employee changes
void subscribeToEmployeeUpdates(String companyId) {
  supabase
    .from('v_user_salary:company_id=eq.$companyId')
    .stream(primaryKey: ['user_id'])
    .listen((List<Map<String, dynamic>> data) {
      // Update UI with new data
      updateEmployeeList(data);
    });
}
```

## 5. Enhanced Features

### 5.1 Bulk Operations
- Select multiple employees for bulk updates
- Bulk salary adjustments (percentage or fixed amount)
- Bulk role changes
- Export selected employees to CSV/Excel

### 5.2 Advanced Analytics
- Salary distribution chart
- Department-wise employee count
- Role hierarchy visualization
- Attendance trends graph
- Turnover rate tracking

### 5.3 Smart Notifications
- Upcoming contract renewals
- Probation period endings
- Unusual attendance patterns
- Salary review reminders

### 5.4 Integration Features
- Sync with external HR systems
- Payroll system integration
- Biometric attendance integration
- Document management (contracts, certificates)

### 5.5 Audit Trail
- Track all changes to employee data
- Who made changes and when
- Reason for changes
- Ability to revert changes

## 6. Performance Optimizations

### 6.1 Data Loading
- Pagination for large employee lists (20 items per page)
- Lazy loading for employee details
- Cache frequently accessed data
- Use database views for complex queries

### 6.2 Search Optimization
- Debounced search input (300ms delay)
- Client-side filtering for loaded data
- Index key fields in database

### 6.3 UI Performance
- Virtual scrolling for long lists
- Image lazy loading and caching
- Optimistic UI updates
- Skeleton loaders during data fetch

## 7. Security Considerations

### 7.1 Access Control
- Role-based access to employee data
- Hide sensitive information (salary) based on permissions
- Audit log for all data access

### 7.2 Data Protection
- Encrypt sensitive data in transit
- Mask bank account numbers
- Secure file uploads for documents
- Session timeout for idle users

## 8. Mobile Responsiveness

### 8.1 Responsive Breakpoints
- Mobile: < 600px (single column, stacked layout)
- Tablet: 600px - 1024px (2 columns)
- Desktop: > 1024px (3 columns with sidebar)

### 8.2 Touch Optimizations
- Minimum touch target: 44px
- Swipe gestures for navigation
- Pull-to-refresh functionality
- Bottom sheet for mobile modals

## 9. Accessibility

### 9.1 WCAG 2.1 AA Compliance
- Proper heading hierarchy
- Alt text for images
- Keyboard navigation support
- Screen reader compatibility
- High contrast mode support

### 9.2 Internationalization
- Support for RTL languages
- Date/time localization
- Currency formatting
- Multi-language support

## 10. Error Handling

### 10.1 User-Friendly Error Messages
- Network errors: "Unable to connect. Please check your internet connection."
- Permission errors: "You don't have permission to perform this action."
- Validation errors: Inline field-specific messages

### 10.2 Recovery Options
- Retry mechanisms for failed requests
- Offline mode with sync capability
- Data recovery from local storage

## Implementation Priority

1. **Phase 1**: Basic employee list with search and filter
2. **Phase 2**: Employee detail view with edit capabilities
3. **Phase 3**: Bulk operations and advanced features
4. **Phase 4**: Analytics and reporting
5. **Phase 5**: External integrations

## Technical Implementation Notes

- Use Provider/Riverpod for state management
- Implement repository pattern for data access
- Use Freezed for immutable data models
- Follow clean architecture principles
- Write comprehensive tests (unit, widget, integration)