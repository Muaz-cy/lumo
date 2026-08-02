import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/features/cart/domain/entities/cart_item_entity.dart';
import 'package:lumo/features/cart/providers/cart_providers.dart';
import 'package:lumo/features/product/providers/product_providers.dart';
import 'package:lumo/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:lumo/shared/widgets/lumo_wishlist_button.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/widgets/lumo_image_gallery.dart';
import 'package:lumo/shared/widgets/lumo_product_card.dart';
import 'package:lumo/shared/widgets/lumo_rating_bar.dart';
import 'package:lumo/shared/widgets/lumo_skeleton.dart';
import 'package:lumo/features/product/domain/entities/product_entity.dart';

/// Lumo Product Detail Screen
/// A product page is not information. It is persuasion through clarity.
/// Beauty → Purpose → Quality → Value → Specs → Reviews → Related.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return productAsync.when(
      loading: () => const _ProductDetailSkeleton(),
      error: (e, _) => _ProductDetailError(
        onBack: () => context.pop(),
      ),
      data: (product) => _ProductDetailContent(product: product),
    );
  }
}

// ─────────────────────────────────────────────
// Main content
// ─────────────────────────────────────────────

class _ProductDetailContent extends ConsumerWidget {
  const _ProductDetailContent({required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relatedAsync = ref.watch(relatedProductsProvider(
      productId: product.id,
      categoryId: product.categoryId,
    ));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: _TransparentAppBar(product: product),
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Gallery — full bleed, no padding
              SliverToBoxAdapter(
                child: LumoImageGallery(
                  imageUrls: product.imageUrls,
                  heroTag: 'product_${product.id}',
                  height: MediaQuery.sizeOf(context).height * 0.58,
                ),
              ),

              // Product info sheet
              SliverToBoxAdapter(
                child: _ProductInfoSheet(product: product),
              ),

              // Related products
              SliverToBoxAdapter(
                child: relatedAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (related) => related.isEmpty
                      ? const SizedBox.shrink()
                      : _RelatedProductsSection(
                          products: related,
                          onProductTap: (id) =>
                              context.push('/product/$id'),
                        ),
                ),
              ),

              // Bottom padding for the sticky bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),

          // Sticky add-to-cart bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _AddToCartBar(product: product),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Transparent app bar
// ─────────────────────────────────────────────

class _TransparentAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _TransparentAppBar({required this.product});
  final ProductEntity product;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: LumoColors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: LumoSpacing.space16),
        child: _CircleIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => context.pop(),
        ),
      ),
      actions: [
        LumoWishlistButton(
          item: WishlistItemEntity(
            productId: product.id,
            title: product.title,
            brand: product.brand,
            price: product.price,
            originalPrice: product.originalPrice,
            imageUrl: product.primaryImage,
          ),
          backgrounded: true,
        ),
        const SizedBox(width: LumoSpacing.space16),
        _CircleIconButton(
          icon: Icons.share_outlined,
          onTap: () {},
        ),
        const SizedBox(width: LumoSpacing.space16),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: LumoColors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: LumoShadows.soft,
        ),
        child: Icon(icon, size: 18, color: LumoColors.black),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Product info sheet — the editorial story
// ─────────────────────────────────────────────

class _ProductInfoSheet extends StatelessWidget {
  const _ProductInfoSheet({required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(LumoRadius.xl),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: LumoSpacing.space12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outline,
                borderRadius: LumoRadius.borderPill,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              LumoSpacing.space24,
              20,
              LumoSpacing.space24,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand
                Text(
                  product.brand.toUpperCase(),
                  style: LumoTypography.labelSmall.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.45),
                    letterSpacing: 1.5,
                  ),
                ).animate().fadeIn(
                      duration: LumoMotion.normal,
                      curve: LumoMotion.enter,
                    ),

                const SizedBox(height: LumoSpacing.space8),

                // Title
                Text(
                  product.title,
                  style: LumoTypography.headlineLarge.copyWith(
                    color: colors.onSurface,
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: 80.ms,
                      duration: LumoMotion.normal,
                      curve: LumoMotion.enter,
                    )
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: LumoSpacing.space16),

                // Rating
                if (product.rating != null)
                  GestureDetector(
                    onTap: () => context.push('/reviews/${product.id}'),
                    child: LumoRatingBar(
                      rating: product.rating!,
                      reviewCount: product.reviewCount,
                    ),
                  ).animate().fadeIn(
                        delay: 120.ms,
                        duration: LumoMotion.normal,
                        curve: LumoMotion.enter,
                      ),

                const SizedBox(height: 20),

                // Price row
                _PriceRow(product: product)
                    .animate()
                    .fadeIn(
                      delay: 160.ms,
                      duration: LumoMotion.normal,
                      curve: LumoMotion.enter,
                    ),

                // Low stock — honest, never fake urgency
                if (product.isLowStock) ...[
                  const SizedBox(height: LumoSpacing.space12),
                  _LowStockBadge(count: product.stockCount!),
                ],

                const SizedBox(height: LumoSpacing.space32),

                // Key features
                if (product.keyFeatures.isNotEmpty) ...[
                  _KeyFeatures(features: product.keyFeatures),
                  const SizedBox(height: LumoSpacing.space32),
                ],

                // Description
                if (product.description != null &&
                    product.description!.isNotEmpty) ...[
                  _SectionLabel(label: 'About'),
                  const SizedBox(height: LumoSpacing.space12),
                  Text(
                    product.description!,
                    style: LumoTypography.bodyLarge.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.7),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: LumoSpacing.space32),
                ],

                // Benefits
                if (product.benefits.isNotEmpty) ...[
                  _SectionLabel(label: 'Why you\'ll love it'),
                  const SizedBox(height: LumoSpacing.space16),
                  _BenefitsList(benefits: product.benefits),
                  const SizedBox(height: LumoSpacing.space32),
                ],

                // Specs
                if (product.specs.isNotEmpty) ...[
                  _SectionLabel(label: 'Specifications'),
                  const SizedBox(height: LumoSpacing.space16),
                  _SpecsTable(specs: product.specs),
                  const SizedBox(height: LumoSpacing.space32),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sub-components
// ─────────────────────────────────────────────

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\$${product.price.toStringAsFixed(0)}',
          style: LumoTypography.headlineMedium.copyWith(
            color: colors.onSurface,
          ),
        ),
        if (product.hasDiscount) ...[
          const SizedBox(width: LumoSpacing.space12),
          Padding(
            padding: const EdgeInsets.only(bottom: LumoSpacing.space4),
            child: Text(
              '\$${product.originalPrice!.toStringAsFixed(0)}',
              style: LumoTypography.bodyLarge.copyWith(
                color: colors.onSurface.withValues(alpha: 0.35),
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
          const SizedBox(width: LumoSpacing.space8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: LumoSpacing.space8,
              vertical: LumoSpacing.space4,
            ),
            decoration: BoxDecoration(
              color: LumoColors.lightDiscount.withValues(alpha: 0.1),
              borderRadius: LumoRadius.borderSmall,
            ),
            child: Text(
              '-${product.discountPercent.toStringAsFixed(0)}%',
              style: LumoTypography.labelSmall.copyWith(
                color: LumoColors.lightDiscount,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LowStockBadge extends StatelessWidget {
  const _LowStockBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: LumoColors.lightWarning,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: LumoSpacing.space8),
        Text(
          'Only $count left in stock',
          style: LumoTypography.bodySmall.copyWith(
            color: LumoColors.lightWarning,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: LumoTypography.titleMedium.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class _KeyFeatures extends StatelessWidget {
  const _KeyFeatures({required this.features});
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Wrap(
      spacing: LumoSpacing.space8,
      runSpacing: LumoSpacing.space8,
      children: features
          .map(
            (f) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: LumoSpacing.space16,
                vertical: LumoSpacing.space8,
              ),
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                borderRadius: LumoRadius.borderPill,
              ),
              child: Text(
                f,
                style: LumoTypography.labelMedium.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _BenefitsList extends StatelessWidget {
  const _BenefitsList({required this.benefits});
  final List<String> benefits;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: benefits
          .map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: LumoSpacing.space12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: colors.onSurface,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: LumoSpacing.space16),
                  Expanded(
                    child: Text(
                      b,
                      style: LumoTypography.bodyLarge.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SpecsTable extends StatelessWidget {
  const _SpecsTable({required this.specs});
  final Map<String, String> specs;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final entries = specs.entries.toList();

    return Container(
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: LumoRadius.borderLarge,
      ),
      child: Column(
        children: List.generate(entries.length, (i) {
          final isLast = i == entries.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LumoSpacing.space16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        entries[i].key,
                        style: LumoTypography.bodyMedium.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        entries[i].value,
                        style: LumoTypography.bodyMedium.copyWith(
                          color: colors.onSurface,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: colors.outline.withValues(alpha: 0.5),
                  indent: LumoSpacing.space16,
                  endIndent: LumoSpacing.space16,
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Related products
// ─────────────────────────────────────────────

class _RelatedProductsSection extends StatelessWidget {
  const _RelatedProductsSection({
    required this.products,
    required this.onProductTap,
  });
  final List<ProductEntity> products;
  final void Function(String id) onProductTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space24,
            LumoSpacing.space8,
            LumoSpacing.space24,
            LumoSpacing.space16,
          ),
          child: Text(
            'You may also like',
            style: LumoTypography.headlineSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
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
              onTap: () => onProductTap(products[i].id),
            )
                .animate(delay: (i * 60).ms)
                .fadeIn(
                  duration: LumoMotion.normal,
                  curve: LumoMotion.enter,
                ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Sticky add-to-cart bar — the signature moment
// ─────────────────────────────────────────────

class _AddToCartBar extends ConsumerStatefulWidget {
  const _AddToCartBar({required this.product});
  final ProductEntity product;

  @override
  ConsumerState<_AddToCartBar> createState() => _AddToCartBarState();
}

class _AddToCartBarState extends ConsumerState<_AddToCartBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  bool _added = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: LumoMotion.fast,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: LumoMotion.snap),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onAddToCart() async {
    if (_added) return;
    HapticFeedback.mediumImpact();
    await _controller.forward();
    await _controller.reverse();
    ref.read(cartNotifierProvider.notifier).addItem(
          CartItemEntity(
            productId: widget.product.id,
            title: widget.product.title,
            brand: widget.product.brand,
            price: widget.product.price,
            originalPrice: widget.product.originalPrice,
            imageUrl: widget.product.primaryImage,
            quantity: 1,
          ),
        );
    setState(() => _added = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _added = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space16,
        LumoSpacing.space24,
        MediaQuery.paddingOf(context).bottom + LumoSpacing.space16,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.outline, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Quantity selector
          Container(
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: LumoRadius.borderMedium,
            ),
            child: Row(
              children: [
                _QtyButton(
                  icon: Icons.remove,
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: LumoSpacing.space12,
                  ),
                  child: Text(
                    '1',
                    style: LumoTypography.titleMedium.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ),
                _QtyButton(
                  icon: Icons.add,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(width: LumoSpacing.space12),

          // Add to cart button
          Expanded(
            child: ScaleTransition(
              scale: _scaleAnim,
              child: AnimatedContainer(
                duration: LumoMotion.normal,
                curve: LumoMotion.snap,
                height: 52,
                decoration: BoxDecoration(
                  color: _added ? LumoColors.lightSuccess : colors.primary,
                  borderRadius: LumoRadius.borderMedium,
                ),
                child: Material(
                  color: LumoColors.transparent,
                  child: InkWell(
                    onTap: widget.product.isAvailable ? _onAddToCart : null,
                    borderRadius: LumoRadius.borderMedium,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: LumoMotion.fast,
                        child: _added
                            ? Row(
                                key: const ValueKey('added'),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_rounded,
                                    color: LumoColors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: LumoSpacing.space8),
                                  Text(
                                    'Added to cart',
                                    style: LumoTypography.labelLarge.copyWith(
                                      color: LumoColors.white,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                key: const ValueKey('add'),
                                widget.product.isAvailable
                                    ? 'Add to cart'
                                    : 'Out of stock',
                                style: LumoTypography.labelLarge.copyWith(
                                  color: colors.onPrimary,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: 300.ms,
          duration: LumoMotion.normal,
          curve: LumoMotion.enter,
        )
        .slideY(begin: 0.5, end: 0);
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 48,
        child: Icon(icon, size: 18, color: colors.onSurface),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Loading skeleton
// ─────────────────────────────────────────────

class _ProductDetailSkeleton extends StatelessWidget {
  const _ProductDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Column(
        children: [
          LumoSkeleton(
            width: double.infinity,
            height: size.height * 0.58,
            borderRadius: BorderRadius.zero,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(LumoSpacing.space24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LumoSkeleton(width: 80, height: 14),
                  const SizedBox(height: LumoSpacing.space12),
                  const LumoSkeleton(width: 240, height: 32),
                  const SizedBox(height: LumoSpacing.space16),
                  const LumoSkeleton(width: 120, height: 18),
                  const SizedBox(height: LumoSpacing.space16),
                  const LumoSkeleton(width: 100, height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────

class _ProductDetailError extends StatelessWidget {
  const _ProductDetailError({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(LumoSpacing.space48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: colors.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: LumoSpacing.space24),
                Text(
                  'Product not found.',
                  style: LumoTypography.titleMedium.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: LumoSpacing.space32),
                OutlinedButton(
                  onPressed: onBack,
                  child: const Text('Go back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
