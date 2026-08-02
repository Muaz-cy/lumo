/// Lumo — Collection Entity
/// A curated group of products. Collections inspire, not just categorize.
final class CollectionEntity {
  const CollectionEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.productIds,
    this.accentColor,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final List<String> productIds;
  final int? accentColor;
}
