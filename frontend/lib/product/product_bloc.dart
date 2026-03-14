import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/error/exceptions.dart';
import '../domain/models/category.dart';
import '../domain/models/product.dart';
import '../domain/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;

  ProductBloc(this._repository) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductDetails>(_onLoadProductDetails);
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    final bool isInitialLoad = event.page == 1;
    
    // Preserve existing data if we are already in Loaded state
    List<Category>? existingCategories;
    List<Product> currentProducts = [];
    
    if (state is ProductLoaded) {
      final loadedState = state as ProductLoaded;
      existingCategories = loadedState.categories;
      if (!isInitialLoad) {
        currentProducts = List.from(loadedState.products ?? []);
      }
    }

    if (isInitialLoad) {
      emit(ProductLoading());
    }

    try {
      final newProducts = await _repository.getProducts(
        categoryId: event.categoryId,
        isFeatured: event.isFeatured,
        page: event.page,
        limit: event.limit,
      );
      
      final bool hasReachedMax = newProducts.length < event.limit;
      final List<Product> updatedProducts = isInitialLoad ? newProducts : (currentProducts..addAll(newProducts));

      emit(ProductLoaded(
        products: updatedProducts,
        categories: existingCategories,
        currentCategoryId: event.categoryId,
        currentPage: event.page,
        hasReachedMax: hasReachedMax,
      ));
    } on DataException catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred while loading products.'));
    }
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductState> emit,
  ) async {
    // Preserve existing data
    List<Product>? existingProducts;
    List<Category>? existingCategories;
    String? existingCategoryId;
    
    if (state is ProductLoaded) {
      final loadedState = state as ProductLoaded;
      existingProducts = loadedState.products;
      existingCategories = loadedState.categories;
      existingCategoryId = loadedState.currentCategoryId;
    }

    emit(ProductLoading());
    try {
      final product = await _repository.getProductDetails(event.productId);
      if (product == null) {
        emit(ProductError('Product not found.'));
        return;
      }
      
      emit(ProductLoaded(
        products: existingProducts,
        selectedProduct: product,
        categories: existingCategories,
        currentCategoryId: existingCategoryId,
      ));
    } on DataException catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred while loading product details.'));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProductState> emit,
  ) async {
    // Preserve existing data
    List<Product>? existingProducts;
    Product? existingSelectedProduct;
    String? existingCategoryId;

    if (state is ProductLoaded) {
      final loadedState = state as ProductLoaded;
      existingProducts = loadedState.products;
      existingSelectedProduct = loadedState.selectedProduct;
      existingCategoryId = loadedState.currentCategoryId;
    }

    emit(ProductLoading());
    try {
      final categories = await _repository.getCategories();
      emit(ProductLoaded(
        products: existingProducts,
        selectedProduct: existingSelectedProduct,
        categories: categories,
        currentCategoryId: existingCategoryId,
      ));
    } on DataException catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred while loading categories.'));
    }
  }
}
