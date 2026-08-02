import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/wishlist_item_entity.dart';

part 'wishlist_item_hive_model.g.dart';

/// Lumo — Wishlist Item Hive Model
@HiveType(typeId: 2)
class WishlistItemHiveModel extends HiveObject {
  WishlistItemHiveModel({
    required this.productId,
    required this.title,
    required this.brand,
    required this.price,
    required this.imageUrl,
    this.originalPrice,
    this.savedAt,
  });

  @HiveField(0)
  String productId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String brand;

  @HiveField(3)
  double price;

  @HiveField(4)
  double? originalPrice;

  @HiveField(5)
  String imageUrl;

  @HiveField(6)
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
