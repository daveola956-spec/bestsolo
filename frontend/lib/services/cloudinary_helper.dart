class CloudinaryHelper {
  CloudinaryHelper._();

  /// Transforms a raw Cloudinary URL into a thumbnail.
  /// Transformation: w_400,c_fill,q_auto,f_auto
  static String getThumbnailUrl(String imageUrl) {
    if (!imageUrl.contains('cloudinary.com')) return imageUrl;
    return _applyTransformation(imageUrl, 'w_400,c_fill,q_auto,f_auto');
  }

  /// Transforms a raw Cloudinary URL into a high-quality product image.
  /// Transformation: w_800,q_auto,f_auto
  static String getProductImageUrl(String imageUrl) {
    if (!imageUrl.contains('cloudinary.com')) return imageUrl;
    return _applyTransformation(imageUrl, 'w_800,q_auto,f_auto');
  }

  static String _applyTransformation(String url, String transformation) {
    // Cloudinary URLs usually look like: 
    // https://res.cloudinary.com/demo/image/upload/v12345678/sample.jpg
    // We want to insert the transformation after '/upload/'
    const pattern = '/upload/';
    if (!url.contains(pattern)) return url;
    
    final parts = url.split(pattern);
    return '${parts[0]}$pattern$transformation/${parts[1]}';
  }
}
