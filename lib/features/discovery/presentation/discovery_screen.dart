import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/widgets/lumo_skeleton.dart';
import '../domain/entities/editorial_card_entity.dart';
import '../providers/discovery_providers.dart';

/// Lumo Discovery Screen
/// Emotional purpose: Inspire. Make users feel like they're reading a magazine,
/// not scrolling a catalogue. Every card is a story.
class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(discoveryFeedProvider);

    return Scaffold(
      body: SafeArea(
        child: feedAsync.when(
          loading: () => const _DiscoverySkeleton(),
          error: (_, __) => const _DiscoveryError(),
          data: (feed) => _DiscoveryContent(feed: feed),
        ),
      ),
    );
  }
}

class _DiscoveryContent extends StatelessWidget {
  const _DiscoveryContent({required this.feed});
  final List<EditorialCardEntity> feed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space24,
            LumoSpacing.space24,
            LumoSpacing.space24,
            LumoSpacing.space8,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discovery',
                  style: LumoTypography.headlineLarge.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: LumoSpacing.space4),
                Text(
                  'Stories worth your time.',
                  style: LumoTypography.bodyMedium.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                .slideY(begin: -0.1, end: 0),
          ),
        ),

        // Editorial feed — mixed layout
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space16,
            LumoSpacing.space16,
            LumoSpacing.space16,
            LumoSpacing.space80,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _buildCard(context, feed[i], i),
              childCount: feed.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    EditorialCardEntity card,
    int index,
  ) {
    // Pair square cards side-by-side
    if (card.size == EditorialCardSize.square) {
      final nextIndex = index + 1;
      if (nextIndex < feed.length &&
          feed[nextIndex].size == EditorialCardSize.square) {
        return Padding(
          padding: const EdgeInsets.only(bottom: LumoSpacing.space12),
          child: Row(
            children: [
              Expanded(
                child: _EditorialCard(card: card)
                    .animate(delay: (index * 80).ms)
                    .fadeIn(
                      duration: LumoMotion.normal,
                      curve: LumoMotion.enter,
                    )
                    .slideY(begin: 0.06, end: 0),
              ),
              const SizedBox(width: LumoSpacing.space12),
              Expanded(
                child: _EditorialCard(card: feed[nextIndex])
                    .animate(delay: ((index + 1) * 80).ms)
                    .fadeIn(
                      duration: LumoMotion.normal,
                      curve: LumoMotion.enter,
                    )
                    .slideY(begin: 0.06, end: 0),
              ),
            ],
          ),
        );
      }
      // Odd square — skip if already rendered as pair
      final prevIndex = index - 1;
      if (prevIndex >= 0 && feed[prevIndex].size == EditorialCardSize.square) {
        return const SizedBox.shrink();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: LumoSpacing.space12),
      child: _EditorialCard(card: card)
          .animate(delay: (index * 80).ms)
          .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
          .slideY(begin: 0.06, end: 0),
    );
  }
}

class _EditorialCard extends StatelessWidget {
  const _EditorialCard({required this.card});
  final EditorialCardEntity card;

  double get _aspectRatio => switch (card.size) {
        EditorialCardSize.hero => 0.75,
        EditorialCardSize.wide => 1.4,
        EditorialCardSize.square => 0.85,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.actionRoute != null
          ? () => context.push(card.actionRoute!)
          : null,
      child: ClipRRect(
        borderRadius: LumoRadius.borderXL,
        child: AspectRatio(
          aspectRatio: _aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              CachedNetworkImage(
                imageUrl: card.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                ),
              ),

              // Gradient
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.72),
                    ],
                    stops: const [0.35, 1.0],
                  ),
                ),
              ),

              // Content
              Positioned(
                left: LumoSpacing.space20,
                right: LumoSpacing.space20,
                bottom: LumoSpacing.space20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (card.tag != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: LumoSpacing.space8,
                          vertical: LumoSpacing.space4,
                        ),
                        decoration: BoxDecoration(
                          color: LumoColors.white.withValues(alpha: 0.2),
                          borderRadius: LumoRadius.borderPill,
                          border: Border.all(
                            color: LumoColors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          card.tag!.toUpperCase(),
                          style: LumoTypography.labelSmall.copyWith(
                            color: LumoColors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: LumoSpacing.space12),
                    ],
                    Text(
                      card.headline,
                      style: _headlineStyle(card.size),
                    ),
                    const SizedBox(height: LumoSpacing.space8),
                    Text(
                      card.subheadline,
                      style: LumoTypography.bodySmall.copyWith(
                        color: LumoColors.white.withValues(alpha: 0.75),
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (card.actionLabel != null) ...[
                      const SizedBox(height: LumoSpacing.space16),
                      _ActionButton(label: card.actionLabel!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _headlineStyle(EditorialCardSize size) {
    return switch (size) {
      EditorialCardSize.hero => LumoTypography.headlineLarge.copyWith(
          color: LumoColors.white,
        ),
      EditorialCardSize.wide => LumoTypography.headlineSmall.copyWith(
          color: LumoColors.white,
        ),
      EditorialCardSize.square => LumoTypography.titleLarge.copyWith(
          color: LumoColors.white,
        ),
    };
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LumoSpacing.space16,
        vertical: LumoSpacing.space8,
      ),
      decoration: BoxDecoration(
        color: LumoColors.white,
        borderRadius: LumoRadius.borderPill,
      ),
      child: Text(
        label,
        style: LumoTypography.labelMedium.copyWith(
          color: LumoColors.black,
        ),
      ),
    );
  }
}

class _DiscoverySkeleton extends StatelessWidget {
  const _DiscoverySkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(LumoSpacing.space16),
      children: [
        LumoSkeleton(
          width: double.infinity,
          height: 420,
          borderRadius: LumoRadius.borderXL,
        ),
        const SizedBox(height: LumoSpacing.space12),
        LumoSkeleton(
          width: double.infinity,
          height: 220,
          borderRadius: LumoRadius.borderXL,
        ),
        const SizedBox(height: LumoSpacing.space12),
        Row(
          children: [
            Expanded(
              child: LumoSkeleton(
                width: double.infinity,
                height: 200,
                borderRadius: LumoRadius.borderXL,
              ),
            ),
            const SizedBox(width: LumoSpacing.space12),
            Expanded(
              child: LumoSkeleton(
                width: double.infinity,
                height: 200,
                borderRadius: LumoRadius.borderXL,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DiscoveryError extends StatelessWidget {
  const _DiscoveryError();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Text(
        'Could not load discovery feed.',
        style: LumoTypography.bodyMedium.copyWith(
          color: colors.onSurface.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
