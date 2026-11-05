/// Lumo — Inquiry Entity
/// Represents a buyer's inquiry about a property.
/// Stored in-memory now. Persisted to Supabase `inquiries` table in Phase 5.
final class InquiryEntity {
  const InquiryEntity({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyImage,
    required this.message,
    required this.submittedAt,
    this.status = InquiryStatus.pending,
  });

  final String id;
  final String propertyId;
  final String propertyTitle;
  final String propertyImage;
  final String message;
  final DateTime submittedAt;
  final InquiryStatus status;
}

enum InquiryStatus { pending, responded, closed }
