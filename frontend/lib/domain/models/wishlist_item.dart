import 'package:equatable/equatable.dart';

class WishlistItem extends Equatable {
  final String id;
  final String customerId;
  final String productId;
  final DateTime createdAt;

  const WishlistItem({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.createdAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      productId: json['product_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'product_id': productId,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, customerId, productId, createdAt];
}
