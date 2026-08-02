import '../../domain/entities/product_entity.dart';

/// Lumo — Product DTO
/// Responsible only for JSON deserialization and mapping to domain entity.
/// Domain entity never knows about JSON.
final class ProductDto {
  const ProductDto({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    required this.imageUrls,
    required this.categoryId,
    this.originalPrice,
    this.rating,
    this.reviewCount = 0,
    this.isAvailable = true,
    this.isFeatured = false,
    this.tags = const [],
    this.description,
    this.benefits = const [],
    this.specs = const {},
    this.keyFeatures = const [],
    this.stockCount,
  });

  final String id;
  final String title;
  final String brand;
  final double price;
  final double? originalPrice;
  final List<String> imageUrls;
  final String categoryId;
  final double? rating;
  final int reviewCount;
  final bool isAvailable;
  final bool isFeatured;
  final List<String> tags;
  final String? description;
  final List<String> benefits;
  final Map<String, String> specs;
  final List<String> keyFeatures;
  final int? stockCount;

  factory ProductDto.fromJson(Map<String, dynamic> json) => ProductDto(
        id: json['id'] as String,
        title: json['title'] as String,
        brand: json['brand'] as String? ?? '',
        price: (json['price'] as num).toDouble(),
        originalPrice: json['original_price'] != null
            ? (json['original_price'] as num).toDouble()
            : null,
        imageUrls: (json['image_urls'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        categoryId: json['category_id'] as String? ?? '',
        rating: json['rating'] != null
            ? (json['rating'] as num).toDouble()
            : null,
        reviewCount: json['review_count'] as int? ?? 0,
        isAvailable: json['is_available'] as bool? ?? true,
        isFeatured: json['is_featured'] as bool? ?? false,
        tags: (json['tags'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        description: json['description'] as String?,
        benefits: (json['benefits'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        specs: (json['specs'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, v.toString()),
            ) ??
            {},
        keyFeatures: (json['key_features'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        stockCount: json['stock_count'] as int?,
      );

  ProductEntity toEntity() => ProductEntity(
        id: id,
        title: title,
        brand: brand,
        price: price,
        originalPrice: originalPrice,
        imageUrls: imageUrls,
        categoryId: categoryId,
        rating: rating,
        reviewCount: reviewCount,
        isAvailable: isAvailable,
        isFeatured: isFeatured,
        tags: tags,
        description: description,
        benefits: benefits,
        specs: specs,
        keyFeatures: keyFeatures,
        stockCount: stockCount,
      );
}
