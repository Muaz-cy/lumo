import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumo/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:lumo/features/wishlist/providers/wishlist_providers.dart';
import 'package:lumo/shared/design_system/design_system.dart';

/// Lumo Wishlist Button
/// The save animation communicates "This matters." — not "Database updated."
/// Use this anywhere a product can be saved: cards, detail screen, lists.
class LumoWishlistButton extends ConsumerStatefulWidget {
  const LumoWishlistButton({
    super.key,
    required this.item,
    this.size = 20,
    this.backgrounded = false,
  });

  /// The product to save/unsave.
  final WishlistItemEntity item;

  /// Icon size.
  final double size;

  /// If true, renders inside a frosted circle (for use over images).
  final bool backgrounded;

  @override
  ConsumerState<LumoWishlistButton> createState() =>
      _LumoWishlistButtonState();
}

class _LumoWishlistButtonState extends ConsumerState<LumoWishlistButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: LumoMotion.fast,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    final notifier = ref.read(wishlistNotifierProvider.notifier);
    final added = notifier.toggle(widget.item);

    if (added) {
      // Meaningful haptic — "This matters."
      HapticFeedback.mediumImpact();
      // Heartbeat: scale up then settle
      await _controller.forward();
      await _controller.reverse();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWishlisted = ref.watch(wishlistNotifierProvider.notifier)
        .isWishlisted(widget.item.productId);

    final icon = AnimatedSwitcher(
      duration: LumoMotion.fast,
      switchInCurve: LumoMotion.snap,
      switchOutCurve: LumoMotion.exit,
      transitionBuilder: (child, anim) => ScaleTransition(
        scale: anim,
        child: child,
      ),
      child: Icon(
        isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        key: ValueKey(isWishlisted),
        size: widget.size,
        color: isWishlisted
            ? LumoColors.lightError
            : (widget.backgrounded ? LumoColors.black : null),
      ),
    );

    final button = GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 1.3).animate(
          CurvedAnimation(parent: _controller, curve: LumoMotion.spring),
        ),
        child: widget.backgrounded
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: LumoColors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: LumoShadows.soft,
                ),
                child: Center(child: icon),
              )
            : icon,
      ),
    );

    // On first wishlist — burst animation
    if (isWishlisted) {
      return button
          .animate(key: ValueKey('wishlisted_${widget.item.productId}'))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1, 1),
          );
    }

    return button;
  }
}
