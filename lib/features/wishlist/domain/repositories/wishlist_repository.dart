import 'package:dartz/dartz.dart';
import 'package:lumo/core/errors/failures.dart';
import '../entities/wishlist_item_entity.dart';

/// Lumo — Wishlist Repository Contract
abstract interface class WishlistRepository {
  Either<LumoFailure, List<WishlistItemEntity>> getWishlist();
  Either<LumoFailure, List<WishlistItemEntity>> addItem(WishlistItemEntity item);
  Either<LumoFailure, List<WishlistItemEntity>> removeItem(String productId);
  bool isWishlisted(String productId);
}
