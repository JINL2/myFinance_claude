import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Store service provider
final storeServiceProvider = Provider<StoreService>((ref) {
  return StoreService();
});

class StoreService {
  final _supabase = Supabase.instance.client;

  /// Create a new store for a company and return the store ID if successful
  Future<String?> createStore({
    required String storeName,
    required String companyId,
    String? storeAddress,
    String? storePhone,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('No user logged in');
      }

      // Generate store code
      final storeCode = _generateStoreCode(storeName);
      
      // Create the store
      final storeResponse = await _supabase
          .from('stores')
          .insert({
            'store_name': storeName,
            'store_code': storeCode,
            'company_id': companyId,
            'store_address': storeAddress ?? '',
            'store_phone': storePhone ?? '',
          })
          .select()
          .single();

      final storeId = storeResponse['store_id'];
      
      try {
        // Add user to store
        await _supabase
            .from('user_stores')
            .insert({
              'user_id': userId,
              'store_id': storeId,
            });

        return storeId;
      } catch (innerError) {
        print('StoreService Error during user_stores creation: $innerError');
        
        // Try to clean up
        try {
          await _supabase
              .from('stores')
              .delete()
              .eq('store_id', storeId);
        } catch (deleteError) {
          print('StoreService Error: Failed to clean up store: $deleteError');
        }
        
        return null;
      }
    } catch (e) {
      print('StoreService Error: Failed to create store: $e');
      return null;
    }
  }

  String _generateStoreCode(String storeName) {
    // Simple code generation - can be improved
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final prefix = storeName.replaceAll(' ', '').substring(0, 3).toUpperCase();
    return '$prefix${timestamp.substring(timestamp.length - 6)}';
  }
}