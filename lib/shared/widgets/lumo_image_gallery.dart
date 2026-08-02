import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../design_system/design_system.dart';

/// Lumo Image Gallery
/// Images deserve attention. Allow generous space.
/// Smooth transitions. No visual jumping.
class LumoImageGallery extends StatefulWidget {
  const LumoImageGallery({
    super.key,
    required this.imageUrls,
    required this.heroTag,
    this.height = 480,
  });

  final List<String> imageUrls;
  final String heroTag;
  final double height;

  @override
  State<LumoImageGallery> createState() => _LumoImageGalleryState();
}

class _LumoImageGalleryState extends State<LumoImageGallery> {
  final _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls.isEmpty ? [''] : widget.imageUrls;

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Gallery pages
          Hero(
            tag: widget.heroTag,
            child: PageView.builder(
              controller: _controller,
              itemCount: images.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (_, i) => _GalleryImage(imageUrl: images[i]),
            ),
          ),

          // Dot indicators — only shown when multiple images
          if (images.length > 1)
            Positioned(
              bottom: LumoSpacing.space16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (i) => AnimatedContainer(
                    duration: LumoMotion.fast,
                    curve: LumoMotion.snap,
                    margin: const EdgeInsets.symmetric(
                      horizontal: LumoSpacing.space4,
                    ),
                    width: _current == i ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _current == i
                          ? LumoColors.white
                          : LumoColors.white.withValues(alpha: 0.4),
                      borderRadius: LumoRadius.borderPill,
                    ),
                  ),
                ),
              ),
            ),

          // Image count badge — top right
          if (images.length > 1)
            Positioned(
              top: LumoSpacing.space16,
              right: LumoSpacing.space16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: LumoSpacing.space12,
                  vertical: LumoSpacing.space4,
                ),
                decoration: BoxDecoration(
                  color: LumoColors.black.withValues(alpha: 0.4),
                  borderRadius: LumoRadius.borderPill,
                ),
                child: Text(
                  '${_current + 1} / ${images.length}',
                  style: LumoTypography.labelSmall.copyWith(
                    color: LumoColors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GalleryImage extends StatelessWidget {
  const _GalleryImage({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (imageUrl.isEmpty) {
      return Container(
        color: colors.secondaryContainer,
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: colors.onSecondaryContainer.withValues(alpha: 0.3),
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
          size: 48,
          color: colors.onSecondaryContainer.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
