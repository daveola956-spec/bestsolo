import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/category.dart';
import '../../product/product_bloc.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/product_grid.dart';

class ShopScreen extends StatefulWidget {
  final String? initialCategoryId;

  const ShopScreen({
    super.key,
    this.initialCategoryId,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final _searchCtrl = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Fetch products (full catalog) with optional category filter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(LoadProducts(
        categoryId: widget.initialCategoryId,
        page: 1,
      ));
      context.read<ProductBloc>().add(LoadCategories());
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<ProductBloc>().state;
      if (state is ProductLoaded && !state.hasReachedMax) {
        context.read<ProductBloc>().add(LoadProducts(
          categoryId: state.currentCategoryId,
          page: state.currentPage + 1,
        ));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onCategorySelected(String? categoryId) {
    context.read<ProductBloc>().add(LoadProducts(categoryId: categoryId, page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF333333), size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Shop Catalog',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Column(
              children: [
                AppTextField(
                  label: '',
                  hint: 'Search products...',
                  controller: _searchCtrl,
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 16),
                _buildCategoryChips(),
              ],
            ),
          ),
          
          // Product Grid
          Expanded(
            child: ProductGrid(
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previous, current) {
        if (current is ProductLoaded) {
          return previous is! ProductLoaded || 
                 previous.categories != current.categories ||
                 previous.currentCategoryId != current.currentCategoryId;
        }
        return false;
      },
      builder: (context, state) {
        if (state is ProductLoaded && state.categories != null) {
          final categories = state.categories!;
          final selectedId = state.currentCategoryId;

          return SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final category = isAll ? null : categories[index - 1];
                final isSelected = isAll ? selectedId == null : selectedId == category?.id;

                return ChoiceChip(
                  label: Text(
                    isAll ? 'All' : category!.name,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.white : const Color(0xFF666666),
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => _onCategorySelected(category?.id),
                  selectedColor: const Color(0xFF1FAF5A),
                  backgroundColor: const Color(0xFFF5F5F5),
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox(height: 40);
      },
    );
  }
}
