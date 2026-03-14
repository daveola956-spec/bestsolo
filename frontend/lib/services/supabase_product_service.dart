import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/error/exceptions.dart';
import '../domain/models/category.dart';
import '../domain/models/product.dart';
import '../domain/repositories/product_repository.dart';

class SupabaseProductService implements ProductRepository {
  final SupabaseClient _client;

  SupabaseProductService(this._client);

  @override
  Future<List<Product>> getProducts({
    String? categoryId,
    bool? isFeatured,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final int from = (page - 1) * limit;
      final int to = (page * limit) - 1;

      // Summary view select: essential fields + primary image only
      var query = _client.from('products').select('''
        id, name, price, description, category_id, is_featured,
        images:product_images(image_url)
      ''').eq('is_active', true);

      // Only fetch the primary image for the catalog view
      query = query.eq('product_images.is_primary', true);

      if (categoryId != null && categoryId.isNotEmpty) {
        query = query.eq('category_id', categoryId);
      }

      if (isFeatured != null) {
        query = query.eq('is_featured', isFeatured);
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(from, to);
      
      return (response as List<dynamic>)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw DataException(message: e.message, code: e.code, original: e);
    } catch (e) {
      throw DataException(message: 'Failed to fetch products', original: e);
    }
  }

  @override
  Future<Product?> getProductDetails(String productId) async {
    try {
      // Detail view select: Fetch EVERYTHING
      final response = await _client.from('products').select('''
        *,
        variants:product_variants(*),
        images:product_images(*)
      ''').eq('id', productId).single();

      return Product.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return null; // Not found
      throw DataException(message: e.message, code: e.code, original: e);
    } catch (e) {
      throw DataException(message: 'Failed to fetch product details', original: e);
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .order('name', ascending: true);

      return (response as List<dynamic>)
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw DataException(message: e.message, code: e.code, original: e);
    } catch (e) {
      throw DataException(message: 'Failed to fetch categories', original: e);
    }
  }
}
