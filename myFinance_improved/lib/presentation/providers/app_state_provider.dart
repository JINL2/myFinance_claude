import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/homepage/models/homepage_models.dart';
import '../../domain/entities/company.dart';
import '../../domain/entities/store.dart';

// App state class to hold persistent data
class AppState {
  const AppState({
    this.userWithCompanies,
    this.selectedCompanyId,
    this.selectedStoreId,
    this.lastSyncTime,
    this.categoriesWithFeatures,
    this.rawApiData,
    this.isRefreshNeeded = false,
  });

  final UserWithCompanies? userWithCompanies;
  final String? selectedCompanyId;
  final String? selectedStoreId;
  final DateTime? lastSyncTime;
  final List<CategoryWithFeatures>? categoriesWithFeatures;
  final Map<String, dynamic>? rawApiData; // Store raw API responses
  final bool isRefreshNeeded; // Flag to indicate if data refresh is needed

  AppState copyWith({
    UserWithCompanies? userWithCompanies,
    String? selectedCompanyId,
    String? selectedStoreId,
    DateTime? lastSyncTime,
    List<CategoryWithFeatures>? categoriesWithFeatures,
    Map<String, dynamic>? rawApiData,
    bool? isRefreshNeeded,
    bool clearCategories = false,
    bool clearUserData = false,
  }) {
    return AppState(
      userWithCompanies: clearUserData ? null : (userWithCompanies ?? this.userWithCompanies),
      selectedCompanyId: selectedCompanyId ?? this.selectedCompanyId,
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      categoriesWithFeatures: clearCategories ? null : (categoriesWithFeatures ?? this.categoriesWithFeatures),
      rawApiData: rawApiData ?? this.rawApiData,
      isRefreshNeeded: isRefreshNeeded ?? this.isRefreshNeeded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userWithCompanies': userWithCompanies?.toJson(),
      'selectedCompanyId': selectedCompanyId,
      'selectedStoreId': selectedStoreId,
      'lastSyncTime': lastSyncTime?.toIso8601String(),
      'categoriesWithFeatures': categoriesWithFeatures?.map((c) => c.toJson()).toList(),
      'rawApiData': rawApiData,
      'isRefreshNeeded': isRefreshNeeded,
    };
  }

  factory AppState.fromJson(Map<String, dynamic> json) {
    return AppState(
      userWithCompanies: json['userWithCompanies'] != null
          ? UserWithCompanies.fromJson(json['userWithCompanies'] as Map<String, dynamic>)
          : null,
      selectedCompanyId: json['selectedCompanyId'] as String?,
      selectedStoreId: json['selectedStoreId'] as String?,
      lastSyncTime: json['lastSyncTime'] != null
          ? DateTime.parse(json['lastSyncTime'] as String)
          : null,
      categoriesWithFeatures: json['categoriesWithFeatures'] != null
          ? (json['categoriesWithFeatures'] as List)
              .map((e) => CategoryWithFeatures.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      rawApiData: json['rawApiData'] as Map<String, dynamic>?,
      isRefreshNeeded: json['isRefreshNeeded'] as bool? ?? false,
    );
  }
}

// App state notifier with persistence
class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState()) {
    _loadFromStorage();
  }

  static const String _storageKey = 'app_state';

  // Load state from SharedPreferences
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        state = AppState.fromJson(json);
        print('AppState: Loaded from storage - Companies: ${state.userWithCompanies?.companies.length ?? 0}');
      }
    } catch (e) {
      print('AppState: Failed to load from storage: $e');
    }
  }

  // Save state to SharedPreferences
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(state.toJson());
      await prefs.setString(_storageKey, jsonString);
      print('AppState: Saved to storage');
    } catch (e) {
      print('AppState: Failed to save to storage: $e');
    }
  }

  // Update user companies data
  Future<void> updateUserCompanies(UserWithCompanies userWithCompanies) async {
    state = state.copyWith(
      userWithCompanies: userWithCompanies,
      lastSyncTime: DateTime.now(),
    );
    await _saveToStorage();
    print('AppState: Updated user companies - ${userWithCompanies.companies.length} companies');
  }

  // Select company
  Future<void> selectCompany(String companyId) async {
    state = state.copyWith(
      selectedCompanyId: companyId,
      selectedStoreId: null, // Clear store selection when company changes
    );
    await _saveToStorage();
    print('AppState: Selected company: $companyId');
  }

  // Select store
  Future<void> selectStore(String storeId) async {
    state = state.copyWith(selectedStoreId: storeId);
    await _saveToStorage();
    print('AppState: Selected store: $storeId');
  }

  // Clear all data (logout)
  Future<void> clearData() async {
    state = const AppState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    print('AppState: Cleared all data');
  }

  // Get selected company
  Company? get selectedCompany {
    if (state.selectedCompanyId == null || state.userWithCompanies == null) {
      return null;
    }
    
    try {
      return state.userWithCompanies!.companies.firstWhere(
        (company) => company.id == state.selectedCompanyId,
      );
    } catch (e) {
      return null;
    }
  }

  // Get selected store
  Store? get selectedStore {
    if (state.selectedStoreId == null || selectedCompany == null) {
      return null;
    }
    
    try {
      return selectedCompany!.stores.firstWhere(
        (store) => store.id == state.selectedStoreId,
      );
    } catch (e) {
      return null;
    }
  }

  // Check if data is stale (older than 5 minutes)
  bool get isDataStale {
    if (state.lastSyncTime == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(state.lastSyncTime!);
    return difference.inMinutes > 5;
  }

  // Update categories with features
  Future<void> updateCategoriesWithFeatures(List<CategoryWithFeatures> categories) async {
    state = state.copyWith(categoriesWithFeatures: categories);
    await _saveToStorage();
    print('AppState: Updated categories - ${categories.length} categories');
  }

  // Update raw API data for debugging
  Future<void> updateRawApiData(Map<String, dynamic> data) async {
    state = state.copyWith(rawApiData: data);
    await _saveToStorage();
    print('AppState: Updated raw API data');
  }

  // Refresh all data from API
  Future<void> refreshAllData() async {
    // Clear all cached data to force refresh from API
    state = state.copyWith(
      lastSyncTime: null, // Force data to be considered stale
      clearCategories: true, // Clear cached categories
      clearUserData: true, // Clear cached user data
    );
    await _saveToStorage();
    print('AppState: Cleared all cached data for refresh');
  }

  // Get or set company by ID (used after creation)
  Future<void> selectCompanyById(String companyId) async {
    state = state.copyWith(
      selectedCompanyId: companyId,
      selectedStoreId: null,
    );
    await _saveToStorage();
    print('AppState: Selected company by ID: $companyId');
  }

  // Mark that refresh is needed (when company/store structure changes)
  Future<void> markRefreshNeeded() async {
    // Clear the last sync time to force data refresh
    state = state.copyWith(
      isRefreshNeeded: true,
      lastSyncTime: null, // Force data to be considered stale
    );
    await _saveToStorage();
    print('AppState: Marked refresh needed and cleared last sync time');
  }

  // Clear refresh flag after refreshing
  Future<void> clearRefreshFlag() async {
    state = state.copyWith(isRefreshNeeded: false);
    await _saveToStorage();
    print('AppState: Cleared refresh flag');
  }

  // Check if refresh is needed
  bool get needsRefresh => state.isRefreshNeeded;
}

// Provider for app state
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

// Computed providers for convenience
final selectedCompanyProvider = Provider<Company?>((ref) {
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  // Force the provider to rebuild when app state changes
  return appStateNotifier.selectedCompany;
});

final selectedStoreProvider = Provider<Store?>((ref) {
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  // Force the provider to rebuild when app state changes
  return appStateNotifier.selectedStore;
});

final userCompaniesDataProvider = Provider<UserWithCompanies?>((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.userWithCompanies;
});

final isDataStaleProvider = Provider<bool>((ref) {
  final appStateNotifier = ref.read(appStateProvider.notifier);
  return appStateNotifier.isDataStale;
});