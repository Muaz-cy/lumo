import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/widgets/lumo_skeleton.dart';
import '../domain/entities/category_entity.dart';
import '../providers/categories_providers.dart';
import '../../search/domain/entities/search_result_entity.dart';

/// Lumo Categories Screen
/// Emotional purpose: Make browsing feel like walking through a curated showroom.
/// Every category is a world. The imagery does the selling.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesListProvider);

    return Scaffold(
      body: SafeArea(
        child: categoriesAsync.when(
          loading: () => const _CategoriesSkeleton(),
          error: (_, __) => const _CategoriesError(),
          data: (categories) => _CategoriesContent(categories: categories),
        ),
      ),
    );
  }
}

class _CategoriesContent extends StatelessWidget {
  const _CategoriesContent({required this.categories});
  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space24,
            LumoSpacing.space24,
            LumoSpacing.space24,
            LumoSpacing.space8,
          ),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Categories',
              style: LumoTypography.headlineLarge.copyWith(
                color: colors.onSurface,
              ),
            )
                .animate()
                .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                .slideY(begin: -0.1, end: 0),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space16,
            LumoSpacing.space16,
            LumoSpacing.space16,
            LumoSpacing.space80,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _CategoryCard(
                category: categories[i],
                onTap: () =>
                    context.push('/categories/${categories[i].id}'),
              )
                  .animate(delay: (i * 60).ms)
                  .fadeIn(
                    duration: LumoMotion.normal,
                    curve: LumoMotion.enter,
                  )
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                  ),
              childCount: categories.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: LumoSpacing.space12,
              mainAxisSpacing: LumoSpacing.space12,
              childAspectRatio: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});
  final CategoryEntity category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: LumoRadius.borderXL,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full-bleed image
            CachedNetworkImage(
              imageUrl: category.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              errorWidget: (_, __, ___) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
            // Gradient overlay
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.65),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            // Text
            Positioned(
              left: LumoSpacing.space16,
              right: LumoSpacing.space16,
              bottom: LumoSpacing.space16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.name,
                    style: LumoTypography.titleLarge.copyWith(
                      color: LumoColors.white,
                    ),
                  ),
                  const SizedBox(height: LumoSpacing.space2),
                  Text(
                    '${category.productCount} items',
                    style: LumoTypography.bodySmall.copyWith(
                      color: LumoColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesSkeleton extends StatelessWidget {
  const _CategoriesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(LumoSpacing.space16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: LumoSpacing.space12,
          mainAxisSpacing: LumoSpacing.space12,
          childAspectRatio: 0.8,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => LumoSkeleton(
          width: double.infinity,
          height: double.infinity,
          borderRadius: LumoRadius.borderXL,
        ),
      ),
    );
  }
}

class _CategoriesError extends StatelessWidget {
  const _CategoriesError();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Text(
        'Could not load categories.',
        style: LumoTypography.bodyMedium.copyWith(
          color: colors.onSurface.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}

// ─── Category Detail Screen ───────────────────────────────────────────────────

/// Lumo Category Detail Screen
/// Emotional purpose: Immerse the user in a single world of products.
class CategoryDetailScreen extends ConsumerWidget {
  const CategoryDetailScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(
      categoryDetailProvider(categoryId: categoryId),
    );
    final productsAsync = ref.watch(
      categoryProductsProvider(categoryId: categoryId),
    );

    return Scaffold(
      body: categoryAsync.when(
        loading: () => const _CategoryDetailSkeleton(),
        error: (_, __) => const _CategoryDetailError(),
        data: (category) => category == null
            ? const _CategoryDetailError()
            : _CategoryDetailContent(
                category: category,
                productsAsync: productsAsync,
              ),
      ),
    );
  }
}

class _CategoryDetailContent extends StatelessWidget {
  const _CategoryDetailContent({
    required this.category,
    required this.productsAsync,
  });

  final CategoryEntity category;
  final AsyncValue<List<SearchResultEntity>> productsAsync;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Hero image app bar
        SliverAppBar(
          expandedHeight: 260,
          pinned: true,
          backgroundColor: colors.surface,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              margin: const EdgeInsets.all(LumoSpacing.space8),
              decoration: BoxDecoration(
                color: LumoColors.black.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: LumoColors.white,
                size: 20,
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: category.imageUrl,
                  fit: BoxFit.cover,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        colors.surface.withValues(alpha: 0.9),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  left: LumoSpacing.space24,
                  right: LumoSpacing.space24,
                  bottom: LumoSpacing.space24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        category.name,
                        style: LumoTypography.headlineLarge.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      if (category.description != null) ...[
                        const SizedBox(height: LumoSpacing.space4),
                        Text(
                          category.description!,
                          style: LumoTypography.bodyMedium.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Products
        productsAsync.when(
          loading: () => SliverPadding(
            padding: const EdgeInsets.all(LumoSpacing.space16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, __) => LumoSkeleton(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: LumoRadius.borderLarge,
                ),
                childCount: 6,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: LumoSpacing.space12,
                mainAxisSpacing: LumoSpacing.space20,
                childAspectRatio: 0.62,
              ),
            ),
          ),
          error: (_, __) => SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(LumoSpacing.space48),
                child: Text(
                  'Could not load products.',
                  style: LumoTypography.bodyMedium.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ),
          ),
          data: (products) => products.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(LumoSpacing.space48),
                      child: Text(
                        'No products yet.',
                        style: LumoTypography.bodyMedium.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    LumoSpacing.space16,
                    LumoSpacing.space16,
                    LumoSpacing.space16,
                    LumoSpacing.space80,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _CategoryProductCard(
                        result: products[i],
                        onTap: () =>
                            context.push('/product/${products[i].productId}'),
                      )
                          .animate(delay: (i * 50).ms)
                          .fadeIn(
                            duration: LumoMotion.normal,
                            curve: LumoMotion.enter,
                          )
                          .slideY(begin: 0.08, end: 0),
                      childCount: products.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: LumoSpacing.space12,
                      mainAxisSpacing: LumoSpacing.space20,
                      childAspectRatio: 0.62,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _CategoryProductCard extends StatelessWidget {
  const _CategoryProductCard({required this.result, required this.onTap});
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
          Text(
            '\$${result.price.toStringAsFixed(0)}',
            style: LumoTypography.labelMedium.copyWith(
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDetailSkeleton extends StatelessWidget {
  const _CategoryDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: LumoSkeleton(
            width: double.infinity,
            height: 260,
            borderRadius: BorderRadius.zero,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(LumoSpacing.space16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (_, __) => LumoSkeleton(
                width: double.infinity,
                height: double.infinity,
                borderRadius: LumoRadius.borderLarge,
              ),
              childCount: 6,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: LumoSpacing.space12,
              mainAxisSpacing: LumoSpacing.space20,
              childAspectRatio: 0.62,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryDetailError extends StatelessWidget {
  const _CategoryDetailError();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'Category not found.',
          style: LumoTypography.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ),
    );
  }
}
