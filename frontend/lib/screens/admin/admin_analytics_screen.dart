import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../analytics/analytics_bloc.dart';
import '../../analytics/analytics_event.dart';
import '../../analytics/analytics_state.dart';
import '../../domain/models/analytics_model.dart';
import '../../inventory/inventory_bloc.dart';
import '../../inventory/inventory_state.dart';
import '../../domain/models/inventory_model.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsBloc>().add(FetchAnalyticsSummary());
  }

  @override
  Widget build(BuildContext context) {
    final curFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          'Business Analytics',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AnalyticsBloc>().add(RefreshAnalytics()),
          ),
        ],
      ),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1FAF5A)));
          }

          if (state is AnalyticsLoaded) {
            final data = state.analytics;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AnalyticsBloc>().add(RefreshAnalytics());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMetricsGrid(data, curFormat),
                    
                    const SizedBox(height: 32),
                    
                    // ── Low Stock Alerts ──────────────────────────────────────
                    BlocBuilder<InventoryBloc, InventoryState>(
                      builder: (context, invState) {
                        if (invState is InventoryLoaded && invState.alerts.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Low Stock Alerts',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildLowStockList(invState.alerts),
                              const SizedBox(height: 32),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    
                    // ── Top Selling Products ──────────────────────────────────
                    Text(
                      'Top Selling Products',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTopProductsList(data, curFormat),
                  ],
                ),
              ),
            );
          }

          if (state is AnalyticsError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMetricsGrid(AnalyticsModel data, NumberFormat curFormat) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            _buildStatCard(
              title: 'Total Orders',
              value: data.totalOrders.toString(),
              icon: Icons.shopping_cart_outlined,
              color: Colors.blue,
            ),
            _buildStatCard(
              title: 'Total Revenue',
              value: curFormat.format(data.totalRevenue),
              icon: Icons.account_balance_wallet_outlined,
              color: Colors.green,
            ),
            _buildStatCard(
              title: 'Customers',
              value: data.totalCustomers.toString(),
              icon: Icons.people_outline,
              color: Colors.orange,
            ),
            _buildStatCard(
              title: 'Avg. Order',
              value: data.totalOrders > 0 
                  ? curFormat.format(data.totalRevenue / data.totalOrders)
                  : '₦0',
              icon: Icons.analytics_outlined,
              color: Colors.purple,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockList(List<InventoryAlert> alerts) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: alerts.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            title: Text(
              alert.productName,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Size: ${alert.size}, Color: ${alert.color}',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: alert.stock == 0 ? Colors.red[50] : Colors.orange[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${alert.stock} left',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: alert.stock == 0 ? Colors.red : Colors.orange[900],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopProductsList(AnalyticsModel data, NumberFormat curFormat) {
    if (data.topProducts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'No sales data yet',
            style: GoogleFonts.inter(color: Colors.grey[400]),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.topProducts.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final product = data.topProducts[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFF0F0F0),
              child: Text(
                '#${index + 1}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1FAF5A),
                ),
              ),
            ),
            title: Text(
              product.productName,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${product.totalQuantity} items sold',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
            ),
            trailing: Text(
              curFormat.format(product.totalRevenue),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1FAF5A),
              ),
            ),
          );
        },
      ),
    );
  }
}
