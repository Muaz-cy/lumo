import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Lumo — GetProductById Use Case
final class GetProductById {
  const GetProductById(this._repository);
  final ProductRepository _repository;

  Future<Either<LumoFailure, ProductEntity>> call(String id) =>
      _repository.getProductById(id);
}

/// Lumo — GetRelatedProducts Use Case
final class GetRelatedProducts {
  const GetRelatedProducts(this._repository);
  final ProductRepository _repository;

  Future<Either<LumoFailure, List<ProductEntity>>> call({
    required String productId,
    required String categoryId,
  }) =>
      _repository.getRelatedProducts(
        productId: productId,
        categoryId: categoryId,
      );
}
