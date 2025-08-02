// lib/presentation/app/route_constants.dart

/// Route constants for type-safe navigation
/// These constants match the routes stored in Supabase
class RouteConstants {
  // Prevent instantiation
  RouteConstants._();
  
  // Auth routes
  static const auth = '/auth';
  static const login = '/auth/login';
  static const signup = '/auth/signup';
  static const forgotPassword = '/auth/forgot-password';
  
  // Main routes
  static const home = '/';
  
  // Role & Permission Management
  static const delegateRolePage = '/delegateRolePage';
  static const rolePermissionPage = '/rolePermissionPage';
  
  // Content Management
  static const contentsCreation = '/conetentsCreation';
  
  // Asset Management
  static const addFixAsset = '/addFixAsset';
  
  // Cash Management
  static const cashLocation = '/cashLocation';
  static const cashEnding = '/cashEnding';
  static const cashBalance = '/cashBalance';
  static const cashCountingByStore = '/cashCountingByStore';
  static const cashCountingData = '/cashCountingData';
  
  // Financial Management
  static const incomeStatement = '/incomeStatement';
  static const dailyIncomeByStore = '/dailyIncomeByStore';
  static const dailyIncomeData = '/dailyIncomeData';
  static const journalInput = '/journalInput';
  static const accountMapping = '/accountMapping';
  static const transactionHistory = '/transactionHistory';
  
  // Debt & Balance Management
  static const debtControl = '/debtControl';
  static const debitBalanceByStore = '/debitBalanceByStore';
  static const debitBalanceData = '/debitBalanceData';
  static const bankBalanceByStore = '/bankBalanceByStore';
  static const bankVaultEnding = '/bankVaultEnding';
  
  // Employee Management
  static const employeeSetting = '/employeeSetting';
  static const attendance = '/attendance';
  
  // Store Management
  static const storeCreation = '/storeCreation';
  static const storeShiftSetting = '/storeShiftSetting';
  
  // Other Features
  static const registerCounterparty = '/registerCounterparty';
  static const registerDenomination = '/registerDenomination';
  static const surveyDashboard = '/surveyDashboard';
  
  /// Get all defined routes
  static List<String> get allRoutes => [
    auth,
    login,
    signup,
    forgotPassword,
    home,
    delegateRolePage,
    rolePermissionPage,
    contentsCreation,
    addFixAsset,
    cashLocation,
    cashEnding,
    cashBalance,
    cashCountingByStore,
    cashCountingData,
    incomeStatement,
    dailyIncomeByStore,
    dailyIncomeData,
    journalInput,
    accountMapping,
    transactionHistory,
    debtControl,
    debitBalanceByStore,
    debitBalanceData,
    bankBalanceByStore,
    bankVaultEnding,
    employeeSetting,
    attendance,
    storeCreation,
    storeShiftSetting,
    registerCounterparty,
    registerDenomination,
    surveyDashboard,
  ];
  
  /// Check if a route is an auth route
  static bool isAuthRoute(String route) {
    return route.startsWith(auth);
  }
  
  /// Check if a route requires authentication
  static bool requiresAuth(String route) {
    return !isAuthRoute(route);
  }
  
  /// Get display name for a route
  static String getDisplayName(String route) {
    final routeMap = {
      delegateRolePage: 'Delegate Role',
      rolePermissionPage: 'Role Permissions',
      contentsCreation: 'Contents Helper',
      addFixAsset: 'Add Fixed Asset',
      cashLocation: 'Cash Location',
      cashEnding: 'Cash Ending',
      cashBalance: 'Cash Balance',
      cashCountingByStore: 'Cash Counting by Store',
      cashCountingData: 'Cash Counting Data',
      incomeStatement: 'Income Statement',
      dailyIncomeByStore: 'Daily Income by Store',
      dailyIncomeData: 'Daily Income Data',
      journalInput: 'Journal Input',
      accountMapping: 'Account Mapping',
      transactionHistory: 'Transaction History',
      debtControl: 'Debt Control',
      debitBalanceByStore: 'Debit Balance by Store',
      debitBalanceData: 'Debit Balance Data',
      bankBalanceByStore: 'Bank Balance by Store',
      bankVaultEnding: 'Bank Vault Ending',
      employeeSetting: 'Employee Settings',
      attendance: 'Attendance',
      storeCreation: 'Store Creation',
      storeShiftSetting: 'Store Shift Settings',
      registerCounterparty: 'Register Counterparty',
      registerDenomination: 'Register Denomination',
      surveyDashboard: 'Survey Dashboard',
    };
    
    return routeMap[route] ?? route;
  }
}