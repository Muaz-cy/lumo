import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/features/cart/domain/entities/cart_item_entity.dart';
import 'package:lumo/features/cart/providers/cart_providers.dart';
import 'package:lumo/shared/design_system/design_system.dart';

/// Lumo Cart Screen
/// The cart is not a receipt. It is a decision space.
/// Users should feel confident, informed, and never pressured.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartNotifierProvider);

    if (cart.isEmpty) return const _EmptyCart();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _CartAppBar(itemCount: cart.itemCount),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LumoSpacing.space24,
                ),
                sliver: SliverList.separated(
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: LumoSpacing.space16),
                  itemBuilder: (_, i) => _CartItemCard(
                    item: cart.items[i],
                    index: i,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _OrderSummary(cart: cart),
              ),
              // Bottom padding for sticky bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _CheckoutBar(total: cart.total),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// App bar
// ─────────────────────────────────────────────

class _CartAppBar extends StatelessWidget {
  const _CartAppBar({required this.itemCount});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SliverAppBar(
      pinned: true,
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          Text(
            'My Cart',
            style: LumoTypography.titleLarge.copyWith(
              color: colors.onSurface,
            ),
          ),
          Text(
            '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
            style: LumoTypography.bodySmall.copyWith(
              color: colors.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }
}

// ─────────────────────────────────────────────
// Cart item card
// ─────────────────────────────────────────────

class _CartItemCard extends ConsumerWidget {
  const _CartItemCard({required this.item, required this.index});
  final CartItemEntity item;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final notifier = ref.read(cartNotifierProvider.notifier);

    return Dismissible(
      key: ValueKey(item.productId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        notifier.removeItem(item.productId);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: LumoSpacing.space24),
        decoration: BoxDecoration(
          color: LumoColors.lightError.withValues(alpha: 0.1),
          borderRadius: LumoRadius.borderLarge,
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: LumoColors.lightError,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(LumoSpacing.space16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: LumoRadius.borderLarge,
          border: Border.all(color: colors.outline, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: LumoRadius.borderMedium,
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 88,
                  height: 88,
                  color: colors.secondaryContainer,
                  child: Icon(
                    Icons.image_outlined,
                    color: colors.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),

            const SizedBox(width: LumoSpacing.space16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.brand.toUpperCase(),
                    style: LumoTypography.labelSmall.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.4),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: LumoSpacing.space4),
                  Text(
                    item.title,
                    style: LumoTypography.titleMedium.copyWith(
                      color: colors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: LumoSpacing.space12),
                  Row(
                    children: [
                      // Price
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${item.price.toStringAsFixed(0)}',
                              style: LumoTypography.titleMedium.copyWith(
                                color: colors.onSurface,
                              ),
                            ),
                            if (item.hasDiscount)
                              Text(
                                '\$${item.originalPrice!.toStringAsFixed(0)}',
                                style: LumoTypography.bodySmall.copyWith(
                                  color:
                                      colors.onSurface.withValues(alpha: 0.35),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Quantity stepper
                      _QuantityStepper(
                        quantity: item.quantity,
                        onDecrement: () => notifier.updateQuantity(
                          item.productId,
                          item.quantity - 1,
                        ),
                        onIncrement: () => notifier.updateQuantity(
                          item.productId,
                          item.quantity + 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideX(begin: 0.05, end: 0);
  }
}

// ─────────────────────────────────────────────
// Quantity stepper
// ─────────────────────────────────────────────

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: LumoRadius.borderMedium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: quantity == 1
                ? Icons.delete_outline_rounded
                : Icons.remove_rounded,
            onTap: () {
              HapticFeedback.selectionClick();
              onDecrement();
            },
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$quantity',
              style: LumoTypography.titleMedium.copyWith(
                color: colors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            onTap: () {
              HapticFeedback.selectionClick();
              onIncrement();
            },
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Order summary
// ─────────────────────────────────────────────

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.cart});
  final dynamic cart;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space32,
        LumoSpacing.space24,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: LumoTypography.titleMedium.copyWith(
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: LumoSpacing.space16),
          Container(
            padding: const EdgeInsets.all(LumoSpacing.space20),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: LumoRadius.borderLarge,
            ),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'Subtotal',
                  value: '\$${cart.subtotal.toStringAsFixed(2)}',
                ),
                if (cart.totalSavings > 0) ...[
                  const SizedBox(height: LumoSpacing.space12),
                  _SummaryRow(
                    label: 'Savings',
                    value: '-\$${cart.totalSavings.toStringAsFixed(2)}',
                    valueColor: LumoColors.lightSuccess,
                  ),
                ],
                const SizedBox(height: LumoSpacing.space12),
                _SummaryRow(
                  label: 'Shipping',
                  value: cart.hasFreeShipping
                      ? 'Free'
                      : '\$${cart.shippingCost.toStringAsFixed(2)}',
                  valueColor:
                      cart.hasFreeShipping ? LumoColors.lightSuccess : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: LumoSpacing.space16,
                  ),
                  child: Divider(
                    height: 1,
                    color: colors.outline.withValues(alpha: 0.5),
                  ),
                ),
                _SummaryRow(
                  label: 'Total',
                  value: '\$${cart.total.toStringAsFixed(2)}',
                  isTotal: true,
                ),
                if (!cart.hasFreeShipping) ...[
                  const SizedBox(height: LumoSpacing.space12),
                  _FreeShippingProgress(subtotal: cart.subtotal),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          delay: 200.ms,
          duration: LumoMotion.normal,
          curve: LumoMotion.enter,
        );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = isTotal
        ? LumoTypography.titleMedium
        : LumoTypography.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: style.copyWith(
            color: isTotal
                ? colors.onSurface
                : colors.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: style.copyWith(
            color: valueColor ?? colors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _FreeShippingProgress extends StatelessWidget {
  const _FreeShippingProgress({required this.subtotal});
  final double subtotal;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final remaining = (75.0 - subtotal).clamp(0.0, 75.0);
    final progress = (subtotal / 75.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: LumoRadius.borderPill,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: colors.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation(colors.primary),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: LumoSpacing.space8),
        Text(
          'Add \$${remaining.toStringAsFixed(2)} more for free shipping',
          style: LumoTypography.bodySmall.copyWith(
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Sticky checkout bar
// ─────────────────────────────────────────────

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.total});
  final double total;

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
        border: Border(top: BorderSide(color: colors.outline, width: 1)),
      ),
      child: FilledButton(
        onPressed: () => context.push('/checkout'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: const RoundedRectangleBorder(
            borderRadius: LumoRadius.borderMedium,
          ),
        ),
        child: Text(
          'Checkout · \$${total.toStringAsFixed(2)}',
          style: LumoTypography.labelLarge.copyWith(
            color: colors.onPrimary,
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideY(begin: 0.5, end: 0);
  }
}

// ─────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'My Cart',
          style: LumoTypography.titleLarge.copyWith(color: colors.onSurface),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(LumoSpacing.space48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: colors.onSurface.withValues(alpha: 0.15),
              ),
              const SizedBox(height: LumoSpacing.space24),
              Text(
                'Your cart is empty',
                style: LumoTypography.headlineSmall.copyWith(
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: LumoSpacing.space12),
              Text(
                'Discover something you\'ll love.',
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
                  style: LumoTypography.labelLarge.copyWith(
                    color: colors.onPrimary,
                  ),
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
