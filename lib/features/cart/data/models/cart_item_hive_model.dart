import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/cart_item_entity.dart';

part 'cart_item_hive_model.g.dart';

/// Lumo — Cart Item Hive Model
/// Persists cart items locally. Mapped to/from CartItemEntity.
@HiveType(typeId: 1)
class CartItemHiveModel extends HiveObject {
  CartItemHiveModel({
    required this.productId,
    required this.title,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    this.originalPrice,
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
  int quantity;

  CartItemEntity toEntity() => CartItemEntity(
        productId: productId,
        title: title,
        brand: brand,
        price: price,
        originalPrice: originalPrice,
        imageUrl: imageUrl,
        quantity: quantity,
      );

  static CartItemHiveModel fromEntity(CartItemEntity e) => CartItemHiveModel(
        productId: e.productId,
        title: e.title,
        brand: e.brand,
        price: e.price,
        originalPrice: e.originalPrice,
        imageUrl: e.imageUrl,
        quantity: e.quantity,
      );
}
