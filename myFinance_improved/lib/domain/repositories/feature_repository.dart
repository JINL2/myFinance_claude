import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/feature.dart';
import '../../presentation/pages/homepage/models/homepage_models.dart';

abstract class FeatureRepository {
  /// Get all categories with their features
  Future<List<CategoryWithFeatures>> getCategoriesWithFeatures();
  
  /// Get top features by user based on usage statistics
  /// This fetches data from the top_features_by_user view in Supabase
  Future<List<TopFeature>> getTopFeaturesByUser({
    required String userId,
  });
  
  /// Update feature click count (for tracking usage)
  Future<void> trackFeatureClick({
    required String userId,
    required String featureId,
  });
}


// Supabase implementation
class SupabaseFeatureRepository implements FeatureRepository {
  @override
  Future<List<CategoryWithFeatures>> getCategoriesWithFeatures() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      print('🔥🔥🔥 API CALL: get_categories_with_features');
      print('🔥 Timestamp: $timestamp');
      print('🔥 Stack trace to see who called this:');
      print(StackTrace.current.toString().split('\n').take(10).join('\n'));
      
      final response = await Supabase.instance.client
          .rpc('get_categories_with_features');
      
      print('FeatureRepository: Response type: ${response.runtimeType}');
      print('FeatureRepository: Response: $response');
      
      if (response == null) {
        print('FeatureRepository: No data returned');
        return [];
      }
      
      if (response is List) {
        return (response as List<dynamic>)
            .map((category) => CategoryWithFeatures.fromJson(category as Map<String, dynamic>))
            .toList();
      }
      
      return [];
    } catch (e) {
      print('FeatureRepository: Error getting categories: $e');
      return [];
    }
  }

  @override
  Future<List<TopFeature>> getTopFeaturesByUser({required String userId}) async {
    try {
      // For now return empty list - can be implemented later
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> trackFeatureClick({
    required String userId,
    required String featureId,
  }) async {
    try {
      // For now do nothing - can be implemented later
    } catch (e) {
      // Ignore errors for now
    }
  }
}