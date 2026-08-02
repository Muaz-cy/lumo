/// Lumo — Wishlist Item Entity
/// People save dreams, not products.
/// Pure domain — no Flutter, no Hive.
final class WishlistItemEntity {
  const WishlistItemEntity({
    required this.productId,
    required this.title,
    required this.brand,
    required this.price,
    required this.imageUrl,
    this.originalPrice,
    this.savedAt,
  });

  final String productId;
  final String title;
  final String brand;
  final double price;
  final double? originalPrice;
  final String imageUrl;

  /// When the user saved this item — used for sorting.
  final DateTime? savedAt;

  bool get hasDiscount =>
      originalPrice != null && originalPrice! > price;

  double get discountPercent =>
      hasDiscount ? ((originalPrice! - price) / originalPrice! * 100) : 0;
}
