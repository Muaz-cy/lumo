import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/features/inquiry/providers/inquiry_providers.dart';
import 'package:lumo/features/property/domain/entities/property_entity.dart';
import 'package:lumo/features/property/providers/property_providers.dart';
import 'package:lumo/features/wishlist/providers/saved_providers.dart';
import 'package:lumo/l10n/app_localizations.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/providers/comparison_provider.dart';
import 'package:lumo/shared/widgets/lumo_price_display.dart';
import 'package:lumo/shared/widgets/lumo_skeleton.dart';
import 'package:lumo/features/authentication/providers/auth_providers.dart';
import 'package:lumo/core/router/app_router.dart';

class PropertyDetailScreen extends ConsumerWidget {
  const PropertyDetailScreen({super.key, required this.propertyId});
  final String propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(propertyDetailProvider(propertyId));

    return async.when(
      loading: () => const _Skeleton(),
      error: (_, __) => _Error(onBack: () => context.pop()),
      data: (property) => _Content(property: property),
    );
  }
}

// ─────────────────────────────────────────────
// Main content
// ─────────────────────────────────────────────

class _Content extends ConsumerWidget {
  const _Content({required this.property});
  final PropertyEntity property;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarAsync = ref.watch(similarPropertiesProvider(property.id));

    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      extendBodyBehindAppBar: true,
      appBar: _AppBar(property: property),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Image gallery
              SliverToBoxAdapter(
                child: _ImageGallery(imageUrls: property.imageUrls),
              ),

              // Info sheet
              SliverToBoxAdapter(child: _InfoSheet(property: property)),

              // Similar properties
              SliverToBoxAdapter(
                child: similarAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (similar) => similar.isEmpty
                      ? const SizedBox.shrink()
                      : _SimilarSection(properties: similar),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // Sticky inquiry bar
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ComparisonBar(currentPropertyId: property.id),
                _InquiryBar(property: property),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// App bar
// ─────────────────────────────────────────────

class _AppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _AppBar({required this.property});
  final PropertyEntity property;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComparing = ref.watch(
      comparisonNotifierProvider.select((s) => s.any((p) => p.id == property.id)),
    );
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: LumoSpacing.space16),
        child: _CircleButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () => context.pop()),
      ),
      actions: [
        _CircleButton(
          icon: isComparing ? Icons.compare_arrows_rounded : Icons.compare_arrows_outlined,
          onTap: () {
            HapticFeedback.selectionClick();
            final notifier = ref.read(comparisonNotifierProvider.notifier);
            if (isComparing) {
              notifier.remove(property.id);
            } else {
              final added = notifier.add(property);
              if (!added) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Maximum 4 properties can be compared.'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: LumoColors.lightPrimary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
          },
        ),
        const SizedBox(width: LumoSpacing.space8),
        _CircleButton(icon: Icons.share_outlined, onTap: () {}),
        const SizedBox(width: LumoSpacing.space16),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LumoColors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40, height: 40,
          child: Icon(icon, size: 18, color: LumoColors.black),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Image gallery
// ─────────────────────────────────────────────

class _ImageGallery extends StatefulWidget {
  const _ImageGallery({required this.imageUrls});
  final List<String> imageUrls;

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.5;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            itemCount: widget.imageUrls.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => CachedNetworkImage(
              imageUrl: widget.imageUrls[i],
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: LumoColors.lightSurfaceSecondary),
              errorWidget: (_, __, ___) => Container(color: LumoColors.lightSurfaceSecondary),
            ),
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: LumoSpacing.space16,
              left: 0, right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (i) => AnimatedContainer(
                    duration: LumoMotion.fast,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _current == i ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _current == i ? LumoColors.white : LumoColors.white.withValues(alpha: 0.5),
                      borderRadius: LumoRadius.borderPill,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Info sheet
// ─────────────────────────────────────────────

class _InfoSheet extends StatelessWidget {
  const _InfoSheet({required this.property});
  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final lang = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: LumoColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(LumoRadius.xl)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          LumoSpacing.space24, LumoSpacing.space24,
          LumoSpacing.space24, 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verified badge
            if (property.isVerified)
              Container(
                margin: const EdgeInsets.only(bottom: LumoSpacing.space12),
                padding: const EdgeInsets.symmetric(
                  horizontal: LumoSpacing.space12, vertical: LumoSpacing.space8,
                ),
                decoration: BoxDecoration(
                  color: LumoColors.lightVerifiedContainer,
                  borderRadius: LumoRadius.borderSmall,
                  border: Border.all(color: LumoColors.lightVerified.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, size: 14, color: LumoColors.lightVerified),
                    const SizedBox(width: LumoSpacing.space6),
                    Text(
                      l10n.propertyTeamVerified,
                      style: LumoTypography.labelSmall.copyWith(
                        color: LumoColors.lightVerified,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter),

            // Title
            Text(
              property.localizedTitle(lang),
              style: LumoTypography.headlineLarge.copyWith(color: colors.onSurface),
            )
                .animate()
                .fadeIn(delay: 60.ms, duration: LumoMotion.normal, curve: LumoMotion.enter)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: LumoSpacing.space4),

            // Location
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: colors.onSurface.withValues(alpha: 0.45)),
                const SizedBox(width: 4),
                Text(
                  '${property.neighborhood}, ${property.city}',
                  style: LumoTypography.bodyMedium.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),

            const SizedBox(height: LumoSpacing.space20),

            // Price block
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LumoPriceDisplay(
                      priceEtb: property.priceEtb,
                      isRent: property.purpose == ListingPurpose.rent,
                      compact: false,
                      style: LumoTypography.headlineMedium
                          .copyWith(color: LumoColors.lightGold),
                    ),
                    ExchangeRateCaption(),
                  ],
                ),
                const Spacer(),
                CurrencyToggle(),
                const SizedBox(width: LumoSpacing.space8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: LumoSpacing.space12, vertical: LumoSpacing.space6,
                  ),
                  decoration: BoxDecoration(
                    color: LumoColors.lightSurfaceSecondary,
                    borderRadius: LumoRadius.borderSmall,
                  ),
                  child: Text(
                    property.purpose == ListingPurpose.sale
                        ? l10n.propertyForSale
                        : l10n.propertyForRent,
                    style: LumoTypography.labelSmall.copyWith(color: colors.onSurface),
                  ),
                ),
              ],
            ),

            const SizedBox(height: LumoSpacing.space24),

            // Stats row
            Container(
              padding: const EdgeInsets.all(LumoSpacing.space16),
              decoration: BoxDecoration(
                color: LumoColors.lightSurfaceSecondary,
                borderRadius: LumoRadius.borderLarge,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat(icon: Icons.bed_outlined, label: property.bedroomLabel),
                  _StatDivider(),
                  _Stat(icon: Icons.bathtub_outlined, label: '${property.bathrooms} bath'),
                  _StatDivider(),
                  _Stat(icon: Icons.straighten_rounded, label: '${property.areaSqm.toInt()} m²'),
                ],
              ),
            ),

            // Description
            if (property.localizedDescription(lang) != null) ...[
              const SizedBox(height: LumoSpacing.space24),
              Text(
                l10n.propertyAbout,
                style: LumoTypography.titleMedium.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: LumoSpacing.space8),
              Text(
                property.localizedDescription(lang)!,
                style: LumoTypography.bodyLarge.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.7),
                  height: 1.7,
                ),
              ),
            ],

            // Amenities
            if (property.amenities.isNotEmpty) ...[
              const SizedBox(height: LumoSpacing.space24),
              Text(
                l10n.propertyFeatures,
                style: LumoTypography.titleMedium.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: LumoSpacing.space12),
              Wrap(
                spacing: LumoSpacing.space8,
                runSpacing: LumoSpacing.space8,
                children: property.amenities
                    .map((a) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: LumoSpacing.space12,
                            vertical: LumoSpacing.space6,
                          ),
                          decoration: BoxDecoration(
                            color: LumoColors.lightSurfaceSecondary,
                            borderRadius: LumoRadius.borderPill,
                            border: Border.all(color: LumoColors.lightBorder),
                          ),
                          child: Text(
                            a,
                            style: LumoTypography.labelMedium.copyWith(color: colors.onSurface),
                          ),
                        ))
                    .toList(),
              ),
            ],

            const SizedBox(height: LumoSpacing.space32),

            // See in Maps
            _SeeInMapsButton(property: property),

            const SizedBox(height: LumoSpacing.space32),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// See in Maps button
// ─────────────────────────────────────────────

class _SeeInMapsButton extends StatelessWidget {
  const _SeeInMapsButton({required this.property});
  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    final hasCoords = property.latitude != null && property.longitude != null;

    return OutlinedButton.icon(
      onPressed: hasCoords
          ? () => context.push('/map/property/${property.id}')
          : null,
      icon: Icon(
        Icons.map_outlined,
        size: 18,
        color: hasCoords ? LumoColors.lightPrimary : LumoColors.lightTextTertiary,
      ),
      label: Text(
        hasCoords ? 'See in Maps' : 'Location not available',
        style: LumoTypography.labelMedium.copyWith(
          color: hasCoords ? LumoColors.lightPrimary : LumoColors.lightTextTertiary,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(
          color: hasCoords ? LumoColors.lightBorder : LumoColors.lightDivider,
        ),
        shape: RoundedRectangleBorder(borderRadius: LumoRadius.borderMedium),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Stat
// ─────────────────────────────────────────────

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, size: 20, color: LumoColors.lightGold),
        const SizedBox(height: LumoSpacing.space4),
        Text(
          label,
          style: LumoTypography.labelMedium.copyWith(color: colors.onSurface),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: LumoColors.lightDivider);
  }
}

// ─────────────────────────────────────────────
// Similar properties
// ─────────────────────────────────────────────

class _SimilarSection extends StatelessWidget {
  const _SimilarSection({required this.properties});
  final List<PropertyEntity> properties;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space24, 0, LumoSpacing.space24, LumoSpacing.space12,
          ),
          child: Text(
            'Similar properties',
            style: LumoTypography.titleMedium.copyWith(color: colors.onSurface),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
            itemCount: properties.length,
            separatorBuilder: (_, __) => const SizedBox(width: LumoSpacing.space12),
            itemBuilder: (_, i) {
              final p = properties[i];
              return GestureDetector(
                onTap: () => context.push('/property/${p.id}'),
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: LumoRadius.borderLarge,
                    border: Border.all(color: LumoColors.lightBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(LumoRadius.large),
                        ),
                        child: SizedBox(
                          height: 110,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: p.primaryImage,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: LumoColors.lightSurfaceSecondary),
                            errorWidget: (_, __, ___) =>
                                Container(color: LumoColors.lightSurfaceSecondary),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(LumoSpacing.space10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LumoPriceDisplay(
                              priceEtb: p.priceEtb,
                              compact: true,
                              style: LumoTypography.labelLarge
                                  .copyWith(color: LumoColors.lightGold),
                            ),
                            Text(
                              p.title,
                              style: LumoTypography.bodySmall
                                  .copyWith(color: colors.onSurface),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Comparison bar
// ─────────────────────────────────────────────

class _ComparisonBar extends ConsumerWidget {
  const _ComparisonBar({required this.currentPropertyId});
  final String currentPropertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compared = ref.watch(comparisonNotifierProvider);
    if (compared.length < 2) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => context.push(LumoRoutes.comparison),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: LumoSpacing.space24,
          vertical: LumoSpacing.space10,
        ),
        color: LumoColors.lightPrimary,
        child: Row(
          children: [
            const Icon(Icons.compare_arrows_rounded,
                size: 16, color: LumoColors.white),
            const SizedBox(width: LumoSpacing.space8),
            Text(
              'Compare ${compared.length} properties',
              style: LumoTypography.labelMedium.copyWith(
                color: LumoColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              'View →',
              style: LumoTypography.labelSmall.copyWith(
                color: LumoColors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Inquiry bar
// ─────────────────────────────────────────────


// ─────────────────────────────────────────────
// Comparison bar
// ─────────────────────────────────────────────

class _InquiryBar extends ConsumerWidget {
  const _InquiryBar({required this.property});
  final PropertyEntity property;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final user = ref.watch(currentUserProvider);
    final isGuest = user == null || user.isGuest;
    final isSaved = ref.watch(
      savedNotifierProvider.select((s) => s.any((p) => p.property.id == property.id)),
    );
    final hasInquired = ref.watch(
      inquiryNotifierProvider.select((s) => s.any((i) => i.propertyId == property.id)),
    );

    return Container(
      padding: EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space16,
        LumoSpacing.space24,
        MediaQuery.paddingOf(context).bottom + LumoSpacing.space16,
      ),
      decoration: BoxDecoration(
        color: LumoColors.lightBackground,
        border: Border(top: BorderSide(color: LumoColors.lightBorder)),
      ),
      child: Row(
        children: [
          // Save button
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: isSaved ? LumoColors.lightGoldContainer : LumoColors.lightSurfaceSecondary,
              borderRadius: LumoRadius.borderMedium,
              border: Border.all(
                color: isSaved ? LumoColors.lightGold : LumoColors.lightBorder,
              ),
            ),
            child: IconButton(
              icon: Icon(
                isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: isSaved ? LumoColors.lightGold : colors.onSurface,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                if (isGuest) {
                  _showAuthGate(context);
                  return;
                }
                ref.read(savedNotifierProvider.notifier).toggle(property);
              },
            ),
          ),

          const SizedBox(width: LumoSpacing.space12),

          // Inquire button
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  if (isGuest) {
                    _showAuthGate(context);
                    return;
                  }
                  _showInquirySheet(context, property);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasInquired
                      ? LumoColors.lightSurfaceSecondary
                      : LumoColors.lightGold,
                  foregroundColor: hasInquired
                      ? LumoColors.lightGold
                      : LumoColors.white,
                  shape: RoundedRectangleBorder(borderRadius: LumoRadius.borderMedium),
                ),
                child: Text(hasInquired ? 'Inquiry sent ✓' : 'Inquire about this property'),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideY(begin: 0.5, end: 0);
  }

  void _showAuthGate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: LumoColors.lightBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(LumoRadius.xl)),
      ),
      builder: (_) => _AuthGateSheet(),
    );
  }

  void _showInquirySheet(BuildContext context, PropertyEntity property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: LumoColors.lightBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(LumoRadius.xl)),
      ),
      builder: (_) => _InquirySheet(property: property),
    );
  }
}

// ─────────────────────────────────────────────
// Auth gate sheet — shown to guests
// ─────────────────────────────────────────────

class _AuthGateSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space24,
        LumoSpacing.space24,
        MediaQuery.viewInsetsOf(context).bottom + LumoSpacing.space32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: LumoColors.lightBorder,
                borderRadius: LumoRadius.borderPill,
              ),
            ),
          ),
          const SizedBox(height: LumoSpacing.space24),
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: LumoColors.lightGoldContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_outline_rounded,
                color: LumoColors.lightGold, size: 26),
          ),
          const SizedBox(height: LumoSpacing.space20),
          Text(
            'Sign in to continue',
            style: LumoTypography.headlineSmall.copyWith(color: colors.onSurface),
          ),
          const SizedBox(height: LumoSpacing.space8),
          Text(
            'Create a free account to save properties\nand send inquiries.',
            style: LumoTypography.bodyMedium.copyWith(
              color: colors.onSurface.withValues(alpha: 0.5),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: LumoSpacing.space24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.push(LumoRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: LumoColors.lightGold,
                foregroundColor: LumoColors.white,
                shape: RoundedRectangleBorder(borderRadius: LumoRadius.borderMedium),
              ),
              child: const Text('Sign in'),
            ),
          ),
          const SizedBox(height: LumoSpacing.space12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: LumoRadius.borderMedium),
              ),
              child: const Text('Continue browsing'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Inquiry sheet — real submit flow
// ─────────────────────────────────────────────

class _InquirySheet extends ConsumerStatefulWidget {
  const _InquirySheet({required this.property});
  final PropertyEntity property;

  @override
  ConsumerState<_InquirySheet> createState() => _InquirySheetState();
}

class _InquirySheetState extends ConsumerState<_InquirySheet> {
  final _messageController = TextEditingController(
    text: "Hi, I'm interested in this property. Please contact me.",
  );
  bool _loading = false;
  bool _success = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() => _loading = true);

    await ref.read(inquiryNotifierProvider.notifier).submit(
          propertyId: widget.property.id,
          propertyTitle: widget.property.title,
          propertyImage: widget.property.primaryImage,
          message: _messageController.text.trim(),
        );

    if (mounted) setState(() { _loading = false; _success = true; });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space24,
        LumoSpacing.space24,
        MediaQuery.viewInsetsOf(context).bottom + LumoSpacing.space24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: LumoColors.lightBorder,
                borderRadius: LumoRadius.borderPill,
              ),
            ),
          ),
          const SizedBox(height: LumoSpacing.space20),

          if (_success) ...[
            // ── Success state ──────────────────────────
            Center(
              child: Column(
                children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: LumoColors.lightVerifiedContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: LumoColors.lightVerified, size: 32),
                  ),
                  const SizedBox(height: LumoSpacing.space16),
                  Text(
                    'Inquiry sent!',
                    style: LumoTypography.headlineSmall.copyWith(color: colors.onSurface),
                  ),
                  const SizedBox(height: LumoSpacing.space8),
                  Text(
                    'We\'ll be in touch within 24 hours.',
                    style: LumoTypography.bodyMedium.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: LumoSpacing.space24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LumoColors.lightGold,
                        foregroundColor: LumoColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: LumoRadius.borderMedium),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                  ),
            ),
          ] else ...[
            // ── Form state ─────────────────────────────
            Text(
              'Send an inquiry',
              style: LumoTypography.headlineSmall.copyWith(color: colors.onSurface),
            ),
            const SizedBox(height: LumoSpacing.space4),
            Text(
              widget.property.title,
              style: LumoTypography.bodyMedium.copyWith(
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: LumoSpacing.space20),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Your message...',
                filled: true,
                fillColor: LumoColors.lightSurfaceSecondary,
                border: OutlineInputBorder(
                  borderRadius: LumoRadius.borderLarge,
                  borderSide: BorderSide(color: LumoColors.lightBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: LumoRadius.borderLarge,
                  borderSide: BorderSide(color: LumoColors.lightBorder),
                ),
              ),
            ),
            const SizedBox(height: LumoSpacing.space16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: LumoColors.lightGold,
                  foregroundColor: LumoColors.white,
                  shape: RoundedRectangleBorder(borderRadius: LumoRadius.borderMedium),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: LumoColors.white,
                        ),
                      )
                    : const Text('Send inquiry'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Skeleton & Error
// ─────────────────────────────────────────────

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      body: Column(
        children: [
          LumoSkeleton(width: double.infinity, height: size.height * 0.5, borderRadius: BorderRadius.zero),
          Padding(
            padding: const EdgeInsets.all(LumoSpacing.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                LumoSkeleton(width: 120, height: 24),
                SizedBox(height: LumoSpacing.space12),
                LumoSkeleton(width: 240, height: 32),
                SizedBox(height: LumoSpacing.space12),
                LumoSkeleton(width: 160, height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48),
              const SizedBox(height: LumoSpacing.space24),
              const Text('Property not found.'),
              const SizedBox(height: LumoSpacing.space32),
              OutlinedButton(onPressed: onBack, child: const Text('Go back')),
            ],
          ),
        ),
      ),
    );
  }
}
