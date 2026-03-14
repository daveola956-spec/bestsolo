import 'package:equatable/equatable.dart';
import 'order_item.dart';
import 'shipping_address.dart';

class Order extends Equatable {
  final String id;
  final String customerId;
  final String? shippingAddressId;
  final double totalPrice;
  final double discountAmount;
  final String paymentStatus;
  final String orderStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Included relations
  final List<OrderItem> items;
  final ShippingAddress? shippingAddress;

  const Order({
    required this.id,
    required this.customerId,
    this.shippingAddressId,
    required this.totalPrice,
    this.discountAmount = 0.0,
    required this.paymentStatus,
    required this.orderStatus,
    this.createdAt,
    this.updatedAt,
    this.items = const [],
    this.shippingAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      shippingAddressId: json['shipping_address_id'] as String?,
      totalPrice: (json['total_price'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['payment_status'] as String,
      orderStatus: json['order_status'] as String,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
      items: (json['order_items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList() ?? 
          [],
      shippingAddress: json['shipping_addresses'] != null 
          ? ShippingAddress.fromJson(json['shipping_addresses'] as Map<String, dynamic>) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'shipping_address_id': shippingAddressId,
        'total_price': totalPrice,
        'discount_amount': discountAmount,
        'payment_status': paymentStatus,
        'order_status': orderStatus,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
        'order_items': items.map((i) => i.toJson()).toList(),
        if (shippingAddress != null) 'shipping_addresses': shippingAddress!.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        customerId,
        shippingAddressId,
        totalPrice,
        discountAmount,
        paymentStatus,
        orderStatus,
        createdAt,
        updatedAt,
        items,
        shippingAddress,
      ];
}
