import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository for reading and contributing to the community rules and
/// merchant mapping library stored in Supabase.
class SupabaseCommunityRepository {
  final SupabaseClient _client;

  const SupabaseCommunityRepository(this._client);

  // ─── Community Rules ────────────────────────────────────────────────────

  /// Fetches verified community classification rules ranked by upvotes.
  Future<List<Map<String, dynamic>>> fetchCommunityRules({
    int limit = 50,
  }) async {
    final response = await _client
        .from('community_rules')
        .select()
        .eq('is_verified', true)
        .order('upvotes', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(response as List);
  }

  // ─── Community Merchants ────────────────────────────────────────────────

  /// Fetches community merchant → category mappings ranked by upvotes.
  Future<List<Map<String, dynamic>>> fetchCommunityMerchants({
    int limit = 200,
  }) async {
    final response = await _client
        .from('community_merchants')
        .select()
        .order('upvotes', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(response as List);
  }

  /// Contributes or updates a merchant → category mapping.
  Future<void> contributeMerchantMapping({
    required String merchantName,
    required String category,
    String? subcategory,
  }) async {
    final user = _client.auth.currentUser;
    await _client.from('community_merchants').upsert(
      {
        'merchant_name': merchantName,
        'subcategory': ?subcategory,
        'contributed_by': user?.id,
        'upvotes': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      onConflict: 'merchant_name',
    );
  }
}
