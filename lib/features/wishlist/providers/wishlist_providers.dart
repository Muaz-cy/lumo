import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/wishlist_item_hive_model.dart';
import '../data/repositories/wishlist_repository_impl.dart';
import '../domain/entities/wishlist_item_entity.dart';
import '../domain/repositories/wishlist_repository.dart';

part 'wishlist_providers.g.dart';

const _wishlistBoxName = 'lumo_wishlist';

@riverpod
Box<WishlistItemHiveModel> wishlistBox(Ref ref) =>
    Hive.box<WishlistItemHiveModel>(_wishlistBoxName);

@riverpod
WishlistRepository wishlistRepository(Ref ref) =>
    WishlistRepositoryImpl(ref.watch(wishlistBoxProvider));

/// Single source of truth for the wishlist.
@riverpod
class WishlistNotifier extends _$WishlistNotifier {
  @override
  List<WishlistItemEntity> build() {
    final result = ref.watch(wishlistRepositoryProvider).getWishlist();
    return result.fold((_) => [], (items) => items);
  }

  WishlistRepository get _repo => ref.read(wishlistRepositoryProvider);

  /// Toggles wishlist state — adds if absent, removes if present.
  /// Returns true if item was added (for animation trigger).
  bool toggle(WishlistItemEntity item) {
    final wasWishlisted = _repo.isWishlisted(item.productId);
    if (wasWishlisted) {
      final result = _repo.removeItem(item.productId);
      result.fold((_) {}, (items) => state = items);
      return false;
    } else {
      final result = _repo.addItem(item);
      result.fold((_) {}, (items) => state = items);
      return true;
    }
  }

  bool isWishlisted(String productId) =>
      _repo.isWishlisted(productId);
}
