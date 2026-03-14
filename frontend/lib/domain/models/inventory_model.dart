import 'package:equatable/equatable.dart';

class InventoryAlert extends Equatable {
  final String productId;
  final String productName;
  final String variantId;
  final String size;
  final String color;
  final int stock;

  const InventoryAlert({
    required this.productId,
    required this.productName,
    required this.variantId,
    required this.size,
    required this.color,
    required this.stock,
  });

  factory InventoryAlert.fromJson(Map<String, dynamic> json) {
    return InventoryAlert(
      productId: json['product_id'] as String,
      productName: json['products']['name'] as String,
      variantId: json['id'] as String,
      size: json['size'] as String,
      color: json['color'] as String,
      stock: (json['stock'] as num).toInt(),
    );
  }

  @override
  List<Object?> get props => [productId, productName, variantId, size, color, stock];
}
