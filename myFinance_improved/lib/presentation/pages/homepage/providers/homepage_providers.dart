import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/domain/repositories/user_repository.dart';
import 'package:myfinance_improved/domain/repositories/company_repository.dart';
import 'package:myfinance_improved/domain/repositories/feature_repository.dart';
import 'package:myfinance_improved/domain/entities/company.dart';
import 'package:myfinance_improved/domain/entities/store.dart';
import 'package:myfinance_improved/presentation/providers/auth_provider.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';
import '../models/homepage_models.dart';

/// Provider for user data with companies (integrates with app state)
final userCompaniesProvider = FutureProvider<UserWithCompanies>((ref) async {
  final user = ref.watch(authStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  // Watch app state to rebuild when isRefreshNeeded changes
  final appState = ref.watch(appStateProvider);
  
  if (user == null) {
    throw UnauthorizedException();
  }
  
  // Check if we need to refresh based on the isRefreshNeeded flag or if data is stale
  final needsRefresh = appState.isRefreshNeeded || appStateNotifier.isDataStale;
  
  // Check if we have cached data and don't need to refresh
  if (appState.userWithCompanies != null && !needsRefresh) {
    print('UserCompaniesProvider: Using cached data (needsRefresh: $needsRefresh, isDataStale: ${appStateNotifier.isDataStale})');
    return appState.userWithCompanies!;
  }
  
  // Fetch fresh data from API
  print('UserCompaniesProvider: Fetching fresh data from API for user: ${user.id}');
  print('UserCompaniesProvider: Reason - needsRefresh: $needsRefresh, isDataStale: ${appStateNotifier.isDataStale}');
  final repository = ref.watch(userRepositoryProvider);
  final userWithCompanies = await repository.getUserWithCompanies(user.id);
  
  // Save to app state for persistence
  await appStateNotifier.updateUserCompanies(userWithCompanies);
  
  print('UserCompaniesProvider: Fetched ${userWithCompanies.companies.length} companies:');
  for (final company in userWithCompanies.companies) {
    print('  - ${company.companyName} (${company.id}) with ${company.stores.length} stores');
  }
  
  // Auto-select first company if none selected
  if (appState.selectedCompanyId == null && userWithCompanies.companies.isNotEmpty) {
    await appStateNotifier.selectCompany(userWithCompanies.companies.first.id);
  }
  
  return userWithCompanies;
});

/// Force refresh provider - ALWAYS fetches from API
final forceRefreshUserCompaniesProvider = FutureProvider<UserWithCompanies>((ref) async {
  print('🔵🔵🔵 ForceRefreshUserCompanies: PROVIDER CALLED');
  print('🔵 This provider ALWAYS calls the API - no cache!');
  
  final user = ref.watch(authStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  if (user == null) {
    throw UnauthorizedException();
  }
  
  // ALWAYS fetch fresh data from API - no cache check
  print('🔵 ForceRefreshUserCompanies: About to call API for user: ${user.id}');
  final repository = ref.watch(userRepositoryProvider);
  final userWithCompanies = await repository.getUserWithCompanies(user.id);
  
  // Save to app state for persistence
  await appStateNotifier.updateUserCompanies(userWithCompanies);
  
  print('ForceRefreshUserCompanies: Fetched ${userWithCompanies.companies.length} companies:');
  for (final company in userWithCompanies.companies) {
    print('  - ${company.companyName} (${company.id}) with ${company.stores.length} stores');
  }
  
  // Auto-select first company if none selected
  final appState = ref.read(appStateProvider);
  if (appState.selectedCompanyId == null && userWithCompanies.companies.isNotEmpty) {
    await appStateNotifier.selectCompany(userWithCompanies.companies.first.id);
  }
  
  return userWithCompanies;
});

// Note: selectedCompanyProvider and selectedStoreProvider are now imported from app_state_provider.dart
// to avoid duplication and ensure single source of truth

/// Provider for categories with features filtered by permissions
final categoriesWithFeaturesProvider = FutureProvider<List<CategoryWithFeatures>>((ref) async {
  final repository = ref.watch(featureRepositoryProvider);
  // Watch app state to rebuild when isRefreshNeeded changes
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  print('CategoriesProvider: App state selectedCompanyId: ${appState.selectedCompanyId}');
  
  // Check if we need to refresh based on the isRefreshNeeded flag or if data is stale
  final needsRefresh = appState.isRefreshNeeded || appStateNotifier.isDataStale;
  
  // Check if we have cached categories and don't need to refresh
  if (appState.categoriesWithFeatures != null && !needsRefresh) {
    print('CategoriesProvider: Using cached categories (needsRefresh: $needsRefresh, isDataStale: ${appStateNotifier.isDataStale})');
    return appState.categoriesWithFeatures!;
  }
  
  // Get selected company from app state
  final selectedCompany = appStateNotifier.selectedCompany;
  
  if (selectedCompany == null) {
    print('CategoriesProvider: No selected company, returning empty list');
    return [];
  }
  
  print('CategoriesProvider: Selected company: ${selectedCompany.companyName}');
  final userRole = selectedCompany.role;
  final permissions = userRole.permissions;
  print('CategoriesProvider: User permissions count: ${permissions.length}');
  
  // Fetch all categories with features
  final categories = await repository.getCategoriesWithFeatures();
  print('CategoriesProvider: Fetched ${categories.length} categories from repository');
  
  // Filter features based on user permissions
  final filteredCategories = categories.map((category) {
    final filteredFeatures = category.features.where((feature) {
      return permissions.contains(feature.featureId);
    }).toList();
    
    print('CategoriesProvider: Category "${category.categoryName}" has ${filteredFeatures.length}/${category.features.length} permitted features');
    
    return CategoryWithFeatures(
      categoryId: category.categoryId,
      categoryName: category.categoryName,
      features: filteredFeatures,
    );
  }).where((category) {
    // Only include categories that have at least one permitted feature
    return category.features.isNotEmpty;
  }).toList();
  
  // Save to app state for caching
  await appStateNotifier.updateCategoriesWithFeatures(filteredCategories);
  
  print('CategoriesProvider: Returning ${filteredCategories.length} categories with features');
  return filteredCategories;
});

/// Force refresh provider for categories - ALWAYS fetches from API
final forceRefreshCategoriesProvider = FutureProvider<List<CategoryWithFeatures>>((ref) async {
  print('🔵🔵🔵 ForceRefreshCategories: PROVIDER CALLED');
  print('🔵 This provider ALWAYS calls the API - no cache!');
  
  final repository = ref.watch(featureRepositoryProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  // Get selected company from app state
  final selectedCompany = appStateNotifier.selectedCompany;
  
  if (selectedCompany == null) {
    print('🔵 ForceRefreshCategories: No selected company, returning empty list');
    return [];
  }
  
  print('🔵 ForceRefreshCategories: About to call API for categories');
  final userRole = selectedCompany.role;
  final permissions = userRole.permissions;
  
  // ALWAYS fetch fresh categories from API
  final categories = await repository.getCategoriesWithFeatures();
  print('ForceRefreshCategories: Fetched ${categories.length} categories from repository');
  
  // Filter features based on user permissions
  final filteredCategories = categories.map((category) {
    final filteredFeatures = category.features.where((feature) {
      return permissions.contains(feature.featureId);
    }).toList();
    
    print('ForceRefreshCategories: Category "${category.categoryName}" has ${filteredFeatures.length}/${category.features.length} permitted features');
    
    return CategoryWithFeatures(
      categoryId: category.categoryId,
      categoryName: category.categoryName,
      features: filteredFeatures,
    );
  }).where((category) {
    // Only include categories that have at least one permitted feature
    return category.features.isNotEmpty;
  }).toList();
  
  // Save to app state for caching
  await appStateNotifier.updateCategoriesWithFeatures(filteredCategories);
  
  print('ForceRefreshCategories: Returning ${filteredCategories.length} categories with features');
  return filteredCategories;
});

/// Homepage loading state model
class HomepageLoading {
  const HomepageLoading({
    this.isUserDataLoading = false,
    this.isFeaturesLoading = false,
    this.isSyncLoading = false,
  });

  final bool isUserDataLoading;
  final bool isFeaturesLoading;
  final bool isSyncLoading;

  HomepageLoading copyWith({
    bool? isUserDataLoading,
    bool? isFeaturesLoading,
    bool? isSyncLoading,
  }) {
    return HomepageLoading(
      isUserDataLoading: isUserDataLoading ?? this.isUserDataLoading,
      isFeaturesLoading: isFeaturesLoading ?? this.isFeaturesLoading,
      isSyncLoading: isSyncLoading ?? this.isSyncLoading,
    );
  }
}

/// Provider for homepage loading states
class HomepageLoadingStateNotifier extends StateNotifier<HomepageLoading> {
  HomepageLoadingStateNotifier() : super(const HomepageLoading());

  void setUserDataLoading(bool isLoading) {
    state = state.copyWith(isUserDataLoading: isLoading);
  }

  void setFeaturesLoading(bool isLoading) {
    state = state.copyWith(isFeaturesLoading: isLoading);
  }

  void setSyncLoading(bool isLoading) {
    state = state.copyWith(isSyncLoading: isLoading);
  }
}

final homepageLoadingStateProvider = StateNotifierProvider<HomepageLoadingStateNotifier, HomepageLoading>((ref) {
  return HomepageLoadingStateNotifier();
});

/// Provider to check if user can add stores (Owner role only)
final canAddStoreProvider = Provider<bool>((ref) {
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final selectedCompany = appStateNotifier.selectedCompany;
  return selectedCompany?.role.roleName == 'Owner';
});

/// Provider for top features by user based on usage
final topFeaturesByUserProvider = FutureProvider<List<TopFeature>>((ref) async {
  final user = ref.watch(authStateProvider);
  
  if (user == null) {
    return [];
  }
  
  final repository = ref.watch(featureRepositoryProvider);
  return repository.getTopFeaturesByUser(userId: user.id);
});

/// Provider for company count to detect changes
final localCompanyCountProvider = Provider<int?>((ref) {
  final userCompanies = ref.watch(userCompaniesProvider).valueOrNull;
  return userCompanies?.companyCount;
});

/// Repository providers (using Supabase implementations)
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return SupabaseUserRepository();
});

final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  return SupabaseCompanyRepository();
});

final featureRepositoryProvider = Provider<FeatureRepository>((ref) {
  return SupabaseFeatureRepository();
});

/// Exception classes
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'User is not authenticated']);
}