import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/review_entity.dart';

part 'reviews_providers.g.dart';

// ─── Reviews list ─────────────────────────────────────────────────────────────

@riverpod
Future<List<ReviewEntity>> productReviews(
  Ref ref, {
  required String productId,
}) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return _mockReviews
      .where((r) => r.productId == productId)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

// ─── Rating breakdown ─────────────────────────────────────────────────────────

@riverpod
Future<RatingBreakdown?> ratingBreakdown(
  Ref ref, {
  required String productId,
}) async {
  final reviews = await ref.watch(
    productReviewsProvider(productId: productId).future,
  );
  if (reviews.isEmpty) return null;

  final total = reviews.length;
  final avg = reviews.map((r) => r.rating).reduce((a, b) => a + b) / total;
  final dist = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  for (final r in reviews) {
    final star = r.rating.round().clamp(1, 5);
    dist[star] = (dist[star] ?? 0) + 1;
  }

  return RatingBreakdown(
    average: avg,
    totalCount: total,
    distribution: dist,
    aiSummary:
        'Customers love the premium quality and minimalist design. '
        'The fit is consistently praised as true-to-size. '
        'A few noted the price point, but agree it reflects the craftsmanship.',
  );
}

// ─── Helpful votes ────────────────────────────────────────────────────────────

@riverpod
class HelpfulVotes extends _$HelpfulVotes {
  @override
  Set<String> build() => {};

  void toggle(String reviewId) {
    if (state.contains(reviewId)) {
      state = {...state}..remove(reviewId);
    } else {
      state = {...state, reviewId};
    }
  }

  bool isVoted(String reviewId) => state.contains(reviewId);
}

// ─── Mock data ────────────────────────────────────────────────────────────────

final _mockReviews = [
  ReviewEntity(
    id: 'r1',
    productId: 'p1',
    authorName: 'James Whitfield',
    rating: 5,
    title: 'Worth every penny',
    body:
        'I\'ve owned a lot of merino wool pieces and this is genuinely the best. '
        'The weight is perfect — not too heavy, not too thin. Wears beautifully '
        'after 6 months of regular use with zero pilling.',
    imageUrls: [
      'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
    ],
    helpfulCount: 24,
    isVerifiedPurchase: true,
    createdAt: DateTime.now().subtract(const Duration(days: 12)),
  ),
  ReviewEntity(
    id: 'r2',
    productId: 'p1',
    authorName: 'Sofia Andersson',
    rating: 4,
    title: 'Great quality, runs slightly large',
    body:
        'The fabric is incredibly soft and the construction is excellent. '
        'I\'d recommend sizing down if you\'re between sizes. '
        'The colour is exactly as shown — a true off-white.',
    helpfulCount: 18,
    isVerifiedPurchase: true,
    createdAt: DateTime.now().subtract(const Duration(days: 28)),
  ),
  ReviewEntity(
    id: 'r3',
    productId: 'p1',
    authorName: 'Marcus Chen',
    rating: 5,
    title: 'My new everyday staple',
    body:
        'Bought this on a whim and it\'s become my most-worn piece. '
        'Pairs with everything. The minimalist design is exactly what I was looking for.',
    helpfulCount: 11,
    isVerifiedPurchase: true,
    createdAt: DateTime.now().subtract(const Duration(days: 45)),
  ),
  ReviewEntity(
    id: 'r4',
    productId: 'p1',
    authorName: 'Priya Nair',
    rating: 4,
    body:
        'Really happy with this purchase. The quality is evident the moment '
        'you hold it. Shipping was fast and packaging was minimal and thoughtful.',
    helpfulCount: 7,
    isVerifiedPurchase: false,
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
  ),
  ReviewEntity(
    id: 'r5',
    productId: 'p1',
    authorName: 'Tom Eriksen',
    rating: 3,
    title: 'Good but not perfect',
    body:
        'The quality is there but I expected a slightly heavier weight for the price. '
        'Still a solid piece — just manage your expectations.',
    helpfulCount: 5,
    isVerifiedPurchase: true,
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
  ),
  // Reviews for other products
  ReviewEntity(
    id: 'r6',
    productId: 'p3',
    authorName: 'Alex Morgan',
    rating: 5,
    title: 'The only wallet you\'ll ever need',
    body:
        'Slim, well-made, and holds everything I need. '
        'The leather has aged beautifully over 8 months.',
    helpfulCount: 32,
    isVerifiedPurchase: true,
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
  ),
  ReviewEntity(
    id: 'r7',
    productId: 'p3',
    authorName: 'Nina Patel',
    rating: 5,
    body: 'Gifted this to my partner and he loves it. Excellent quality.',
    helpfulCount: 14,
    isVerifiedPurchase: true,
    createdAt: DateTime.now().subtract(const Duration(days: 22)),
  ),
];
