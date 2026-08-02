/// Lumo — Product Entity
/// Pure domain model. No Flutter. No Supabase. No JSON.
/// This is the truth of what a product is in Lumo's world.
final class ProductEntity {
  const ProductEntity({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    required this.imageUrls,
    required this.categoryId,
    this.originalPrice,
    this.rating,
    this.reviewCount = 0,
    this.isAvailable = true,
    this.isFeatured = false,
    this.tags = const [],
    this.description,
    this.benefits = const [],
    this.specs = const {},
    this.keyFeatures = const [],
    this.stockCount,
  });

  final String id;
  final String title;
  final String brand;
  final double price;
  final double? originalPrice;
  final List<String> imageUrls;
  final String categoryId;
  final double? rating;
  final int reviewCount;
  final bool isAvailable;
  final bool isFeatured;
  final List<String> tags;
  final String? description;

  /// Short benefit statements — shown before specs.
  final List<String> benefits;

  /// Technical specifications — key/value pairs.
  final Map<String, String> specs;

  /// 2–4 key feature highlights shown prominently.
  final List<String> keyFeatures;

  /// Remaining stock — used for honest availability messaging.
  final int? stockCount;

  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';

  bool get hasDiscount =>
      originalPrice != null && originalPrice! > price;

  double get discountPercent =>
      hasDiscount ? ((originalPrice! - price) / originalPrice! * 100) : 0;

  bool get isLowStock => stockCount != null && stockCount! <= 5 && stockCount! > 0;
}
