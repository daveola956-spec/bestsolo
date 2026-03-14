import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';

import '../../auth/auth_bloc.dart';
import './widgets/home_view.dart';
import '../wishlist/wishlist_screen.dart' as wishlist_screen;
import '../../app.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundAlt,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.shopping_bag_outlined,
                      size: 18, color: AppColors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  'BEST SOLO',
                  style: AppTextStyles.h6.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search_outlined,
                    color: AppColors.textSecondary, size: 24),
                onPressed: () {
                  // TODO: Focus search
                },
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined,
                    color: AppColors.textSecondary, size: 24),
                onPressed: () {
                  // TODO: Navigate to cart
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              const HomeView(),
              const wishlist_screen.WishlistScreen(),
              _buildProfileView(state),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              backgroundColor: Colors.white,
              elevation: 0,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.disabledGray,
              selectedLabelStyle: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              unselectedLabelStyle: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.disabledGray,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.storefront_outlined),
                  activeIcon: Icon(Icons.storefront),
                  label: 'Shop',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border_outlined),
                  activeIcon: Icon(Icons.favorite),
                  label: 'Saved',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileView(AuthState state) {
    if (state is! AuthAuthenticated) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF1FAF5A),
                child: Text(
                  (state.fullName ?? state.email)[0].toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.fullName ?? 'User',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      state.email,
                      style: GoogleFonts.inter(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _buildProfileItem(
            icon: Icons.shopping_bag_outlined,
            label: 'Order History',
            onTap: () => context.pushNamed(AppRoutes.orderHistory),
          ),
          if (state.role == 'staff' || state.role == 'owner') ...[
            const SizedBox(height: 16),
            Text(
              'Admin Management',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
            _buildProfileItem(
              icon: Icons.list_alt,
              label: 'Manage Orders',
              onTap: () => context.pushNamed(AppRoutes.adminOrders),
            ),
            _buildProfileItem(
              icon: Icons.image_outlined,
              label: 'Manage Banners',
              onTap: () => context.pushNamed(AppRoutes.adminBanners),
            ),
            _buildProfileItem(
              icon: Icons.bar_chart_outlined,
              label: 'Business Analytics',
              onTap: () => context.pushNamed(AppRoutes.adminAnalytics),
            ),
          ],
          _buildProfileItem(
            icon: Icons.person_outline,
            label: 'Edit Profile',
            onTap: () {},
          ),
          _buildProfileItem(
            icon: Icons.location_on_outlined,
            label: 'Shipping Addresses',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildProfileItem(
            icon: Icons.logout,
            label: 'Logout',
            color: Colors.red,
            onTap: () => context.read<AuthBloc>().add(AuthSignOutRequested()),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? const Color(0xFF1FAF5A)).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color ?? const Color(0xFF1FAF5A), size: 20),
      ),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
