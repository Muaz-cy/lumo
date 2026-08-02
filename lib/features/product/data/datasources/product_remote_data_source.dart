import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/lumo_logger.dart';
import '../models/product_dto.dart';

/// Lumo — Product Remote Data Source
final class ProductRemoteDataSource {
  const ProductRemoteDataSource(this._client);
  final SupabaseClient _client;

  Future<ProductDto> getProductById(String id) async {
    LumoLogger.debug('Fetching product: $id');
    final response = await _client
        .from('products')
        .select()
        .eq('id', id)
        .single();
    return ProductDto.fromJson(response);
  }

  Future<List<ProductDto>> getRelatedProducts({
    required String productId,
    required String categoryId,
  }) async {
    LumoLogger.debug('Fetching related products for category: $categoryId');
    final response = await _client
        .from('products')
        .select()
        .eq('category_id', categoryId)
        .eq('is_available', true)
        .neq('id', productId)
        .limit(8);
    return (response as List)
        .map((json) => ProductDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
