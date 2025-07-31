import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:myfinance_improved/presentation/widgets/debug/debug_panel.dart';
import 'providers/homepage_providers.dart' hide selectedCompanyProvider, selectedStoreProvider;
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import 'models/homepage_models.dart';
import 'widgets/modern_drawer.dart';
import '../../../domain/entities/company.dart';
import '../../../domain/entities/store.dart';
import '../../../domain/entities/feature.dart';
import '../../../data/services/click_tracking_service.dart';

class HomePageRedesigned extends ConsumerStatefulWidget {
  const HomePageRedesigned({super.key});

  @override
  ConsumerState<HomePageRedesigned> createState() => _HomePageRedesignedState();
}

class _HomePageRedesignedState extends ConsumerState<HomePageRedesigned> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Check for refresh when page is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndClearRefreshFlag();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Check for refresh when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      _checkAndClearRefreshFlag();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check for refresh when page regains focus (e.g., after navigation)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndClearRefreshFlag();
    });
  }

  Future<void> _checkAndClearRefreshFlag() async {
    final appStateNotifier = ref.read(appStateProvider.notifier);
    
    // Check if refresh is needed
    if (appStateNotifier.needsRefresh) {
      print('🟡🟡🟡 HomePage: Passive refresh detected - refreshing data');
      
      // Use the same refresh logic as pull-to-refresh
      try {
        // First, invalidate the force refresh providers to ensure they re-execute
        ref.invalidate(forceRefreshUserCompaniesProvider);
        ref.invalidate(forceRefreshCategoriesProvider);
        
        print('🟡 Force refresh providers invalidated, now calling them...');
        
        // Now call the force refresh providers that ALWAYS fetch from API
        final userCompaniesResult = await ref.read(forceRefreshUserCompaniesProvider.future);
        final categoriesResult = await ref.read(forceRefreshCategoriesProvider.future);
        
        print('🟡 Force refresh providers completed with results:');
        print('🟡 UserCompanies: ${userCompaniesResult.companies.length} companies');
        print('🟡 Categories: ${categoriesResult.length} categories');
        
        // Invalidate the regular providers to show the new data
        ref.invalidate(userCompaniesProvider);
        ref.invalidate(categoriesWithFeaturesProvider);
        
        // Clear the refresh flag after successful refresh
        await appStateNotifier.clearRefreshFlag();
        
        print('🟡 HomePage: Passive refresh COMPLETED - fresh data from API');
      } catch (e) {
        print('🟡 HomePage: Error during passive refresh: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userCompaniesAsync = ref.watch(userCompaniesProvider);
    final categoriesAsync = ref.watch(categoriesWithFeaturesProvider);
    final appState = ref.watch(appStateProvider);
    // Watch the selections so they update when changed
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final selectedStore = ref.watch(selectedStoreProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main Content
          userCompaniesAsync.when(
            data: (userData) => RefreshIndicator(
              onRefresh: () => _handleRefresh(ref),
              color: Theme.of(context).colorScheme.primary,
              child: CustomScrollView(
                slivers: [
                  // Simple App Bar
                  _buildSimpleAppBar(context, userData),
                  
                  // Pinned Hello Section
                  _buildPinnedHelloSection(context, userData, selectedCompany, selectedStore),
                  
                  // Add spacing after Hello section
                  SliverToBoxAdapter(
                    child: SizedBox(height: TossSpacing.space4),
                  ),
                  
                  // Quick Actions Section
                  _buildQuickActionsSection(categoriesAsync),
                  
                  // Main Features
                  _buildMainFeaturesSection(categoriesAsync),
                ],
              ),
            ),
            loading: () => Center(
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Something went wrong', style: TossTextStyles.h3),
                  const SizedBox(height: 8),
                  Text(error.toString(), style: TossTextStyles.caption),
                ],
              ),
            ),
          ),
          
          // Debug Panel
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: DebugPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleAppBar(BuildContext context, UserWithCompanies userData) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent, // Prevents color change on scroll
      shadowColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 56, // Standard app bar height
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onSurface),
        onPressed: () => _showCompanyStoreBottomSheet(context, ref),
      ),
      actions: [
        // Notifications
        IconButton(
          icon: Badge(
            isLabelVisible: true,
            smallSize: 6,
            largeSize: 6,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.notifications_none_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 26,
            ),
          ),
          onPressed: () {},
        ),
        // Profile
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Theme.of(context).colorScheme.surface,
            elevation: 4,
            onSelected: (value) {
              if (value == 'settings') {
                // Navigate to settings
                context.push('/settings');
              } else if (value == 'logout') {
                // Handle logout
                ref.read(authStateProvider.notifier).signOut();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Text(
                      'Settings',
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Text(
                      'Logout',
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            child: CircleAvatar(
              radius: 18,
              backgroundImage: userData.profileImage.isNotEmpty
                  ? NetworkImage(userData.profileImage)
                  : null,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: userData.profileImage.isEmpty
                  ? Text(
                      userData.userFirstName.isNotEmpty ? userData.userFirstName[0] : 'U',
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinnedHelloSection(BuildContext context, UserWithCompanies userData, Company? selectedCompany, Store? selectedStore) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _PinnedHelloDelegate(
        userData: userData,
        selectedCompany: selectedCompany,
        selectedStore: selectedStore,
        context: context,
      ),
    );
  }


  Widget _buildQuickActionsSection(AsyncValue<List<CategoryWithFeatures>> categoriesAsync) {
    return SliverToBoxAdapter(
      child: categoriesAsync.when(
        data: (categories) {
          // Get top 6 most important features across all categories with their category IDs
          final allFeaturesWithCategory = <(Feature, String)>[];
          for (final category in categories) {
            print('Category: ${category.categoryName} (ID: ${category.categoryId})');
            for (final feature in category.features) {
              print('  - Feature: ${feature.featureName} will use categoryId: ${category.categoryId}');
              allFeaturesWithCategory.add((feature, category.categoryId));
            }
          }
          
          // For now, take first 6 features. In production, this would be based on usage
          final quickFeaturesWithCategory = allFeaturesWithCategory.take(6).toList();
          
          if (quickFeaturesWithCategory.isEmpty) return const SizedBox.shrink();
          
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header with consistent spacing
                  Text(
                    'Quick Actions',
                    style: TossTextStyles.h3.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space3),
                  
                  // Container with consistent padding
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: TossShadows.cardShadow,
                    ),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio: 1.3, // Adjust for better proportions with spacing
                    ),
                    itemCount: quickFeaturesWithCategory.length,
                    itemBuilder: (context, index) {
                      final (feature, categoryId) = quickFeaturesWithCategory[index];
                      return _buildQuickActionItem(feature, categoryId);
                    },
                  ),
                ),
                SizedBox(height: TossSpacing.space4),
                ],
              ),
            ),
          );
        },
        loading: () => _buildQuickActionsLoading(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildQuickActionsLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space1),
            child: Text(
              'Quick Actions',
              style: TossTextStyles.h3.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: TossSpacing.space4),
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: TossShadows.cardShadow,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: TossSpacing.space3,
                mainAxisSpacing: TossSpacing.space3,
                childAspectRatio: 1.0,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Container(
                        width: 50,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: TossSpacing.space8),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(Feature feature, String categoryId) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleFeatureTap(feature, categoryId),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.06),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with compact sizing
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: feature.featureIcon.isNotEmpty &&
                        (feature.featureIcon.startsWith('http://') ||
                         feature.featureIcon.startsWith('https://'))
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          feature.featureIcon,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.apps,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.apps,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
              ),
              SizedBox(height: TossSpacing.space1),
              Text(
                feature.featureName,
                style: TossTextStyles.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainFeaturesSection(AsyncValue<List<CategoryWithFeatures>> categoriesAsync) {
    return SliverToBoxAdapter(
      child: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: Container(
                  padding: EdgeInsets.all(TossSpacing.space10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: TossShadows.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: TossSpacing.space4),
                      Text(
                        'No features available',
                        style: TossTextStyles.body.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Features',
                    style: TossTextStyles.h3.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space3),
                  ...categories.map((category) => _buildCategorySection(category)),
                  SizedBox(height: TossSpacing.space24), // Space for debug panel
                ],
              ),
            ),
          );
        },
        loading: () => Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Center(
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        error: (error, _) => Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: TossShadows.cardShadow,
              ),
              child: Text(
                'Error loading features: $error',
                style: TossTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(CategoryWithFeatures category) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space4),
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: TossShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header with Toss-style minimal design
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Text(
                category.categoryName,
                style: TossTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space4),
          
          // Features List with minimal spacing
          ...category.features.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;
            return Column(
              children: [
                _buildFeatureListItem(feature, category.categoryId),
                if (index < category.features.length - 1)
                  SizedBox(height: TossSpacing.space1),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFeatureListItem(Feature feature, String categoryId) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleFeatureTap(feature, categoryId),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3, 
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              // Icon with theme colors
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: feature.featureIcon.isNotEmpty &&
                        (feature.featureIcon.startsWith('http://') ||
                         feature.featureIcon.startsWith('https://'))
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          feature.featureIcon,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.apps,
                            color: Theme.of(context).colorScheme.primary,
                            size: 16,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.apps,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
              ),
              SizedBox(width: TossSpacing.space3),
              
              // Feature Name with theme colors
              Expanded(
                child: Text(
                  feature.featureName,
                  style: TossTextStyles.body.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              
              // Arrow with theme colors
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFeatureTap(Feature feature, [String? categoryId]) async {
    try {
      // Track the feature click only if categoryId is provided
      if (categoryId != null) {
        print('Tracking feature: ${feature.featureName} with categoryId: $categoryId');
        final clickTracker = ref.read(clickTrackingServiceProvider);
        await clickTracker.trackFeatureEntityClick(feature, categoryId: categoryId);
      } else {
        print('Warning: No categoryId provided for feature: ${feature.featureName}');
      }
      
      // Navigate to the feature route
      if (feature.featureRoute.isNotEmpty) {
        context.push(feature.featureRoute);
      } else {
        // Show message if no route is defined
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${feature.featureName} coming soon!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (e) {
      print('Error handling feature tap: $e');
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening ${feature.featureName}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    try {
      print('🟢🟢🟢 HomePage: PULL-TO-REFRESH TRIGGERED');
      print('🟢 This should ALWAYS call the API!');
      
      // First, invalidate the force refresh providers to ensure they re-execute
      ref.invalidate(forceRefreshUserCompaniesProvider);
      ref.invalidate(forceRefreshCategoriesProvider);
      
      print('🟢 Force refresh providers invalidated, now calling them...');
      
      // Now call the force refresh providers that ALWAYS fetch from API
      final userCompaniesResult = await ref.read(forceRefreshUserCompaniesProvider.future);
      final categoriesResult = await ref.read(forceRefreshCategoriesProvider.future);
      
      print('🟢 Force refresh providers completed with results:');
      print('🟢 UserCompanies: ${userCompaniesResult.companies.length} companies');
      print('🟢 Categories: ${categoriesResult.length} categories');
      
      // Invalidate the regular providers to show the new data
      ref.invalidate(userCompaniesProvider);
      ref.invalidate(categoriesWithFeaturesProvider);
      
      print('🟢 HomePage: Manual refresh COMPLETED - fresh data from API');
      
      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data refreshed successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (e) {
      print('HomePage: Manual refresh failed: $e');
      
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  void _showCompanyStoreBottomSheet(BuildContext context, WidgetRef ref) {
    // No longer refresh automatically when showing drawer
    final userCompaniesAsync = ref.read(userCompaniesProvider);
    
    userCompaniesAsync.when(
      data: (userData) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ModernDrawer(userData: userData),
          ),
        );
      },
      loading: () {
        // Show loading indicator if data is not available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Loading user data...'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
      error: (error, _) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
    );
  }
}

class _PinnedHelloDelegate extends SliverPersistentHeaderDelegate {
  final UserWithCompanies userData;
  final Company? selectedCompany;
  final Store? selectedStore;
  final BuildContext context;

  _PinnedHelloDelegate({
    required this.userData,
    required this.selectedCompany,
    required this.selectedStore,
    required this.context,
  });

  @override
  double get minExtent => 85.0;

  @override
  double get maxExtent => 85.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: TossShadows.cardShadow,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello, ${userData.userFirstName}!',
              style: TossTextStyles.h2.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (selectedCompany != null) ...[
              SizedBox(height: TossSpacing.space1),
              Row(
                children: [
                  Text(
                    selectedCompany!.companyName,
                    style: TossTextStyles.body.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (selectedStore != null) ...[
                    Text(
                      ' • ',
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        selectedStore!.storeName,
                        style: TossTextStyles.caption.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }
}