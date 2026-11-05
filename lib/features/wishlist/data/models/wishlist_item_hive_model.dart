import '../../domain/entities/wishlist_item_entity.dart';

/// Lumo — Wishlist Item Model
/// Will be replaced by Supabase-backed saved properties in Phase 4.
class WishlistItemHiveModel {
  WishlistItemHiveModel({
    required this.productId,
    required this.title,
    required this.brand,
    required this.price,
    required this.imageUrl,
    this.originalPrice,
    this.savedAt,
  });

  String productId;
  String title;
  String brand;
  double price;
  double? originalPrice;
  String imageUrl;
  DateTime? savedAt;

  WishlistItemEntity toEntity() => WishlistItemEntity(
        productId: productId,
        title: title,
        brand: brand,
        price: price,
        originalPrice: originalPrice,
        imageUrl: imageUrl,
        savedAt: savedAt,
      );

  static WishlistItemHiveModel fromEntity(WishlistItemEntity e) =>
      WishlistItemHiveModel(
        productId: e.productId,
        title: e.title,
        brand: e.brand,
        price: e.price,
        originalPrice: e.originalPrice,
        imageUrl: e.imageUrl,
        savedAt: e.savedAt ?? DateTime.now(),
      );
}
