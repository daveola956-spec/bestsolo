import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/order.dart';
import '../../widgets/app_button.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final Order order;

  const OrderConfirmationScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Order Confirmed',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Success Icon
            const Center(
              child: Icon(
                Icons.check_circle,
                color: Color(0xFF1FAF5A),
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Thank You!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order has been placed successfully.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF666666),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Order Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Order ID', '#${order.id.substring(0, 8).toUpperCase()}', isBold: true),
                  const Divider(height: 24),
                  _buildDetailRow('Payment Status', order.paymentStatus.toUpperCase(), 
                    color: order.paymentStatus.toLowerCase() == 'paid' ? const Color(0xFF1FAF5A) : Colors.orange),
                  const Divider(height: 24),
                  _buildDetailRow('Estimated Delivery', '3 - 5 Working Days'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Order Summary
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Order Summary',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Text(
                    '${item.quantity}x ',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      'Product Item', // In a real app, OrderItem might need productName if not joining
                      style: GoogleFonts.inter(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '₦${(item.price * item.quantity).toStringAsFixed(0)}',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )),
            
            const Divider(height: 32),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₦${order.totalPrice.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1FAF5A),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 48),
            
            AppButton(
              label: 'Continue Shopping',
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF888888),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
