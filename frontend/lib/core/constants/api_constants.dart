import 'package:flutter/foundation.dart';

class ApiConstants {
  ApiConstants._();

  // ── Supabase ──────────────────────────────────────────────────────────────
  // TODO: Replace with your actual Supabase project values from
  //       https://app.supabase.com → Settings → API
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://YOUR_PROJECT_ID.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_ANON_KEY',
  );

  // ── Table names ───────────────────────────────────────────────────────────
  static const String usersTable = 'users';
  static const String productsTable = 'products';
  static const String categoriesTable = 'categories';
  static const String variantsTable = 'product_variants';
  static const String ordersTable = 'orders';
  static const String orderItemsTable = 'order_items';
  static const String addressesTable = 'addresses';
  static const String cartTable = 'cart_items';
  static const String wishlistTable = 'wishlist';
  static const String paymentsTable = 'payments';

  // ── Supabase Edge Functions ───────────────────────────────────────────────
  static const String paymentWebhookFn = 'payment-webhook';
  static const String orderNotificationFn = 'order-notifications';
  static const String imageUploadSignatureFn = 'image-upload-signature';

  // ── Storage buckets ───────────────────────────────────────────────────────
  static const String productImagesBucket = 'product-images';
  static const String avatarsBucket = 'avatars';

  // ── Cloudinary ────────────────────────────────────────────────────────────
  static const String cloudinaryCloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'YOUR_CLOUD_NAME',
  );
  static const String cloudinaryUploadPreset = 'bestsolo_products';

  // ── Monnify ───────────────────────────────────────────────────────────────
  static const String monnifyBaseUrl = kDebugMode
      ? 'https://sandbox.monnify.com/api/v1'
      : 'https://api.monnify.com/api/v1';
  static const String monnifyContractCode = String.fromEnvironment(
    'MONNIFY_CONTRACT_CODE',
    defaultValue: 'YOUR_CONTRACT_CODE',
  );
  static const String monnifyApiKey = String.fromEnvironment(
    'MONNIFY_API_KEY',
    defaultValue: 'YOUR_API_KEY',
  );
  static const String monnifyPublicKey = String.fromEnvironment(
    'MONNIFY_PUBLIC_KEY',
    defaultValue: 'YOUR_PUBLIC_KEY',
  );

  // ── Pagination ────────────────────────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ── Timeouts ──────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ── Cart / Storage keys ───────────────────────────────────────────────────
  static const String guestCartKey = 'guest_cart';
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String recentSearchesKey = 'recent_searches';
}