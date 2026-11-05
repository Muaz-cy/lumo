import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/core/router/app_router.dart';
import 'package:lumo/features/home/domain/entities/home_section.dart';
import 'package:lumo/features/home/providers/home_providers.dart';
import 'package:lumo/features/property/domain/entities/property_entity.dart';
import 'package:lumo/l10n/app_localizations.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/widgets/lumo_price_display.dart';
import 'package:lumo/shared/widgets/lumo_skeleton.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);

    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      body: SafeArea(
        child: homeState.when(
          loading: () => const _HomeSkeleton(),
          error: (e, _) => _HomeError(
            onRetry: () => ref.read(homeNotifierProvider.notifier).refresh(),
          ),
          data: (sections) => _HomeContent(sections: sections),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Content
// ─────────────────────────────────────────────

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.sections});
  final List<HomeSection> sections;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {},
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _HomeTopBar()),
          ...sections.map((s) => _sectionSliver(context, s)),
          const SliverToBoxAdapter(child: SizedBox(height: LumoSpacing.space80)),
        ],
      ),
    );
  }

  Widget _sectionSliver(BuildContext context, HomeSection section) {
    return switch (section) {
      FeaturedSection(:final properties) =>
        SliverToBoxAdapter(child: _FeaturedCarousel(properties: properties)),

      NeighborhoodSection(:final neighborhoods) =>
        SliverToBoxAdapter(child: _NeighborhoodChips(neighborhoods: neighborhoods)),

      ForSaleSection(:final properties) => SliverToBoxAdapter(
          child: _PropertyRow(
            title: 'For Sale',
            properties: properties,
          ),
        ),

      ForRentSection(:final properties) => SliverToBoxAdapter(
          child: _PropertyRow(
            title: 'For Rent',
            properties: properties,
          ),
        ),
    };
  }
}

// ─────────────────────────────────────────────
// Top bar
// ─────────────────────────────────────────────

class _HomeTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space24,
        LumoSpacing.space24,
        LumoSpacing.space8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lumo',
                  style: LumoTypography.headlineLarge.copyWith(
                    color: LumoColors.lightGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Your home, back home.',
                  style: LumoTypography.bodyMedium.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                .slideY(begin: -0.1, end: 0),
          ),
          IconButton(
            onPressed: () => context.push(LumoRoutes.notifications),
            icon: const Icon(
              Icons.notifications_outlined,
              color: LumoColors.lightGold,
            ),
          ),
          IconButton(
            onPressed: () => context.push(LumoRoutes.consultation),
            icon: Icon(
              Icons.phone_outlined,
              color: colors.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Featured carousel — hero cards
// ─────────────────────────────────────────────

class _FeaturedCarousel extends StatelessWidget {
  const _FeaturedCarousel({required this.properties});
  final List<PropertyEntity> properties;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
          child: Text(
            'Featured',
            style: LumoTypography.titleLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: LumoSpacing.space12),
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
            itemCount: properties.length,
            separatorBuilder: (_, __) => const SizedBox(width: LumoSpacing.space16),
            itemBuilder: (_, i) => _PropertyHeroCard(property: properties[i])
                .animate(delay: (i * 80).ms)
                .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                .slideX(begin: 0.1, end: 0),
          ),
        ),
      ],
    );
  }
}

class _PropertyHeroCard extends StatelessWidget {
  const _PropertyHeroCard({required this.property});
  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/property/${property.id}'),
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          borderRadius: LumoRadius.borderLarge,
          boxShadow: LumoShadows.soft,
        ),
        child: ClipRRect(
          borderRadius: LumoRadius.borderLarge,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              CachedNetworkImage(
                imageUrl: property.primaryImage,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: LumoColors.lightSurfaceSecondary),
                errorWidget: (_, __, ___) => Container(color: LumoColors.lightSurfaceSecondary),
              ),

              // Gradient overlay
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      LumoColors.lightPrimary.withValues(alpha: 0.85),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),

              // Content
              Positioned(
                left: LumoSpacing.space16,
                right: LumoSpacing.space16,
                bottom: LumoSpacing.space16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (property.isVerified)
                      Container(
                        margin: const EdgeInsets.only(bottom: LumoSpacing.space8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: LumoSpacing.space8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: LumoColors.white.withValues(alpha: 0.15),
                          borderRadius: LumoRadius.borderSmall,
                          border: Border.all(
                            color: LumoColors.white.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded, size: 10, color: LumoColors.white),
                            const SizedBox(width: 4),
                            Text(
                              AppLocalizations.of(context).propertyVerified,
                              style: LumoTypography.labelSmall.copyWith(
                                color: LumoColors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      property.localizedTitle(Localizations.localeOf(context).languageCode),
                      style: LumoTypography.titleMedium.copyWith(color: LumoColors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: LumoSpacing.space4),
                    Row(
                      children: [
                        LumoPriceDisplay(
                          priceEtb: property.priceEtb,
                          isRent: property.purpose == ListingPurpose.rent,
                          compact: true,
                          style: LumoTypography.labelLarge.copyWith(
                              color: LumoColors.lightGold),
                        ),
                      ],
                    ),
                    const SizedBox(height: LumoSpacing.space4),
                    Text(
                      '${property.bedroomLabel} · ${property.areaSqm.toInt()} m² · ${property.neighborhood}',
                      style: LumoTypography.bodySmall.copyWith(
                        color: LumoColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Neighborhood chips
// ─────────────────────────────────────────────

class _NeighborhoodChips extends StatelessWidget {
  const _NeighborhoodChips({required this.neighborhoods});
  final List<NeighborhoodItem> neighborhoods;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: LumoSpacing.space24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
          child: Text(
            'Browse by area',
            style: LumoTypography.titleLarge.copyWith(color: colors.onSurface),
          ),
        ),
        const SizedBox(height: LumoSpacing.space12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
            itemCount: neighborhoods.length,
            separatorBuilder: (_, __) => const SizedBox(width: LumoSpacing.space8),
            itemBuilder: (_, i) {
              final n = neighborhoods[i];
              return GestureDetector(
                onTap: () => context.go(
                  LumoRoutes.search,
                  extra: {'neighborhood': n.name},
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: LumoSpacing.space16,
                    vertical: LumoSpacing.space8,
                  ),
                  decoration: BoxDecoration(
                    color: LumoColors.lightSurfaceSecondary,
                    borderRadius: LumoRadius.borderPill,
                    border: Border.all(color: LumoColors.lightBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        n.name,
                        style: LumoTypography.labelMedium.copyWith(color: colors.onSurface),
                      ),
                      const SizedBox(width: LumoSpacing.space4),
                      Text(
                        '${n.listingCount}',
                        style: LumoTypography.labelSmall.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate(delay: (i * 40).ms)
                  .fadeIn(duration: LumoMotion.fast, curve: LumoMotion.enter)
                  .slideX(begin: 0.1, end: 0);
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Property row (for sale / for rent)
// ─────────────────────────────────────────────

class _PropertyRow extends StatelessWidget {
  const _PropertyRow({required this.title, required this.properties});
  final String title;
  final List<PropertyEntity> properties;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: LumoSpacing.space24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
          child: Text(
            title,
            style: LumoTypography.titleLarge.copyWith(color: colors.onSurface),
          ),
        ),
        const SizedBox(height: LumoSpacing.space12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
            itemCount: properties.length,
            separatorBuilder: (_, __) => const SizedBox(width: LumoSpacing.space12),
            itemBuilder: (_, i) => _PropertyCard(property: properties[i])
                .animate(delay: (i * 60).ms)
                .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter),
          ),
        ),
      ],
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({required this.property});
  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/property/${property.id}'),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: LumoRadius.borderLarge,
          border: Border.all(color: LumoColors.lightBorder),
          boxShadow: LumoShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(LumoRadius.large)),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: property.primaryImage,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: LumoColors.lightSurfaceSecondary),
                  errorWidget: (_, __, ___) =>
                      Container(color: LumoColors.lightSurfaceSecondary),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(LumoSpacing.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (property.isVerified)
                    Row(
                      children: [
                        const Icon(Icons.verified_rounded, size: 12, color: LumoColors.lightVerified),
                        const SizedBox(width: 3),
                        Text(
                          'Verified',
                          style: LumoTypography.labelSmall.copyWith(
                            color: LumoColors.lightVerified,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: LumoSpacing.space4),
                  LumoPriceDisplay(
                    priceEtb: property.priceEtb,
                    isRent: property.purpose == ListingPurpose.rent,
                    compact: true,
                    style: LumoTypography.labelLarge.copyWith(
                        color: LumoColors.lightGold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    property.localizedTitle(Localizations.localeOf(context).languageCode),
                    style: LumoTypography.bodySmall.copyWith(color: colors.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${property.bedroomLabel} · ${property.areaSqm.toInt()} m²',
                    style: LumoTypography.labelSmall.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Skeleton
// ─────────────────────────────────────────────

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(LumoSpacing.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LumoSkeleton(width: 80, height: 28),
          const SizedBox(height: LumoSpacing.space8),
          const LumoSkeleton(width: 160, height: 16),
          const SizedBox(height: LumoSpacing.space24),
          const LumoSkeleton(width: double.infinity, height: 48, borderRadius: LumoRadius.borderMedium),
          const SizedBox(height: LumoSpacing.space24),
          const LumoSkeleton(width: 100, height: 20),
          const SizedBox(height: LumoSpacing.space12),
          Row(
            children: [
              const LumoSkeleton(width: 260, height: 280, borderRadius: LumoRadius.borderLarge),
              const SizedBox(width: LumoSpacing.space16),
              const LumoSkeleton(width: 260, height: 280, borderRadius: LumoRadius.borderLarge),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Error
// ─────────────────────────────────────────────

class _HomeError extends StatelessWidget {
  const _HomeError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LumoSpacing.space48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: colors.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: LumoSpacing.space24),
            Text('Something went wrong.', style: LumoTypography.titleMedium),
            const SizedBox(height: LumoSpacing.space32),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
