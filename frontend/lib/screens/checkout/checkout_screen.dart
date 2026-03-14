import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app.dart';
import '../../auth/auth_bloc.dart';
import '../../cart/cart_bloc.dart';
import '../../domain/models/order.dart';
import '../../domain/models/order_item.dart';
import '../../domain/models/shipping_address.dart';
import '../../order/order_bloc.dart';
import '../../promo/promo_bloc.dart';
import '../../promo/promo_event.dart';
import '../../domain/models/promo_code.dart';
import '../../promo/promo_state.dart';
import '../../inventory/inventory_bloc.dart';
import '../../inventory/inventory_event.dart';
import '../../inventory/inventory_state.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../injection.dart';
import '../../services/monnify_payment_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'Nigeria');
  final _promoController = TextEditingController();

  PromoCode? _appliedPromo;

  String _paymentMethod = 'Monnify';

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _onConfirmCheckout(CartUpdated cartState, String userId) {
    if (!_formKey.currentState!.validate()) return;

    final shippingAddress = ShippingAddress(
      id: '', // Backend generates this
      customerId: userId,
      fullName: _fullNameController.text.trim(),
      phone: _phoneController.text.trim(),
      addressLine: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      country: _countryController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
    );

    // Trigger stock availability check before creating order
    final stockItems = cartState.items.map((item) => {
      'variant_id': item.productId, // Note: Assuming productId is used for simple stock check for now or update it later if variantId is available
      'quantity': item.quantity,
    }).toList();

    context.read<InventoryBloc>().add(CheckStockAvailability(stockItems));
  }

  void _createFinalOrder(CartUpdated cartState, String userId) {
    // Re-calculating address for final order creation logic
    // (This part could be refactored to reuse variables)
    final shippingAddress = ShippingAddress(
      id: '',
      customerId: userId,
      fullName: _fullNameController.text.trim(),
      phone: _phoneController.text.trim(),
      addressLine: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      country: _countryController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
    );

    final orderItems = cartState.items.map((cartItem) {
      return OrderItem(
        id: '', // Backend generates this
        orderId: '', // Set by repository
        productId: cartItem.productId,
        variantId: '', // CartItem does not have variantId yet
        quantity: cartItem.quantity,
        price: cartItem.price,
      );
    }).toList();

    final subtotal = cartState.total;
    final discount = _appliedPromo?.calculateDiscount(subtotal) ?? 0.0;
    final finalTotal = subtotal - discount;

    final order = Order(
      id: '', // Backend generates this
      customerId: userId,
      totalPrice: finalTotal,
      discountAmount: discount,
      paymentStatus: 'pending',
      orderStatus: 'processing',
      items: orderItems,
      shippingAddress: shippingAddress,
    );

    context.read<OrderBloc>().add(CreateOrder(order));
  }

  Future<void> _processMonnifyPayment(Order createdOrder, String customerEmail, String customerName) async {
    final monnifyService = getIt<MonnifyPaymentService>();
    
    final response = await monnifyService.initializePayment(
      customerName: customerName,
      customerEmail: customerEmail,
      amount: createdOrder.totalPrice,
      transactionReference: createdOrder.id,
    );

    if (response != null && response.transactionStatus == 'SUCCESS') {
      // Update order status to PAID
      if (mounted) {
        context.read<OrderBloc>().add(UpdatePaymentStatus(createdOrder.id, 'paid'));
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful!'), backgroundColor: Colors.green),
        );
        context.read<CartBloc>().add(ClearCart());
        context.goNamed(AppRoutes.orderConfirmation, extra: createdOrder);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Failed or Cancelled'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState is! CartUpdated || cartState.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is! AuthAuthenticated) {
                return const Center(child: Text('Please login to continue'));
              }

              return MultiBlocListener(
                listeners: [
                  BlocListener<InventoryBloc, InventoryState>(
                    listener: (context, invState) {
                      if (invState is StockAvailabilityResult) {
                        if (invState.isAvailable) {
                          _createFinalOrder(cartState, authState.userId);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Some items in your cart are out of stock or unavailable in the requested quantity.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else if (invState is InventoryError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(invState.message), backgroundColor: Colors.red),
                        );
                      }
                    },
                  ),
                  BlocListener<OrderBloc, OrderState>(
                    listener: (context, orderState) {
                      if (orderState is OrderCreated) {
                        // Dispatch IncrementPromoUsage via PromoBloc — no direct repository access from UI.
                        if (_appliedPromo != null) {
                          context.read<PromoBloc>().add(IncrementPromoUsage(_appliedPromo!.id));
                        }
                        
                        if (_paymentMethod == 'Monnify') {
                          _processMonnifyPayment(orderState.order, authState.email, _fullNameController.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order placed successfully!'), backgroundColor: Colors.green),
                          );
                          context.read<CartBloc>().add(ClearCart());
                          context.goNamed(AppRoutes.orderConfirmation, extra: orderState.order);
                        }
                      } else if (orderState is OrderError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(orderState.message), backgroundColor: Colors.red),
                        );
                      }
                    },
                  ),
                ],
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, orderState) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Shipping Address'),
                          const SizedBox(height: 15),
                          AppTextField(
                            label: 'Full Name',
                            controller: _fullNameController,
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 15),
                          AppTextField(
                            label: 'Phone Number',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 15),
                          AppTextField(
                            label: 'Address Line',
                            controller: _addressController,
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'City',
                                  controller: _cityController,
                                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: AppTextField(
                                  label: 'State',
                                  controller: _stateController,
                                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'Postal Code',
                                  controller: _postalCodeController,
                                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: AppTextField(
                                  label: 'Country',
                                  controller: _countryController,
                                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          _buildSectionTitle('Payment Method'),
                          const SizedBox(height: 10),
                          _buildPaymentOption('Monnify', 'Pay with Bank or Card'),
                          _buildPaymentOption('Cash on Delivery', 'Pay when you receive'),
                          const SizedBox(height: 30),
                          _buildSectionTitle('Order Summary'),
                          const SizedBox(height: 15),
                          
                          // Promo Code Input
                          BlocConsumer<PromoBloc, PromoState>(
                            listener: (context, state) {
                              if (state is PromoApplied) {
                                setState(() => _appliedPromo = state.promoCode);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Promo code applied!'), backgroundColor: Colors.green),
                                );
                              } else if (state is PromoError) {
                                setState(() => _appliedPromo = null);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                                );
                              }
                            },
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppTextField(
                                          label: 'Promo Code',
                                          controller: _promoController,
                                          hint: 'Enter code',
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: 80,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: state is PromoLoading 
                                              ? null 
                                              : () => context.read<PromoBloc>().add(ValidatePromoCode(_promoController.text.trim())),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF333333),
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          child: state is PromoLoading 
                                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                              : const Text('Apply'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_appliedPromo != null) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.check_circle, color: Colors.green, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Code ${_appliedPromo!.code} applied',
                                          style: const TextStyle(color: Colors.green, fontSize: 12),
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () {
                                            setState(() => _appliedPromo = null);
                                            _promoController.clear();
                                            context.read<PromoBloc>().add(ClearPromoCode());
                                          },
                                          child: const Text('Remove', style: TextStyle(color: Colors.red, fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          _buildSummaryRow('Subtotal', '₦${cartState.total.toStringAsFixed(2)}'),
                          if (_appliedPromo != null)
                            _buildSummaryRow(
                              'Discount', 
                              '-₦${_appliedPromo!.calculateDiscount(cartState.total).toStringAsFixed(2)}',
                              valueColor: Colors.red,
                            ),
                          _buildSummaryRow('Shipping', 'Free'),
                          const Divider(height: 30),
                          _buildSummaryRow(
                            'Total', 
                            '₦${(cartState.total - (_appliedPromo?.calculateDiscount(cartState.total) ?? 0)).toStringAsFixed(2)}', 
                            isBold: true,
                          ),
                          const SizedBox(height: 40),
                          AppButton(
                            label: (orderState is OrderLoading || context.watch<InventoryBloc>().state is InventoryLoading) 
                                ? 'Processing...' 
                                : 'Place Order',
                            onPressed: (orderState is OrderLoading || context.watch<InventoryBloc>().state is InventoryLoading)
                                ? null 
                                : () => _onConfirmCheckout(cartState, authState.userId),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1FAF5A),
      ),
    );
  }

  Widget _buildPaymentOption(String title, String subtitle) {
    return RadioListTile<String>(
      value: title,
      groupValue: _paymentMethod,
      onChanged: (v) => setState(() => _paymentMethod = v!),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      activeColor: const Color(0xFF1FAF5A),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? (isBold ? const Color(0xFF1FAF5A) : null),
            ),
          ),
        ],
      ),
    );
  }
}
