import '../../domain/entities/collection_entity.dart';

/// Lumo — Collection DTO
final class CollectionDto {
  const CollectionDto({
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

  factory CollectionDto.fromJson(Map<String, dynamic> json) => CollectionDto(
        id: json['id'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String? ?? '',
        imageUrl: json['image_url'] as String? ?? '',
        productIds: (json['product_ids'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        accentColor: json['accent_color'] as int?,
      );

  CollectionEntity toEntity() => CollectionEntity(
        id: id,
        title: title,
        subtitle: subtitle,
        imageUrl: imageUrl,
        productIds: productIds,
        accentColor: accentColor,
      );
}
