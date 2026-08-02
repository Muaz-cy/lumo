/// Lumo — Search Result Entity
/// Wraps a product result with search-specific metadata.
final class SearchResultEntity {
  const SearchResultEntity({
    required this.productId,
    required this.title,
    required this.brand,
    required this.price,
    required this.imageUrl,
    this.originalPrice,
    this.rating,
    this.categoryId = '',
  });

  final String productId;
  final String title;
  final String brand;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final double? rating;
  final String categoryId;

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  double get discountPercent =>
      hasDiscount ? ((originalPrice! - price) / originalPrice! * 100) : 0;
}
