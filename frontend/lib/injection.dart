import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/auth_bloc.dart';
import 'auth/auth_repository.dart';
import 'auth/supabase_auth_repository.dart';
import 'cart/cart_bloc.dart';
import 'core/constants/api_constants.dart';
import 'domain/repositories/cart_repository.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/repositories/wishlist_repository.dart';
import 'order/order_bloc.dart';
import 'product/product_bloc.dart';
import 'wishlist/wishlist_bloc.dart';
import 'services/auth_service.dart';
import 'services/local_cart_service.dart';
import 'services/monnify_payment_service.dart';
import 'services/supabase_order_service.dart';
import 'services/supabase_product_service.dart';
import 'services/supabase_wishlist_service.dart';
import 'services/supabase_review_service.dart';
import 'domain/repositories/review_repository.dart';
import 'review/review_bloc.dart';
import 'services/supabase_promo_service.dart';
import 'domain/repositories/promo_repository.dart';
import 'promo/promo_bloc.dart';
import 'services/supabase_banner_service.dart';
import 'domain/repositories/banner_repository.dart';
import 'banner/banner_bloc.dart';
import 'services/analytics_service.dart';
import 'domain/repositories/analytics_repository.dart';
import 'analytics/analytics_bloc.dart';
import 'services/inventory_service.dart';
import 'domain/repositories/inventory_repository.dart';
import 'inventory/inventory_bloc.dart';
import 'inventory/inventory_event.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // ── Local Storage ─────────────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  // ── Supabase ──────────────────────────────────────────────────────────────
  await Supabase.initialize(
    url: ApiConstants.supabaseUrl,
    anonKey: ApiConstants.supabaseAnonKey,
  );

  getIt.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );

  // ── Dio (HTTP client) ─────────────────────────────────────────────────────
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ));

    // Add auth token interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final session = getIt<SupabaseClient>().auth.currentSession;
          if (session != null) {
            options.headers['Authorization'] = 'Bearer ${session.accessToken}';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // TODO: Handle 401 → refresh token or sign out
          handler.next(error);
        },
      ),
    );

    return dio;
  });

  // ── Auth ──────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<SupabaseClient>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => SupabaseAuthRepository(getIt<AuthService>()),
  );

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(getIt<AuthRepository>(), getIt<SupabaseClient>()),
  );

  // ── Products ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ProductRepository>(
    () => SupabaseProductService(getIt<SupabaseClient>()),
  );

  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(getIt<ProductRepository>()),
  );

  // ── Cart ──────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<CartRepository>(
    () => LocalCartService(getIt<SharedPreferences>()),
  );

  getIt.registerFactory<CartBloc>(
    () => CartBloc(getIt<CartRepository>()),
  );

  // ── Orders ────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<OrderRepository>(
    () => SupabaseOrderService(getIt<SupabaseClient>()),
  );

  getIt.registerLazySingleton<MonnifyPaymentService>(
    () => MonnifyPaymentService(),
  );

  getIt.registerFactory<OrderBloc>(
    () => OrderBloc(getIt<OrderRepository>()),
  );

  // ── Wishlist ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<WishlistRepository>(
    () => SupabaseWishlistService(getIt<SupabaseClient>()),
  );

  getIt.registerFactory<WishlistBloc>(
    () => WishlistBloc(getIt<WishlistRepository>()),
  );

  // ── Reviews ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ReviewRepository>(
    () => SupabaseReviewService(getIt<SupabaseClient>()),
  );

  getIt.registerFactory<ReviewBloc>(
    () => ReviewBloc(getIt<ReviewRepository>()),
  );

  // ── Promo Codes ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<PromoRepository>(
    () => SupabasePromoService(getIt<SupabaseClient>()),
  );

  getIt.registerFactory<PromoBloc>(
    () => PromoBloc(getIt<PromoRepository>()),
  );

  // ── Marketing Banners ───────────────────────────────────────────────────
  getIt.registerLazySingleton<BannerRepository>(
    () => SupabaseBannerService(getIt<SupabaseClient>()),
  );

  getIt.registerFactory<BannerBloc>(
    () => BannerBloc(getIt<BannerRepository>()),
  );

  // ── Analytics ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AnalyticsRepository>(
    () => SupabaseAnalyticsService(getIt<SupabaseClient>()),
  );

  getIt.registerFactory<AnalyticsBloc>(
    () => AnalyticsBloc(getIt<AnalyticsRepository>()),
  );

  // ── Inventory ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<InventoryRepository>(
    () => SupabaseInventoryService(getIt<SupabaseClient>()),
  );

  getIt.registerFactory<InventoryBloc>(
    () => InventoryBloc(getIt<InventoryRepository>()),
  );
}