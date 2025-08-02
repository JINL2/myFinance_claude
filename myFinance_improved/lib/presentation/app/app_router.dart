import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../providers/auth_provider.dart';
import '../providers/app_state_provider.dart';
import '../pages/homepage/homepage_redesigned.dart';
import '../pages/delegaterolepage/delegaterolepage.dart';
import '../pages/rolepermissionpage/rolepermissionpage.dart';
import '../pages/features/feature_page.dart';
import 'app_routes.dart';
import 'dynamic_route_builder.dart';

// Router notifier to listen to auth state changes
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<bool>(
      isAuthenticatedProvider,
      (previous, next) {
        print('RouterNotifier: Auth state changed from $previous to $next');
        notifyListeners();
      },
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  // Get features from app state for dynamic routes
  final appState = ref.watch(appStateProvider);
  final featuresWithCategory = <Map<String, dynamic>>[];
  
  // Map features with their category IDs
  for (final category in (appState.categoriesWithFeatures ?? [])) {
    for (final feature in category.features) {
      featuresWithCategory.add({
        'route': feature.featureRoute,
        'feature_name': feature.featureName,
        'category_id': category.categoryId,
      });
    }
  }
  
  // Build dynamic routes from features
  final dynamicRoutes = DynamicRouteBuilder.buildRoutesFromFeatures(featuresWithCategory);
  
  print('Router: Creating router with ${dynamicRoutes.length} dynamic routes');
  print('Router: Dynamic routes include: ${dynamicRoutes.map((r) => r.path).join(', ')}');
  
  final router = GoRouter(
    initialLocation: '/auth/login',
    refreshListenable: RouterNotifier(ref),
    onException: (context, state, router) {
      print('Router Exception: ${state.error}');
      print('Router Exception: Attempted location: ${state.matchedLocation}');
      print('Router Exception: Dynamic routes count: ${dynamicRoutes.length}');
    },
    redirect: (context, state) {
      final isAuth = ref.read(isAuthenticatedProvider);
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      
      print('Router redirect: isAuth=$isAuth, location=${state.matchedLocation}, isAuthRoute=$isAuthRoute');
      
      // If not authenticated and not on auth route, go to login
      if (!isAuth && !isAuthRoute) {
        print('Router redirect: Not authenticated, redirecting to login');
        return '/auth/login';
      }
      
      // If authenticated and on auth route, go to home
      if (isAuth && isAuthRoute) {
        print('Router redirect: Authenticated on auth route, redirecting to home');
        return '/';
      }
      
      print('Router redirect: No redirect needed');
      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/auth',
        redirect: (context, state) => '/auth/login',
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'signup',
            builder: (context, state) => const SignupPage(),
          ),
          GoRoute(
            path: 'forgot-password',
            builder: (context, state) => const ForgotPasswordPage(),
          ),
        ],
      ),
      
      // Main App Routes (protected)
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePageRedesigned(),
        routes: [
          // Add all dynamic routes as sub-routes
          ...dynamicRoutes,
          
          // Add a fallback route for unmatched paths
          DynamicRouteBuilder.buildFallbackRoute(),
        ],
      ),
    ],
  );
  
  // Add global route handler for missing leading slash issue
  print('Router: Setup complete with ${router.routerDelegate.currentConfiguration.routes.length} total routes');
  
  return router;
});