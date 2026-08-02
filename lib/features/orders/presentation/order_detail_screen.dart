import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../shared/design_system/design_system.dart';
import '../../../shared/widgets/lumo_skeleton.dart';
import '../domain/entities/order_entity.dart';
import '../providers/orders_providers.dart';

/// Lumo Order Detail Screen
/// Each order should clearly display: Status. Timeline. Tracking. Actions.
/// Users should always know where their purchase is.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId: orderId));
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
          'Order details',
          style: LumoTypography.titleLarge.copyWith(color: colors.onSurface),
        ),
        centerTitle: true,
      ),
      body: orderAsync.when(
        loading: () => const _OrderDetailSkeleton(),
        error: (_, __) => const _OrderDetailError(),
        data: (order) => order == null
            ? const _OrderDetailError()
            : _OrderDetailContent(order: order),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Content
// ─────────────────────────────────────────────

class _OrderDetailContent extends StatelessWidget {
  const _OrderDetailContent({required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space24,
            LumoSpacing.space16,
            LumoSpacing.space24,
            LumoSpacing.space40,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Status hero
              _StatusHero(order: order),

              const SizedBox(height: LumoSpacing.space24),

              // Timeline
              if (order.timeline.isNotEmpty) ...[
                _OrderSection(
                  title: 'Timeline',
                  delay: 100,
                  child: _OrderTimeline(timeline: order.timeline),
                ),
                const SizedBox(height: LumoSpacing.space16),
              ],

              // Tracking
              if (order.trackingNumber != null) ...[
                _OrderSection(
                  title: 'Tracking',
                  delay: 160,
                  child: _TrackingRow(
                    trackingNumber: order.trackingNumber!,
                    estimatedDelivery: order.estimatedDelivery,
                  ),
                ),
                const SizedBox(height: LumoSpacing.space16),
              ],

              // Items
              _OrderSection(
                title: 'Items (${order.itemCount})',
                delay: 200,
                child: Column(
                  children: order.items
                      .map((item) => _OrderItemRow(item: item))
                      .toList(),
                ),
              ),

              const SizedBox(height: LumoSpacing.space16),

              // Summary
              _OrderSection(
                title: 'Summary',
                delay: 240,
                child: _OrderSummary(order: order),
              ),

              const SizedBox(height: LumoSpacing.space16),

              // Delivery
              _OrderSection(
                title: 'Delivery address',
                delay: 280,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: LumoSpacing.space12),
                    Expanded(
                      child: Text(
                        order.deliveryAddress,
                        style: LumoTypography.bodyMedium.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: LumoSpacing.space32),

              // Actions
              _OrderActions(order: order),
            ]),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Status hero
// ─────────────────────────────────────────────

class _StatusHero extends StatelessWidget {
  const _StatusHero({required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      padding: const EdgeInsets.all(LumoSpacing.space20),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: LumoRadius.borderXL,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.displayId,
                  style: LumoTypography.labelLarge.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: LumoSpacing.space4),
                Text(
                  'Placed ${dateFormat.format(order.placedAt)}',
                  style: LumoTypography.bodySmall.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                if (order.estimatedDelivery != null &&
                    order.status.isActive) ...[
                  const SizedBox(height: LumoSpacing.space8),
                  Text(
                    'Est. delivery ${dateFormat.format(order.estimatedDelivery!)}',
                    style: LumoTypography.bodySmall.copyWith(
                      color: LumoColors.lightSuccess,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _StatusBadge(status: order.status),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideY(begin: 0.05, end: 0);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final (bg, fg) = switch (status) {
      OrderStatus.delivered => (
          LumoColors.lightSuccess.withValues(alpha: 0.12),
          LumoColors.lightSuccess
        ),
      OrderStatus.cancelled ||
      OrderStatus.returned => (
          LumoColors.lightError.withValues(alpha: 0.12),
          LumoColors.lightError
        ),
      OrderStatus.shipped ||
      OrderStatus.outForDelivery => (
          colors.primaryContainer,
          colors.onSurface
        ),
      _ => (colors.surface, colors.onSurface.withValues(alpha: 0.6)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LumoSpacing.space16,
        vertical: LumoSpacing.space8,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: LumoRadius.borderPill,
      ),
      child: Text(
        status.label,
        style: LumoTypography.labelMedium.copyWith(color: fg),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Timeline
// ─────────────────────────────────────────────

class _OrderTimeline extends StatelessWidget {
  const _OrderTimeline({required this.timeline});
  final List<OrderTimelineEvent> timeline;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final timeFormat = DateFormat('MMM d · h:mm a');

    return Column(
      children: timeline.reversed.toList().asMap().entries.map((entry) {
        final i = entry.key;
        final event = entry.value;
        final isFirst = i == 0;
        final isLast = i == timeline.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline line + dot
              SizedBox(
                width: 24,
                child: Column(
                  children: [
                    // Top line
                    if (!isFirst)
                      Expanded(
                        child: Center(
                          child: Container(
                            width: 1.5,
                            color: colors.outline,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 6),

                    // Dot
                    Container(
                      width: isFirst ? 10 : 8,
                      height: isFirst ? 10 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFirst ? colors.primary : colors.outline,
                      ),
                    ),

                    // Bottom line
                    if (!isLast)
                      Expanded(
                        child: Center(
                          child: Container(
                            width: 1.5,
                            color: colors.outline,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 6),
                  ],
                ),
              ),

              const SizedBox(width: LumoSpacing.space16),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: LumoSpacing.space8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.status.label,
                        style: LumoTypography.bodyMedium.copyWith(
                          color: isFirst
                              ? colors.onSurface
                              : colors.onSurface.withValues(alpha: 0.6),
                          fontWeight:
                              isFirst ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                      if (event.description != null) ...[
                        const SizedBox(height: LumoSpacing.space2),
                        Text(
                          event.description!,
                          style: LumoTypography.bodySmall.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.45),
                          ),
                        ),
                      ],
                      const SizedBox(height: LumoSpacing.space4),
                      Text(
                        timeFormat.format(event.timestamp),
                        style: LumoTypography.bodySmall.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
// Tracking row
// ─────────────────────────────────────────────

class _TrackingRow extends StatelessWidget {
  const _TrackingRow({
    required this.trackingNumber,
    this.estimatedDelivery,
  });

  final String trackingNumber;
  final DateTime? estimatedDelivery;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trackingNumber,
                style: LumoTypography.labelLarge.copyWith(
                  color: colors.onSurface,
                ),
              ),
              if (estimatedDelivery != null) ...[
                const SizedBox(height: LumoSpacing.space4),
                Text(
                  'Est. ${DateFormat('MMM d').format(estimatedDelivery!)}',
                  style: LumoTypography.bodySmall.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: trackingNumber));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Tracking number copied'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: colors.primary,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: LumoSpacing.space12,
              vertical: LumoSpacing.space8,
            ),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: LumoRadius.borderSmall,
            ),
            child: Text(
              'Copy',
              style: LumoTypography.labelSmall.copyWith(
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
// Order item row
// ─────────────────────────────────────────────

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});
  final OrderItemEntity item;

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
              imageUrl: item.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: colors.secondaryContainer,
              ),
            ),
          ),
          const SizedBox(width: LumoSpacing.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.brand.toUpperCase(),
                  style: LumoTypography.labelSmall.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.4),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: LumoSpacing.space2),
                Text(
                  item.title,
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
                '\$${item.subtotal.toStringAsFixed(2)}',
                style: LumoTypography.labelLarge.copyWith(
                  color: colors.onSurface,
                ),
              ),
              Text(
                'Qty ${item.quantity}',
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
// Order summary
// ─────────────────────────────────────────────

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        _SummaryRow(
          label: 'Subtotal',
          value: '\$${order.subtotal.toStringAsFixed(2)}',
          colors: colors,
        ),
        const SizedBox(height: LumoSpacing.space8),
        _SummaryRow(
          label: 'Shipping',
          value: order.shippingCost == 0
              ? 'Free'
              : '\$${order.shippingCost.toStringAsFixed(2)}',
          valueColor:
              order.shippingCost == 0 ? LumoColors.lightSuccess : null,
          colors: colors,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: LumoSpacing.space12),
          child: Divider(height: 1, color: colors.outline),
        ),
        _SummaryRow(
          label: 'Total',
          value: '\$${order.total.toStringAsFixed(2)}',
          isTotal: true,
          colors: colors,
        ),
        const SizedBox(height: LumoSpacing.space8),
        _SummaryRow(
          label: 'Payment',
          value: order.paymentSummary,
          colors: colors,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
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
          style: style.copyWith(color: valueColor ?? colors.onSurface),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Section container
// ─────────────────────────────────────────────

class _OrderSection extends StatelessWidget {
  const _OrderSection({
    required this.title,
    required this.child,
    required this.delay,
  });

  final String title;
  final Widget child;
  final int delay;

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
              LumoSpacing.space16,
              LumoSpacing.space12,
            ),
            child: Text(
              title,
              style: LumoTypography.labelLarge.copyWith(
                color: colors.onSurface,
              ),
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
        .slideY(begin: 0.04, end: 0);
  }
}

// ─────────────────────────────────────────────
// Actions
// ─────────────────────────────────────────────

class _OrderActions extends StatelessWidget {
  const _OrderActions({required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        if (order.status == OrderStatus.delivered)
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: const RoundedRectangleBorder(
                borderRadius: LumoRadius.borderMedium,
              ),
            ),
            child: Text(
              'Buy again',
              style: LumoTypography.labelLarge.copyWith(
                color: colors.onPrimary,
              ),
            ),
          ),
        if (order.status.isActive) ...[
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: const RoundedRectangleBorder(
                borderRadius: LumoRadius.borderMedium,
              ),
            ),
            child: const Text('Contact support'),
          ),
        ],
      ],
    )
        .animate()
        .fadeIn(
          delay: 320.ms,
          duration: LumoMotion.normal,
          curve: LumoMotion.enter,
        );
  }
}

// ─────────────────────────────────────────────
// Skeleton + Error
// ─────────────────────────────────────────────

class _OrderDetailSkeleton extends StatelessWidget {
  const _OrderDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(LumoSpacing.space24),
      child: Column(
        children: [
          const LumoSkeleton(
              width: double.infinity,
              height: 100,
              borderRadius: LumoRadius.borderXL),
          const SizedBox(height: LumoSpacing.space16),
          const LumoSkeleton(
              width: double.infinity,
              height: 180,
              borderRadius: LumoRadius.borderLarge),
          const SizedBox(height: LumoSpacing.space16),
          const LumoSkeleton(
              width: double.infinity,
              height: 140,
              borderRadius: LumoRadius.borderLarge),
        ],
      ),
    );
  }
}

class _OrderDetailError extends StatelessWidget {
  const _OrderDetailError();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Order not found.',
        style: LumoTypography.bodyMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
