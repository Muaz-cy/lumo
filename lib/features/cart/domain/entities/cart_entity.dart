import 'cart_item_entity.dart';

/// Lumo — Cart Entity
/// Aggregate root for the shopping cart. Computes totals from items.
final class CartEntity {
  const CartEntity({this.items = const []});

  final List<CartItemEntity> items;

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => items.fold(0, (sum, i) => sum + i.subtotal);

  /// Savings = sum of (originalPrice - price) * quantity for discounted items.
  double get totalSavings => items.fold(0, (sum, i) {
        if (!i.hasDiscount) return sum;
        return sum + ((i.originalPrice! - i.price) * i.quantity);
      });

  /// Free shipping above $75, otherwise flat $5.99.
  double get shippingCost => subtotal >= 75.0 ? 0.0 : 5.99;

  bool get hasFreeShipping => shippingCost == 0.0;

  double get total => subtotal + shippingCost;
}
