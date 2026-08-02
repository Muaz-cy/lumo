import 'package:flutter/material.dart';
import '../../../shared/design_system/design_system.dart';

/// Lumo Search Bar
/// The search field should feel alive. Fast. Responsive. Elegant.
class LumoSearchBar extends StatelessWidget {
  const LumoSearchBar({
    super.key,
    this.onTap,
    this.hint = 'Search products, brands...',
  });

  final VoidCallback? onTap;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space16),
        decoration: BoxDecoration(
          color: colors.secondaryContainer,
          borderRadius: LumoRadius.borderPill,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: colors.onSecondaryContainer,
              size: 20,
            ),
            const SizedBox(width: LumoSpacing.space12),
            Expanded(
              child: Text(
                hint,
                style: LumoTypography.bodyMedium.copyWith(
                  color: colors.onSecondaryContainer,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: colors.outline,
            ),
            const SizedBox(width: LumoSpacing.space12),
            Icon(
              Icons.tune_rounded,
              color: colors.onSecondaryContainer,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
