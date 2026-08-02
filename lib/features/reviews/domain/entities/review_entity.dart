/// Lumo — Review Entity
final class ReviewEntity {
  const ReviewEntity({
    required this.id,
    required this.productId,
    required this.authorName,
    required this.rating,
    required this.body,
    required this.createdAt,
    this.title,
    this.imageUrls = const [],
    this.helpfulCount = 0,
    this.isVerifiedPurchase = false,
    this.authorAvatarUrl,
  });

  final String id;
  final String productId;
  final String authorName;
  final double rating;
  final String? title;
  final String body;
  final List<String> imageUrls;
  final int helpfulCount;
  final bool isVerifiedPurchase;
  final DateTime createdAt;
  final String? authorAvatarUrl;

  String get initials {
    final parts = authorName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return authorName.isNotEmpty ? authorName[0].toUpperCase() : '?';
  }
}

/// Aggregated rating breakdown for a product.
final class RatingBreakdown {
  const RatingBreakdown({
    required this.average,
    required this.totalCount,
    required this.distribution,
    this.aiSummary,
  });

  /// average rating 0–5
  final double average;
  final int totalCount;

  /// Map of star (1–5) → count
  final Map<int, int> distribution;

  /// AI-generated summary of all reviews.
  final String? aiSummary;

  double percentFor(int star) {
    if (totalCount == 0) return 0;
    return (distribution[star] ?? 0) / totalCount;
  }
}
