import '../../../product/domain/entities/product_entity.dart';
import 'collection_entity.dart';

/// Lumo — Home Sections
/// Each section of the home screen is a typed value.
/// The UI renders based on type — never on string keys.
sealed class HomeSection {
  const HomeSection();
}

final class HeroSection extends HomeSection {
  const HeroSection({required this.product});
  final ProductEntity product;
}

final class CollectionsSection extends HomeSection {
  const CollectionsSection({required this.collections});
  final List<CollectionEntity> collections;
}

final class TrendingSection extends HomeSection {
  const TrendingSection({required this.products});
  final List<ProductEntity> products;
}

final class RecommendedSection extends HomeSection {
  const RecommendedSection({required this.products});
  final List<ProductEntity> products;
}

final class EditorialBreakSection extends HomeSection {
  const EditorialBreakSection({
    required this.headline,
    required this.subheadline,
    required this.imageUrl,
  });
  final String headline;
  final String subheadline;
  final String imageUrl;
}
