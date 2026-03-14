import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'auth/auth_bloc.dart';
import 'cart/cart_bloc.dart';
import 'product/product_bloc.dart';
import 'order/order_bloc.dart';
import 'wishlist/wishlist_bloc.dart';
import 'review/review_bloc.dart';
import 'promo/promo_bloc.dart';
import 'banner/banner_bloc.dart';
import 'banner/banner_event.dart';
import 'analytics/analytics_bloc.dart';
import 'analytics/analytics_event.dart';
import 'inventory/inventory_bloc.dart';
import 'inventory/inventory_event.dart';
import 'injection.dart';
import 'widgets/deferred_widget.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register_page.dart';
import 'screens/auth/forgot_password_page.dart';
import 'screens/shop/shop_screen.dart' as shop_screen;
import 'screens/cart/cart_screen.dart' as cart_screen;
import 'screens/checkout/checkout_screen.dart' as checkout_screen;
import 'screens/home/home_page.dart';
import 'screens/product/product_details_screen.dart' as product_details;
import 'screens/orders/order_confirmation_screen.dart';
import 'screens/orders/order_history_screen.dart';
import 'screens/orders/order_details_screen.dart';
import 'screens/admin/orders/admin_orders_screen.dart' deferred as admin_orders;
import 'screens/admin/admin_banners_screen.dart' deferred as admin_banners;
import 'screens/admin/admin_analytics_screen.dart' deferred as admin_analytics;
import 'domain/models/order.dart';
import 'core/theme/theme.dart';

/// Route names — use these with context.goNamed(AppRoutes.xxx)
class AppRoutes {
  AppRoutes._();

  static const splash = 'splash';
  static const login = 'login';
  static const register = 'register';
  static const forgotPassword = 'forgot-password';
  static const home = 'home';
  static const shop = 'shop';
  static const checkout = 'checkout';
  static const orderConfirmation = 'order-confirmation';
  static const orderHistory = 'order-history';
  static const orderDetails = 'order-details';
  static const adminOrders = 'admin-orders';
  static const adminBanners = 'admin-banners';
  static const adminAnalytics = 'admin-analytics';
}

// ⚠️ TEST BYPASS — set to false when Supabase is connected
const kTestBypass = true;

final _router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    // ⚠️ TEST MODE: bypass all auth guards for UI testing
    if (kTestBypass) {
      if (state.matchedLocation == '/') return '/home';
      return null;
    }

    final authState = context.read<AuthBloc>().state;
    final isLoggingIn = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/forgot-password' ||
        state.matchedLocation == '/';
    final isAdminRoute = state.matchedLocation.startsWith('/admin');

    // Redirect authenticated users away from auth screens
    if (authState is AuthAuthenticated && isLoggingIn) return '/home';

    // Redirect unauthenticated users to login
    if (authState is AuthUnauthenticated && !isLoggingIn) return '/login';

    // Block non-admin users from accessing admin routes
    if (isAdminRoute) {
      if (authState is AuthUnauthenticated) return '/login';
      if (authState is AuthAuthenticated && !authState.isAdmin) return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: AppRoutes.login,
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: AppRoutes.register,
      builder: (_, __) => const RegisterPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: AppRoutes.forgotPassword,
      builder: (_, __) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/home',
      name: AppRoutes.home,
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: '/shop',
      name: AppRoutes.shop,
      builder: (context, state) {
        final categoryId = state.uri.queryParameters['categoryId'];
        return shop_screen.ShopScreen(initialCategoryId: categoryId);
      },
    ),
    GoRoute(
      path: '/product/:id',
      name: 'product-details',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return product_details.ProductDetailsScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (_, __) => const cart_screen.CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      name: AppRoutes.checkout,
      builder: (_, __) => const checkout_screen.CheckoutScreen(),
    ),
    GoRoute(
      path: '/order-confirmation',
      name: AppRoutes.orderConfirmation,
      builder: (context, state) {
        final order = state.extra as Order;
        return OrderConfirmationScreen(order: order);
      },
    ),
    GoRoute(
      path: '/order-history',
      name: AppRoutes.orderHistory,
      builder: (_, __) => const OrderHistoryScreen(),
      routes: [
        GoRoute(
          path: ':id',
          name: AppRoutes.orderDetails,
          builder: (context, state) {
            final order = state.extra as Order;
            return OrderDetailsScreen(order: order);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/admin/orders',
      name: AppRoutes.adminOrders,
      builder: (_, __) => DeferredWidget(
        loader: admin_orders.loadLibrary,
        builder: () => admin_orders.AdminOrdersScreen(),
      ),
    ),
    GoRoute(
      path: '/admin/banners',
      name: AppRoutes.adminBanners,
      builder: (_, __) => DeferredWidget(
        loader: admin_banners.loadLibrary,
        builder: () => admin_banners.AdminBannersScreen(),
      ),
    ),
    GoRoute(
      path: '/admin/analytics',
      name: AppRoutes.adminAnalytics,
      builder: (_, __) => DeferredWidget(
        loader: admin_analytics.loadLibrary,
        builder: () => admin_analytics.AdminAnalyticsScreen(),
      ),
    ),
  ],
);

class BestSoloApp extends StatelessWidget {
  const BestSoloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<ProductBloc>(
          create: (_) => getIt<ProductBloc>(),
        ),
        BlocProvider<CartBloc>(
          create: (_) => getIt<CartBloc>()..add(LoadCart()),
        ),
        BlocProvider<OrderBloc>(
          create: (_) => getIt<OrderBloc>(),
        ),
        BlocProvider<WishlistBloc>(
          create: (_) => getIt<WishlistBloc>(),
        ),
        BlocProvider<ReviewBloc>(
          create: (_) => getIt<ReviewBloc>(),
        ),
        BlocProvider<PromoBloc>(
          create: (_) => getIt<PromoBloc>(),
        ),
        BlocProvider<BannerBloc>(
          create: (_) => getIt<BannerBloc>()..add(LoadBanners()),
        ),
        BlocProvider<AnalyticsBloc>(
          create: (_) => getIt<AnalyticsBloc>()..add(FetchAnalyticsSummary()),
        ),
        BlocProvider<InventoryBloc>(
          create: (_) => getIt<InventoryBloc>()..add(LoadInventoryAlerts()),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Trigger route redirect on auth state changes
          if (state is AuthAuthenticated) {
            _router.go('/home');
            context.read<WishlistBloc>().add(LoadWishlist(state.userId));
          }
          if (state is AuthUnauthenticated) {
            _router.go('/login');
          }
        },
        child: MaterialApp.router(
          title: 'BEST SOLO',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
        ),
      ),
    );
  }
}