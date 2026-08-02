import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumo/core/router/app_router.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/widgets/lumo_collection_card.dart';
import 'package:lumo/shared/widgets/lumo_hero_card.dart';
import 'package:lumo/shared/widgets/lumo_product_card.dart';
import 'package:lumo/shared/widgets/lumo_search_bar.dart';
import 'package:lumo/shared/widgets/lumo_section_header.dart';
import 'package:lumo/shared/widgets/lumo_skeleton.dart';
import 'package:lumo/features/home/domain/entities/home_section.dart';
import 'package:lumo/features/home/providers/home_providers.dart';
import 'package:go_router/go_router.dart';

/// Lumo Home Screen
/// The soul of Lumo. The first screen determines whether users stay.
/// An editorial experience — not a catalogue.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: homeState.when(
          loading: () => const HomeScreenSkeleton(),
          error: (error, _) => _HomeError(
            onRetry: () => ref.read(homeNotifierProvider.notifier).refresh(),
          ),
          data: (sections) => _HomeContent(sections: sections),
        ),
      ),
    );
  }
}

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
          // Top bar — greeting + cart icon
          SliverToBoxAdapter(child: _HomeTopBar()),

          // Search bar
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: LumoSpacing.space24,
            ),
            sliver: SliverToBoxAdapter(
              child: LumoSearchBar(
                onTap: () => context.push(LumoRoutes.search),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: LumoSpacing.space32),
          ),

          // Sections
          ...sections.map((section) => _sectionSliver(context, section)),

          const SliverToBoxAdapter(
            child: SizedBox(height: LumoSpacing.space80),
          ),
        ],
      ),
    );
  }

  Widget _sectionSliver(BuildContext context, HomeSection section) {
    return switch (section) {
      HeroSection(:final product) => SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: LumoSpacing.space24,
          ),
          sliver: SliverToBoxAdapter(
            child: LumoHeroCard(
              product: product,
              onTap: () => context.push('/product/${product.id}'),
            ).animate().fadeIn(
                  duration: LumoMotion.deliberate,
                  curve: LumoMotion.enter,
                ),
          ),
        ),

      CollectionsSection(:final collections) => SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: LumoSpacing.space32),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LumoSpacing.space24,
                ),
                child: LumoSectionHeader(
                  title: 'Collections',
                  actionLabel: 'See all',
                  onAction: () => context.push(LumoRoutes.categories),
                ),
              ),
              const SizedBox(height: LumoSpacing.space16),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: LumoSpacing.space24,
                  ),
                  itemCount: collections.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: LumoSpacing.space12),
                  itemBuilder: (_, i) => LumoCollectionCard(
                    collection: collections[i],
                    onTap: () {},
                  )
                      .animate(delay: (i * 80).ms)
                      .fadeIn(
                        duration: LumoMotion.normal,
                        curve: LumoMotion.enter,
                      )
                      .slideX(begin: 0.2, end: 0),
                ),
              ),
            ],
          ),
        ),

      TrendingSection(:final products) => SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: LumoSpacing.space32),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LumoSpacing.space24,
                ),
                child: LumoSectionHeader(
                  title: 'Trending',
                  actionLabel: 'See all',
                  onAction: () => context.push(LumoRoutes.discovery),
                ),
              ),
              const SizedBox(height: LumoSpacing.space16),
              SizedBox(
                height: 300,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: LumoSpacing.space24,
                  ),
                  itemCount: products.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: LumoSpacing.space16),
                  itemBuilder: (_, i) => LumoProductCard(
                    product: products[i],
                    onTap: () =>
                        context.push('/product/${products[i].id}'),
                  )
                      .animate(delay: (i * 60).ms)
                      .fadeIn(
                        duration: LumoMotion.normal,
                        curve: LumoMotion.enter,
                      ),
                ),
              ),
            ],
          ),
        ),

      EditorialBreakSection(:final headline, :final subheadline) =>
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space24,
            LumoSpacing.space32,
            LumoSpacing.space24,
            0,
          ),
          sliver: SliverToBoxAdapter(
            child: _EditorialBreak(
              headline: headline,
              subheadline: subheadline,
            ),
          ),
        ),

      RecommendedSection(:final products) => SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: LumoSpacing.space32),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LumoSpacing.space24,
                ),
                child: const LumoSectionHeader(title: 'For you'),
              ),
              const SizedBox(height: LumoSpacing.space16),
              SizedBox(
                height: 300,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: LumoSpacing.space24,
                  ),
                  itemCount: products.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: LumoSpacing.space16),
                  itemBuilder: (_, i) => LumoProductCard(
                    product: products[i],
                    onTap: () =>
                        context.push('/product/${products[i].id}'),
                  ),
                ),
              ),
            ],
          ),
        ),
    };
  }
}

class _HomeTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space24,
        LumoSpacing.space24,
        LumoSpacing.space16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning',
                  style: LumoTypography.bodyMedium.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: LumoSpacing.space4),
                Text(
                  'Discover today.',
                  style: LumoTypography.headlineMedium.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(
                  duration: LumoMotion.normal,
                  curve: LumoMotion.enter,
                )
                .slideY(begin: -0.2, end: 0),
          ),
        ],
      ),
    );
  }
}

class _EditorialBreak extends StatelessWidget {
  const _EditorialBreak({
    required this.headline,
    required this.subheadline,
  });

  final String headline;
  final String subheadline;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(LumoSpacing.space32),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: LumoRadius.borderXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headline,
            style: LumoTypography.headlineMedium.copyWith(
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: LumoSpacing.space8),
          Text(
            subheadline,
            style: LumoTypography.bodyMedium.copyWith(
              color: colors.onPrimaryContainer.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideY(begin: 0.1, end: 0);
  }
}

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
            Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: colors.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: LumoSpacing.space24),
            Text(
              'Something went wrong.',
              style: LumoTypography.titleMedium.copyWith(
                color: colors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: LumoSpacing.space8),
            Text(
              'Check your connection and try again.',
              style: LumoTypography.bodyMedium.copyWith(
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: LumoSpacing.space32),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
