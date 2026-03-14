import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 18,
    this.color = const Color(0xFFFFB400),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star_rounded, color: color, size: size);
        } else if (index < rating) {
          return Icon(Icons.star_half_rounded, color: color, size: size);
        } else {
          return Icon(Icons.star_outline_rounded, color: color, size: size);
        }
      }),
    );
  }
}
