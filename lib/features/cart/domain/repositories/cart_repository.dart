import 'package:dartz/dartz.dart';
import 'package:lumo/core/errors/failures.dart';
import '../entities/cart_entity.dart';
import '../entities/cart_item_entity.dart';

/// Lumo — Cart Repository Contract
/// UI never knows whether cart lives in Hive, memory, or the cloud.
abstract interface class CartRepository {
  /// Returns the current cart state.
  Either<LumoFailure, CartEntity> getCart();

  /// Adds an item or increments quantity if already present.
  Either<LumoFailure, CartEntity> addItem(CartItemEntity item);

  /// Removes an item entirely by productId.
  Either<LumoFailure, CartEntity> removeItem(String productId);

  /// Updates quantity for a given productId. Removes if quantity <= 0.
  Either<LumoFailure, CartEntity> updateQuantity(String productId, int quantity);

  /// Clears the entire cart.
  Either<LumoFailure, CartEntity> clearCart();
}
