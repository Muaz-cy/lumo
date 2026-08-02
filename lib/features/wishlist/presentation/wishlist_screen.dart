import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:lumo/features/wishlist/providers/wishlist_providers.dart';
import 'package:lumo/shared/design_system/design_system.dart';

/// Lumo Wishlist Screen
/// People save dreams, not products.
/// This screen is a personal inspiration board — calm, beautiful, personal.
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(wishlistNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: items.isEmpty
          ? const _EmptyWishlist()
          : _WishlistContent(items: items),
    );
  }
}

// ─────────────────────────────────────────────
// Content
// ─────────────────────────────────────────────

class _WishlistContent extends StatelessWidget {
  const _WishlistContent({required this.items});
  final List<WishlistItemEntity> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: colors.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              Text(
                'Saved',
                style: LumoTypography.titleLarge
                    .copyWith(color: colors.onSurface),
              ),
              Text(
                '${items.length} ${items.length == 1 ? 'item' : 'items'}',
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
            LumoSpacing.space24,
            LumoSpacing.space8,
            LumoSpacing.space24,
            LumoSpacing.space40,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: LumoSpacing.space12,
              mainAxisSpacing: LumoSpacing.space12,
              childAspectRatio: 0.72,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) => _WishlistCard(
              item: items[i],
              index: i,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Wishlist card
// ─────────────────────────────────────────────

class _WishlistCard extends ConsumerWidget {
  const _WishlistCard({required this.item, required this.index});
  final WishlistItemEntity item;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final notifier = ref.read(wishlistNotifierProvider.notifier);

    return GestureDetector(
      onTap: () => context.push('/product/${item.productId}'),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: LumoRadius.borderLarge,
          border: Border.all(color: colors.outline, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(LumoRadius.large),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: colors.secondaryContainer,
                        child: Icon(
                          Icons.image_outlined,
                          color: colors.onSurface.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                  // Remove button
                  Positioned(
                    top: LumoSpacing.space8,
                    right: LumoSpacing.space8,
                    child: _RemoveButton(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        notifier.toggle(item);
                      },
                    ),
                  ),
                  // Discount badge
                  if (item.hasDiscount)
                    Positioned(
                      top: LumoSpacing.space8,
                      left: LumoSpacing.space8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: LumoSpacing.space8,
                          vertical: LumoSpacing.space4,
                        ),
                        decoration: BoxDecoration(
                          color: LumoColors.lightDiscount,
                          borderRadius: LumoRadius.borderSmall,
                        ),
                        child: Text(
                          '-${item.discountPercent.toStringAsFixed(0)}%',
                          style: LumoTypography.labelSmall.copyWith(
                            color: LumoColors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(LumoSpacing.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.brand.toUpperCase(),
                    style: LumoTypography.labelSmall.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.4),
                      letterSpacing: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: LumoSpacing.space4),
                  Text(
                    item.title,
                    style: LumoTypography.bodyMedium.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: LumoSpacing.space8),
                  Row(
                    children: [
                      Text(
                        '\$${item.price.toStringAsFixed(0)}',
                        style: LumoTypography.labelLarge.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      if (item.hasDiscount) ...[
                        const SizedBox(width: LumoSpacing.space8),
                        Text(
                          '\$${item.originalPrice!.toStringAsFixed(0)}',
                          style: LumoTypography.bodySmall.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.35),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: (index * 40).ms)
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1, 1),
          curve: LumoMotion.snap,
        );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: LumoColors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          boxShadow: LumoShadows.soft,
        ),
        child: const Icon(
          Icons.favorite_rounded,
          size: 16,
          color: LumoColors.lightError,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(LumoSpacing.space48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 64,
                      color: colors.onSurface.withValues(alpha: 0.15),
                    ),
                    const SizedBox(height: LumoSpacing.space24),
                    Text(
                      'Nothing saved yet',
                      style: LumoTypography.headlineSmall
                          .copyWith(color: colors.onSurface),
                    ),
                    const SizedBox(height: LumoSpacing.space12),
                    Text(
                      'Tap the heart on any product\nto save it here.',
                      style: LumoTypography.bodyMedium.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: LumoSpacing.space40),
                    FilledButton(
                      onPressed: () => context.go('/home'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(200, 52),
                        shape: const RoundedRectangleBorder(
                          borderRadius: LumoRadius.borderMedium,
                        ),
                      ),
                      child: Text(
                        'Start exploring',
                        style: LumoTypography.labelLarge
                            .copyWith(color: colors.onPrimary),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(
                        duration: LumoMotion.deliberate,
                        curve: LumoMotion.enter)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
