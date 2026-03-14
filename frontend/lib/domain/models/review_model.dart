import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String productId;
  final String customerId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final String? customerName; // Optional: loaded from user profile

  const Review({
    required this.id,
    required this.productId,
    required this.customerId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.customerName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      customerId: json['customer_id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      customerName: json['customer_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'customer_id': customerId,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, productId, customerId, rating, comment, createdAt, customerName];
}

class ProductRating extends Equatable {
  final String productId;
  final int reviewCount;
  final double averageRating;

  const ProductRating({
    required this.productId,
    required this.reviewCount,
    required this.averageRating,
  });

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
      productId: json['product_id'] as String,
      reviewCount: (json['review_count'] as num).toInt(),
      averageRating: (json['average_rating'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [productId, reviewCount, averageRating];
}
