import '../../../property/domain/entities/property_entity.dart';

sealed class HomeSection {
  const HomeSection();
}

final class FeaturedSection extends HomeSection {
  const FeaturedSection({required this.properties});
  final List<PropertyEntity> properties;
}

final class NeighborhoodSection extends HomeSection {
  const NeighborhoodSection({required this.neighborhoods});
  final List<NeighborhoodItem> neighborhoods;
}

final class ForSaleSection extends HomeSection {
  const ForSaleSection({required this.properties});
  final List<PropertyEntity> properties;
}

final class ForRentSection extends HomeSection {
  const ForRentSection({required this.properties});
  final List<PropertyEntity> properties;
}

class NeighborhoodItem {
  const NeighborhoodItem({
    required this.name,
    required this.nameAm,
    required this.city,
    required this.listingCount,
    this.imageUrl,
  });
  final String name;
  final String nameAm;
  final String city;
  final int listingCount;
  final String? imageUrl;
}
