import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/core/router/app_router.dart';
import 'package:lumo/features/authentication/providers/auth_providers.dart';
import 'package:lumo/features/broker/domain/entities/broker_listing_entity.dart';
import 'package:lumo/features/broker/providers/broker_providers.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/widgets/lumo_skeleton.dart';

class BrokerDashboardScreen extends ConsumerWidget {
  const BrokerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final listingsAsync = ref.watch(brokerListingsProvider);

    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _Header(user: user)),
            SliverToBoxAdapter(
              child: listingsAsync.when(
                loading: () => const _StatsSkeleton(),
                error: (_, __) => const _StatsEmpty(),
                data: (listings) => _StatsRow(listings: listings),
              ),
            ),
            SliverToBoxAdapter(child: _QuickActions()),
            SliverToBoxAdapter(
              child: listingsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (listings) => listings.isEmpty
                    ? _EmptyListings()
                    : _RecentListings(listings: listings.take(3).toList()),
              ),
            ),
            const SliverToBoxAdapter(
                child: SizedBox(height: LumoSpacing.space80)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final name = user?.displayName?.isNotEmpty == true
        ? user!.displayName!.split(' ').first
        : 'there';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24, LumoSpacing.space32,
        LumoSpacing.space24, LumoSpacing.space24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: LumoSpacing.space10,
                  vertical: LumoSpacing.space4,
                ),
                decoration: BoxDecoration(
                  color: LumoColors.lightGoldContainer,
                  borderRadius: LumoRadius.borderPill,
                  border: Border.all(
                      color: LumoColors.lightGold.withValues(alpha: 0.4)),
                ),
                child: Text(
                  'BROKER',
                  style: LumoTypography.labelSmall.copyWith(
                    color: LumoColors.lightGold,
                    letterSpacing: 1.2,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: LumoSpacing.space12),
          Text(
            'Good to see you,\n$name.',
            style: LumoTypography.headlineLarge.copyWith(
              color: colors.onSurface,
              height: 1.2,
            ),
          )
              .animate()
              .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
              .slideY(begin: -0.08, end: 0),
          const SizedBox(height: LumoSpacing.space8),
          Text(
            'Manage your listings and track their review status.',
            style: LumoTypography.bodyMedium.copyWith(
              color: colors.onSurface.withValues(alpha: 0.45),
            ),
          )
              .animate()
              .fadeIn(
                  delay: 80.ms,
                  duration: LumoMotion.normal,
                  curve: LumoMotion.enter),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Stats row
// ─────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.listings});
  final List<BrokerListingEntity> listings;

  @override
  Widget build(BuildContext context) {
    final pending =
        listings.where((l) => l.status == BrokerListingStatus.pendingReview || l.status == BrokerListingStatus.underReview).length;
    final approved =
        listings.where((l) => l.status == BrokerListingStatus.approved).length;
    final rejected =
        listings.where((l) => l.status == BrokerListingStatus.rejected).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
      child: Row(
        children: [
          _StatCard(
              value: '${listings.length}',
              label: 'Total',
              color: LumoColors.lightGold),
          const SizedBox(width: LumoSpacing.space12),
          _StatCard(
              value: '$pending',
              label: 'In Review',
              color: LumoColors.lightGold.withValues(alpha: 0.7)),
          const SizedBox(width: LumoSpacing.space12),
          _StatCard(
              value: '$approved',
              label: 'Approved',
              color: LumoColors.lightVerified),
          const SizedBox(width: LumoSpacing.space12),
          _StatCard(
              value: '$rejected',
              label: 'Rejected',
              color: LumoColors.lightPrimary.withValues(alpha: 0.4)),
        ],
      ),
    )
        .animate()
        .fadeIn(
            delay: 100.ms,
            duration: LumoMotion.normal,
            curve: LumoMotion.enter)
        .slideY(begin: 0.05, end: 0);
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.value, required this.label, required this.color});
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: LumoSpacing.space16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: LumoRadius.borderLarge,
          border: Border.all(color: LumoColors.lightBorder),
          boxShadow: LumoShadows.soft,
        ),
        child: Column(
          children: [
            Text(value,
                style:
                    LumoTypography.headlineSmall.copyWith(color: color)),
            const SizedBox(height: LumoSpacing.space2),
            Text(label,
                style: LumoTypography.labelSmall.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.4),
                )),
          ],
        ),
      ),
    );
  }
}

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
      child: Row(
        children: List.generate(
          4,
          (_) => Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: LumoSpacing.space12),
              child: const LumoSkeleton(
                  width: double.infinity,
                  height: 72,
                  borderRadius: LumoRadius.borderLarge),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsEmpty extends StatelessWidget {
  const _StatsEmpty();

  @override
  Widget build(BuildContext context) => const SizedBox(height: LumoSpacing.space8);
}

// ─────────────────────────────────────────────
// Quick actions
// ─────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24, LumoSpacing.space24,
        LumoSpacing.space24, 0,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () => context.go(LumoRoutes.brokerSubmit),
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text('Submit a new listing'),
          style: ElevatedButton.styleFrom(
            backgroundColor: LumoColors.lightGold,
            foregroundColor: LumoColors.white,
            shape: RoundedRectangleBorder(
                borderRadius: LumoRadius.borderMedium),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
            delay: 150.ms,
            duration: LumoMotion.normal,
            curve: LumoMotion.enter);
  }
}

// ─────────────────────────────────────────────
// Recent listings preview
// ─────────────────────────────────────────────

class _RecentListings extends StatelessWidget {
  const _RecentListings({required this.listings});
  final List<BrokerListingEntity> listings;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24, LumoSpacing.space32,
        LumoSpacing.space24, 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent submissions',
                  style: LumoTypography.titleMedium
                      .copyWith(color: colors.onSurface)),
              GestureDetector(
                onTap: () => context.go(LumoRoutes.brokerListings),
                child: Text('See all',
                    style: LumoTypography.labelMedium
                        .copyWith(color: LumoColors.lightGold)),
              ),
            ],
          ),
          const SizedBox(height: LumoSpacing.space16),
          ...listings.asMap().entries.map(
                (e) => Padding(
                  padding:
                      const EdgeInsets.only(bottom: LumoSpacing.space12),
                  child: _ListingRow(listing: e.value, index: e.key),
                ),
              ),
        ],
      ),
    );
  }
}

class _ListingRow extends StatelessWidget {
  const _ListingRow({required this.listing, required this.index});
  final BrokerListingEntity listing;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(LumoSpacing.space14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: LumoRadius.borderLarge,
        border: Border.all(color: LumoColors.lightBorder),
        boxShadow: LumoShadows.soft,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing.title,
                    style: LumoTypography.labelLarge
                        .copyWith(color: colors.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: LumoSpacing.space4),
                Text(
                  '${listing.neighborhood} · ETB ${listing.priceEtb.toStringAsFixed(0)}',
                  style: LumoTypography.bodySmall.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: LumoSpacing.space12),
          _StatusBadge(status: listing.status),
        ],
      ),
    )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideY(begin: 0.05, end: 0);
  }
}

class _EmptyListings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24, LumoSpacing.space40,
        LumoSpacing.space24, 0,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.home_work_outlined,
                size: 48,
                color: LumoColors.lightGold.withValues(alpha: 0.3)),
            const SizedBox(height: LumoSpacing.space16),
            Text('No listings yet',
                style: LumoTypography.titleMedium
                    .copyWith(color: colors.onSurface)),
            const SizedBox(height: LumoSpacing.space8),
            Text(
              'Submit your first property to get started.',
              style: LumoTypography.bodySmall.copyWith(
                color: colors.onSurface.withValues(alpha: 0.45),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
            duration: LumoMotion.deliberate, curve: LumoMotion.enter);
  }
}

// ─────────────────────────────────────────────
// Status badge — shared across broker screens
// ─────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final BrokerListingStatus status;

  @override
  Widget build(BuildContext context) {
    final (color) = switch (status) {
      BrokerListingStatus.draft =>
        LumoColors.lightTextSecondary,
      BrokerListingStatus.pendingReview ||
      BrokerListingStatus.underReview =>
        LumoColors.lightGold,
      BrokerListingStatus.approved => LumoColors.lightVerified,
      BrokerListingStatus.rejected => Theme.of(context).colorScheme.error,
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
        style: LumoTypography.labelSmall
            .copyWith(color: color, fontSize: 10),
      ),
    );
  }
}
