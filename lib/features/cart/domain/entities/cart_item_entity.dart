/// Lumo — Cart Item Entity
/// A single line item in the cart. Pure domain — no Flutter, no Hive.
final class CartItemEntity {
  const CartItemEntity({
    required this.productId,
    required this.title,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    this.originalPrice,
  });

  final String productId;
  final String title;
  final String brand;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final int quantity;

  double get subtotal => price * quantity;

  bool get hasDiscount =>
      originalPrice != null && originalPrice! > price;

  double get discountPercent =>
      hasDiscount ? ((originalPrice! - price) / originalPrice! * 100) : 0;

  CartItemEntity copyWith({int? quantity}) => CartItemEntity(
        productId: productId,
        title: title,
        brand: brand,
        price: price,
        originalPrice: originalPrice,
        imageUrl: imageUrl,
        quantity: quantity ?? this.quantity,
      );
}
