import 'package:flutter/material.dart';
import '../core/theme/text_styles.dart';
import '../core/theme/colors.dart';
import '../domain/models/product.dart';
import '../services/cloudinary_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../wishlist/wishlist_bloc.dart';
import '../auth/auth_bloc.dart';
import 'app_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    // Show placeholder if no image exists
    final imageUrl = product.images.isNotEmpty ? product.images.first.imageUrl : null;
    
    // Format price
    final formattedPrice = '₦${product.price.toStringAsFixed(0)}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            AspectRatio(
              aspectRatio: 4 / 5, // 4:5 aspect ratio as per design
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? AppImage(
                            imageUrl: CloudinaryHelper.getThumbnailUrl(imageUrl),
                            borderRadius: 12,
                          )
                        : _buildPlaceholder(),
                  ),
                  
                  // Favorite Button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: BlocBuilder<WishlistBloc, WishlistState>(
                      builder: (context, state) {
                        final isFavorite = state is WishlistLoaded && 
                            state.isProductInWishlist(product.id);

                        return GestureDetector(
                          onTap: () {
                            final authState = context.read<AuthBloc>().state;
                            if (authState is AuthAuthenticated) {
                              context.read<WishlistBloc>().add(
                                ToggleWishlist(authState.userId, product.id)
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please login to add to wishlist'))
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite 
                                  ? Icons.favorite_rounded 
                                  : Icons.favorite_border_rounded,
                              size: 18,
                              color: isFavorite 
                                  ? const Color(0xFFF44336) 
                                  : const Color(0xFF666666),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Out of stock badge
                  if (product.variants.isNotEmpty && 
                      product.variants.every((v) => v.stock <= 0))
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'SOLD OUT',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Details Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formattedPrice,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder({bool isLoading = false}) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: isLoading 
            ? const SizedBox(
                width: 20, 
                height: 20, 
                child: CircularProgressIndicator(
                  strokeWidth: 2, 
                  color: Color(0xFF1FAF5A)
                )
              )
            : const Icon(
                Icons.image_outlined,
                size: 32,
                color: Color(0xFFE0E0E0),
              ),
      ),
    );
  }
}
