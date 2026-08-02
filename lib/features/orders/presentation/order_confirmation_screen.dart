import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/design_system/design_system.dart';
import '../../../core/router/app_router.dart';

/// Lumo Order Confirmation Screen
/// The signature moment after purchase.
/// Celebrate subtly. Explain what happens next. Offer useful next actions.
/// Premium products whisper. They never shout.
class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _checkController;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: LumoMotion.deliberate,
    );

    // Gentle haptic — meaningful, not dramatic
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        HapticFeedback.mediumImpact();
        _checkController.forward();
      }
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Check mark — the quiet celebration
              _AnimatedCheckmark(controller: _checkController),

              const SizedBox(height: LumoSpacing.space40),

              // Headline
              Text(
                'Order placed.',
                style: LumoTypography.headlineLarge.copyWith(
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(
                    delay: 600.ms,
                    duration: LumoMotion.deliberate,
                    curve: LumoMotion.enter,
                  )
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: LumoSpacing.space16),

              // Subheadline
              Text(
                'Thank you for your order.\nWe\'ll send you a confirmation shortly.',
                style: LumoTypography.bodyLarge.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.55),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(
                    delay: 750.ms,
                    duration: LumoMotion.deliberate,
                    curve: LumoMotion.enter,
                  ),

              const SizedBox(height: LumoSpacing.space32),

              // Order ID chip
              _OrderIdChip(orderId: widget.orderId),

              const SizedBox(height: LumoSpacing.space48),

              // What happens next
              _WhatHappensNext(),

              const Spacer(flex: 3),

              // Actions
              _ConfirmationActions(),

              const SizedBox(height: LumoSpacing.space32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated checkmark — the quiet celebration
// ─────────────────────────────────────────────

class _AnimatedCheckmark extends StatelessWidget {
  const _AnimatedCheckmark({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: controller,
        curve: LumoMotion.snap,
      ),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: LumoColors.lightSuccess.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: controller,
              curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
            ),
            child: Icon(
              Icons.check_rounded,
              size: 36,
              color: LumoColors.lightSuccess,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Order ID chip
// ─────────────────────────────────────────────

class _OrderIdChip extends StatelessWidget {
  const _OrderIdChip({required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Show a clean short reference — not the full raw ID
    final displayId = orderId.length > 16
        ? '#${orderId.substring(orderId.length - 8).toUpperCase()}'
        : '#${orderId.toUpperCase()}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LumoSpacing.space20,
        vertical: LumoSpacing.space12,
      ),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: LumoRadius.borderPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Order ',
            style: LumoTypography.bodyMedium.copyWith(
              color: colors.onSurface.withValues(alpha: 0.5),
            ),
          ),
          Text(
            displayId,
            style: LumoTypography.labelLarge.copyWith(
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: 900.ms,
          duration: LumoMotion.normal,
          curve: LumoMotion.enter,
        )
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
        );
  }
}

// ─────────────────────────────────────────────
// What happens next — reduces post-purchase anxiety
// ─────────────────────────────────────────────

class _WhatHappensNext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    const steps = [
      (icon: Icons.mark_email_read_outlined, label: 'Confirmation email sent'),
      (icon: Icons.inventory_2_outlined, label: 'Order being prepared'),
      (icon: Icons.local_shipping_outlined, label: 'Shipped within 1–2 days'),
    ];

    return Column(
      children: steps.indexed
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: LumoSpacing.space16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.secondaryContainer,
                      borderRadius: LumoRadius.borderMedium,
                    ),
                    child: Icon(
                      entry.$2.icon,
                      size: 18,
                      color: colors.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: LumoSpacing.space16),
                  Text(
                    entry.$2.label,
                    style: LumoTypography.bodyMedium.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 1000 + entry.$1 * 100),
                    duration: LumoMotion.normal,
                    curve: LumoMotion.enter,
                  )
                  .slideX(begin: 0.05, end: 0),
            ),
          )
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────
// Actions
// ─────────────────────────────────────────────

class _ConfirmationActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        FilledButton(
          onPressed: () => context.go(LumoRoutes.orders),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape: const RoundedRectangleBorder(
              borderRadius: LumoRadius.borderMedium,
            ),
          ),
          child: Text(
            'Track my order',
            style: LumoTypography.labelLarge.copyWith(
              color: colors.onPrimary,
            ),
          ),
        )
            .animate()
            .fadeIn(
              delay: 1300.ms,
              duration: LumoMotion.normal,
              curve: LumoMotion.enter,
            )
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: LumoSpacing.space12),

        TextButton(
          onPressed: () => context.go(LumoRoutes.home),
          child: Text(
            'Continue shopping',
            style: LumoTypography.labelLarge.copyWith(
              color: colors.onSurface.withValues(alpha: 0.45),
            ),
          ),
        )
            .animate()
            .fadeIn(
              delay: 1400.ms,
              duration: LumoMotion.normal,
              curve: LumoMotion.enter,
            ),
      ],
    );
  }
}
