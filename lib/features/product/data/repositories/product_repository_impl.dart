import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/logging/lumo_logger.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

/// Lumo — Product Repository Implementation
final class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._dataSource);
  final ProductRemoteDataSource _dataSource;

  @override
  Future<Either<LumoFailure, ProductEntity>> getProductById(String id) async {
    try {
      final dto = await _dataSource.getProductById(id);
      return Right(dto.toEntity());
    } on PostgrestException catch (e) {
      LumoLogger.error('Supabase error fetching product $id', e);
      if (e.code == 'PGRST116') return const Left(NotFoundFailure());
      return Left(ServerFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Unknown error fetching product $id', e, st);
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<LumoFailure, List<ProductEntity>>> getRelatedProducts({
    required String productId,
    required String categoryId,
  }) async {
    try {
      final dtos = await _dataSource.getRelatedProducts(
        productId: productId,
        categoryId: categoryId,
      );
      return Right(dtos.map((d) => d.toEntity()).toList());
    } on PostgrestException catch (e) {
      LumoLogger.error('Supabase error fetching related products', e);
      return Left(ServerFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Unknown error fetching related products', e, st);
      return const Left(UnknownFailure());
    }
  }
}
