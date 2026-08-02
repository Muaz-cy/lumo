import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../features/product/domain/entities/product_entity.dart';
import '../design_system/design_system.dart';

/// Lumo Product Card
/// Products are living objects. They should never feel static.
/// Every card answers: What is it? Why should I care?
class LumoProductCard extends StatelessWidget {
  const LumoProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.width = 180,
  });

  final ProductEntity product;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Hero(
              tag: 'product_${product.id}',
              child: ClipRRect(
                borderRadius: LumoRadius.borderLarge,
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _ProductImage(imageUrl: product.primaryImage),
                      if (product.hasDiscount)
                        Positioned(
                          top: LumoSpacing.space8,
                          left: LumoSpacing.space8,
                          child: _DiscountBadge(
                            percent: product.discountPercent,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: LumoSpacing.space12),
            // Brand
            Text(
              product.brand.toUpperCase(),
              style: LumoTypography.labelSmall.copyWith(
                color: colors.onSurface.withValues(alpha: 0.45),
                letterSpacing: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: LumoSpacing.space4),
            // Title
            Text(
              product.title,
              style: LumoTypography.bodyMedium.copyWith(
                color: colors.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: LumoSpacing.space8),
            // Price row
            Row(
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: LumoTypography.titleMedium.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                if (product.hasDiscount) ...[
                  const SizedBox(width: LumoSpacing.space8),
                  Text(
                    '\$${product.originalPrice!.toStringAsFixed(0)}',
                    style: LumoTypography.bodySmall.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.4),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: LumoMotion.normal,
          curve: LumoMotion.enter,
        );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (imageUrl.isEmpty) {
      return Container(
        color: colors.secondaryContainer,
        child: Icon(
          Icons.image_outlined,
          color: colors.onSecondaryContainer.withValues(alpha: 0.3),
          size: 40,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: colors.secondaryContainer),
      errorWidget: (_, __, ___) => Container(
        color: colors.secondaryContainer,
        child: Icon(
          Icons.image_outlined,
          color: colors.onSecondaryContainer.withValues(alpha: 0.3),
          size: 40,
        ),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.percent});
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LumoSpacing.space8,
        vertical: LumoSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: LumoColors.lightDiscount,
        borderRadius: LumoRadius.borderSmall,
      ),
      child: Text(
        '-${percent.toStringAsFixed(0)}%',
        style: LumoTypography.labelSmall.copyWith(color: LumoColors.white),
      ),
    );
  }
}
