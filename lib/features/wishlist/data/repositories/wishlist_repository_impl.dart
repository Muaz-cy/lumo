import 'package:dartz/dartz.dart';
import 'package:lumo/core/errors/failures.dart';
import '../../domain/entities/wishlist_item_entity.dart';
import '../../domain/repositories/wishlist_repository.dart';

/// Lumo — Wishlist Repository (In-Memory Stub)
/// Hive dependency removed. Will be Supabase-backed (saved_properties) in Phase 4.
class WishlistRepositoryImpl implements WishlistRepository {
  final Map<String, WishlistItemEntity> _items = {};

  List<WishlistItemEntity> _buildList() {
    return _items.values.toList()
      ..sort((a, b) =>
          (b.savedAt ?? DateTime(0)).compareTo(a.savedAt ?? DateTime(0)));
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
      _items[item.productId] = WishlistItemEntity(
        productId: item.productId,
        title: item.title,
        brand: item.brand,
        price: item.price,
        originalPrice: item.originalPrice,
        imageUrl: item.imageUrl,
        savedAt: DateTime.now(),
      );
      return Right(_buildList());
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to save item.'));
    }
  }

  @override
  Either<LumoFailure, List<WishlistItemEntity>> removeItem(String productId) {
    try {
      _items.remove(productId);
      return Right(_buildList());
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to remove item.'));
    }
  }

  @override
  bool isWishlisted(String productId) => _items.containsKey(productId);
}
