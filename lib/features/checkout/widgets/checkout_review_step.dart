import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/design_system/design_system.dart';
import '../../../features/cart/providers/cart_providers.dart';
import '../domain/entities/address_entity.dart';
import '../domain/entities/checkout_state.dart';
import '../domain/entities/payment_method_entity.dart';
import '../providers/checkout_providers.dart';

/// Lumo Checkout — Review Step
/// The final moment before purchase.
/// Users must feel: safe, informed, confident.
/// Every question answered: Am I safe? What happens next?
class CheckoutReviewStep extends ConsumerWidget {
  const CheckoutReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutNotifierProvider);
    final cart = ref.watch(cartNotifierProvider);
    final colors = Theme.of(context).colorScheme;

    if (checkoutState.address == null || checkoutState.paymentMethod == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space8,
        LumoSpacing.space24,
        LumoSpacing.space40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review your order',
            style: LumoTypography.headlineSmall.copyWith(
              color: colors.onSurface,
            ),
          ).animate().fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter),

          const SizedBox(height: LumoSpacing.space8),

          Text(
            'Everything look right? Place your order below.',
            style: LumoTypography.bodyMedium.copyWith(
              color: colors.onSurface.withValues(alpha: 0.5),
            ),
          ).animate().fadeIn(
                delay: 60.ms,
                duration: LumoMotion.normal,
                curve: LumoMotion.enter,
              ),

          const SizedBox(height: LumoSpacing.space32),

          // Items
          _ReviewSection(
            title: 'Items',
            onEdit: null,
            delay: 80,
            child: Column(
              children: cart.items
                  .map((item) => _OrderItemRow(
                        imageUrl: item.imageUrl,
                        title: item.title,
                        brand: item.brand,
                        price: item.price,
                        quantity: item.quantity,
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: LumoSpacing.space16),

          // Delivery address
          _ReviewSection(
            title: 'Delivery',
            onEdit: () => ref
                .read(checkoutNotifierProvider.notifier)
                .goToStep(CheckoutStep.delivery),
            delay: 120,
            child: _AddressPreview(address: checkoutState.address!),
          ),

          const SizedBox(height: LumoSpacing.space16),

          // Payment method
          _ReviewSection(
            title: 'Payment',
            onEdit: () => ref
                .read(checkoutNotifierProvider.notifier)
                .goToStep(CheckoutStep.payment),
            delay: 160,
            child: _PaymentPreview(method: checkoutState.paymentMethod!),
          ),

          const SizedBox(height: LumoSpacing.space16),

          // Order totals
          _ReviewSection(
            title: 'Summary',
            onEdit: null,
            delay: 200,
            child: _OrderTotals(cart: cart),
          ),

          const SizedBox(height: LumoSpacing.space40),

          // Place order button
          _PlaceOrderButton(
            isLoading: checkoutState.isPlacingOrder,
            total: cart.total,
            onTap: () async {
              HapticFeedback.mediumImpact();
              final orderId = await ref
                  .read(checkoutNotifierProvider.notifier)
                  .placeOrder();
              if (orderId != null && context.mounted) {
                ref.read(cartNotifierProvider.notifier).clearCart();
                ref.read(checkoutNotifierProvider.notifier).reset();
                context.go('/order-confirmation/$orderId');
              }
            },
          ).animate().fadeIn(
                delay: 240.ms,
                duration: LumoMotion.normal,
                curve: LumoMotion.enter,
              ),

          const SizedBox(height: LumoSpacing.space16),

          // Trust note
          Center(
            child: Text(
              'Free returns within 30 days · Secure checkout',
              style: LumoTypography.bodySmall.copyWith(
                color: colors.onSurface.withValues(alpha: 0.35),
              ),
              textAlign: TextAlign.center,
            ),
          ).animate().fadeIn(
                delay: 260.ms,
                duration: LumoMotion.normal,
                curve: LumoMotion.enter,
              ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Review section container
// ─────────────────────────────────────────────

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({
    required this.title,
    required this.child,
    required this.delay,
    this.onEdit,
  });

  final String title;
  final Widget child;
  final int delay;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: LumoRadius.borderLarge,
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LumoSpacing.space16,
              LumoSpacing.space16,
              LumoSpacing.space8,
              LumoSpacing.space12,
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: LumoTypography.labelLarge.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                const Spacer(),
                if (onEdit != null)
                  GestureDetector(
                    onTap: onEdit,
                    child: Padding(
                      padding: const EdgeInsets.all(LumoSpacing.space8),
                      child: Text(
                        'Edit',
                        style: LumoTypography.labelMedium.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.outline),
          Padding(
            padding: const EdgeInsets.all(LumoSpacing.space16),
            child: child,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: delay),
          duration: LumoMotion.normal,
          curve: LumoMotion.enter,
        )
        .slideY(begin: 0.05, end: 0);
  }
}

// ─────────────────────────────────────────────
// Order item row
// ─────────────────────────────────────────────

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({
    required this.imageUrl,
    required this.title,
    required this.brand,
    required this.price,
    required this.quantity,
  });

  final String imageUrl;
  final String title;
  final String brand;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: LumoSpacing.space12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: LumoRadius.borderSmall,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: colors.secondaryContainer,
                child: Icon(
                  Icons.image_outlined,
                  size: 20,
                  color: colors.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
          const SizedBox(width: LumoSpacing.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand.toUpperCase(),
                  style: LumoTypography.labelSmall.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.4),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: LumoSpacing.space2),
                Text(
                  title,
                  style: LumoTypography.bodyMedium.copyWith(
                    color: colors.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: LumoSpacing.space12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${(price * quantity).toStringAsFixed(2)}',
                style: LumoTypography.labelLarge.copyWith(
                  color: colors.onSurface,
                ),
              ),
              Text(
                'Qty $quantity',
                style: LumoTypography.bodySmall.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Address preview
// ─────────────────────────────────────────────

class _AddressPreview extends StatelessWidget {
  const _AddressPreview({required this.address});
  final AddressEntity address;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 18,
          color: colors.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: LumoSpacing.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.fullName,
                style: LumoTypography.bodyMedium.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: LumoSpacing.space2),
              Text(
                address.displayLine1,
                style: LumoTypography.bodyMedium.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                address.displayLine2,
                style: LumoTypography.bodyMedium.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                address.country,
                style: LumoTypography.bodyMedium.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Payment preview
// ─────────────────────────────────────────────

class _PaymentPreview extends StatelessWidget {
  const _PaymentPreview({required this.method});
  final PaymentMethodEntity method;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          method.type == PaymentType.googlePay
              ? Icons.g_mobiledata_rounded
              : Icons.credit_card_rounded,
          size: 18,
          color: colors.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: LumoSpacing.space12),
        Text(
          method.displayName,
          style: LumoTypography.bodyMedium.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Order totals
// ─────────────────────────────────────────────

class _OrderTotals extends StatelessWidget {
  const _OrderTotals({required this.cart});
  final dynamic cart;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        _TotalRow(
          label: 'Subtotal',
          value: '\$${cart.subtotal.toStringAsFixed(2)}',
          colors: colors,
        ),
        if (cart.totalSavings > 0) ...[
          const SizedBox(height: LumoSpacing.space8),
          _TotalRow(
            label: 'Savings',
            value: '-\$${cart.totalSavings.toStringAsFixed(2)}',
            valueColor: LumoColors.lightSuccess,
            colors: colors,
          ),
        ],
        const SizedBox(height: LumoSpacing.space8),
        _TotalRow(
          label: 'Shipping',
          value: cart.hasFreeShipping
              ? 'Free'
              : '\$${cart.shippingCost.toStringAsFixed(2)}',
          valueColor: cart.hasFreeShipping ? LumoColors.lightSuccess : null,
          colors: colors,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: LumoSpacing.space12),
          child: Divider(height: 1, color: colors.outline),
        ),
        _TotalRow(
          label: 'Total',
          value: '\$${cart.total.toStringAsFixed(2)}',
          isTotal: true,
          colors: colors,
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    required this.colors,
    this.valueColor,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final ColorScheme colors;
  final Color? valueColor;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final style =
        isTotal ? LumoTypography.titleMedium : LumoTypography.bodyMedium;

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

// ─────────────────────────────────────────────
// Place order button — the signature moment
// ─────────────────────────────────────────────

class _PlaceOrderButton extends StatelessWidget {
  const _PlaceOrderButton({
    required this.isLoading,
    required this.total,
    required this.onTap,
  });

  final bool isLoading;
  final double total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: LumoMotion.normal,
      curve: LumoMotion.snap,
      height: 56,
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: LumoRadius.borderMedium,
      ),
      child: Material(
        color: LumoColors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: LumoRadius.borderMedium,
          child: Center(
            child: AnimatedSwitcher(
              duration: LumoMotion.fast,
              child: isLoading
                  ? SizedBox(
                      key: const ValueKey('loading'),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.onPrimary,
                      ),
                    )
                  : Text(
                      key: const ValueKey('place'),
                      'Place order · \$${total.toStringAsFixed(2)}',
                      style: LumoTypography.labelLarge.copyWith(
                        color: colors.onPrimary,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
