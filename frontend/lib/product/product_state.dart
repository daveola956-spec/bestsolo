part of 'product_bloc.dart';

sealed class ProductState {}

/// Initial state before any data is loaded.
final class ProductInitial extends ProductState {}

/// State while products, categories, or details are being fetched.
final class ProductLoading extends ProductState {}

/// State when data has been successfully loaded.
final class ProductLoaded extends ProductState {
  final List<Product>? products;
  final Product? selectedProduct;
  final List<Category>? categories;
  final String? currentCategoryId;
  final int currentPage;
  final bool hasReachedMax;

  ProductLoaded({
    this.products,
    this.selectedProduct,
    this.categories,
    this.currentCategoryId,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  ProductLoaded copyWith({
    List<Product>? products,
    Product? selectedProduct,
    List<Category>? categories,
    String? currentCategoryId,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      categories: categories ?? this.categories,
      currentCategoryId: currentCategoryId ?? this.currentCategoryId,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

/// State when an error occurs during data fetching.
final class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
