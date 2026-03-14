import 'package:equatable/equatable.dart';

class ProductVariant extends Equatable {
  final String? size;
  final String? color;
  final int stock;

  const ProductVariant({
    this.size,
    this.color,
    required this.stock,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      size: json['size'] as String?,
      color: json['color'] as String?,
      stock: (json['stock'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'size': size,
        'color': color,
        'stock': stock,
      };

  @override
  List<Object?> get props => [size, color, stock];
}
