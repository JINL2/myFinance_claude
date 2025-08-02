// lib/presentation/app/app_routes.dart

/// Centralized route management for the application
class AppRoutes {
  // Auth routes
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  
  // Main app routes
  static const String home = '/';
  
  // Feature routes from Supabase (without leading slash in DB)
  static const String delegateRolePage = '/delegateRolePage';
  static const String rolePermissionPage = '/rolePermissionPage';
  static const String contentsCreation = '/conetentsCreation';
  static const String addFixAsset = '/addFixAsset';
  static const String cashLocation = '/cashLocation';
  static const String incomeStatement = '/incomeStatement';
  static const String employeeSetting = '/employeeSetting';
  static const String debtControl = '/debtControl';
  static const String storeCreation = '/storeCreation';
  static const String cashCountingByStore = '/cashCountingByStore';
  static const String dailyIncomeByStore = '/dailyIncomeByStore';
  static const String debitBalanceByStore = '/debitBalanceByStore';
  static const String bankBalanceByStore = '/bankBalanceByStore';
  static const String cashCountingData = '/cashCountingData';
  static const String dailyIncomeData = '/dailyIncomeData';
  static const String debitBalanceData = '/debitBalanceData';
  static const String bankVaultEnding = '/bankVaultEnding';
  
  /// Normalize a route by ensuring it starts with '/'
  static String normalize(String route) {
    if (route.isEmpty) return '/';
    return route.startsWith('/') ? route : '/$route';
  }
  
  /// Check if a route is valid
  static bool isValidRoute(String route) {
    return route.isNotEmpty && route != '/';
  }
  
  /// Get route name for display
  static String getDisplayName(String route) {
    final normalized = normalize(route);
    // Remove leading slash and convert camelCase to Title Case
    final name = normalized.substring(1);
    return name.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (Match m) => '${m[1]} ${m[2]}',
    );
  }
  
  /// Map of feature routes to their page types
  static const Map<String, FeaturePageType> featurePageTypes = {
    delegateRolePage: FeaturePageType.custom,
    rolePermissionPage: FeaturePageType.custom,
    // All others use generic FeaturePage
  };
}

/// Feature page types for routing
enum FeaturePageType {
  generic,  // Uses FeaturePage widget
  custom,   // Has custom implementation
}

/// Route configuration for dynamic features
class DynamicRouteConfig {
  final String path;
  final String featureName;
  final String? categoryId;
  final FeaturePageType pageType;
  
  const DynamicRouteConfig({
    required this.path,
    required this.featureName,
    this.categoryId,
    this.pageType = FeaturePageType.generic,
  });
  
  /// Create from Supabase feature data
  factory DynamicRouteConfig.fromFeature(Map<String, dynamic> feature) {
    final route = feature['route'] as String? ?? '';
    final normalizedRoute = AppRoutes.normalize(route);
    
    return DynamicRouteConfig(
      path: normalizedRoute,
      featureName: feature['feature_name'] as String? ?? 'Unknown Feature',
      categoryId: feature['category_id'] as String?,
      pageType: AppRoutes.featurePageTypes[normalizedRoute] ?? FeaturePageType.generic,
    );
  }
}