import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lumo/core/errors/failures.dart';
import '../../domain/entities/wishlist_item_entity.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../models/wishlist_item_hive_model.dart';

/// Lumo — Wishlist Repository Implementation
/// Synchronous Hive operations — works fully offline.
class WishlistRepositoryImpl implements WishlistRepository {
  WishlistRepositoryImpl(this._box);

  final Box<WishlistItemHiveModel> _box;

  List<WishlistItemEntity> _buildList() {
    final items = _box.values.map((m) => m.toEntity()).toList()
      ..sort((a, b) => (b.savedAt ?? DateTime(0))
          .compareTo(a.savedAt ?? DateTime(0)));
    return items;
  }

  @override
  Either<LumoFailure, List<WishlistItemEntity>> getWishlist() {
    try {
      return Right(_buildList());
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to load wishlist.'));
    }
  }

  @override
  Either<LumoFailure, List<WishlistItemEntity>> addItem(
      WishlistItemEntity item) {
    try {
      _box.put(item.productId, WishlistItemHiveModel.fromEntity(item));
      return Right(_buildList());
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to save item.'));
    }
  }

  @override
  Either<LumoFailure, List<WishlistItemEntity>> removeItem(String productId) {
    try {
      _box.delete(productId);
      return Right(_buildList());
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to remove item.'));
    }
  }

  @override
  bool isWishlisted(String productId) => _box.containsKey(productId);
}
