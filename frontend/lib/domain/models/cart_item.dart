import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final String productId;
  final String? variantId;
  final String productName;
  final String imageUrl;
  final double price;
  final String? size;
  final String? color;
  final int quantity;

  const CartItem({
    required this.id,
    required this.productId,
    this.variantId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    this.size,
    this.color,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      variantId: json['variant_id'] as String?,
      productName: json['product_name'] as String,
      imageUrl: json['image_url'] as String,
      price: (json['price'] as num).toDouble(),
      size: json['size'] as String?,
      color: json['color'] as String?,
      quantity: (json['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'variant_id': variantId,
        'product_name': productName,
        'image_url': imageUrl,
        'price': price,
        'size': size,
        'color': color,
        'quantity': quantity,
      };

  CartItem copyWith({
    String? id,
    String? productId,
    String? variantId,
    String? productName,
    String? imageUrl,
    double? price,
    String? size,
    String? color,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      productName: productName ?? this.productName,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Calculates the total price for this specific item (price * quantity)
  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [
        id,
        productId,
        variantId,
        productName,
        imageUrl,
        price,
        size,
        color,
        quantity,
      ];
}
