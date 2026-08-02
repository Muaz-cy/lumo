import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lumo/core/errors/failures.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../models/cart_item_hive_model.dart';

/// Lumo — Cart Repository Implementation
/// Offline-first: all cart operations are synchronous Hive reads/writes.
class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._box);

  final Box<CartItemHiveModel> _box;

  CartEntity _buildCart() {
    final items = _box.values.map((m) => m.toEntity()).toList();
    return CartEntity(items: items);
  }

  @override
  Either<LumoFailure, CartEntity> getCart() {
    try {
      return Right(_buildCart());
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to load cart.'));
    }
  }

  @override
  Either<LumoFailure, CartEntity> addItem(CartItemEntity item) {
    try {
      final existing = _box.get(item.productId);
      if (existing != null) {
        existing.quantity += item.quantity;
        existing.save();
      } else {
        _box.put(item.productId, CartItemHiveModel.fromEntity(item));
      }
      return Right(_buildCart());
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to add item to cart.'));
    }
  }

  @override
  Either<LumoFailure, CartEntity> removeItem(String productId) {
    try {
      _box.delete(productId);
      return Right(_buildCart());
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to remove item from cart.'));
    }
  }

  @override
  Either<LumoFailure, CartEntity> updateQuantity(
      String productId, int quantity) {
    try {
      if (quantity <= 0) {
        _box.delete(productId);
      } else {
        final existing = _box.get(productId);
        if (existing != null) {
          existing.quantity = quantity;
          existing.save();
        }
      }
      return Right(_buildCart());
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to update quantity.'));
    }
  }

  @override
  Either<LumoFailure, CartEntity> clearCart() {
    try {
      _box.clear();
      return Right(_buildCart());
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to clear cart.'));
    }
  }
}
