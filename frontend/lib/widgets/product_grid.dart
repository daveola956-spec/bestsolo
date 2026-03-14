import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../product/product_bloc.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ProductGrid({
    super.key,
    this.scrollController,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previous, current) {
        // Only rebuild if state type changes or if data actually changes
        if (previous.runtimeType != current.runtimeType) return true;
        
        if (previous is ProductLoaded && current is ProductLoaded) {
          // Compare product IDs or lengths to detect meaningful changes
          return previous.products?.length != current.products?.length ||
                 previous.products != current.products;
        }
        
        return true;
      },
      builder: (context, state) {
        if (state is ProductInitial || (state is ProductLoading && state is! ProductLoaded)) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF1FAF5A),
            ),
          );
        }

        if (state is ProductError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: Color(0xFFF44336)),
                const SizedBox(height: 16),
                Text(
                  'Error loading products',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProductBloc>().add(LoadProducts(page: 1));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1FAF5A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (state is ProductLoaded) {
          final products = state.products ?? [];

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2_outlined,
                      size: 64, color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 16),
                  Text(
                    'No products found',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for new arrivals.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            );
          }

          // Responsive calculation
          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2; // Mobile default
              
              if (constraints.maxWidth > 1200) {
                crossAxisCount = 5;
              } else if (constraints.maxWidth > 900) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth > 600) {
                crossAxisCount = 3;
              }

              return Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      shrinkWrap: shrinkWrap,
                      physics: physics,
                      padding: const EdgeInsets.all(24),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 0.70,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            context.push('/product/${product.id}');
                          },
                        );
                      },
                    ),
                  ),
                  // Loading Indicator at the bottom
                  if (state is ProductLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1FAF5A),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        }

        return const SizedBox.shrink(); // Empty fallback
      },
    );
  }
}
