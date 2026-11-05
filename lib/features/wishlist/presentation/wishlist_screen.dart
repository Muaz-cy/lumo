import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lumo/features/property/domain/entities/property_entity.dart';
import 'package:lumo/features/wishlist/providers/saved_providers.dart';
import 'package:lumo/shared/design_system/design_system.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedNotifierProvider);

    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      body: saved.isEmpty ? const _Empty() : _Content(saved: saved),
    );
  }
}

// ─────────────────────────────────────────────
// Content
// ─────────────────────────────────────────────

class _Content extends StatelessWidget {
  const _Content({required this.saved});
  final List<SavedProperty> saved;

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
              Text('Saved', style: LumoTypography.titleLarge.copyWith(color: colors.onSurface)),
              Text(
                '${saved.length} propert${saved.length == 1 ? 'y' : 'ies'}',
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
            itemCount: saved.length,
            separatorBuilder: (_, __) => const SizedBox(height: LumoSpacing.space12),
            itemBuilder: (_, i) => _SavedCard(item: saved[i], index: i),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Saved card
// ─────────────────────────────────────────────

class _SavedCard extends ConsumerWidget {
  const _SavedCard({required this.item, required this.index});
  final SavedProperty item;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final p = item.property;
    final fmt = NumberFormat.compact();

    return GestureDetector(
      onTap: () => context.push('/property/${p.id}'),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: LumoRadius.borderLarge,
          border: Border.all(color: LumoColors.lightBorder),
          boxShadow: LumoShadows.soft,
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(LumoRadius.large),
              ),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  p.primaryImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: LumoColors.lightSurfaceSecondary),
                ),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LumoSpacing.space14,
                  vertical: LumoSpacing.space12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (p.isVerified) ...[
                          const Icon(Icons.verified_rounded,
                              size: 11, color: LumoColors.lightVerified),
                          const SizedBox(width: 3),
                          Text('Verified',
                              style: LumoTypography.labelSmall.copyWith(
                                color: LumoColors.lightVerified, fontSize: 10)),
                          const SizedBox(width: LumoSpacing.space8),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: LumoSpacing.space6, vertical: 2),
                          decoration: BoxDecoration(
                            color: LumoColors.lightSurfaceSecondary,
                            borderRadius: LumoRadius.borderPill,
                          ),
                          child: Text(
                            p.purpose == ListingPurpose.sale ? 'For Sale' : 'For Rent',
                            style: LumoTypography.labelSmall.copyWith(
                              color: colors.onSurface.withValues(alpha: 0.5),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      p.title,
                      style: LumoTypography.labelLarge.copyWith(color: colors.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ETB ${fmt.format(p.priceEtb)}${p.purpose == ListingPurpose.rent ? '/mo' : ''}',
                          style: LumoTypography.labelMedium
                              .copyWith(color: LumoColors.lightGold),
                        ),
                        Text(
                          '${p.bedroomLabel} · ${p.areaSqm.toInt()} m²',
                          style: LumoTypography.labelSmall.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Remove
            Padding(
              padding: const EdgeInsets.only(right: LumoSpacing.space12),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(savedNotifierProvider.notifier).toggle(p);
                },
                child: const Icon(Icons.bookmark_rounded,
                    size: 20, color: LumoColors.lightGold),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideY(begin: 0.05, end: 0);
  }
}

// ─────────────────────────────────────────────
// Empty state
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
              Icon(Icons.bookmark_border_rounded, size: 64,
                  color: LumoColors.lightGold.withValues(alpha: 0.3)),
              const SizedBox(height: LumoSpacing.space24),
              Text('No saved properties',
                  style: LumoTypography.headlineSmall.copyWith(color: colors.onSurface)),
              const SizedBox(height: LumoSpacing.space12),
              Text(
                'Tap the bookmark on any property\nto save it here.',
                style: LumoTypography.bodyMedium.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: LumoSpacing.space40),
              SizedBox(
                width: 200,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LumoColors.lightGold,
                    foregroundColor: LumoColors.white,
                    shape: RoundedRectangleBorder(borderRadius: LumoRadius.borderMedium),
                  ),
                  child: const Text('Browse properties'),
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: LumoMotion.deliberate, curve: LumoMotion.enter)
              .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
        ),
      ),
    );
  }
}
