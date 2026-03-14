import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/theme/colors.dart';

import '../../../product/product_bloc.dart';
import '../../../widgets/product_grid.dart';
import '../../../widgets/banner_slider.dart';
import '../../../domain/models/category.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Fetch only featured products (max 8) and categories
    final productBloc = context.read<ProductBloc>();
    productBloc.add(LoadCategories());
    productBloc.add(LoadProducts(limit: 8, isFeatured: true));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const BannerSlider(),
          
          const SizedBox(height: 32),
          
          // Categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Categories',
              style: AppTextStyles.h4,
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryList(),
          
          const SizedBox(height: 32),
          
          // Featured Products Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Products',
                  style: AppTextStyles.h4,
                ),
                TextButton(
                  onPressed: () => context.push('/shop'),
                  child: Text(
                    'See All',
                    style: AppTextStyles.button.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          
          // Featured Grid
          const ProductGrid(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previous, current) {
        if (current is ProductLoaded) {
          return previous is! ProductLoaded || previous.categories != current.categories;
        }
        return false;
      },
      builder: (context, state) {
        if (state is ProductLoaded && state.categories != null) {
          final categories = state.categories!;
          return SizedBox(
            height: 100,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () => context.push('/shop?categoryId=${category.id}'),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1FAF5A).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.category_outlined,
                          color: Color(0xFF1FAF5A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox(height: 100);
      },
    );
  }
}
