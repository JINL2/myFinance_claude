import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';

class FeaturePage extends ConsumerWidget {
  const FeaturePage({
    super.key,
    required this.featureRoute,
    this.featureName,
    this.categoryId,
  });

  final String featureRoute;
  final String? featureName;
  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _getFeatureTitle(),
          style: TossTextStyles.h3.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Feature Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getFeatureIcon(),
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getFeatureTitle(),
                                style: TossTextStyles.h2.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space1),
                              Text(
                                'Feature in development',
                                style: TossTextStyles.caption.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: TossSpacing.space6),
              
              // Coming Soon Content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(
                          Icons.construction_rounded,
                          size: 48,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space6),
                      Text(
                        'Coming Soon',
                        style: TossTextStyles.h1.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Text(
                        'This feature is under development.\nWe\'ll notify you when it\'s ready!',
                        textAlign: TextAlign.center,
                        style: TossTextStyles.body.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space8),
                      
                      // Debug Information (only in debug mode)
                      if (kDebugMode) ...[
                        Container(
                          padding: EdgeInsets.all(TossSpacing.space3),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.error.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Debug Info:',
                                style: TossTextStyles.caption.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space1),
                              Text(
                                'Route: $featureRoute',
                                style: TossTextStyles.caption.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (featureName != null)
                                Text(
                                  'Feature: $featureName',
                                  style: TossTextStyles.caption.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              if (categoryId != null)
                                Text(
                                  'Category: $categoryId',
                                  style: TossTextStyles.caption.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFeatureTitle() {
    if (featureName != null && featureName!.isNotEmpty) {
      return featureName!;
    }
    
    // Convert route to readable name
    String title = featureRoute.replaceAll('/', '');
    
    // Convert camelCase to Title Case
    title = title.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    ).trim();
    
    // Capitalize first letter
    if (title.isNotEmpty) {
      title = title[0].toUpperCase() + title.substring(1);
    }
    
    return title.isEmpty ? 'Feature' : title;
  }

  IconData _getFeatureIcon() {
    final route = featureRoute.toLowerCase();
    
    if (route.contains('content')) return Icons.create;
    if (route.contains('asset')) return Icons.account_balance_wallet;
    if (route.contains('cash')) return Icons.money;
    if (route.contains('income')) return Icons.trending_up;
    if (route.contains('employee')) return Icons.people;
    if (route.contains('role') || route.contains('permission')) return Icons.admin_panel_settings;
    if (route.contains('debt')) return Icons.credit_card;
    if (route.contains('register')) return Icons.app_registration;
    if (route.contains('journal')) return Icons.book;
    if (route.contains('account')) return Icons.account_circle;
    if (route.contains('store') || route.contains('shift')) return Icons.store;
    if (route.contains('transaction') || route.contains('history')) return Icons.history;
    if (route.contains('survey') || route.contains('dashboard')) return Icons.dashboard;
    if (route.contains('attendance')) return Icons.access_time;
    if (route.contains('denomination')) return Icons.monetization_on;
    if (route.contains('balance')) return Icons.account_balance;
    if (route.contains('bank') || route.contains('vault')) return Icons.account_balance;
    
    return Icons.featured_play_list;
  }
}