import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';


import '/auth/base_auth_user_provider.dart';

import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? HomepageWidget() : Auth1Widget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) =>
              appStateNotifier.loggedIn ? HomepageWidget() : Auth1Widget(),
        ),
        FFRoute(
          name: CashBalanceWidget.routeName,
          path: CashBalanceWidget.routePath,
          builder: (context, params) => CashBalanceWidget(),
        ),
        FFRoute(
          name: BankVaultEndingWidget.routeName,
          path: BankVaultEndingWidget.routePath,
          builder: (context, params) => BankVaultEndingWidget(),
        ),
        FFRoute(
          name: HomepageWidget.routeName,
          path: HomepageWidget.routePath,
          builder: (context, params) => HomepageWidget(
            firstLogin: params.getParam(
              'firstLogin',
              ParamType.bool,
            ),
            companyclicked: params.getParam(
              'companyclicked',
              ParamType.bool,
            ),
            storeclicked: params.getParam(
              'storeclicked',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: StoreShiftSettingWidget.routeName,
          path: StoreShiftSettingWidget.routePath,
          builder: (context, params) => StoreShiftSettingWidget(),
        ),
        FFRoute(
          name: TransactionHistoryWidget.routeName,
          path: TransactionHistoryWidget.routePath,
          builder: (context, params) => TransactionHistoryWidget(),
        ),
        FFRoute(
          name: ResetPasswordWidget.routeName,
          path: ResetPasswordWidget.routePath,
          builder: (context, params) => ResetPasswordWidget(),
        ),
        FFRoute(
          name: NewpasswordWidget.routeName,
          path: NewpasswordWidget.routePath,
          builder: (context, params) => NewpasswordWidget(),
        ),
        FFRoute(
          name: UserProfileInputWidget.routeName,
          path: UserProfileInputWidget.routePath,
          builder: (context, params) => UserProfileInputWidget(),
        ),
        FFRoute(
          name: CashLocationWidget.routeName,
          path: CashLocationWidget.routePath,
          builder: (context, params) => CashLocationWidget(),
        ),
        FFRoute(
          name: AccountMappingWidget.routeName,
          path: AccountMappingWidget.routePath,
          builder: (context, params) => AccountMappingWidget(),
        ),
        FFRoute(
          name: Auth1Widget.routeName,
          path: Auth1Widget.routePath,
          builder: (context, params) => Auth1Widget(),
        ),
        FFRoute(
          name: TransactionTemplateWidget.routeName,
          path: TransactionTemplateWidget.routePath,
          builder: (context, params) => TransactionTemplateWidget(),
        ),
        FFRoute(
          name: CashControlWidget.routeName,
          path: CashControlWidget.routePath,
          builder: (context, params) => CashControlWidget(),
        ),
        FFRoute(
          name: AddFixAssetWidget.routeName,
          path: AddFixAssetWidget.routePath,
          builder: (context, params) => AddFixAssetWidget(),
        ),
        FFRoute(
          name: TimeTableUserWidget.routeName,
          path: TimeTableUserWidget.routePath,
          builder: (context, params) => TimeTableUserWidget(),
        ),
        FFRoute(
          name: MyPageWidget.routeName,
          path: MyPageWidget.routePath,
          builder: (context, params) => MyPageWidget(),
        ),
        FFRoute(
          name: RegisterCounterpartyWidget.routeName,
          path: RegisterCounterpartyWidget.routePath,
          builder: (context, params) => RegisterCounterpartyWidget(),
        ),
        FFRoute(
          name: RolePermissionPageWidget.routeName,
          path: RolePermissionPageWidget.routePath,
          builder: (context, params) => RolePermissionPageWidget(),
        ),
        FFRoute(
          name: DelegateRolePageWidget.routeName,
          path: DelegateRolePageWidget.routePath,
          builder: (context, params) => DelegateRolePageWidget(),
        ),
        FFRoute(
          name: TestestesWidget.routeName,
          path: TestestesWidget.routePath,
          builder: (context, params) => TestestesWidget(),
        ),
        FFRoute(
          name: RegisterDenominationWidget.routeName,
          path: RegisterDenominationWidget.routePath,
          builder: (context, params) => RegisterDenominationWidget(),
        ),
        FFRoute(
          name: EmployeeSettingWidget.routeName,
          path: EmployeeSettingWidget.routePath,
          builder: (context, params) => EmployeeSettingWidget(),
        ),
        FFRoute(
          name: IncomeStatementWidget.routeName,
          path: IncomeStatementWidget.routePath,
          builder: (context, params) => IncomeStatementWidget(),
        ),
        FFRoute(
          name: ChooseCompanyWidget.routeName,
          path: ChooseCompanyWidget.routePath,
          builder: (context, params) => ChooseCompanyWidget(),
        ),
        FFRoute(
          name: TimetableManage123Widget.routeName,
          path: TimetableManage123Widget.routePath,
          builder: (context, params) => TimetableManage123Widget(),
        ),
        FFRoute(
          name: JournalInputWidget.routeName,
          path: JournalInputWidget.routePath,
          builder: (context, params) => JournalInputWidget(),
        ),
        FFRoute(
          name: BalanceSheetWidget.routeName,
          path: BalanceSheetWidget.routePath,
          builder: (context, params) => BalanceSheetWidget(),
        ),
        FFRoute(
          name: AttendanceWidget.routeName,
          path: AttendanceWidget.routePath,
          builder: (context, params) => AttendanceWidget(),
        ),
        FFRoute(
          name: CashEndingWidget.routeName,
          path: CashEndingWidget.routePath,
          builder: (context, params) => CashEndingWidget(),
        ),
        FFRoute(
          name: DebtControlWidget.routeName,
          path: DebtControlWidget.routePath,
          builder: (context, params) => DebtControlWidget(),
        ),
        FFRoute(
          name: AttendancetestesWidget.routeName,
          path: AttendancetestesWidget.routePath,
          builder: (context, params) => AttendancetestesWidget(),
        ),
        FFRoute(
          name: CashLocation1Widget.routeName,
          path: CashLocation1Widget.routePath,
          builder: (context, params) => CashLocation1Widget(),
        ),
        FFRoute(
          name: TimeTableUsertestWidget.routeName,
          path: TimeTableUsertestWidget.routePath,
          builder: (context, params) => TimeTableUsertestWidget(),
        ),
        FFRoute(
          name: TimetableManageWidget.routeName,
          path: TimetableManageWidget.routePath,
          builder: (context, params) => TimetableManageWidget(),
        ),
        FFRoute(
          name: ConetentsCreationWidget.routeName,
          path: ConetentsCreationWidget.routePath,
          builder: (context, params) => ConetentsCreationWidget(),
        ),
        FFRoute(
          name: SurveyDashboardWidget.routeName,
          path: SurveyDashboardWidget.routePath,
          builder: (context, params) => SurveyDashboardWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/auth1';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/images/ChatGPT_Image_May_18,_2025,_06_30_02_PM.png',
                    fit: BoxFit.cover,
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
