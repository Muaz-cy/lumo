/// Lumo — Broker Profile Entity
/// Represents a verified broker partner on the platform.
final class BrokerProfileEntity {
  const BrokerProfileEntity({
    required this.id,
    required this.userId,
    required this.agencyName,
    required this.phone,
    required this.createdAt,
    this.bio,
    this.avatarUrl,
    this.isVerified = false,
    this.totalListings = 0,
    this.approvedListings = 0,
  });

  final String id;
  final String userId;
  final String agencyName;
  final String phone;
  final DateTime createdAt;
  final String? bio;
  final String? avatarUrl;
  final bool isVerified;
  final int totalListings;
  final int approvedListings;
}
