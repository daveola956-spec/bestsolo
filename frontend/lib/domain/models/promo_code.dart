import 'package:equatable/equatable.dart';

enum DiscountType { percentage, fixed }

class PromoCode extends Equatable {
  final String id;
  final String code;
  final DiscountType discountType;
  final double discountValue;
  final DateTime? expiryDate;
  final int? maxUsage;
  final int usedCount;

  const PromoCode({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    this.expiryDate,
    this.maxUsage,
    required this.usedCount,
  });

  bool get isValid {
    final now = DateTime.now();
    if (expiryDate != null && expiryDate!.isBefore(now)) return false;
    if (maxUsage != null && usedCount >= maxUsage!) return false;
    return true;
  }

  double calculateDiscount(double subtotal) {
    if (discountType == DiscountType.percentage) {
      return subtotal * (discountValue / 100);
    } else {
      return discountValue;
    }
  }

  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      id: json['id'] as String,
      code: json['code'] as String,
      discountType: json['discount_type'] == 'percentage' 
          ? DiscountType.percentage 
          : DiscountType.fixed,
      discountValue: (json['discount_value'] as num).toDouble(),
      expiryDate: json['expiry_date'] != null 
          ? DateTime.parse(json['expiry_date'] as String) 
          : null,
      maxUsage: json['max_usage'] as int?,
      usedCount: json['used_count'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, code, discountType, discountValue, expiryDate, maxUsage, usedCount];
}
