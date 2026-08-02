import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/widgets/lumo_skeleton.dart';
import '../domain/entities/review_entity.dart';
import '../providers/reviews_providers.dart';

/// Lumo Reviews Screen
/// Emotional purpose: Build trust through authentic voices.
/// Reviews are social proof — they should feel human, not clinical.
class ReviewsScreen extends ConsumerWidget {
  const ReviewsScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(
      productReviewsProvider(productId: productId),
    );
    final breakdownAsync = ref.watch(
      ratingBreakdownProvider(productId: productId),
    );
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Reviews',
          style: LumoTypography.titleLarge.copyWith(color: colors.onSurface),
        ),
        centerTitle: true,
      ),
      body: reviewsAsync.when(
        loading: () => const _ReviewsSkeleton(),
        error: (_, __) => const _ReviewsError(),
        data: (reviews) => reviews.isEmpty
            ? const _EmptyReviews()
            : _ReviewsContent(
                reviews: reviews,
                breakdownAsync: breakdownAsync,
                productId: productId,
              ),
      ),
    );
  }
}

// ─── Main content ─────────────────────────────────────────────────────────────

class _ReviewsContent extends StatelessWidget {
  const _ReviewsContent({
    required this.reviews,
    required this.breakdownAsync,
    required this.productId,
  });

  final List<ReviewEntity> reviews;
  final AsyncValue<RatingBreakdown?> breakdownAsync;
  final String productId;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Breakdown + AI summary
        SliverToBoxAdapter(
          child: breakdownAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(LumoSpacing.space24),
              child: LumoSkeleton(width: double.infinity, height: 180),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (breakdown) => breakdown == null
                ? const SizedBox.shrink()
                : _RatingBreakdownCard(breakdown: breakdown),
          ),
        ),

        // Review count header
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space24,
            LumoSpacing.space8,
            LumoSpacing.space24,
            LumoSpacing.space4,
          ),
          sliver: SliverToBoxAdapter(
            child: Text(
              '${reviews.length} review${reviews.length == 1 ? '' : 's'}',
              style: LumoTypography.titleMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),

        // Reviews list
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space24,
            LumoSpacing.space8,
            LumoSpacing.space24,
            LumoSpacing.space80,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _ReviewCard(
                review: reviews[i],
                index: i,
              ),
              childCount: reviews.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Rating breakdown card ────────────────────────────────────────────────────

class _RatingBreakdownCard extends StatelessWidget {
  const _RatingBreakdownCard({required this.breakdown});
  final RatingBreakdown breakdown;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space16,
        LumoSpacing.space24,
        LumoSpacing.space8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score + bars
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Big score
              Column(
                children: [
                  Text(
                    breakdown.average.toStringAsFixed(1),
                    style: LumoTypography.displayLarge.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _StarRow(rating: breakdown.average, size: 16),
                  const SizedBox(height: LumoSpacing.space4),
                  Text(
                    '${breakdown.totalCount} reviews',
                    style: LumoTypography.bodySmall.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: LumoSpacing.space24),
              // Distribution bars
              Expanded(
                child: Column(
                  children: [5, 4, 3, 2, 1].map((star) {
                    final pct = breakdown.percentFor(star);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: LumoSpacing.space4),
                      child: Row(
                        children: [
                          Text(
                            '$star',
                            style: LumoTypography.labelSmall.copyWith(
                              color: colors.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(width: LumoSpacing.space8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: LumoRadius.borderPill,
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 6,
                                backgroundColor: colors.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation(
                                  colors.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter),

          // AI summary
          if (breakdown.aiSummary != null) ...[
            const SizedBox(height: LumoSpacing.space20),
            Container(
              padding: const EdgeInsets.all(LumoSpacing.space16),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: LumoRadius.borderLarge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 14,
                        color: colors.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: LumoSpacing.space8),
                      Text(
                        'AI Summary',
                        style: LumoTypography.labelSmall.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.5),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: LumoSpacing.space8),
                  Text(
                    breakdown.aiSummary!,
                    style: LumoTypography.bodyMedium.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.75),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(
                  delay: 100.ms,
                  duration: LumoMotion.normal,
                  curve: LumoMotion.enter,
                )
                .slideY(begin: 0.05, end: 0),
          ],
        ],
      ),
    );
  }
}

// ─── Review card ──────────────────────────────────────────────────────────────

class _ReviewCard extends ConsumerWidget {
  const _ReviewCard({required this.review, required this.index});
  final ReviewEntity review;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final isVoted = ref.watch(
      helpfulVotesProvider.select((s) => s.contains(review.id)),
    );
    final displayCount =
        review.helpfulCount + (isVoted ? 1 : 0);

    return Padding(
      padding: const EdgeInsets.only(bottom: LumoSpacing.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              _Avatar(review: review),
              const SizedBox(width: LumoSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.authorName,
                          style: LumoTypography.labelLarge.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        if (review.isVerifiedPurchase) ...[
                          const SizedBox(width: LumoSpacing.space8),
                          _VerifiedBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: LumoSpacing.space2),
                    Row(
                      children: [
                        _StarRow(rating: review.rating, size: 12),
                        const SizedBox(width: LumoSpacing.space8),
                        Text(
                          _formatDate(review.createdAt),
                          style: LumoTypography.bodySmall.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: LumoSpacing.space12),

          // Title
          if (review.title != null) ...[
            Text(
              review.title!,
              style: LumoTypography.titleMedium.copyWith(
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: LumoSpacing.space4),
          ],

          // Body
          Text(
            review.body,
            style: LumoTypography.bodyMedium.copyWith(
              color: colors.onSurface.withValues(alpha: 0.7),
              height: 1.6,
            ),
          ),

          // Images
          if (review.imageUrls.isNotEmpty) ...[
            const SizedBox(height: LumoSpacing.space12),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.imageUrls.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: LumoSpacing.space8),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: LumoRadius.borderMedium,
                  child: CachedNetworkImage(
                    imageUrl: review.imageUrls[i],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 80,
                      height: 80,
                      color: colors.surfaceContainerHighest,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: colors.surfaceContainerHighest,
                    ),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: LumoSpacing.space12),

          // Helpful
          GestureDetector(
            onTap: () =>
                ref.read(helpfulVotesProvider.notifier).toggle(review.id),
            child: AnimatedContainer(
              duration: LumoMotion.fast,
              curve: LumoMotion.snap,
              padding: const EdgeInsets.symmetric(
                horizontal: LumoSpacing.space12,
                vertical: LumoSpacing.space4,
              ),
              decoration: BoxDecoration(
                color: isVoted
                    ? colors.primaryContainer
                    : colors.surfaceContainerHighest,
                borderRadius: LumoRadius.borderPill,
                border: Border.all(
                  color: isVoted ? colors.primary : colors.outline,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isVoted
                        ? Icons.thumb_up_rounded
                        : Icons.thumb_up_outlined,
                    size: 14,
                    color: isVoted
                        ? colors.primary
                        : colors.onSurface.withValues(alpha: 0.45),
                  ),
                  const SizedBox(width: LumoSpacing.space4),
                  Text(
                    'Helpful ($displayCount)',
                    style: LumoTypography.labelSmall.copyWith(
                      color: isVoted
                          ? colors.primary
                          : colors.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: LumoSpacing.space24),
          Divider(height: 1, color: colors.outline),
        ],
      ),
    )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideY(begin: 0.05, end: 0);
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays < 1) return 'Today';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({required this.review});
  final ReviewEntity review;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.primaryContainer,
      ),
      clipBehavior: Clip.antiAlias,
      child: review.authorAvatarUrl != null
          ? CachedNetworkImage(
              imageUrl: review.authorAvatarUrl!,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => _Initials(
                initials: review.initials,
                colors: colors,
              ),
            )
          : _Initials(initials: review.initials, colors: colors),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.initials, required this.colors});
  final String initials;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: LumoTypography.labelMedium.copyWith(
          color: colors.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LumoSpacing.space4,
        vertical: LumoSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: LumoColors.lightSuccess.withValues(alpha: 0.1),
        borderRadius: LumoRadius.borderPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            size: 10,
            color: LumoColors.lightSuccess,
          ),
          const SizedBox(width: LumoSpacing.space4),
          Text(
            'Verified',
            style: LumoTypography.labelSmall.copyWith(
              color: LumoColors.lightSuccess,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating, required this.size});
  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final half = !filled && i < rating;
        return Icon(
          filled
              ? Icons.star_rounded
              : half
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
          size: size,
          color: LumoColors.lightRating,
        );
      }),
    );
  }
}

// ─── Empty / Error / Skeleton ─────────────────────────────────────────────────

class _EmptyReviews extends StatelessWidget {
  const _EmptyReviews();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LumoSpacing.space48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 48,
              color: colors.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: LumoSpacing.space24),
            Text(
              'No reviews yet',
              style: LumoTypography.titleMedium.copyWith(
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: LumoSpacing.space8),
            Text(
              'Be the first to share your experience.',
              style: LumoTypography.bodyMedium.copyWith(
                color: colors.onSurface.withValues(alpha: 0.45),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewsSkeleton extends StatelessWidget {
  const _ReviewsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(LumoSpacing.space24),
      children: [
        const LumoSkeleton(width: double.infinity, height: 180),
        const SizedBox(height: LumoSpacing.space24),
        ...List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: LumoSpacing.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    LumoSkeleton(
                      width: 40,
                      height: 40,
                      borderRadius: LumoRadius.borderPill,
                    ),
                    SizedBox(width: LumoSpacing.space12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LumoSkeleton(width: 120, height: 14),
                        SizedBox(height: LumoSpacing.space4),
                        LumoSkeleton(width: 80, height: 12),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: LumoSpacing.space12),
                LumoSkeleton(width: double.infinity, height: 14),
                SizedBox(height: LumoSpacing.space4),
                LumoSkeleton(width: double.infinity, height: 14),
                SizedBox(height: LumoSpacing.space4),
                LumoSkeleton(width: 200, height: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewsError extends StatelessWidget {
  const _ReviewsError();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Could not load reviews.',
        style: LumoTypography.bodyMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
