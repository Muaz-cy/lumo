import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/features/property/domain/entities/property_entity.dart';
import 'package:lumo/features/search/providers/search_providers.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/widgets/lumo_price_display.dart';
import 'package:lumo/shared/widgets/lumo_skeleton.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.initialNeighborhood});

  /// Pre-applied neighborhood filter when navigated from home area chips.
  final String? initialNeighborhood;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;
  String _activeQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _applyNeighborhood(widget.initialNeighborhood);
    });
  }

  @override
  void didUpdateWidget(SearchScreen old) {
    super.didUpdateWidget(old);
    if (widget.initialNeighborhood != old.initialNeighborhood &&
        widget.initialNeighborhood != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _applyNeighborhood(widget.initialNeighborhood),
      );
    }
  }

  void _applyNeighborhood(String? neighborhood) {
    if (neighborhood == null) return;
    _controller.text = neighborhood;
    setState(() => _activeQuery = neighborhood);
    ref.read(searchQueryProvider.notifier).update(neighborhood);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() => _activeQuery = value.trim());
        ref.read(searchQueryProvider.notifier).update(value.trim());
      }
    });
  }

  void _submit(String query) {
    if (query.trim().isEmpty) return;
    setState(() => _activeQuery = query.trim());
    _controller.text = query.trim();
    ref.read(searchHistoryProvider.notifier).add(query.trim());
    _focusNode.unfocus();
  }

  void _clear() {
    _controller.clear();
    setState(() => _activeQuery = '');
    ref.read(searchQueryProvider.notifier).clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(searchFilterNotifierProvider);
    final hasActiveFilters = filters.purpose != null || filters.type != null;
    final showResults = _activeQuery.isNotEmpty || hasActiveFilters;

    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _SearchBar(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _onChanged,
              onSubmitted: _submit,
              onClear: _clear,
            ),
            _FilterRow(filters: filters),
            Expanded(
              child: showResults
                  ? _Results(query: _activeQuery, filters: filters)
                  : _Idle(onQuerySelected: _submit),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Search bar
// ─────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space16, LumoSpacing.space16,
        LumoSpacing.space16, LumoSpacing.space8,
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: LumoColors.lightSurface,
          borderRadius: LumoRadius.borderPill,
          border: Border.all(color: LumoColors.lightBorder),
        ),
        child: Row(
          children: [
            const SizedBox(width: LumoSpacing.space16),
            const Icon(Icons.search_rounded, size: 20, color: LumoColors.lightTextTertiary),
            const SizedBox(width: LumoSpacing.space8),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                textInputAction: TextInputAction.search,
                cursorColor: LumoColors.lightPrimary,
                cursorWidth: 1.5,
                style: LumoTypography.bodyMedium.copyWith(
                  color: LumoColors.lightPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search by area, type, or keyword...',
                  hintStyle: LumoTypography.bodyMedium.copyWith(
                    color: LumoColors.lightTextTertiary,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (_, value, __) => value.text.isNotEmpty
                  ? GestureDetector(
                      onTap: onClear,
                      child: const Padding(
                        padding: EdgeInsets.only(right: LumoSpacing.space12),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: LumoColors.lightTextTertiary,
                        ),
                      ),
                    )
                  : const SizedBox(width: LumoSpacing.space12),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Filter row
// ─────────────────────────────────────────────

class _FilterRow extends ConsumerWidget {
  const _FilterRow({required this.filters});
  final SearchFilters filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(searchFilterNotifierProvider.notifier);

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space16),
        children: [
          _FilterChip(
            label: 'For Sale',
            active: filters.purpose == ListingPurpose.sale,
            onTap: () => notifier.setPurpose(
              filters.purpose == ListingPurpose.sale ? null : ListingPurpose.sale,
            ),
          ),
          const SizedBox(width: LumoSpacing.space8),
          _FilterChip(
            label: 'For Rent',
            active: filters.purpose == ListingPurpose.rent,
            onTap: () => notifier.setPurpose(
              filters.purpose == ListingPurpose.rent ? null : ListingPurpose.rent,
            ),
          ),
          const SizedBox(width: LumoSpacing.space8),
          _FilterChip(
            label: 'Apartment',
            active: filters.type == PropertyType.apartment,
            onTap: () => notifier.setType(
              filters.type == PropertyType.apartment ? null : PropertyType.apartment,
            ),
          ),
          const SizedBox(width: LumoSpacing.space8),
          _FilterChip(
            label: 'Villa',
            active: filters.type == PropertyType.villa,
            onTap: () => notifier.setType(
              filters.type == PropertyType.villa ? null : PropertyType.villa,
            ),
          ),
          const SizedBox(width: LumoSpacing.space8),
          _FilterChip(
            label: 'House',
            active: filters.type == PropertyType.house,
            onTap: () => notifier.setType(
              filters.type == PropertyType.house ? null : PropertyType.house,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: LumoMotion.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: LumoSpacing.space16,
          vertical: LumoSpacing.space8,
        ),
        decoration: BoxDecoration(
          // Active = warm charcoal. Not gold — gold is for price/value only.
          color: active ? LumoColors.lightPrimary : LumoColors.lightSurface,
          borderRadius: LumoRadius.borderPill,
          border: Border.all(
            color: active ? LumoColors.lightPrimary : LumoColors.lightBorder,
          ),
        ),
        child: Text(
          label,
          style: LumoTypography.labelMedium.copyWith(
            color: active ? LumoColors.white : LumoColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Idle state
// ─────────────────────────────────────────────

class _Idle extends ConsumerWidget {
  const _Idle({required this.onQuerySelected});
  final ValueChanged<String> onQuerySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(searchHistoryProvider);
    final trending = ref.watch(trendingSearchesProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
      children: [
        if (history.isNotEmpty) ...[
          const SizedBox(height: LumoSpacing.space24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent',
                style: LumoTypography.titleMedium.copyWith(
                  color: LumoColors.lightPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => ref.read(searchHistoryProvider.notifier).clear(),
                child: Text(
                  'Clear',
                  style: LumoTypography.labelMedium.copyWith(
                    color: LumoColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: LumoSpacing.space8),
          ...history.asMap().entries.map(
                (e) => _HistoryTile(
                  query: e.value,
                  onTap: () => onQuerySelected(e.value),
                  onRemove: () =>
                      ref.read(searchHistoryProvider.notifier).remove(e.value),
                )
                    .animate(delay: (e.key * 40).ms)
                    .fadeIn(duration: LumoMotion.fast, curve: LumoMotion.enter)
                    .slideX(begin: -0.05, end: 0),
              ),
        ],
        const SizedBox(height: LumoSpacing.space32),
        Text(
          'Popular searches',
          style: LumoTypography.titleMedium.copyWith(color: LumoColors.lightPrimary),
        ),
        const SizedBox(height: LumoSpacing.space16),
        Wrap(
          spacing: LumoSpacing.space8,
          runSpacing: LumoSpacing.space8,
          children: trending.asMap().entries.map((e) {
            return GestureDetector(
              onTap: () => onQuerySelected(e.value),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: LumoSpacing.space16,
                  vertical: LumoSpacing.space8,
                ),
                decoration: BoxDecoration(
                  color: LumoColors.lightSurface,
                  borderRadius: LumoRadius.borderPill,
                  border: Border.all(color: LumoColors.lightBorder),
                ),
                child: Text(
                  e.value,
                  style: LumoTypography.labelMedium.copyWith(
                    color: LumoColors.lightTextSecondary,
                  ),
                ),
              ),
            )
                .animate(delay: (e.key * 50).ms)
                .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
          }).toList(),
        ),
        const SizedBox(height: LumoSpacing.space80),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.query, required this.onTap, required this.onRemove});
  final String query;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: LumoRadius.borderMedium,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: LumoSpacing.space12),
        child: Row(
          children: [
            const Icon(
              Icons.history_rounded,
              size: 18,
              color: LumoColors.lightTextTertiary,
            ),
            const SizedBox(width: LumoSpacing.space12),
            Expanded(
              child: Text(
                query,
                style: LumoTypography.bodyMedium.copyWith(
                  color: LumoColors.lightPrimary,
                ),
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: LumoColors.lightTextTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Results
// ─────────────────────────────────────────────

class _Results extends ConsumerWidget {
  const _Results({required this.query, required this.filters});
  final String query;
  final SearchFilters filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(searchResultsProvider(query: query, filters: filters));

    return async.when(
      loading: () => const _Skeleton(),
      error: (_, __) => const _Error(),
      data: (results) => results.isEmpty
          ? _Empty(query: query)
          : _ResultsList(results: results),
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({required this.results});
  final List<PropertyEntity> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space24, LumoSpacing.space12,
            LumoSpacing.space24, LumoSpacing.space8,
          ),
          child: Text(
            '${results.length} propert${results.length == 1 ? 'y' : 'ies'}',
            style: LumoTypography.bodySmall.copyWith(
              color: LumoColors.lightTextSecondary,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              LumoSpacing.space24, 0, LumoSpacing.space24, LumoSpacing.space80,
            ),
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: LumoSpacing.space12),
            itemBuilder: (_, i) {
              final p = results[i];
              return GestureDetector(
                onTap: () => context.push('/property/${p.id}'),
                child: Container(
                  decoration: BoxDecoration(
                    color: LumoColors.lightSurface,
                    borderRadius: LumoRadius.borderLarge,
                    border: Border.all(color: LumoColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(LumoRadius.large),
                        ),
                        child: SizedBox(
                          width: 110,
                          height: 100,
                          child: Image.network(
                            p.primaryImage,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: LumoColors.lightSurfaceSecondary),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(LumoSpacing.space12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (p.isVerified)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: LumoSpacing.space4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.verified_rounded,
                                          size: 11, color: LumoColors.lightVerified),
                                      const SizedBox(width: 3),
                                      Text(
                                        'Lumo Verified',
                                        style: LumoTypography.labelSmall.copyWith(
                                          color: LumoColors.lightVerified,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Text(
                                p.localizedTitle(Localizations.localeOf(context).languageCode),
                                style: LumoTypography.bodyMedium.copyWith(
                                  color: LumoColors.lightPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: LumoSpacing.space4),
                              LumoPriceDisplay(
                                priceEtb: p.priceEtb,
                                isRent: p.purpose == ListingPurpose.rent,
                                compact: true,
                                style: LumoTypography.labelLarge.copyWith(
                                  color: LumoColors.lightGold,
                                ),
                              ),
                              const SizedBox(height: LumoSpacing.space4),
                              Text(
                                '${p.bedroomLabel} · ${p.areaSqm.toInt()} m² · ${p.neighborhood}',
                                style: LumoTypography.labelSmall.copyWith(
                                  color: LumoColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate(delay: (i * 50).ms)
                  .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                  .slideY(begin: 0.05, end: 0);
            },
          ),
        ),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LumoSpacing.space48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: LumoColors.lightTextTertiary,
            ),
            const SizedBox(height: LumoSpacing.space24),
            Text(
              query.isEmpty
                  ? 'No properties match your filters.'
                  : 'No results for "$query"',
              style: LumoTypography.titleMedium.copyWith(color: LumoColors.lightPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: LumoSpacing.space8),
            Text(
              'Try adjusting your search or filters.',
              style: LumoTypography.bodyMedium.copyWith(
                color: LumoColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(LumoSpacing.space24),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: LumoSpacing.space12),
      itemBuilder: (_, __) => const LumoSkeleton(
        width: double.infinity,
        height: 100,
        borderRadius: LumoRadius.borderLarge,
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Something went wrong.',
        style: LumoTypography.bodyMedium.copyWith(
          color: LumoColors.lightTextSecondary,
        ),
      ),
    );
  }
}
