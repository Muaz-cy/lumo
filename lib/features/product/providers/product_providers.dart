import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/datasources/product_remote_data_source.dart';
import '../data/repositories/product_repository_impl.dart';
import '../domain/entities/product_entity.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/usecases/product_usecases.dart';

part 'product_providers.g.dart';

@riverpod
ProductRemoteDataSource productRemoteDataSource(Ref ref) =>
    ProductRemoteDataSource(Supabase.instance.client);

@riverpod
ProductRepository productRepository(Ref ref) =>
    ProductRepositoryImpl(ref.watch(productRemoteDataSourceProvider));

@riverpod
GetProductById getProductById(Ref ref) =>
    GetProductById(ref.watch(productRepositoryProvider));

@riverpod
GetRelatedProducts getRelatedProducts(Ref ref) =>
    GetRelatedProducts(ref.watch(productRepositoryProvider));

/// Fetches a single product by ID — auto-disposed when screen leaves.
@riverpod
Future<ProductEntity> productDetail(Ref ref, String id) async {
  final result = await ref.watch(getProductByIdProvider).call(id);
  return result.fold((failure) => throw failure, (product) => product);
}

/// Fetches related products — keyed by productId + categoryId.
@riverpod
Future<List<ProductEntity>> relatedProducts(
  Ref ref, {
  required String productId,
  required String categoryId,
}) async {
  final result = await ref.watch(getRelatedProductsProvider).call(
        productId: productId,
        categoryId: categoryId,
      );
  return result.fold((failure) => [], (products) => products);
}
