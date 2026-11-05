import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/currency_provider.dart';
import '../design_system/design_system.dart';

/// Displays a property price in the user's chosen currency (ETB or USD).
/// Reads [CurrencyDisplayNotifier] and [ExchangeRateNotifier] automatically.
///
/// Usage:
///   LumoPriceDisplay(priceEtb: property.priceEtb)
///   LumoPriceDisplay(priceEtb: property.priceEtb, isRent: true, compact: true)
class LumoPriceDisplay extends ConsumerWidget {
  const LumoPriceDisplay({
    super.key,
    required this.priceEtb,
    this.isRent = false,
    this.compact = false,
    this.style,
    this.suffixStyle,
    this.color,
  });

  final double priceEtb;
  final bool isRent;

  /// Use compact notation (e.g. 8.5M vs 8,500,000).
  final bool compact;

  final TextStyle? style;
  final TextStyle? suffixStyle;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(currencyDisplayNotifierProvider);
    final rateAsync = ref.watch(exchangeRateNotifierProvider);
    final priceColor = color ?? LumoColors.lightGold;

    final fmtCompact = NumberFormat.compact();
    final fmtFull = NumberFormat('#,##0');

    final baseStyle = style ??
        LumoTypography.labelLarge.copyWith(color: priceColor);
    final rentSuffix = isRent ? '/mo' : '';

    if (display == CurrencyDisplay.usd) {
      return rateAsync.when(
        loading: () => Text(
          compact
              ? 'ETB ${fmtCompact.format(priceEtb)}$rentSuffix'
              : 'ETB ${fmtFull.format(priceEtb)}$rentSuffix',
          style: baseStyle,
        ),
        error: (_, __) => _etbText(priceEtb, compact, fmtCompact, fmtFull,
            rentSuffix, baseStyle),
        data: (rate) {
          final usd = rate.toUsd(priceEtb);
          final label = compact
              ? '≈ \$${fmtCompact.format(usd)}$rentSuffix'
              : '≈ USD ${fmtFull.format(usd)}$rentSuffix';
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(label, style: baseStyle),
              if (rate.isStale)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 11,
                    color: LumoColors.lightGold.withValues(alpha: 0.6),
                  ),
                ),
            ],
          );
        },
      );
    }

    return _etbText(
        priceEtb, compact, fmtCompact, fmtFull, rentSuffix, baseStyle);
  }

  Widget _etbText(
    double price,
    bool compact,
    NumberFormat fmtCompact,
    NumberFormat fmtFull,
    String suffix,
    TextStyle style,
  ) {
    final label = compact
        ? 'ETB ${fmtCompact.format(price)}$suffix'
        : 'ETB ${fmtFull.format(price)}$suffix';
    return Text(label, style: style);
  }
}

/// A small tappable pill that shows the current currency and lets the user
/// toggle between ETB and USD. Place it near price displays.
class CurrencyToggle extends ConsumerWidget {
  const CurrencyToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(currencyDisplayNotifierProvider);
    final isUsd = display == CurrencyDisplay.usd;

    return GestureDetector(
      onTap: () => ref.read(currencyDisplayNotifierProvider.notifier).toggle(),
      child: AnimatedContainer(
        duration: LumoMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isUsd
              ? LumoColors.lightGold.withValues(alpha: 0.12)
              : LumoColors.lightSurfaceSecondary,
          borderRadius: LumoRadius.borderPill,
          border: Border.all(
            color: isUsd
                ? LumoColors.lightGold.withValues(alpha: 0.4)
                : LumoColors.lightBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isUsd ? 'USD' : 'ETB',
              style: LumoTypography.labelSmall.copyWith(
                color: isUsd ? LumoColors.lightGold : LumoColors.lightTextSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
            const SizedBox(width: 3),
            Icon(
              Icons.swap_horiz_rounded,
              size: 12,
              color: isUsd
                  ? LumoColors.lightGold
                  : LumoColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the exchange rate source line: "Rate updated today · open.er-api.com"
/// Used in property detail to be transparent about the conversion source.
class ExchangeRateCaption extends ConsumerWidget {
  const ExchangeRateCaption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(currencyDisplayNotifierProvider);
    if (display != CurrencyDisplay.usd) return const SizedBox.shrink();

    final rateAsync = ref.watch(exchangeRateNotifierProvider);

    return rateAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (rate) {
        final now = DateTime.now();
        final diff = now.difference(rate.updatedAt);
        final String when;
        if (rate.updatedAt.millisecondsSinceEpoch == 0) {
          when = 'unavailable';
        } else if (diff.inMinutes < 60) {
          when = '${diff.inMinutes}m ago';
        } else if (diff.inHours < 24) {
          when = '${diff.inHours}h ago';
        } else {
          when = '${diff.inDays}d ago';
        }

        return Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            rate.isStale
                ? 'Cached rate · $when · open.er-api.com'
                : 'Rate updated $when · open.er-api.com',
            style: LumoTypography.labelSmall.copyWith(
              color: LumoColors.lightTextTertiary,
              fontSize: 10,
            ),
          ),
        );
      },
    );
  }
}
