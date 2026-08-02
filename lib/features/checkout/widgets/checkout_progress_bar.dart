import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/design_system/design_system.dart';
import '../domain/entities/checkout_state.dart';

/// Lumo Checkout Progress Bar
/// Progress should always be visible.
/// Users must always know where they are and what comes next.
class CheckoutProgressBar extends StatelessWidget {
  const CheckoutProgressBar({super.key, required this.currentStep});

  final CheckoutStep currentStep;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: LumoSpacing.space24,
        vertical: LumoSpacing.space20,
      ),
      child: Row(
        children: [
          _StepDot(
            label: 'Delivery',
            index: 0,
            currentIndex: currentStep.index,
            colors: colors,
          ),
          _StepLine(
            isComplete: currentStep.index > 0,
            colors: colors,
          ),
          _StepDot(
            label: 'Payment',
            index: 1,
            currentIndex: currentStep.index,
            colors: colors,
          ),
          _StepLine(
            isComplete: currentStep.index > 1,
            colors: colors,
          ),
          _StepDot(
            label: 'Review',
            index: 2,
            currentIndex: currentStep.index,
            colors: colors,
          ),
        ],
      ),
    ).animate().fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter);
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.colors,
  });

  final String label;
  final int index;
  final int currentIndex;
  final ColorScheme colors;

  bool get isComplete => index < currentIndex;
  bool get isActive => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: LumoMotion.normal,
          curve: LumoMotion.snap,
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isComplete || isActive
                ? colors.primary
                : colors.secondaryContainer,
            border: isActive
                ? Border.all(color: colors.primary, width: 2)
                : null,
          ),
          child: Center(
            child: isComplete
                ? Icon(Icons.check_rounded, size: 14, color: colors.onPrimary)
                : Text(
                    '${index + 1}',
                    style: LumoTypography.labelSmall.copyWith(
                      color: isActive
                          ? colors.onPrimary
                          : colors.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: LumoSpacing.space4),
        AnimatedDefaultTextStyle(
          duration: LumoMotion.normal,
          style: LumoTypography.labelSmall.copyWith(
            color: isActive
                ? colors.onSurface
                : colors.onSurface.withValues(alpha: 0.4),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
          child: Text(label),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.isComplete, required this.colors});

  final bool isComplete;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: LumoSpacing.space20),
        child: AnimatedContainer(
          duration: LumoMotion.normal,
          curve: LumoMotion.snap,
          height: 1.5,
          color: isComplete
              ? colors.primary
              : colors.outline.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
