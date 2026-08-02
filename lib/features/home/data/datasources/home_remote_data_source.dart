import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/lumo_logger.dart';
import '../../../product/data/models/product_dto.dart';
import '../models/collection_dto.dart';

/// Lumo — Home Remote Data Source
/// Owns all Supabase queries for the home screen.
/// Nothing outside this class knows about Supabase.
final class HomeRemoteDataSource {
  const HomeRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<List<ProductDto>> getFeaturedProducts() async {
    LumoLogger.debug('Fetching featured products...');
    final response = await _client
        .from('products')
        .select()
        .eq('is_featured', true)
        .eq('is_available', true)
        .order('created_at', ascending: false)
        .limit(10);

    return (response as List)
        .map((json) => ProductDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductDto>> getTrendingProducts() async {
    LumoLogger.debug('Fetching trending products...');
    final response = await _client
        .from('products')
        .select()
        .eq('is_available', true)
        .order('review_count', ascending: false)
        .limit(12);

    return (response as List)
        .map((json) => ProductDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<CollectionDto>> getCollections() async {
    LumoLogger.debug('Fetching collections...');
    final response = await _client
        .from('collections')
        .select()
        .order('sort_order', ascending: true)
        .limit(6);

    return (response as List)
        .map((json) => CollectionDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductDto>> getRecommendedProducts({String? userId}) async {
    LumoLogger.debug('Fetching recommended products...');
    final query = _client
        .from('products')
        .select()
        .eq('is_available', true)
        .order('rating', ascending: false)
        .limit(10);

    final response = await query;

    return (response as List)
        .map((json) => ProductDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
