import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';

/// Lumo — Product Repository Contract
abstract interface class ProductRepository {
  Future<Either<LumoFailure, ProductEntity>> getProductById(String id);
  Future<Either<LumoFailure, List<ProductEntity>>> getRelatedProducts({
    required String productId,
    required String categoryId,
  });
}
