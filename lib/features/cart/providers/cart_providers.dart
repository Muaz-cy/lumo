import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/cart_item_hive_model.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../domain/entities/cart_entity.dart';
import '../domain/entities/cart_item_entity.dart';
import '../domain/repositories/cart_repository.dart';

part 'cart_providers.g.dart';

const _cartBoxName = 'lumo_cart';

/// Opens (or returns already-open) Hive box for cart items.
@riverpod
Box<CartItemHiveModel> cartBox(Ref ref) {
  return Hive.box<CartItemHiveModel>(_cartBoxName);
}

@riverpod
CartRepository cartRepository(Ref ref) =>
    CartRepositoryImpl(ref.watch(cartBoxProvider));

/// Cart state notifier — single source of truth for the cart.
@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  CartEntity build() {
    final result = ref.watch(cartRepositoryProvider).getCart();
    return result.fold((_) => const CartEntity(), (cart) => cart);
  }

  CartRepository get _repo => ref.read(cartRepositoryProvider);

  void addItem(CartItemEntity item) {
    final result = _repo.addItem(item);
    result.fold((_) {}, (cart) => state = cart);
  }

  void removeItem(String productId) {
    final result = _repo.removeItem(productId);
    result.fold((_) {}, (cart) => state = cart);
  }

  void updateQuantity(String productId, int quantity) {
    final result = _repo.updateQuantity(productId, quantity);
    result.fold((_) {}, (cart) => state = cart);
  }

  void clearCart() {
    final result = _repo.clearCart();
    result.fold((_) {}, (cart) => state = cart);
  }

  bool containsProduct(String productId) =>
      state.items.any((i) => i.productId == productId);
}
