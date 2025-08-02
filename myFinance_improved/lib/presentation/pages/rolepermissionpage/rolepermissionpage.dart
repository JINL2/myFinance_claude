import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/app_error.dart';
import '../../providers/app_state_provider.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../widgets/toss/toss_card.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_button.dart';
import '../../widgets/toss/toss_snackbar.dart';
import 'create_role_modal.dart';
import '../../../data/services/role_service.dart';

class RolePermissionPage extends ConsumerStatefulWidget {
  const RolePermissionPage({super.key});

  @override
  ConsumerState<RolePermissionPage> createState() => _RolePermissionPageState();
}

class _RolePermissionPageState extends ConsumerState<RolePermissionPage> {


  @override
  Widget build(BuildContext context) {
    final selectedCompanyId = ref.watch(selectedCompanyIdProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);
    
    if (selectedCompanyId == null) {
      return _buildNoCompanySelected();
    }

    final rolesAsync = ref.watch(companyRolesProvider(selectedCompanyId));

    return Scaffold(
      backgroundColor: TossColors.gray50,
      body: Stack(
        children: [
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              // Custom App Bar with smooth scroll effect
              _buildSliverAppBar(context),
              
              // Company Header
              if (selectedCompany != null)
                SliverToBoxAdapter(
                  child: _buildCompanyHeader(selectedCompany),
                ),
              
              // Role List
              rolesAsync.when(
                data: (roles) => roles.isEmpty
                    ? SliverFillRemaining(
                        child: _buildEmptyState(),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          TossSpacing.space4,
                          TossSpacing.space4,
                          TossSpacing.space4,
                          100, // Padding for floating button without white container
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildRoleCard(roles[index]);
                            },
                            childCount: roles.length,
                          ),
                        ),
                      ),
                loading: () => SliverFillRemaining(
                  child: Center(child: AppLoading()),
                ),
                error: (error, stack) => SliverFillRemaining(
                  child: Center(
                    child: AppError(
                      message: 'Failed to load roles',
                      onRetry: () => ref.refresh(companyRolesProvider(selectedCompanyId)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Floating Add Button
          Positioned(
            bottom: TossSpacing.space5,
            left: TossSpacing.space5,
            right: TossSpacing.space5,
            child: SafeArea(
              child: TossPrimaryButton(
                text: 'Add New Role',
                onPressed: () => _showCreateRoleModal(context),
                leadingIcon: Icon(Icons.add, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      floating: false,
      forceElevated: false,
      toolbarHeight: 60,
      title: Text(
        'Role & Permission',
        style: TossTextStyles.h2.copyWith(
          color: TossColors.gray900,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: TossColors.gray900, size: 22),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildCompanyHeader(company) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        top: TossSpacing.space3,
        bottom: TossSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            company.companyName,
            style: TossTextStyles.h2.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            'Manage roles and permissions for your team',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(RoleWithPermissions role) {
    // Note: Employee role should be editable like other roles
    final isEditable = role.roleType != 'owner';
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEditable ? () => _showEditRoleModal(context, role) : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: TossColors.gray100,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Role Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Role name with user count and permission badges
                      Row(
                        children: [
                          Text(
                            role.roleName,
                            style: TossTextStyles.bodyLarge.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: TossSpacing.space3),
                          // User Count Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 14,
                                  color: TossColors.primary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  role.userCount.toString(),
                                  style: TossTextStyles.labelSmall.copyWith(
                                    color: TossColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: TossSpacing.space2),
                          // Permission Count Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.gray100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.security_outlined,
                                  size: 14,
                                  color: TossColors.gray600,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  role.permissionCount.toString(),
                                  style: TossTextStyles.labelSmall.copyWith(
                                    color: TossColors.gray600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: TossSpacing.space1),
                      // Description or role type
                      _buildRoleTags(role),
                      // Tags chips
                      if (role.tags != null && role.tags!.isNotEmpty) ...[
                        SizedBox(height: TossSpacing.space2),
                        _buildRoleTagChips(role),
                      ],
                    ],
                  ),
                ),
                
                // Edit Indicator
                if (isEditable)
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: TossColors.gray400,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTags(RoleWithPermissions role) {
    // Check for owner role only (Employee should be editable)
    if (role.roleType == 'owner') {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space2,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: TossColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'System role • Cannot be modified',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.warning,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    
    // Show description or default text (not tags here - moved to separate widget)
    if (role.description != null && role.description!.isNotEmpty) {
      return Text(
        role.description!,
        style: TossTextStyles.bodySmall.copyWith(
          color: TossColors.gray600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    
    // Default text based on role type
    if (role.roleType == 'admin') {
      return Text(
        'System role',
        style: TossTextStyles.bodySmall.copyWith(
          color: TossColors.gray600,
        ),
      );
    }
    
    return Text(
      'Custom role',
      style: TossTextStyles.bodySmall.copyWith(
        color: TossColors.gray600,
      ),
    );
  }

  Widget _buildRoleTagChips(RoleWithPermissions role) {
    final List<String> tagsList = [];
    
    if (role.tags != null && role.tags!.isNotEmpty) {
      // Parse tags from the database format
      role.tags!.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          final tagValue = value.toString().trim();
          
          // Check if the value is a string array like "[Management, Operations]"
          if (tagValue.startsWith('[') && tagValue.endsWith(']')) {
            // Parse the string array
            String cleanedTags = tagValue.substring(1, tagValue.length - 1);
            final tags = cleanedTags
                .split(',')
                .map((tag) => tag.trim())
                .where((tag) => tag.isNotEmpty)
                .toList();
            tagsList.addAll(tags);
          } else {
            tagsList.add(tagValue);
          }
        }
      });
    }
    
    if (tagsList.isEmpty) return SizedBox.shrink();
    
    return SizedBox(
      height: 24, // Fixed height for chips
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tagsList.length,
        separatorBuilder: (context, index) => SizedBox(width: TossSpacing.space2),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TossColors.gray200,
                width: 0.5,
              ),
            ),
            child: Text(
              tagsList[index],
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildNoCompanySelected() {
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        title: Text('Role & Permission', style: TossTextStyles.h2),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
              size: 64,
              color: TossColors.gray300,
            ),
            SizedBox(height: TossSpacing.space4),
            Text(
              'No Company Selected',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Please select a company to manage roles and permissions',
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

  void _showCreateRoleModal(BuildContext context) {
    final selectedCompanyId = ref.read(selectedCompanyIdProvider);
    if (selectedCompanyId == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateRoleModal(companyId: selectedCompanyId),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.supervised_user_circle_outlined,
              size: 40,
              color: TossColors.gray400,
            ),
          ),
          SizedBox(height: TossSpacing.space5),
          Text(
            'No roles yet',
            style: TossTextStyles.h2.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            'Create custom roles to manage\nyour team permissions',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: TossSpacing.space8),
          SizedBox(
            width: 200,
            child: TossPrimaryButton(
              text: 'Create First Role',
              onPressed: () => _showCreateRoleModal(context),
              leadingIcon: Icon(Icons.add, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditRoleModal(BuildContext context, RoleWithPermissions role) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditRoleModal(role: role),
    );
  }
}

// Edit Role Modal Widget
class _EditRoleModal extends ConsumerStatefulWidget {
  final RoleWithPermissions role;
  
  const _EditRoleModal({required this.role});
  
  @override
  ConsumerState<_EditRoleModal> createState() => _EditRoleModalState();
}

class _EditRoleModalState extends ConsumerState<_EditRoleModal> with SingleTickerProviderStateMixin {
  late Map<String, bool> permissionStates;
  late TabController _tabController;
  late TextEditingController _roleNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  bool isLoading = false;
  bool _isExpanded = false;
  bool _isEditingRoleName = false;
  bool _isEditingDescription = false;
  final ScrollController _permissionsScrollController = ScrollController();
  Map<String, bool> expandedCategories = {};
  Map<String, GlobalKey> categoryKeys = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _dragHeight = 0.9;
  
  // Predefined tag options
  final List<String> tagOptions = [
    'Critical',
    'Management',
    'Operations',
    'Finance',
    'Support',
    'Temporary',
    'External',
  ];
  
  Set<String> selectedTags = {};
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0); // Start with Info tab
    _roleNameController = TextEditingController(text: widget.role.roleName);
    _descriptionController = TextEditingController(text: widget.role.description ?? '');
    
    // Initialize tags from JSON
    selectedTags = {}; // Clear first
    
    if (widget.role.tags != null && widget.role.tags!.isNotEmpty) {
      // Handle JSONB format from Supabase
      if (widget.role.tags is Map) {
        final tagsMap = Map<String, dynamic>.from(widget.role.tags!);
        
        // Check each key in the map
        tagsMap.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            final tagValue = value.toString().trim();
            
            // Check if the value is a string array like "[Management, Operations]"
            if (tagValue.startsWith('[') && tagValue.endsWith(']')) {
              // Parse the string array
              String cleanedTags = tagValue.substring(1, tagValue.length - 1);
              final tagsList = cleanedTags
                  .split(',')
                  .map((tag) => tag.trim())
                  .where((tag) => tag.isNotEmpty)
                  .toList();
              
              // Add each tag to selectedTags
              for (final tag in tagsList) {
                final matchingTag = tagOptions.firstWhere(
                  (option) => option.toLowerCase() == tag.toLowerCase(),
                  orElse: () => '',
                );
                if (matchingTag.isNotEmpty) {
                  selectedTags.add(matchingTag);
                }
              }
            }
            // Handle single tag value
            else {
              final matchingTag = tagOptions.firstWhere(
                (option) => option.toLowerCase() == tagValue.toLowerCase(),
                orElse: () => '',
              );
              if (matchingTag.isNotEmpty) {
                selectedTags.add(matchingTag);
              }
            }
          }
        });
      }
    }
    _tagsController = TextEditingController();
    
    // Initialize permission states based on current role permissions
    permissionStates = {};
    for (var permission in widget.role.permissions) {
      if (permission is Map && permission['feature_id'] != null) {
        permissionStates[permission['feature_id']] = true;
      }
    }
    
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _roleNameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _permissionsScrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: MediaQuery.of(context).size.height * _dragHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Draggable Handle Bar
          GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(() {
                _dragHeight -= details.delta.dy / MediaQuery.of(context).size.height;
                _dragHeight = _dragHeight.clamp(0.5, 1.0);
                _isExpanded = _dragHeight > 0.95;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          
          // Modal Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Role',
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: TossColors.gray700),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          
          // Tab Bar and Content
          Expanded(
            child: Column(
              children: [
                // Tab Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: TossColors.gray200, width: 1),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: TossColors.primary,
                    unselectedLabelColor: TossColors.gray500,
                    labelStyle: TossTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: TossTextStyles.labelLarge,
                    indicatorColor: TossColors.primary,
                    indicatorWeight: 2,
                    tabs: [
                      Tab(text: 'Info'),
                      Tab(text: 'Permissions'),
                      Tab(text: 'Members'),
                    ],
                  ),
                ),
                
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Info Tab
                      _buildInfoTab(),
                      // Permissions Tab
                      _buildPermissionsTab(),
                      // Members Tab
                      _buildMembersTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Container(
            padding: EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: TossColors.gray100, width: 1),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: TossColors.gray300, width: 1),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.labelLarge.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: TossPrimaryButton(
                      text: 'Save Changes',
                      onPressed: isLoading ? null : _savePermissions,
                      isLoading: isLoading,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role Name with Edit Button
          _buildEditableField(
            label: 'Role Name',
            value: _roleNameController.text,
            isEditing: _isEditingRoleName,
            controller: _roleNameController,
            placeholder: 'Enter role name',
            onEditToggle: () {
              setState(() {
                _isEditingRoleName = !_isEditingRoleName;
              });
            },
          ),
          
          SizedBox(height: TossSpacing.space5),
          
          // Description with Edit Button
          _buildEditableField(
            label: 'Description',
            value: _descriptionController.text,
            isEditing: _isEditingDescription,
            controller: _descriptionController,
            placeholder: 'Add a description for this role',
            maxLines: 3,
            onEditToggle: () {
              setState(() {
                _isEditingDescription = !_isEditingDescription;
              });
            },
          ),
          
          SizedBox(height: TossSpacing.space5),
          
          // Tags Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tags',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: TossSpacing.space3),
              _buildTagSelector(),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPermissionsTab() {
    final featuresAsync = ref.watch(featuresProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final features = featuresAsync.value ?? [];
    final allSelected = features.isNotEmpty && 
        features.every((f) => permissionStates[f.featureId] ?? false);
    
    return Column(
      children: [
        // Select All / Deselect All Toggle with Sticky Header
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space5,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: TossColors.gray200, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Permissions',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectAllPermissions(!allSelected),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: allSelected ? TossColors.gray100 : TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      allSelected ? 'Deselect All' : 'Select All',
                      style: TossTextStyles.labelSmall.copyWith(
                        color: allSelected ? TossColors.gray700 : TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Features List
        Expanded(
          child: featuresAsync.when(
            data: (features) => categoriesAsync.when(
              data: (categories) => _buildCategorizedFeaturesList(features, categories),
              loading: () => Center(child: AppLoading()),
              error: (_, __) => Center(child: Text('Failed to load categories')),
            ),
            loading: () => Center(child: AppLoading()),
            error: (error, stack) => Center(
              child: AppError(
                message: 'Failed to load features',
                onRetry: () => ref.refresh(featuresProvider),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildMembersTab() {
    final usersInRoleAsync = ref.watch(usersInRoleProvider(widget.role.roleId));
    
    return usersInRoleAsync.when(
      data: (users) => users.isEmpty
          ? Center(
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
                    'No members in this role',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
              itemCount: users.length,
              itemBuilder: (context, index) => _buildMemberItem(users[index]),
            ),
      loading: () => Center(child: AppLoading()),
      error: (_, __) => Center(
        child: AppError(
          message: 'Failed to load members',
          onRetry: () => ref.refresh(usersInRoleProvider(widget.role.roleId)),
        ),
      ),
    );
  }
  
  Widget _buildCategorizedFeaturesList(List<Feature> features, List<Category> categories) {
    // Group features by category
    final Map<String, List<Feature>> featuresByCategory = {};
    for (var feature in features) {
      if (!featuresByCategory.containsKey(feature.categoryId)) {
        featuresByCategory[feature.categoryId] = [];
      }
      featuresByCategory[feature.categoryId]!.add(feature);
    }
    
    // Initialize category keys if not already done
    for (var category in categories) {
      if (!categoryKeys.containsKey(category.categoryId)) {
        categoryKeys[category.categoryId] = GlobalKey();
      }
    }
    
    return ListView.builder(
      controller: _permissionsScrollController,
      padding: EdgeInsets.only(bottom: TossSpacing.space5),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryFeatures = featuresByCategory[category.categoryId] ?? [];
        
        if (categoryFeatures.isEmpty) return SizedBox.shrink();
        
        return _buildCategorySection(category, categoryFeatures);
      },
    );
  }
  
  Widget _buildCategorySection(Category category, List<Feature> features) {
    // Check if all features in this category are selected
    final allSelected = features.every((f) => permissionStates[f.featureId] ?? false);
    final someSelected = features.any((f) => permissionStates[f.featureId] ?? false);
    final isExpanded = expandedCategories[category.categoryId] ?? false;
    
    return Container(
      key: categoryKeys[category.categoryId],
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: TossColors.gray100, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Category Header with Select All
          AnimatedContainer(
            duration: Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space5,
              vertical: TossSpacing.space3,
            ),
            decoration: BoxDecoration(
              color: isExpanded ? TossColors.primary.withOpacity(0.05) : TossColors.gray50,
              border: Border(
                left: BorderSide(
                  color: isExpanded ? TossColors.primary : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              children: [
                // Checkbox
                InkWell(
                  onTap: () => _toggleCategoryPermissions(features, !allSelected),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: allSelected ? TossColors.primary : TossColors.gray300,
                        width: 2,
                      ),
                      color: allSelected ? TossColors.primary : Colors.transparent,
                    ),
                    child: allSelected
                        ? Icon(Icons.check, size: 16, color: Colors.white)
                        : someSelected
                            ? Icon(Icons.remove, size: 16, color: TossColors.gray400)
                            : null,
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                
                // Category Name
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Toggle expansion state immediately for responsiveness
                      setState(() {
                        expandedCategories[category.categoryId] = !isExpanded;
                      });
                      
                      // Scroll animation runs in parallel (non-blocking)
                      if (!isExpanded) {
                        // Use WidgetsBinding to ensure render is complete
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final context = categoryKeys[category.categoryId]?.currentContext;
                          if (context != null && _permissionsScrollController.hasClients) {
                            final RenderBox renderBox = context.findRenderObject() as RenderBox;
                            
                            // Get the position relative to the scroll view
                            final ScrollableState? scrollableState = Scrollable.of(context);
                            if (scrollableState != null) {
                              final RenderBox scrollRenderBox = scrollableState.context.findRenderObject() as RenderBox;
                              final position = renderBox.localToGlobal(Offset.zero, ancestor: scrollRenderBox);
                              
                              // Calculate the offset to bring category to top with small padding
                              final currentScrollOffset = _permissionsScrollController.offset;
                              final targetOffset = currentScrollOffset + position.dy - 16; // 16px padding from top
                              
                              // Animate scroll with smooth duration
                              _permissionsScrollController.animateTo(
                                targetOffset.clamp(0.0, _permissionsScrollController.position.maxScrollExtent),
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                              );
                            }
                          }
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          category.name,
                          style: TossTextStyles.labelLarge.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: TossSpacing.space2),
                        // Dropdown icon with animation
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0.0,
                          duration: Duration(milliseconds: 150),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Count
                Text(
                  '${features.where((f) => permissionStates[f.featureId] ?? false).length}/${features.length}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          
          // Features in Category - Only show if expanded
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            child: isExpanded
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(
                          color: TossColors.primary.withOpacity(0.2),
                          width: 3,
                        ),
                      ),
                    ),
                    child: Column(
                      children: features.map((feature) => _buildFeatureItem(feature)).toList(),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureItem(Feature feature) {
    final isEnabled = permissionStates[feature.featureId] ?? false;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            permissionStates[feature.featureId] = !isEnabled;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space5,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: isEnabled ? TossColors.primary.withOpacity(0.02) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: TossColors.gray100,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: TossSpacing.space10), // Increased indent for better hierarchy
              Expanded(
                child: Text(
                  feature.featureName,
                  style: TossTextStyles.body.copyWith(
                    color: isEnabled ? TossColors.gray900 : TossColors.gray600,
                    fontWeight: isEnabled ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              // Custom checkbox with Toss style
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isEnabled ? TossColors.primary : TossColors.gray300,
                    width: 2,
                  ),
                  color: isEnabled ? TossColors.primary : Colors.transparent,
                ),
                child: isEnabled
                    ? Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMemberItem(RoleUser user) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TossColors.gray50, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: TossColors.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                user.initials,
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.email,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      ' • ',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray400,
                      ),
                    ),
                    Text(
                      _formatJoinDate(user.createdAt),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatJoinDate(DateTime? date) {
    if (date == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
  
  void _selectAllPermissions(bool select) {
    final features = ref.read(featuresProvider).value ?? [];
    setState(() {
      for (var feature in features) {
        permissionStates[feature.featureId] = select;
      }
    });
  }
  
  void _toggleCategoryPermissions(List<Feature> features, bool select) {
    setState(() {
      for (var feature in features) {
        permissionStates[feature.featureId] = select;
      }
    });
  }
  
  Future<void> _savePermissions() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      // Get enabled feature IDs
      final enabledFeatureIds = permissionStates.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
      
      // Convert selected tags to Map - store as string array in tag1
      Map<String, dynamic>? tagsMap;
      if (selectedTags.isNotEmpty) {
        // Format tags as "[Tag1, Tag2]" string to match database format
        final tagsList = selectedTags.toList();
        final formattedTags = '[${tagsList.join(', ')}]';
        tagsMap = {
          'tag1': formattedTags
        };
      }
      
      final service = ref.read(roleServiceProvider);
      final success = await service.updateRole(
        roleId: widget.role.roleId,
        roleName: _roleNameController.text.trim(),
        featureIds: enabledFeatureIds,
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        tags: tagsMap,
      );
      
      if (success) {
        // Refresh the roles list
        ref.invalidate(companyRolesProvider(widget.role.companyId));
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role updated successfully'),
            backgroundColor: TossColors.success,
          ),
        );
        
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to update role');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update role'),
          backgroundColor: TossColors.error,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: TossColors.gray200),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TossTextStyles.body.copyWith(
                color: TossColors.gray400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(TossSpacing.space4),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEditableField({
    required String label,
    required String value,
    required bool isEditing,
    required TextEditingController controller,
    required String placeholder,
    required VoidCallback onEditToggle,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TossTextStyles.labelLarge.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            InkWell(
              onTap: onEditToggle,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                child: Icon(
                  isEditing ? Icons.check : Icons.edit,
                  size: 16,
                  color: isEditing ? TossColors.primary : TossColors.gray500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: TossSpacing.space2),
        if (isEditing)
          Container(
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TossColors.primary, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Slightly smaller to fit inside the border
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                autofocus: true,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                ),
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintStyle: TossTextStyles.body.copyWith(
                    color: TossColors.gray400,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(TossSpacing.space4),
                ),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Text(
              value.isEmpty ? placeholder : value,
              style: TossTextStyles.body.copyWith(
                color: value.isEmpty ? TossColors.gray400 : TossColors.gray900,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildTagSelector() {
    return Wrap(
      spacing: TossSpacing.space2,
      runSpacing: TossSpacing.space2,
      children: tagOptions.map((tag) {
        final isSelected = selectedTags.contains(tag);
        
        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedTags.remove(tag);
              } else {
                selectedTags.add(tag);
              }
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: 6, // Reduced padding
            ),
            decoration: BoxDecoration(
              color: isSelected 
                  ? TossColors.primary.withOpacity(0.08) 
                  : TossColors.gray50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected 
                    ? TossColors.primary 
                    : TossColors.gray200,
                width: 1, // Thinner border
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? TossColors.primary : TossColors.gray400,
                      width: 1.5,
                    ),
                    color: isSelected ? TossColors.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 6),
                Text(
                  tag,
                  style: TossTextStyles.labelSmall.copyWith( // Changed to labelSmall
                    color: isSelected ? TossColors.primary : TossColors.gray700,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    fontSize: 13, // Explicit font size
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
