part of 'product_bloc.dart';

sealed class ProductEvent {}

/// Loads the list of products. Can optionally filter by category and support pagination.
final class LoadProducts extends ProductEvent {
  final String? categoryId;
  final bool? isFeatured;
  final int page;
  final int limit;

  LoadProducts({
    this.categoryId,
    this.isFeatured,
    this.page = 1,
    this.limit = 20,
  });
}

/// Loads the details for a specific product, including variants and images.
final class LoadProductDetails extends ProductEvent {
  final String productId;

  LoadProductDetails(this.productId);
}

/// Loads the list of all available categories.
final class LoadCategories extends ProductEvent {}
