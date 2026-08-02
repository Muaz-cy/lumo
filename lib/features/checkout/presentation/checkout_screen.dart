import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/design_system/design_system.dart';
import '../domain/entities/checkout_state.dart';
import '../providers/checkout_providers.dart';
import '../widgets/checkout_delivery_step.dart';
import '../widgets/checkout_payment_step.dart';
import '../widgets/checkout_progress_bar.dart';
import '../widgets/checkout_review_step.dart';

/// Lumo Checkout Screen
/// Checkout should reduce uncertainty.
/// Progress always visible. Every step answers: Am I safe? What happens next?
/// Never surprise users. Never hide fees. Never pressure decisions.
class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutNotifierProvider);
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: checkoutState.step == CheckoutStep.delivery,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          ref.read(checkoutNotifierProvider.notifier).previousStep();
        }
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: _CheckoutAppBar(
          step: checkoutState.step,
          onBack: () {
            if (checkoutState.step == CheckoutStep.delivery) {
              context.pop();
            } else {
              ref.read(checkoutNotifierProvider.notifier).previousStep();
            }
          },
        ),
        body: Column(
          children: [
            // Progress bar — always visible
            CheckoutProgressBar(currentStep: checkoutState.step),

            Divider(height: 1, color: colors.outline),

            // Step content — animated transition between steps
            Expanded(
              child: AnimatedSwitcher(
                duration: LumoMotion.normal,
                switchInCurve: LumoMotion.enter,
                switchOutCurve: LumoMotion.exit,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.04, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _stepContent(checkoutState.step),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepContent(CheckoutStep step) {
    return switch (step) {
      CheckoutStep.delivery => const CheckoutDeliveryStep(
          key: ValueKey('delivery'),
        ),
      CheckoutStep.payment => const CheckoutPaymentStep(
          key: ValueKey('payment'),
        ),
      CheckoutStep.review => const CheckoutReviewStep(
          key: ValueKey('review'),
        ),
    };
  }
}

// ─────────────────────────────────────────────
// App bar
// ─────────────────────────────────────────────

class _CheckoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CheckoutAppBar({required this.step, required this.onBack});

  final CheckoutStep step;
  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String get _title => switch (step) {
        CheckoutStep.delivery => 'Checkout',
        CheckoutStep.payment => 'Checkout',
        CheckoutStep.review => 'Checkout',
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: onBack,
      ),
      title: Text(
        _title,
        style: LumoTypography.titleLarge.copyWith(color: colors.onSurface),
      ),
      centerTitle: true,
    ).animate().fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter);
  }
}
