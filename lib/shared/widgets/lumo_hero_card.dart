import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../features/product/domain/entities/product_entity.dart';
import '../design_system/design_system.dart';

/// Lumo Hero Card
/// The first thing users see. One stunning story. One clear direction.
/// Products feel intentionally selected — not randomly dumped.
class LumoHeroCard extends StatelessWidget {
  const LumoHeroCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductEntity product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'product_${product.id}',
        child: ClipRRect(
          borderRadius: LumoRadius.borderXL,
          child: SizedBox(
            width: double.infinity,
            height: size.height * 0.55,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                _HeroImage(imageUrl: product.primaryImage),

                // Gradient overlay — bottom to top
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x33000000),
                        Color(0xCC000000),
                      ],
                      stops: [0.3, 0.6, 1.0],
                    ),
                  ),
                ),

                // Content
                Positioned(
                  left: LumoSpacing.space24,
                  right: LumoSpacing.space24,
                  bottom: LumoSpacing.space24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.brand.toUpperCase(),
                        style: LumoTypography.labelMedium.copyWith(
                          color: LumoColors.white.withValues(alpha: 0.7),
                          letterSpacing: 2.0,
                        ),
                      )
                          .animate()
                          .fadeIn(
                            delay: 200.ms,
                            duration: LumoMotion.normal,
                            curve: LumoMotion.enter,
                          )
                          .slideY(begin: 0.3, end: 0),
                      const SizedBox(height: LumoSpacing.space8),
                      Text(
                        product.title,
                        style: LumoTypography.headlineLarge.copyWith(
                          color: LumoColors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                          .animate()
                          .fadeIn(
                            delay: 300.ms,
                            duration: LumoMotion.normal,
                            curve: LumoMotion.enter,
                          )
                          .slideY(begin: 0.3, end: 0),
                      const SizedBox(height: LumoSpacing.space16),
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(0)}',
                            style: LumoTypography.titleLarge.copyWith(
                              color: LumoColors.white,
                            ),
                          ),
                          const Spacer(),
                          _ShopNowButton(),
                        ],
                      )
                          .animate()
                          .fadeIn(
                            delay: 400.ms,
                            duration: LumoMotion.normal,
                            curve: LumoMotion.enter,
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (imageUrl.isEmpty) {
      return Container(color: colors.secondaryContainer);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: colors.secondaryContainer),
      errorWidget: (_, __, ___) => Container(color: colors.secondaryContainer),
    );
  }
}

class _ShopNowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LumoSpacing.space16,
        vertical: LumoSpacing.space8,
      ),
      decoration: BoxDecoration(
        color: LumoColors.white,
        borderRadius: LumoRadius.borderPill,
      ),
      child: Text(
        'Shop now',
        style: LumoTypography.labelMedium.copyWith(
          color: LumoColors.black,
        ),
      ),
    );
  }
}
