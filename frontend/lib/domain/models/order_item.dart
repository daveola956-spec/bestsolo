import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String id;
  final String orderId;
  final String productId;
  final String variantId;
  final int quantity;
  final double price;
  final DateTime? createdAt;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.price,
    this.createdAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      variantId: json['variant_id'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'product_id': productId,
        'variant_id': variantId,
        'quantity': quantity,
        'price': price,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        orderId,
        productId,
        variantId,
        quantity,
        price,
        createdAt,
      ];
}
