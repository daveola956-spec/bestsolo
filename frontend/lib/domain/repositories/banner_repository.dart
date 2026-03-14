import '../models/banner_model.dart';

abstract class BannerRepository {
  Future<List<BannerModel>> fetchActiveBanners();
  Future<List<BannerModel>> fetchAllBanners();
  Future<void> createBanner(BannerModel banner);
  Future<void> updateBannerStatus(String id, bool active);
  Future<void> deleteBanner(String id);
}
