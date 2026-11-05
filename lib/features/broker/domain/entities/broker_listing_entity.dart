/// Lumo — Broker Listing Entity
/// A property submitted by a broker. Goes through Lumo's review pipeline
/// before becoming a public listing. Never auto-published.
final class BrokerListingEntity {
  const BrokerListingEntity({
    required this.id,
    required this.brokerId,
    required this.title,
    required this.titleAm,
    required this.priceEtb,
    required this.neighborhood,
    required this.city,
    required this.propertyType,
    required this.purpose,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqm,
    required this.status,
    required this.submittedAt,
    this.descriptionEn,
    this.descriptionAm,
    this.imageUrls = const [],
    this.amenities = const [],
    this.latitude,
    this.longitude,
    this.reviewNote,
    this.reviewedAt,
  });

  final String id;
  final String brokerId;
  final String title;
  final String titleAm;
  final double priceEtb;
  final String neighborhood;
  final String city;
  final String propertyType;
  final String purpose;
  final int bedrooms;
  final int bathrooms;
  final double areaSqm;
  final BrokerListingStatus status;
  final DateTime submittedAt;
  final String? descriptionEn;
  final String? descriptionAm;
  final List<String> imageUrls;
  final List<String> amenities;
  final double? latitude;
  final double? longitude;

  /// Note left by the Lumo review team — visible to broker on rejection.
  final String? reviewNote;
  final DateTime? reviewedAt;

  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';
}

enum BrokerListingStatus {
  draft,
  pendingReview,
  underReview,
  approved,
  rejected,
}

extension BrokerListingStatusX on BrokerListingStatus {
  String get label => switch (this) {
        BrokerListingStatus.draft => 'Draft',
        BrokerListingStatus.pendingReview => 'Pending Review',
        BrokerListingStatus.underReview => 'Under Review',
        BrokerListingStatus.approved => 'Approved',
        BrokerListingStatus.rejected => 'Rejected',
      };

  /// Maps to the Supabase `listing_status` enum value.
  String get dbValue => switch (this) {
        BrokerListingStatus.draft => 'draft',
        BrokerListingStatus.pendingReview => 'pending_review',
        BrokerListingStatus.underReview => 'under_review',
        BrokerListingStatus.approved => 'approved',
        BrokerListingStatus.rejected => 'rejected',
      };

  static BrokerListingStatus fromDb(String value) => switch (value) {
        'draft' => BrokerListingStatus.draft,
        'pending_review' => BrokerListingStatus.pendingReview,
        'under_review' => BrokerListingStatus.underReview,
        'approved' => BrokerListingStatus.approved,
        'rejected' => BrokerListingStatus.rejected,
        _ => BrokerListingStatus.draft,
      };
}
