import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/features/property/domain/entities/property_entity.dart';
import 'package:lumo/l10n/app_localizations.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/providers/comparison_provider.dart';
import 'package:lumo/shared/widgets/lumo_price_display.dart';

class ComparisonScreen extends ConsumerWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final properties = ref.watch(comparisonNotifierProvider);
    final colors = Theme.of(context).colorScheme;
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      appBar: AppBar(
        backgroundColor: LumoColors.lightBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Compare',
          style: LumoTypography.titleLarge.copyWith(color: colors.onSurface),
        ),
        centerTitle: true,
        actions: [
          if (properties.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(comparisonNotifierProvider.notifier).clear(),
              child: Text(
                'Clear',
                style: LumoTypography.labelMedium.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ),
        ],
      ),
      body: properties.length < 2
          ? _EmptyState(count: properties.length)
          : _ComparisonTable(properties: properties, lang: lang),
    );
  }
}

// ─────────────────────────────────────────────
// Empty / insufficient state
// ─────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final needed = 2 - count;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LumoSpacing.space48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.compare_arrows_rounded,
                size: 48, color: colors.onSurface.withValues(alpha: 0.2)),
            const SizedBox(height: LumoSpacing.space24),
            Text(
              count == 0
                  ? 'No properties selected'
                  : 'Add $needed more propert${needed == 1 ? 'y' : 'ies'}',
              style: LumoTypography.titleMedium.copyWith(color: colors.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: LumoSpacing.space8),
            Text(
              'Use the compare button on any property to add it here.',
              style: LumoTypography.bodyMedium.copyWith(
                color: colors.onSurface.withValues(alpha: 0.45),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Comparison table
// ─────────────────────────────────────────────

class _ComparisonTable extends ConsumerWidget {
  const _ComparisonTable({required this.properties, required this.lang});
  final List<PropertyEntity> properties;
  final String lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final colWidth = (screenWidth - LumoSpacing.space48) / properties.length.clamp(2, 4);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24, 0, LumoSpacing.space24, LumoSpacing.space80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Property header row ──────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: properties
                .map((p) => _PropertyHeader(
                      property: p,
                      width: colWidth,
                      lang: lang,
                      onRemove: () =>
                          ref.read(comparisonNotifierProvider.notifier).remove(p.id),
                      onTap: () => context.push('/property/${p.id}'),
                    ))
                .toList(),
          ),

          const SizedBox(height: LumoSpacing.space24),

          // ── Attribute rows ───────────────────────────
          _AttributeSection(label: 'Price', children: [
            _Row(
              properties: properties,
              colWidth: colWidth,
              builder: (p) => LumoPriceDisplay(
                priceEtb: p.priceEtb,
                isRent: p.purpose == ListingPurpose.rent,
                compact: true,
                style: LumoTypography.labelLarge.copyWith(color: LumoColors.lightGold),
              ),
            ),
          ]),

          _AttributeSection(label: 'Location', children: [
            _Row(
              properties: properties,
              colWidth: colWidth,
              builder: (p) => Text(
                p.neighborhood,
                style: LumoTypography.bodySmall.copyWith(color: colors.onSurface),
              ),
            ),
          ]),

          _AttributeSection(label: 'Type', children: [
            _Row(
              properties: properties,
              colWidth: colWidth,
              builder: (p) => Text(
                _typeLabel(p.propertyType, context),
                style: LumoTypography.bodySmall.copyWith(color: colors.onSurface),
              ),
            ),
          ]),

          _AttributeSection(label: 'Purpose', children: [
            _Row(
              properties: properties,
              colWidth: colWidth,
              builder: (p) => Text(
                p.purpose == ListingPurpose.sale
                    ? AppLocalizations.of(context).propertyForSale
                    : AppLocalizations.of(context).propertyForRent,
                style: LumoTypography.bodySmall.copyWith(color: colors.onSurface),
              ),
            ),
          ]),

          _AttributeSection(label: 'Bedrooms', children: [
            _Row(
              properties: properties,
              colWidth: colWidth,
              builder: (p) => Text(
                p.bedroomLabel,
                style: LumoTypography.bodySmall.copyWith(color: colors.onSurface),
              ),
            ),
          ]),

          _AttributeSection(label: 'Bathrooms', children: [
            _Row(
              properties: properties,
              colWidth: colWidth,
              builder: (p) => Text(
                '${p.bathrooms}',
                style: LumoTypography.bodySmall.copyWith(color: colors.onSurface),
              ),
            ),
          ]),

          _AttributeSection(label: 'Area', children: [
            _Row(
              properties: properties,
              colWidth: colWidth,
              builder: (p) => Text(
                '${p.areaSqm.toInt()} m²',
                style: LumoTypography.bodySmall.copyWith(color: colors.onSurface),
              ),
            ),
          ]),

          _AttributeSection(label: 'Verified', children: [
            _Row(
              properties: properties,
              colWidth: colWidth,
              builder: (p) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    p.isVerified
                        ? Icons.verified_rounded
                        : Icons.remove_rounded,
                    size: 14,
                    color: p.isVerified
                        ? LumoColors.lightVerified
                        : colors.onSurface.withValues(alpha: 0.25),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    p.isVerified ? 'Verified' : '—',
                    style: LumoTypography.bodySmall.copyWith(
                      color: p.isVerified
                          ? LumoColors.lightVerified
                          : colors.onSurface.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
            ),
          ]),

          _AttributeSection(label: 'Amenities', children: [
            _Row(
              properties: properties,
              colWidth: colWidth,
              crossAxisAlignment: CrossAxisAlignment.start,
              builder: (p) => p.amenities.isEmpty
                  ? Text('—',
                      style: LumoTypography.bodySmall.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.3)))
                  : Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: p.amenities
                          .take(4)
                          .map((a) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: LumoColors.lightSurfaceSecondary,
                                  borderRadius: LumoRadius.borderPill,
                                  border: Border.all(color: LumoColors.lightBorder),
                                ),
                                child: Text(a,
                                    style: LumoTypography.labelSmall.copyWith(
                                        color: colors.onSurface, fontSize: 10)),
                              ))
                          .toList(),
                    ),
            ),
          ]),
        ],
      ),
    );
  }

  String _typeLabel(PropertyType type, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (type) {
      PropertyType.apartment => l10n.typeApartment,
      PropertyType.villa => l10n.typeVilla,
      PropertyType.house => 'House',
      PropertyType.land => l10n.typeLand,
      PropertyType.commercial => l10n.typeCommercial,
      PropertyType.office => l10n.typeOffice,
    };
  }
}

// ─────────────────────────────────────────────
// Property header card
// ─────────────────────────────────────────────

class _PropertyHeader extends StatelessWidget {
  const _PropertyHeader({
    required this.property,
    required this.width,
    required this.lang,
    required this.onRemove,
    required this.onTap,
  });
  final PropertyEntity property;
  final double width;
  final String lang;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(right: LumoSpacing.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: ClipRRect(
                    borderRadius: LumoRadius.borderLarge,
                    child: SizedBox(
                      height: 110,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: property.primaryImage,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: LumoColors.lightSurfaceSecondary),
                        errorWidget: (_, __, ___) =>
                            Container(color: LumoColors.lightSurfaceSecondary),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: LumoColors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close_rounded,
                          size: 14,
                          color: colors.onSurface.withValues(alpha: 0.6)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: LumoSpacing.space8),
            GestureDetector(
              onTap: onTap,
              child: Text(
                property.localizedTitle(lang),
                style: LumoTypography.labelMedium.copyWith(color: colors.onSurface),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Attribute section label
// ─────────────────────────────────────────────

class _AttributeSection extends StatelessWidget {
  const _AttributeSection({required this.label, required this.children});
  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: LumoSpacing.space8),
          child: Text(
            label.toUpperCase(),
            style: LumoTypography.labelSmall.copyWith(
              color: colors.onSurface.withValues(alpha: 0.35),
              letterSpacing: 0.8,
              fontSize: 10,
            ),
          ),
        ),
        ...children,
        Divider(height: LumoSpacing.space32, color: LumoColors.lightDivider),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Attribute row — one cell per property
// ─────────────────────────────────────────────

class _Row extends StatelessWidget {
  const _Row({
    required this.properties,
    required this.colWidth,
    required this.builder,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });
  final List<PropertyEntity> properties;
  final double colWidth;
  final Widget Function(PropertyEntity) builder;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: properties
          .map((p) => SizedBox(
                width: colWidth,
                child: Padding(
                  padding: const EdgeInsets.only(right: LumoSpacing.space8),
                  child: builder(p),
                ),
              ))
          .toList(),
    );
  }
}
