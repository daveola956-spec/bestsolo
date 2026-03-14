import 'package:equatable/equatable.dart';

class ShippingAddress extends Equatable {
  final String id;
  final String customerId;
  final String fullName;
  final String phone;
  final String addressLine;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final DateTime? createdAt;

  const ShippingAddress({
    required this.id,
    required this.customerId,
    required this.fullName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.createdAt,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      addressLine: json['address_line'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      postalCode: json['postal_code'] as String,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'full_name': fullName,
        'phone': phone,
        'address_line': addressLine,
        'city': city,
        'state': state,
        'country': country,
        'postal_code': postalCode,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        customerId,
        fullName,
        phone,
        addressLine,
        city,
        state,
        country,
        postalCode,
        createdAt,
      ];
}
