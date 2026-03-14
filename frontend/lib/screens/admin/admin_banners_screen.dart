import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../banner/banner_bloc.dart';
import '../../banner/banner_event.dart';
import '../../banner/banner_state.dart';
import '../../domain/models/banner_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_image.dart';

class AdminBannersScreen extends StatefulWidget {
  const AdminBannersScreen({super.key});

  @override
  State<AdminBannersScreen> createState() => _AdminBannersScreenState();
}

class _AdminBannersScreenState extends State<AdminBannersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BannerBloc>().add(const LoadBanners(activeOnly: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          'Manage Banners',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddBannerDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<BannerBloc, BannerState>(
        builder: (context, state) {
          if (state is BannerLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1FAF5A)));
          }

          if (state is BannerLoaded) {
            if (state.banners.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.image_outlined, size: 64, color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 16),
                    Text(
                      'No banners found',
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.banners.length,
              itemBuilder: (context, index) {
                final banner = state.banners[index];
                return _buildBannerCard(banner);
              },
            );
          }

          if (state is BannerError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBannerCard(BannerModel banner) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AppImage(
              imageUrl: banner.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banner.title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (banner.link != null)
                        Text(
                          banner.link!,
                          style: GoogleFonts.inter(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Switch(
                  value: banner.active,
                  onChanged: (val) {
                    context.read<BannerBloc>().add(ToggleBannerActive(banner.id, val));
                  },
                  activeColor: const Color(0xFF1FAF5A),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => context.read<BannerBloc>().add(DeleteBanner(banner.id)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBannerDialog(BuildContext context) {
    final titleController = TextEditingController();
    final urlController = TextEditingController();
    final linkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Banner', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(labelText: 'Navigation Link (Optional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && urlController.text.isNotEmpty) {
                final banner = BannerModel(
                  id: '',
                  title: titleController.text.trim(),
                  imageUrl: urlController.text.trim(),
                  link: linkController.text.trim().isEmpty ? null : linkController.text.trim(),
                  active: true,
                  createdAt: DateTime.now(),
                );
                context.read<BannerBloc>().add(CreateBanner(banner));
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1FAF5A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
