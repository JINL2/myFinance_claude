import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../providers/auth_provider.dart';
import '../pages/homepage/homepage_redesigned.dart';

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
  // Create router with refresh listenable
  final router = GoRouter(
    initialLocation: '/auth/login',
    refreshListenable: RouterNotifier(ref),
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
      ),
    ],
  );
  
  return router;
});