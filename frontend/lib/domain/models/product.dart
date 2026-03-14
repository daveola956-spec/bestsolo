import 'package:equatable/equatable.dart';
import 'product_image.dart';
import 'product_variant.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final List<ProductVariant> variants;
  final List<ProductImage> images;
  final bool isFeatured;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    this.variants = const [],
    this.images = const [],
    this.isFeatured = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: json['category_id'] as String,
      variants: (json['variants'] as List<dynamic>?)
              ?.map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
              ?.map((i) => ProductImage.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category_id': categoryId,
        'variants': variants.map((v) => v.toJson()).toList(),
        'images': images.map((i) => i.toJson()).toList(),
        'is_featured': isFeatured,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        categoryId,
        variants,
        images,
        isFeatured,
      ];
}
