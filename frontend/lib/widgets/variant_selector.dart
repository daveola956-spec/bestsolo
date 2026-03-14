import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/models/product_variant.dart';

class VariantSelector extends StatelessWidget {
  final List<ProductVariant> variants;
  final String? selectedSize;
  final String? selectedColor;
  final ValueChanged<String> onSizeSelected;
  final ValueChanged<String> onColorSelected;

  const VariantSelector({
    super.key,
    required this.variants,
    required this.selectedSize,
    required this.selectedColor,
    required this.onSizeSelected,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Extract unique available sizes and colors
    final sizes = variants.map((v) => v.size).whereType<String>().toSet().toList();
    final colors = variants.map((v) => v.color).whereType<String>().toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sizes.isNotEmpty) ...[
          Text(
            'Size',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: sizes.map((size) {
              final isSelected = size == selectedSize;
              // Check if THIS size has stock in ANY color (simplified logic)
              final isAvailable = variants.any((v) => v.size == size && v.stock > 0);

              return GestureDetector(
                onTap: isAvailable ? () => onSizeSelected(size) : null,
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1FAF5A) : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1FAF5A)
                          : const Color(0xFFE0E0E0),
                      width: 1.5,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    size,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: _getTextColor(isSelected, isAvailable),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        if (colors.isNotEmpty) ...[
          Text(
            'Color',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colors.map((color) {
              final isSelected = color == selectedColor;
              final isAvailable = variants.any((v) => v.color == color && v.stock > 0);

              return GestureDetector(
                onTap: isAvailable ? () => onColorSelected(color) : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1FAF5A) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1FAF5A)
                          : const Color(0xFFE0E0E0),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    color,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: _getTextColor(isSelected, isAvailable),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Color _getTextColor(bool isSelected, bool isAvailable) {
    if (!isAvailable) return const Color(0xFFBDBDBD); // Disabled gray
    if (isSelected) return Colors.white;
    return const Color(0xFF333333);
  }
}
