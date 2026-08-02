/// Lumo — Category Entity
final class CategoryEntity {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.productCount,
    this.description,
    this.accentColor,
  });

  final String id;
  final String name;
  final String imageUrl;
  final int productCount;
  final String? description;

  /// Optional accent color for the category card overlay (hex string).
  final String? accentColor;
}
