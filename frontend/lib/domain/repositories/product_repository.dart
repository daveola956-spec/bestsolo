import '../models/category.dart';
import '../models/product.dart';

abstract interface class ProductRepository {
  /// Fetches a list of products, optionally filtered by category and paginated.
  Future<List<Product>> getProducts({
    String? categoryId,
    bool? isFeatured,
    int page = 1,
    int limit = 20,
  });

  /// Fetches a single product by ID, including its variants and images.
  Future<Product?> getProductDetails(String productId);

  /// Fetches all available categories.
  Future<List<Category>> getCategories();
}
