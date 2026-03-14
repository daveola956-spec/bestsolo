import 'package:flutter/material.dart';
import 'package:monnify_payment_sdk/monnify_payment_sdk.dart';
import '../core/constants/api_constants.dart';

class MonnifyPaymentService {
  Monnify? _monnify;

  Future<void> init() async {
    try {
      _monnify = await Monnify.initialize(
        applicationMode: ApplicationMode.TEST,
        apiKey: ApiConstants.monnifyApiKey,
        contractCode: ApiConstants.monnifyContractCode,
      );
    } catch (e) {
      debugPrint('Error initializing Monnify SDK: $e');
    }
  }

  Future<dynamic> initializePayment({
    required String customerName,
    required String customerEmail,
    required double amount,
    required String transactionReference,
  }) async {
    if (_monnify == null) {
      await init();
      if (_monnify == null) return null; // Still failed
    }

    final transaction = TransactionDetails().copyWith(
      amount: amount,
      currencyCode: 'NGN',
      customerName: customerName,
      customerEmail: customerEmail,
      paymentReference: transactionReference,
      paymentDescription: 'Best Solo Order Payment',
    );

    try {
      final response = await _monnify?.initializePayment(transaction: transaction);
      return response;
    } catch (e) {
      debugPrint('Monnify Payment Error: $e');
      return null;
    }
  }
}
