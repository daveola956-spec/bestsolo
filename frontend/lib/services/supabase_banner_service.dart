import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/banner_model.dart';
import '../domain/repositories/banner_repository.dart';
import '../core/error/exceptions.dart';

class SupabaseBannerService implements BannerRepository {
  final SupabaseClient _client;

  SupabaseBannerService(this._client);

  @override
  Future<List<BannerModel>> fetchActiveBanners() async {
    try {
      final response = await _client
          .from('banners')
          .select()
          .eq('active', true)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DataException(message: 'Failed to fetch active banners: $e');
    }
  }

  @override
  Future<List<BannerModel>> fetchAllBanners() async {
    try {
      final response = await _client
          .from('banners')
          .select()
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DataException(message: 'Failed to fetch all banners: $e');
    }
  }

  @override
  Future<void> createBanner(BannerModel banner) async {
    try {
      final json = banner.toJson();
      json.remove('id'); // Let Supabase generate UUID
      await _client.from('banners').insert(json);
    } catch (e) {
      throw DataException(message: 'Failed to create banner: $e');
    }
  }

  @override
  Future<void> updateBannerStatus(String id, bool active) async {
    try {
      await _client.from('banners').update({'active': active}).eq('id', id);
    } catch (e) {
      throw DataException(message: 'Failed to update banner status: $e');
    }
  }

  @override
  Future<void> deleteBanner(String id) async {
    try {
      await _client.from('banners').delete().eq('id', id);
    } catch (e) {
      throw DataException(message: 'Failed to delete banner: $e');
    }
  }
}
