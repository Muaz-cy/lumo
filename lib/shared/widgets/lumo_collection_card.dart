import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../features/home/domain/entities/collection_entity.dart';
import '../design_system/design_system.dart';

/// Lumo Collection Card
/// Categories should inspire. Not overwhelm.
/// Each collection feels like entering a different showroom.
class LumoCollectionCard extends StatelessWidget {
  const LumoCollectionCard({
    super.key,
    required this.collection,
    required this.onTap,
  });

  final CollectionEntity collection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: LumoRadius.borderLarge,
        child: SizedBox(
          width: 160,
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              collection.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: collection.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: colors.secondaryContainer),
                      errorWidget: (_, __, ___) =>
                          Container(color: colors.secondaryContainer),
                    )
                  : Container(color: colors.secondaryContainer),

              // Gradient
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xBB000000)],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),

              // Text
              Positioned(
                left: LumoSpacing.space12,
                right: LumoSpacing.space12,
                bottom: LumoSpacing.space12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      collection.title,
                      style: LumoTypography.titleMedium.copyWith(
                        color: LumoColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: LumoSpacing.space2),
                    Text(
                      collection.subtitle,
                      style: LumoTypography.bodySmall.copyWith(
                        color: LumoColors.white.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
