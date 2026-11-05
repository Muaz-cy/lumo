import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:lumo/features/home/domain/entities/home_section.dart';
import 'package:lumo/features/home/providers/home_providers.dart';
import 'package:lumo/features/property/domain/entities/property_entity.dart';
import 'package:lumo/shared/design_system/design_system.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key, this.focusPropertyId});

  /// When set, the map opens centred on this property and shows its preview.
  final String? focusPropertyId;

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  PropertyEntity? _selected;
  bool _didFocus = false;

  static const _center = LatLng(8.9806, 38.7578);

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMarkerTap(PropertyEntity property) {
    HapticFeedback.selectionClick();
    setState(() => _selected = property);
    _mapController.move(LatLng(property.latitude!, property.longitude!), 14.5);
  }

  void _dismiss() => setState(() => _selected = null);

  /// Called once after data loads when a focusPropertyId is provided.
  void _focusOnProperty(List<PropertyEntity> properties) {
    if (_didFocus || widget.focusPropertyId == null) return;
    final target = properties.where((p) => p.id == widget.focusPropertyId).firstOrNull;
    if (target == null || target.latitude == null) return;
    _didFocus = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(LatLng(target.latitude!, target.longitude!), 15.0);
      setState(() => _selected = target);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);

    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      body: homeState.when(
        loading: () => const _MapLoading(),
        error: (_, __) => const _MapError(),
        data: (sections) {
          final properties = sections.fold<List<PropertyEntity>>([], (acc, s) {
            if (s is ForSaleSection) acc.addAll(s.properties);
            if (s is ForRentSection) acc.addAll(s.properties);
            return acc;
          }).where((p) => p.latitude != null && p.longitude != null).toList();

          _focusOnProperty(properties);

          return Stack(
            children: [
              // ── Map ──────────────────────────────────────────
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _center,
                  initialZoom: 12.5,
                  minZoom: 10,
                  maxZoom: 18,
                  onTap: (_, __) => _dismiss(),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.lumo.app',
                    maxZoom: 18,
                  ),
                  MarkerLayer(
                    markers: properties.map((p) {
                      final isSelected = _selected?.id == p.id;
                      return Marker(
                        point: LatLng(p.latitude!, p.longitude!),
                        width: isSelected ? 120 : 90,
                        height: 40,
                        child: GestureDetector(
                          onTap: () => _onMarkerTap(p),
                          child: _PriceMarker(property: p, isSelected: isSelected),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              // ── Top bar ──────────────────────────────────────
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    LumoSpacing.space16, LumoSpacing.space16,
                    LumoSpacing.space16, 0,
                  ),
                  child: Row(
                    children: [
                      // Back button — only shown when opened from property detail
                      if (widget.focusPropertyId != null) ...[
                        _MapButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => context.pop(),
                        ),
                        const SizedBox(width: LumoSpacing.space12),
                      ],
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: LumoColors.white,
                            borderRadius: LumoRadius.borderPill,
                            boxShadow: LumoShadows.soft,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: LumoSpacing.space16),
                              Icon(Icons.search_rounded, size: 18,
                                  color: LumoColors.lightPrimary.withValues(alpha: 0.4)),
                              const SizedBox(width: LumoSpacing.space8),
                              Text(
                                'Search on map...',
                                style: LumoTypography.bodyMedium.copyWith(
                                  color: LumoColors.lightPrimary.withValues(alpha: 0.35),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: LumoSpacing.space12),
                      _MapButton(
                        icon: Icons.my_location_rounded,
                        onTap: () => _mapController.move(_center, 12.5),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter),
              ),

              // ── Property preview card ─────────────────────────
              if (_selected != null)
                Positioned(
                  left: LumoSpacing.space16,
                  right: LumoSpacing.space16,
                  bottom: MediaQuery.paddingOf(context).bottom + LumoSpacing.space16,
                  child: _PropertyPreviewCard(
                    property: _selected!,
                    onDismiss: _dismiss,
                  )
                      .animate()
                      .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                      .slideY(begin: 0.3, end: 0),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Price marker
// ─────────────────────────────────────────────

class _PriceMarker extends StatelessWidget {
  const _PriceMarker({required this.property, required this.isSelected});
  final PropertyEntity property;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.compact();

    return AnimatedContainer(
      duration: LumoMotion.fast,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? LumoColors.lightGold : LumoColors.white,
        borderRadius: LumoRadius.borderPill,
        boxShadow: LumoShadows.soft,
        border: Border.all(
          color: isSelected ? LumoColors.lightGold : LumoColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (property.isVerified)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                Icons.verified_rounded,
                size: 10,
                color: isSelected ? LumoColors.white : LumoColors.lightVerified,
              ),
            ),
          Text(
            'ETB ${fmt.format(property.priceEtb)}',
            style: LumoTypography.labelSmall.copyWith(
              color: isSelected ? LumoColors.white : LumoColors.lightPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Map icon button
// ─────────────────────────────────────────────

class _MapButton extends StatelessWidget {
  const _MapButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: LumoColors.white,
          shape: BoxShape.circle,
          boxShadow: LumoShadows.soft,
        ),
        child: Icon(icon, size: 20, color: LumoColors.lightPrimary),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Property preview card
// ─────────────────────────────────────────────

class _PropertyPreviewCard extends StatelessWidget {
  const _PropertyPreviewCard({required this.property, required this.onDismiss});
  final PropertyEntity property;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.compact();

    return GestureDetector(
      onTap: () => context.push('/property/${property.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: LumoColors.white,
          borderRadius: LumoRadius.borderLarge,
          boxShadow: LumoShadows.floating,
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(LumoRadius.large),
              ),
              child: SizedBox(
                width: 110,
                height: 110,
                child: Image.network(
                  property.primaryImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: LumoColors.lightSurfaceSecondary),
                ),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(LumoSpacing.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (property.isVerified)
                      Row(
                        children: [
                          const Icon(Icons.verified_rounded,
                              size: 11, color: LumoColors.lightVerified),
                          const SizedBox(width: 3),
                          Text(
                            'Verified',
                            style: LumoTypography.labelSmall.copyWith(
                              color: LumoColors.lightVerified,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: LumoSpacing.space4),
                    Text(
                      property.title,
                      style: LumoTypography.bodyMedium
                          .copyWith(color: LumoColors.lightPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: LumoSpacing.space4),
                    Text(
                      'ETB ${fmt.format(property.priceEtb)}'
                      '${property.purpose == ListingPurpose.rent ? '/mo' : ''}',
                      style: LumoTypography.labelLarge
                          .copyWith(color: LumoColors.lightGold),
                    ),
                    const SizedBox(height: LumoSpacing.space4),
                    Text(
                      '${property.bedroomLabel} · ${property.areaSqm.toInt()} m²',
                      style: LumoTypography.labelSmall.copyWith(
                        color: LumoColors.lightPrimary.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Dismiss
            Padding(
              padding: const EdgeInsets.only(right: LumoSpacing.space12),
              child: GestureDetector(
                onTap: onDismiss,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: LumoColors.lightSurfaceSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: LumoColors.lightPrimary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Loading & Error
// ─────────────────────────────────────────────

class _MapLoading extends StatelessWidget {
  const _MapLoading();

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(
          color: LumoColors.lightGold,
          strokeWidth: 2,
        ),
      );
}

class _MapError extends StatelessWidget {
  const _MapError();

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          'Could not load map.',
          style: LumoTypography.bodyMedium.copyWith(
            color: LumoColors.lightPrimary.withValues(alpha: 0.45),
          ),
        ),
      );
}
