import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors - Green
  static const Color primary = Color(0xFF1FAF5A);
  static const Color primaryDark = Color(0xFF158045);
  static const Color primaryLight = Color(0xFFE8F5EA);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color darkGray = Color(0xFF333333);
  static const Color mediumGray = Color(0xFF666666);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color borderGray = Color(0xFFE0E0E0);
  static const Color disabledGray = Color(0xFFBDBDBD);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Extended palette
  static const Color background = white;
  static const Color surface = white;
  static const Color backgroundAlt = Color(0xFFF9F9F9); // Home page background
  static const Color textPrimary = black;
  static const Color textSecondary = mediumGray;
  static const Color textDisabled = disabledGray;

  // Stock status colors
  static const Color inStock = Color(0xFFE8F5EA);
  static const Color lowStock = Color(0xFFFFF8E1);
  static const Color outOfStock = Color(0xFFFFEBEE);

  // Order status colors
  static const Color statusPending = Color(0xFFFFF3E0);
  static const Color statusProcessing = Color(0xFFE3F2FD);
  static const Color statusShipped = Color(0xFFE8F5EA);
  static const Color statusDelivered = Color(0xFFE8F5EA);
  static const Color statusCancelled = Color(0xFFFFEBEE);
}