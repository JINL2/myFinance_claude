import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../models/homepage_models.dart';
import '../../../widgets/toss/toss_card.dart';
import '../providers/homepage_providers.dart';

class QuickAccessSection extends ConsumerWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topFeaturesAsync = ref.watch(topFeaturesByUserProvider);

    return topFeaturesAsync.when(
      data: (topFeatures) {
        if (topFeatures.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Row(
                children: [
                  Text(
                    'Quick Access',
                    style: TossTextStyles.h3,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _showAllFeaturesBottomSheet(context, ref),
                    child: Text(
                      'More ›',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              
              // Horizontal scrollable feature list
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space1),
                  itemCount: topFeatures.length > 6 ? 6 : topFeatures.length, // Limit to 6 items
                  separatorBuilder: (_, __) => const SizedBox(width: TossSpacing.space3),
                  itemBuilder: (context, index) {
                    final feature = topFeatures[index];
                    return QuickAccessFeatureCard(
                      feature: feature,
                      onTap: () => _navigateToFeature(context, feature.route, ref),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(), // Don't show loading for quick access
      error: (error, stackTrace) => const SizedBox.shrink(), // Fail silently
    );
  }

  void _navigateToFeature(BuildContext context, String route, WidgetRef ref) {
    // Navigate to feature and track the click
    // You might want to implement click tracking here
    // context.push('/$route');
    
    // For now, show a snackbar since routes aren't implemented yet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigate to: $route'),
        backgroundColor: TossColors.primary,
      ),
    );
  }

  void _showAllFeaturesBottomSheet(BuildContext context, WidgetRef ref) {
    final topFeatures = ref.read(topFeaturesByUserProvider).valueOrNull ?? [];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  Text(
                    'All Quick Access Features',
                    style: TossTextStyles.h3,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Feature list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(TossSpacing.space4),
                itemCount: topFeatures.length,
                separatorBuilder: (_, __) => const SizedBox(height: TossSpacing.space2),
                itemBuilder: (context, index) {
                  final feature = topFeatures[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: feature.icon,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 40,
                          height: 40,
                          color: TossColors.gray100,
                          child: const Icon(Icons.apps, color: TossColors.gray500),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 40,
                          height: 40,
                          color: TossColors.gray100,
                          child: const Icon(Icons.apps, color: TossColors.gray500),
                        ),
                      ),
                    ),
                    title: Text(
                      feature.featureName,
                      style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Used ${feature.clickCount} times',
                      style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: TossColors.gray400),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToFeature(context, feature.route, ref);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickAccessFeatureCard extends StatelessWidget {
  final TopFeature feature;
  final VoidCallback onTap;
  
  const QuickAccessFeatureCard({
    super.key,
    required this.feature,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 100,
      child: TossCard(
        onTap: onTap,
        padding: const EdgeInsets.all(TossSpacing.space2),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Feature icon from URL
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: feature.icon,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.apps,
                  color: TossColors.primary,
                  size: 20,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.apps,
                  color: TossColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          
          // Feature name
          Text(
            feature.featureName,
            style: TossTextStyles.caption,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          // Click count indicator (subtle)
          if (feature.clickCount > 0)
            Text(
              '${feature.clickCount}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
                fontSize: 10,
              ),
            ),
        ],
        ),
      ),
    );
  }
}