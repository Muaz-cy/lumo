import 'package:flutter/material.dart';
import '../design_system/design_system.dart';

/// Lumo Section Header
/// Consistent section labeling across the home screen.
class LumoSectionHeader extends StatelessWidget {
  const LumoSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            title,
            style: LumoTypography.headlineSmall.copyWith(
              color: colors.onSurface,
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: LumoTypography.labelMedium.copyWith(
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
      ],
    );
  }
}
