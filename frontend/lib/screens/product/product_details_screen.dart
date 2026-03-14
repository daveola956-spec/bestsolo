import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../product/product_bloc.dart';
import '../../widgets/app_button.dart';
import '../../widgets/variant_selector.dart';
import '../../services/cloudinary_helper.dart';
import '../../review/review_bloc.dart';
import '../../review/review_event.dart';
import '../../review/review_state.dart';
import '../../auth/auth_bloc.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/app_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? _selectedSize;
  String? _selectedColor;

  // Placeholder for an actual Cloudinary image gallery carousel logic
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Dispatch event to fetch full details (including variants/images)
    context.read<ProductBloc>().add(LoadProductDetails(widget.productId));
    context.read<ReviewBloc>().add(LoadReviews(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF333333)),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Color(0xFF333333)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to wishlist')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF333333)),
            onPressed: () {
               // TODO Go to cart
            },
          ),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1FAF5A)),
            );
          }

          if (state is ProductLoaded && state.selectedProduct != null) {
            final product = state.selectedProduct!;
            
            // Auto-select first available variants if none selected
            if (_selectedSize == null && product.variants.isNotEmpty) {
              final firstAvailable = product.variants.where((v) => v.stock > 0).firstOrNull;
              if (firstAvailable != null) {
                // Determine if we should set size or color based on what exists
                 // This is a naive auto-select for UX, handled fully in VariantSelector normally
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100), // Space for FAB/bottom bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image Gallery ──────────────────────────────────────────
                  SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        if (product.images.isNotEmpty)
                          PageView.builder(
                            itemCount: product.images.length,
                            onPageChanged: (index) {
                              setState(() => _currentImageIndex = index);
                            },
                            itemBuilder: (context, index) {
                              return AppImage(
                                imageUrl: CloudinaryHelper.getProductImageUrl(product.images[index].imageUrl),
                              );
                            },
                          )
                        else
                          _placeholderImage(),
                          
                        // Dot indicators
                        if (product.images.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                product.images.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: _currentImageIndex == index ? 24 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _currentImageIndex == index 
                                        ? const Color(0xFF1FAF5A) 
                                        : Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ── Product Details ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF000000),
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '₦${product.price.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1FAF5A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Variant Selectors
                        if (product.variants.isNotEmpty) ...[
                          VariantSelector(
                            variants: product.variants,
                            selectedSize: _selectedSize,
                            selectedColor: _selectedColor,
                            onSizeSelected: (size) => setState(() => _selectedSize = size),
                            onColorSelected: (color) => setState(() => _selectedColor = color),
                          ),
                          const SizedBox(height: 32),
                        ],

                        // Description
                        Text(
                          'Description',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.description.isNotEmpty 
                            ? product.description 
                            : 'No description available for this product.',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: const Color(0xFF666666),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 48),
                        
                        // ── Reviews Section ─────────────────────────────────────────
                        BlocBuilder<ReviewBloc, ReviewState>(
                          builder: (context, state) {
                            if (state is ReviewLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (state is ReviewLoaded) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Reviews (${state.reviews.length})',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (state.rating != null)
                                        Row(
                                          children: [
                                            const Icon(Icons.star_rounded, color: Color(0xFFFFB400), size: 20),
                                            const SizedBox(width: 4),
                                            Text(
                                              state.rating!.averageRating.toString(),
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  if (state.reviews.isEmpty)
                                    Text(
                                      'No reviews yet. Be the first to share your thoughts!',
                                      style: GoogleFonts.inter(color: Colors.grey[600]),
                                    )
                                  else
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: state.reviews.length,
                                      separatorBuilder: (_, __) => const Divider(height: 32),
                                      itemBuilder: (context, index) {
                                        final review = state.reviews[index];
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  review.customerName ?? 'Verified Customer',
                                                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
                                                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            RatingStars(rating: review.rating.toDouble(), size: 14),
                                            if (review.comment != null && review.comment!.isNotEmpty) ...[
                                              const SizedBox(height: 8),
                                              Text(
                                                review.comment!,
                                                style: GoogleFonts.inter(color: Colors.grey[800]),
                                              ),
                                            ],
                                          ],
                                        );
                                      },
                                    ),
                                  const SizedBox(height: 24),
                                  TextButton.icon(
                                    onPressed: () => _showReviewModal(context),
                                    icon: const Icon(Icons.rate_review_outlined),
                                    label: const Text('Write a Review'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF1FAF5A),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 48),
                        
                        // Related Products
                        Text(
                          'You might also like',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Related products UI here',
                            style: GoogleFonts.inter(color: const Color(0xFF999999)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Failed to load product', style: GoogleFonts.poppins(fontSize: 18)),
                  TextButton(
                    onPressed: () => context.pop(), 
                    child: const Text('Go Back')
                  )
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: AppButton(
            label: 'Add to Cart',
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
            onPressed: () {
              // TODO: Integrate CartBloc
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Processing Add to Cart...'),
                  backgroundColor: Color(0xFF1FAF5A),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: const Center(
        child: Icon(Icons.inventory_2_outlined, size: 64, color: Color(0xFFE0E0E0)),
      ),
    );
  }

  void _showReviewModal(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to write a review')),
      );
      return;
    }

    int selectedRating = 5;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Write a Review',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Rating',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () => setModalState(() => selectedRating = index + 1),
                      icon: Icon(
                        index < selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: const Color(0xFFFFB400),
                        size: 32,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Text(
                  'Comment (Optional)',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Share your experience with this product...',
                    hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1FAF5A)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Submit Review',
                  onPressed: () {
                    context.read<ReviewBloc>().add(
                      SubmitReview(
                        productId: widget.productId,
                        customerId: authState.userId,
                        rating: selectedRating,
                        comment: commentController.text.trim(),
                      ),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Review submitted successfully'),
                        backgroundColor: Color(0xFF1FAF5A),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
