import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lumo/core/router/app_router.dart';
import 'package:lumo/features/broker/domain/entities/broker_listing_entity.dart';
import 'package:lumo/features/broker/providers/broker_providers.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/widgets/lumo_skeleton.dart';

class BrokerListingsScreen extends ConsumerWidget {
  const BrokerListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(brokerListingsProvider);

    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      body: listingsAsync.when(
        loading: () => const _Skeleton(),
        error: (e, _) => _Error(message: e.toString()),
        data: (listings) => listings.isEmpty
            ? const _Empty()
            : _Content(listings: listings),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Content
// ─────────────────────────────────────────────

class _Content extends StatelessWidget {
  const _Content({required this.listings});
  final List<BrokerListingEntity> listings;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: LumoColors.lightBackground,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              Text('My Listings',
                  style: LumoTypography.titleLarge
                      .copyWith(color: colors.onSurface)),
              Text(
                '${listings.length} submission${listings.length == 1 ? '' : 's'}',
                style: LumoTypography.bodySmall.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space24, LumoSpacing.space8,
            LumoSpacing.space24, LumoSpacing.space80,
          ),
          sliver: SliverList.separated(
            itemCount: listings.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: LumoSpacing.space12),
            itemBuilder: (_, i) =>
                _ListingCard(listing: listings[i], index: i),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Listing card
// ─────────────────────────────────────────────

class _ListingCard extends StatelessWidget {
  const _ListingCard({required this.listing, required this.index});
  final BrokerListingEntity listing;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fmt = NumberFormat('#,##0');
    final dateFmt = DateFormat('MMM d, yyyy');

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: LumoRadius.borderLarge,
        border: Border.all(color: LumoColors.lightBorder),
        boxShadow: LumoShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main info row
          Padding(
            padding: const EdgeInsets.all(LumoSpacing.space16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.title,
                        style: LumoTypography.titleMedium
                            .copyWith(color: colors.onSurface),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: LumoSpacing.space6),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 13,
                              color:
                                  colors.onSurface.withValues(alpha: 0.4)),
                          const SizedBox(width: 3),
                          Text(
                            '${listing.neighborhood}, ${listing.city}',
                            style: LumoTypography.bodySmall.copyWith(
                              color:
                                  colors.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: LumoSpacing.space6),
                      Text(
                        'ETB ${fmt.format(listing.priceEtb)}',
                        style: LumoTypography.labelLarge
                            .copyWith(color: LumoColors.lightGold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: LumoSpacing.space12),
                _StatusBadge(status: listing.status),
              ],
            ),
          ),

          // Meta row
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LumoSpacing.space16, 0,
              LumoSpacing.space16, LumoSpacing.space12,
            ),
            child: Row(
              children: [
                Icon(Icons.bed_outlined,
                    size: 14,
                    color: colors.onSurface.withValues(alpha: 0.35)),
                const SizedBox(width: 4),
                Text(
                  listing.bedrooms == 0
                      ? 'Studio'
                      : '${listing.bedrooms} bed',
                  style: LumoTypography.labelSmall.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(width: LumoSpacing.space12),
                Icon(Icons.straighten_rounded,
                    size: 14,
                    color: colors.onSurface.withValues(alpha: 0.35)),
                const SizedBox(width: 4),
                Text(
                  '${listing.areaSqm.toInt()} m²',
                  style: LumoTypography.labelSmall.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                const Spacer(),
                Text(
                  'Submitted ${dateFmt.format(listing.submittedAt)}',
                  style: LumoTypography.labelSmall.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),

          // Review note — only shown on rejection
          if (listing.status == BrokerListingStatus.rejected &&
              listing.reviewNote != null) ...[
            Divider(height: 1, color: LumoColors.lightDivider),
            Padding(
              padding: const EdgeInsets.all(LumoSpacing.space14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .error
                          .withValues(alpha: 0.7)),
                  const SizedBox(width: LumoSpacing.space8),
                  Expanded(
                    child: Text(
                      listing.reviewNote!,
                      style: LumoTypography.bodySmall.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .error
                            .withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    )
        .animate(delay: (index * 55).ms)
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideY(begin: 0.05, end: 0);
  }
}

// ─────────────────────────────────────────────
// Status badge
// ─────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final BrokerListingStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      BrokerListingStatus.draft => LumoColors.lightTextSecondary,
      BrokerListingStatus.pendingReview ||
      BrokerListingStatus.underReview =>
        LumoColors.lightGold,
      BrokerListingStatus.approved => LumoColors.lightVerified,
      BrokerListingStatus.rejected =>
        Theme.of(context).colorScheme.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: LumoSpacing.space8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: LumoRadius.borderPill,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.label,
        style:
            LumoTypography.labelSmall.copyWith(color: color, fontSize: 10),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Empty / Skeleton / Error
// ─────────────────────────────────────────────

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(LumoSpacing.space48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home_work_outlined,
                  size: 64,
                  color: LumoColors.lightGold.withValues(alpha: 0.3)),
              const SizedBox(height: LumoSpacing.space24),
              Text('No listings yet',
                  style: LumoTypography.headlineSmall
                      .copyWith(color: colors.onSurface)),
              const SizedBox(height: LumoSpacing.space12),
              Text(
                'Your submitted properties will appear here.',
                style: LumoTypography.bodyMedium.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: LumoSpacing.space40),
              SizedBox(
                width: 220,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go(LumoRoutes.brokerSubmit),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LumoColors.lightGold,
                    foregroundColor: LumoColors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: LumoRadius.borderMedium),
                  ),
                  child: const Text('Submit your first listing'),
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(
                  duration: LumoMotion.deliberate, curve: LumoMotion.enter)
              .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1)),
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(LumoSpacing.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LumoSkeleton(width: 140, height: 28),
            const SizedBox(height: LumoSpacing.space24),
            ...List.generate(
              3,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: LumoSpacing.space12),
                child: LumoSkeleton(
                  width: double.infinity,
                  height: 110,
                  borderRadius: LumoRadius.borderLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LumoSpacing.space48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded,
                size: 48,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2)),
            const SizedBox(height: LumoSpacing.space20),
            Text('Could not load listings.',
                style: LumoTypography.bodyMedium.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.45),
                )),
          ],
        ),
      ),
    );
  }
}
