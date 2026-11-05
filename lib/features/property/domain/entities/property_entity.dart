/// Lumo — Property Entity
/// Pure domain model for Ethiopian real estate listings.
final class PropertyEntity {
  const PropertyEntity({
    required this.id,
    required this.title,
    required this.titleAm,
    required this.priceEtb,
    required this.imageUrls,
    required this.neighborhood,
    required this.city,
    required this.propertyType,
    required this.purpose,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqm,
    this.descriptionEn,
    this.descriptionAm,
    this.isVerified = false,
    this.isFeatured = false,
    this.latitude,
    this.longitude,
    this.brokerName,
    this.brokerAvatarUrl,
    this.amenities = const [],
  });

  final String id;
  final String title;
  final String titleAm;
  final double priceEtb;
  final List<String> imageUrls;
  final String neighborhood;
  final String city;
  final PropertyType propertyType;
  final ListingPurpose purpose;
  final int bedrooms;
  final int bathrooms;
  final double areaSqm;
  final String? descriptionEn;
  final String? descriptionAm;
  final bool isVerified;
  final bool isFeatured;
  final double? latitude;
  final double? longitude;
  final String? brokerName;
  final String? brokerAvatarUrl;
  final List<String> amenities;

  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';

  double priceUsd(double etbPerUsd) => priceEtb / etbPerUsd;

  String get bedroomLabel => bedrooms == 0 ? 'Studio' : '$bedrooms bed';

  /// Returns the localized title. Falls back to English if Amharic is empty.
  String localizedTitle(String languageCode) {
    if (languageCode == 'am' && titleAm.isNotEmpty) return titleAm;
    return title;
  }

  /// Returns the localized description. Falls back to English if unavailable.
  String? localizedDescription(String languageCode) {
    if (languageCode == 'am' && descriptionAm != null && descriptionAm!.isNotEmpty) {
      return descriptionAm;
    }
    return descriptionEn;
  }

  factory PropertyEntity.fromDb(Map<String, dynamic> row) {
    final media = (row['property_media'] as List<dynamic>? ?? [])
        .map((m) => m['url'] as String)
        .toList();
    return PropertyEntity(
      id: row['id'] as String,
      title: row['title'] as String? ?? '',
      titleAm: row['title_am'] as String? ?? '',
      priceEtb: (row['price_etb'] as num).toDouble(),
      imageUrls: media,
      neighborhood: row['neighborhood'] as String? ?? '',
      city: row['city'] as String? ?? 'Addis Ababa',
      propertyType: PropertyTypeX.fromDb(row['property_type'] as String?),
      purpose: ListingPurposeX.fromDb(row['purpose'] as String?),
      bedrooms: row['bedrooms'] as int? ?? 0,
      bathrooms: row['bathrooms'] as int? ?? 1,
      areaSqm: (row['area_sqm'] as num?)?.toDouble() ?? 0,
      descriptionEn: row['description_en'] as String?,
      descriptionAm: row['description_am'] as String?,
      isVerified: row['is_verified'] as bool? ?? false,
      isFeatured: row['is_featured'] as bool? ?? false,
      latitude: (row['latitude'] as num?)?.toDouble(),
      longitude: (row['longitude'] as num?)?.toDouble(),
      brokerName: row['profiles']?['display_name'] as String?,
      brokerAvatarUrl: row['profiles']?['avatar_url'] as String?,
      amenities: (row['amenities'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}

enum PropertyType { apartment, villa, house, land, commercial, office }

extension PropertyTypeX on PropertyType {
  static PropertyType fromDb(String? v) => switch (v) {
        'villa' => PropertyType.villa,
        'house' => PropertyType.house,
        'land' => PropertyType.land,
        'commercial' => PropertyType.commercial,
        'office' => PropertyType.office,
        _ => PropertyType.apartment,
      };
}

enum ListingPurpose { sale, rent }

extension ListingPurposeX on ListingPurpose {
  static ListingPurpose fromDb(String? v) =>
      v == 'rent' ? ListingPurpose.rent : ListingPurpose.sale;
}
