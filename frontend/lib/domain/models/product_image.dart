import 'package:equatable/equatable.dart';

class ProductImage extends Equatable {
  final String imageUrl;

  const ProductImage({
    required this.imageUrl,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'image_url': imageUrl,
      };

  @override
  List<Object?> get props => [imageUrl];
}
