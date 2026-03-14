import 'package:equatable/equatable.dart';

class TopProduct extends Equatable {
  final String productId;
  final String productName;
  final int totalQuantity;
  final double totalRevenue;

  const TopProduct({
    required this.productId,
    required this.productName,
    required this.totalQuantity,
    required this.totalRevenue,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      totalQuantity: (json['total_quantity'] as num).toInt(),
      totalRevenue: (json['total_revenue'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [productId, productName, totalQuantity, totalRevenue];
}

class AnalyticsModel extends Equatable {
  final int totalOrders;
  final double totalRevenue;
  final int totalCustomers;
  final List<TopProduct> topProducts;

  const AnalyticsModel({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalCustomers,
    required this.topProducts,
  });

  factory AnalyticsModel.initial() {
    return const AnalyticsModel(
      totalOrders: 0,
      totalRevenue: 0,
      totalCustomers: 0,
      topProducts: [],
    );
  }

  @override
  List<Object?> get props => [totalOrders, totalRevenue, totalCustomers, topProducts];
}
