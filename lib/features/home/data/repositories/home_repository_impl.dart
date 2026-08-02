import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/logging/lumo_logger.dart';
import '../../../home/domain/entities/home_section.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

/// Lumo — Home Repository Implementation
/// Assembles typed HomeSection list from data sources.
/// Converts all exceptions into typed LumoFailures.
final class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._dataSource);

  final HomeRemoteDataSource _dataSource;

  @override
  Future<Either<LumoFailure, List<HomeSection>>> getHomeSections() async {
    try {
      final featured = await _dataSource.getFeaturedProducts();
      final collections = await _dataSource.getCollections();
      final trending = await _dataSource.getTrendingProducts();
      final recommended = await _dataSource.getRecommendedProducts();

      final sections = <HomeSection>[];

      // Hero — first featured product
      if (featured.isNotEmpty) {
        sections.add(HeroSection(product: featured.first.toEntity()));
      }

      // Collections
      if (collections.isNotEmpty) {
        sections.add(CollectionsSection(
          collections: collections.map((c) => c.toEntity()).toList(),
        ));
      }

      // Trending
      if (trending.isNotEmpty) {
        sections.add(TrendingSection(
          products: trending.map((p) => p.toEntity()).toList(),
        ));
      }

      // Editorial break
      sections.add(const EditorialBreakSection(
        headline: 'Discover differently.',
        subheadline: 'Curated for the way you live.',
        imageUrl: '',
      ));

      // Recommended
      if (recommended.isNotEmpty) {
        sections.add(RecommendedSection(
          products: recommended.map((p) => p.toEntity()).toList(),
        ));
      }

      return Right(sections);
    } on AuthException catch (e) {
      LumoLogger.error('Auth error loading home', e);
      return const Left(AuthenticationFailure());
    } on PostgrestException catch (e) {
      LumoLogger.error('Supabase error loading home', e);
      return Left(ServerFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Unknown error loading home', e, st);
      return const Left(UnknownFailure());
    }
  }
}
