// lib/presentation/app/route_validator.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_routes.dart';
import '../providers/app_state_provider.dart';

/// Validator for route navigation
class RouteValidator {
  /// Validate if a route exists and is accessible
  static bool isRouteValid(String route, List<String> availableRoutes) {
    final normalized = AppRoutes.normalize(route);
    
    // Check if route is in available routes
    return availableRoutes.any((r) => 
      AppRoutes.normalize(r) == normalized
    );
  }
  
  /// Get validated route or fallback
  static String getValidatedRoute(String route, List<String> availableRoutes) {
    if (isRouteValid(route, availableRoutes)) {
      return AppRoutes.normalize(route);
    }
    
    // Return home route as fallback
    return AppRoutes.home;
  }
  
  /// Check if user has access to a route based on permissions
  static bool hasRouteAccess(String route, List<String> userPermissions) {
    // TODO: Implement permission-based route access
    // For now, allow all routes
    return true;
  }
  
  /// Get error message for invalid route
  static String getRouteErrorMessage(String route) {
    if (route.isEmpty) {
      return 'Route cannot be empty';
    }
    
    if (!route.startsWith('/') && route.isNotEmpty) {
      return 'Route should start with / but got: $route';
    }
    
    return 'Route not found: $route';
  }
}

/// Provider for route validation
final routeValidatorProvider = Provider<RouteValidator>((ref) {
  return RouteValidator();
});

/// Provider for available routes from app state
final availableRoutesProvider = Provider<List<String>>((ref) {
  final appState = ref.watch(appStateProvider);
  
  // Get all feature routes from app state
  final routes = (appState.categoriesWithFeatures ?? [])
      .expand((cat) => cat.features)
      .map((f) => f.featureRoute)
      .where((r) => r.isNotEmpty)
      .toList();
  
  // Add static routes
  routes.addAll([
    AppRoutes.home,
    AppRoutes.auth,
    AppRoutes.login,
    AppRoutes.signup,
    AppRoutes.forgotPassword,
  ]);
  
  return routes;
});

/// Provider to validate a specific route
final isRouteValidProvider = Provider.family<bool, String>((ref, route) {
  final availableRoutes = ref.watch(availableRoutesProvider);
  return RouteValidator.isRouteValid(route, availableRoutes);
});

/// Navigation helper extension
extension NavigationExtension on WidgetRef {
  /// Navigate to a route with validation
  void navigateToFeature(String route, Function(String) navigate) {
    final availableRoutes = read(availableRoutesProvider);
    final validatedRoute = RouteValidator.getValidatedRoute(route, availableRoutes);
    
    if (validatedRoute != AppRoutes.home || route == AppRoutes.home) {
      navigate(validatedRoute);
    } else {
      // Route not valid, show error
      print('RouteValidator: Invalid route $route');
    }
  }
}