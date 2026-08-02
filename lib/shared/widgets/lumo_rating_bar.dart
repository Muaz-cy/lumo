import 'package:flutter/material.dart';
import '../design_system/design_system.dart';

/// Lumo Rating Bar
/// Honest social proof. Clear. Never inflated.
class LumoRatingBar extends StatelessWidget {
  const LumoRatingBar({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.size = 16,
  });

  final double rating;
  final int reviewCount;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stars
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            final filled = i < rating.floor();
            final partial = !filled && i < rating;
            return Icon(
              filled
                  ? Icons.star_rounded
                  : partial
                      ? Icons.star_half_rounded
                      : Icons.star_outline_rounded,
              size: size,
              color: LumoColors.lightRating,
            );
          }),
        ),
        const SizedBox(width: LumoSpacing.space8),
        Text(
          rating.toStringAsFixed(1),
          style: LumoTypography.labelMedium.copyWith(
            color: colors.onSurface,
          ),
        ),
        const SizedBox(width: LumoSpacing.space4),
        Text(
          '($reviewCount)',
          style: LumoTypography.bodySmall.copyWith(
            color: colors.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}
