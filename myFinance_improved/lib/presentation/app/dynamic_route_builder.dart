// lib/presentation/app/dynamic_route_builder.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/delegaterolepage/delegaterolepage.dart';
import '../pages/rolepermissionpage/rolepermissionpage.dart';
import '../pages/employee_settings/employee_settings_page.dart';
import '../pages/features/feature_page.dart';
import 'app_routes.dart';

/// Builder for dynamic routes from Supabase
class DynamicRouteBuilder {
  /// Build GoRoute from feature configuration
  static GoRoute buildRoute(DynamicRouteConfig config) {
    // For sub-routes, remove the leading slash
    final path = config.path.startsWith('/') ? config.path.substring(1) : config.path;
    return GoRoute(
      path: path,
      builder: (context, state) => _buildPage(config),
    );
  }

  /// Build the appropriate page widget based on feature type
  static Widget _buildPage(DynamicRouteConfig config) {
    // Handle custom pages with dedicated implementations
    switch (config.path) {
      case AppRoutes.delegateRolePage:
        return const DelegateRolePage();
      case AppRoutes.rolePermissionPage:
        return const RolePermissionPage();
      case AppRoutes.employeeSetting:
        return const EmployeeSettingsPage();
      default:
        // Use generic FeaturePage for all other features
        return FeaturePage(
          featureRoute: config.path,
          featureName: config.featureName,
        );
    }
  }

  /// Build all routes from a list of features
  static List<GoRoute> buildRoutesFromFeatures(List<Map<String, dynamic>> features) {
    final routes = <GoRoute>[];
    
    for (final feature in features) {
      try {
        final config = DynamicRouteConfig.fromFeature(feature);
        if (AppRoutes.isValidRoute(config.path)) {
          routes.add(buildRoute(config));
        }
      } catch (e) {
        print('DynamicRouteBuilder: Error building route for feature: $feature, error: $e');
      }
    }
    
    return routes;
  }

  /// Map of custom page builders for specific routes
  static final Map<String, Widget Function()> _customPageBuilders = {
    AppRoutes.delegateRolePage: () => const DelegateRolePage(),
    AppRoutes.rolePermissionPage: () => const RolePermissionPage(),
    AppRoutes.employeeSetting: () => const EmployeeSettingsPage(),
  };

  /// Check if a route has a custom page implementation
  static bool hasCustomPage(String route) {
    final normalized = AppRoutes.normalize(route);
    return _customPageBuilders.containsKey(normalized);
  }

  /// Build a fallback route for unmatched paths
  static GoRoute buildFallbackRoute() {
    return GoRoute(
      path: ':route',
      builder: (context, state) {
        final route = state.pathParameters['route'] ?? '';
        return _buildFallbackPage(route);
      },
    );
  }

  /// Build a fallback page for unmatched routes
  static Widget _buildFallbackPage(String route) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              'Feature "$route" not found',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'This feature may not be available for your account',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider to manage dynamic routes
final dynamicRoutesProvider = StateNotifierProvider<DynamicRoutesNotifier, List<GoRoute>>((ref) {
  return DynamicRoutesNotifier();
});

/// State notifier for dynamic routes
class DynamicRoutesNotifier extends StateNotifier<List<GoRoute>> {
  DynamicRoutesNotifier() : super([]);

  /// Update routes from features
  void updateRoutesFromFeatures(List<Map<String, dynamic>> features) {
    state = DynamicRouteBuilder.buildRoutesFromFeatures(features);
  }

  /// Add a single route
  void addRoute(DynamicRouteConfig config) {
    state = [...state, DynamicRouteBuilder.buildRoute(config)];
  }

  /// Clear all dynamic routes
  void clearRoutes() {
    state = [];
  }

  /// Check if a route exists
  bool hasRoute(String path) {
    final normalized = AppRoutes.normalize(path);
    return state.any((route) => route.path == normalized || '/${route.path}' == normalized);
  }
}