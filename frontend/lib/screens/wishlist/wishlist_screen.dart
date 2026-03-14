import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../wishlist/wishlist_bloc.dart';
import '../../product/product_bloc.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1FAF5A)),
            );
          }

          if (state is WishlistError) {
            return Center(child: Text(state.message));
          }

          if (state is WishlistLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_border_rounded,
                        size: 64, color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 16),
                    Text(
                      'Your wishlist is empty',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save items you love for later.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              );
            }

            return BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                if (productState is ProductLoaded) {
                  final wishlistProducts = productState.products
                      ?.where((p) => state.isProductInWishlist(p.id))
                      .toList() ?? [];

                  return GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 0.70,
                    ),
                    itemCount: wishlistProducts.length,
                    itemBuilder: (context, index) {
                      final product = wishlistProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push('/product/${product.id}'),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1FAF5A)),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
