import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/widgets/lumo_skeleton.dart';
import '../domain/entities/search_result_entity.dart';
import '../providers/search_providers.dart';

/// Lumo Search Screen
/// Emotional purpose: Make finding feel effortless and exciting.
/// The search experience should feel like a knowledgeable friend
/// who already knows what you want.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

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
    });
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

  void _submitQuery(String query) {
    if (query.trim().isEmpty) return;
    setState(() => _activeQuery = query.trim());
    _controller.text = query.trim();
    ref.read(searchHistoryProvider.notifier).add(query.trim());
    _focusNode.unfocus();
  }

  void _clearSearch() {
    _controller.clear();
    setState(() => _activeQuery = '');
    ref.read(searchQueryProvider.notifier).clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _SearchBar(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _onChanged,
              onSubmitted: _submitQuery,
              onClear: _clearSearch,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: _activeQuery.isEmpty
                  ? _SearchIdle(onQuerySelected: _submitQuery)
                  : _SearchResults(query: _activeQuery),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.onBack,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space16,
        LumoSpacing.space16,
        LumoSpacing.space16,
        LumoSpacing.space8,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Icon(
              Icons.arrow_back_rounded,
              color: colors.onSurface,
              size: 24,
            ),
          ),
          const SizedBox(width: LumoSpacing.space12),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: LumoRadius.borderPill,
              ),
              child: Row(
                children: [
                  const SizedBox(width: LumoSpacing.space16),
                  Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: colors.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: LumoSpacing.space8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                      textInputAction: TextInputAction.search,
                      style: LumoTypography.bodyMedium.copyWith(
                        color: colors.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search Lumo...',
                        hintStyle: LumoTypography.bodyMedium.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.35),
                        ),
                        border: InputBorder.none,
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
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: LumoSpacing.space12,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: colors.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                          )
                        : const SizedBox(width: LumoSpacing.space12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Idle State (history + trending) ─────────────────────────────────────────

class _SearchIdle extends ConsumerWidget {
  const _SearchIdle({required this.onQuerySelected});
  final ValueChanged<String> onQuerySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(searchHistoryProvider);
    final trending = ref.watch(trendingSearchesProvider);
    final colors = Theme.of(context).colorScheme;

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
                  color: colors.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    ref.read(searchHistoryProvider.notifier).clear(),
                child: Text(
                  'Clear',
                  style: LumoTypography.labelMedium.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: LumoSpacing.space12),
          ...history.asMap().entries.map(
                (e) => _HistoryTile(
                  query: e.value,
                  onTap: () => onQuerySelected(e.value),
                  onRemove: () => ref
                      .read(searchHistoryProvider.notifier)
                      .remove(e.value),
                )
                    .animate(delay: (e.key * 40).ms)
                    .fadeIn(duration: LumoMotion.fast, curve: LumoMotion.enter)
                    .slideX(begin: -0.05, end: 0),
              ),
        ],
        const SizedBox(height: LumoSpacing.space32),
        Text(
          'Trending',
          style: LumoTypography.titleMedium.copyWith(
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: LumoSpacing.space16),
        Wrap(
          spacing: LumoSpacing.space8,
          runSpacing: LumoSpacing.space8,
          children: trending.asMap().entries.map(
            (e) {
              return _TrendingChip(
                label: e.value,
                onTap: () => onQuerySelected(e.value),
              )
                  .animate(delay: (e.key * 50).ms)
                  .fadeIn(
                    duration: LumoMotion.normal,
                    curve: LumoMotion.enter,
                  )
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
            },
          ).toList(),
        ),
        const SizedBox(height: LumoSpacing.space80),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.query,
    required this.onTap,
    required this.onRemove,
  });

  final String query;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: LumoRadius.borderMedium,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: LumoSpacing.space12),
        child: Row(
          children: [
            Icon(
              Icons.history_rounded,
              size: 18,
              color: colors.onSurface.withValues(alpha: 0.35),
            ),
            const SizedBox(width: LumoSpacing.space12),
            Expanded(
              child: Text(
                query,
                style: LumoTypography.bodyMedium.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: colors.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingChip extends StatelessWidget {
  const _TrendingChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: LumoSpacing.space16,
          vertical: LumoSpacing.space8,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: LumoRadius.borderPill,
        ),
        child: Text(
          label,
          style: LumoTypography.labelMedium.copyWith(
            color: colors.onSurface.withValues(alpha: 0.75),
          ),
        ),
      ),
    );
  }
}

// ─── Results ──────────────────────────────────────────────────────────────────

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query});
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(
      searchResultsProvider(query: query),
    );

    return resultsAsync.when(
      loading: () => const _ResultsSkeleton(),
      error: (_, __) => const _ResultsError(),
      data: (results) => results.isEmpty
          ? _EmptyResults(query: query)
          : _ResultsGrid(results: results),
    );
  }
}

class _ResultsGrid extends StatelessWidget {
  const _ResultsGrid({required this.results});
  final List<SearchResultEntity> results;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space24,
            LumoSpacing.space8,
            LumoSpacing.space24,
            LumoSpacing.space16,
          ),
          child: Text(
            '${results.length} result${results.length == 1 ? '' : 's'}',
            style: LumoTypography.bodySmall.copyWith(
              color: colors.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(
              LumoSpacing.space24,
              0,
              LumoSpacing.space24,
              LumoSpacing.space80,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: LumoSpacing.space12,
              mainAxisSpacing: LumoSpacing.space20,
              childAspectRatio: 0.62,
            ),
            itemCount: results.length,
            itemBuilder: (context, i) => _SearchResultCard(
              result: results[i],
              onTap: () => context.push('/product/${results[i].productId}'),
            )
                .animate(delay: (i * 50).ms)
                .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                .slideY(begin: 0.08, end: 0),
          ),
        ),
      ],
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.result, required this.onTap});
  final SearchResultEntity result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: LumoRadius.borderLarge,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: result.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: colors.surfaceContainerHighest,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: colors.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_outlined,
                        color: colors.onSurface.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  if (result.hasDiscount)
                    Positioned(
                      top: LumoSpacing.space8,
                      left: LumoSpacing.space8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: LumoSpacing.space8,
                          vertical: LumoSpacing.space4,
                        ),
                        decoration: BoxDecoration(
                          color: LumoColors.lightDiscount,
                          borderRadius: LumoRadius.borderSmall,
                        ),
                        child: Text(
                          '-${result.discountPercent.toStringAsFixed(0)}%',
                          style: LumoTypography.labelSmall.copyWith(
                            color: LumoColors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: LumoSpacing.space8),
          Text(
            result.brand.toUpperCase(),
            style: LumoTypography.labelSmall.copyWith(
              color: colors.onSurface.withValues(alpha: 0.4),
              letterSpacing: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: LumoSpacing.space2),
          Text(
            result.title,
            style: LumoTypography.bodySmall.copyWith(color: colors.onSurface),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: LumoSpacing.space4),
          Row(
            children: [
              Text(
                '\$${result.price.toStringAsFixed(0)}',
                style: LumoTypography.labelMedium.copyWith(
                  color: colors.onSurface,
                ),
              ),
              if (result.hasDiscount) ...[
                const SizedBox(width: LumoSpacing.space8),
                Text(
                  '\$${result.originalPrice!.toStringAsFixed(0)}',
                  style: LumoTypography.bodySmall.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.35),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LumoSpacing.space48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: colors.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: LumoSpacing.space24),
            Text(
              'No results for "$query"',
              style: LumoTypography.titleMedium.copyWith(
                color: colors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: LumoSpacing.space8),
            Text(
              'Try a different search term.',
              style: LumoTypography.bodyMedium.copyWith(
                color: colors.onSurface.withValues(alpha: 0.45),
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

class _ResultsSkeleton extends StatelessWidget {
  const _ResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space8,
        LumoSpacing.space24,
        LumoSpacing.space80,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: LumoSpacing.space12,
        mainAxisSpacing: LumoSpacing.space20,
        childAspectRatio: 0.62,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: LumoSkeleton(
              width: double.infinity,
              height: double.infinity,
              borderRadius: LumoRadius.borderLarge,
            ),
          ),
          const SizedBox(height: LumoSpacing.space8),
          const LumoSkeleton(width: 60, height: 10),
          const SizedBox(height: LumoSpacing.space4),
          const LumoSkeleton(width: 120, height: 14),
          const SizedBox(height: LumoSpacing.space4),
          const LumoSkeleton(width: 50, height: 14),
        ],
      ),
    );
  }
}

class _ResultsError extends StatelessWidget {
  const _ResultsError();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        'Something went wrong.',
        style: LumoTypography.bodyMedium.copyWith(
          color: colors.onSurface.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
