import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/design_system/design_system.dart';
import '../../../shared/widgets/lumo_skeleton.dart';
import '../domain/entities/order_entity.dart';
import '../providers/orders_providers.dart';

/// Lumo Orders Screen
/// Orders should feel alive. Users should always know where their purchase is.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersListProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'My Orders',
          style: LumoTypography.titleLarge.copyWith(color: colors.onSurface),
        ),
        centerTitle: true,
      ),
      body: ordersAsync.when(
        loading: () => const _OrdersListSkeleton(),
        error: (_, __) => const _OrdersError(),
        data: (orders) => orders.isEmpty
            ? const _EmptyOrders()
            : _OrdersList(orders: orders),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Orders list
// ─────────────────────────────────────────────

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.orders});
  final List<OrderEntity> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space16,
        LumoSpacing.space24,
        LumoSpacing.space40,
      ),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: LumoSpacing.space12),
      itemBuilder: (_, i) => _OrderCard(order: orders[i], index: i),
    );
  }
}

// ─────────────────────────────────────────────
// Order card
// ─────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.index});
  final OrderEntity order;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/orders/${order.id}'),
      child: Container(
        padding: const EdgeInsets.all(LumoSpacing.space16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: LumoRadius.borderLarge,
          border: Border.all(color: colors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Text(
                  order.displayId,
                  style: LumoTypography.labelLarge.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                const Spacer(),
                _StatusChip(status: order.status),
              ],
            ),

            const SizedBox(height: LumoSpacing.space12),

            // Item images strip
            _ItemImagesStrip(items: order.items),

            const SizedBox(height: LumoSpacing.space12),

            Divider(height: 1, color: colors.outline),

            const SizedBox(height: LumoSpacing.space12),

            // Footer row
            Row(
              children: [
                Text(
                  '${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'} · \$${order.total.toStringAsFixed(2)}',
                  style: LumoTypography.bodyMedium.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: colors.onSurface.withValues(alpha: 0.3),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideY(begin: 0.05, end: 0);
  }
}

// ─────────────────────────────────────────────
// Item images strip
// ─────────────────────────────────────────────

class _ItemImagesStrip extends StatelessWidget {
  const _ItemImagesStrip({required this.items});
  final List<OrderItemEntity> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final visible = items.take(4).toList();
    final overflow = items.length - 4;

    return Row(
      children: [
        ...visible.map(
          (item) => Padding(
            padding: const EdgeInsets.only(right: LumoSpacing.space8),
            child: ClipRRect(
              borderRadius: LumoRadius.borderSmall,
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 52,
                  height: 52,
                  color: colors.secondaryContainer,
                  child: Icon(
                    Icons.image_outlined,
                    size: 18,
                    color: colors.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (overflow > 0)
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: LumoRadius.borderSmall,
            ),
            child: Center(
              child: Text(
                '+$overflow',
                style: LumoTypography.labelMedium.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Status chip
// ─────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final OrderStatus status;

  Color _bgColor(ColorScheme colors) => switch (status) {
        OrderStatus.delivered => LumoColors.lightSuccess.withValues(alpha: 0.1),
        OrderStatus.cancelled ||
        OrderStatus.returned =>
          LumoColors.lightError.withValues(alpha: 0.1),
        OrderStatus.shipped ||
        OrderStatus.outForDelivery =>
          colors.primaryContainer,
        _ => colors.secondaryContainer,
      };

  Color _textColor(ColorScheme colors) => switch (status) {
        OrderStatus.delivered => LumoColors.lightSuccess,
        OrderStatus.cancelled || OrderStatus.returned => LumoColors.lightError,
        OrderStatus.shipped ||
        OrderStatus.outForDelivery =>
          colors.onSurface,
        _ => colors.onSurface.withValues(alpha: 0.6),
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LumoSpacing.space12,
        vertical: LumoSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: _bgColor(colors),
        borderRadius: LumoRadius.borderPill,
      ),
      child: Text(
        status.label,
        style: LumoTypography.labelSmall.copyWith(
          color: _textColor(colors),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

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
              Icons.receipt_long_outlined,
              size: 64,
              color: colors.onSurface.withValues(alpha: 0.15),
            ),
            const SizedBox(height: LumoSpacing.space24),
            Text(
              'No orders yet',
              style: LumoTypography.headlineSmall.copyWith(
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: LumoSpacing.space12),
            Text(
              'Your orders will appear here\nonce you make a purchase.',
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
                'Start shopping',
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
    );
  }
}

// ─────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────

class _OrdersError extends StatelessWidget {
  const _OrdersError();

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
              'Could not load orders.',
              style: LumoTypography.titleMedium.copyWith(
                color: colors.onSurface,
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

class _OrdersListSkeleton extends StatelessWidget {
  const _OrdersListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space16,
        LumoSpacing.space24,
        LumoSpacing.space40,
      ),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: LumoSpacing.space12),
      itemBuilder: (_, __) => const LumoSkeleton(
        width: double.infinity,
        height: 140,
        borderRadius: LumoRadius.borderLarge,
      ),
    );
  }
}
