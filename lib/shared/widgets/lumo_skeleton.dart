import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../design_system/design_system.dart';

/// Lumo Skeleton Loader
/// Loading should feel alive. Never leave users wondering.
/// Use skeletons — never spinners on full screens.
class LumoSkeleton extends StatelessWidget {
  const LumoSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = LumoRadius.borderMedium,
  });

  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? LumoColors.darkSkeleton : LumoColors.lightSkeleton,
      highlightColor: isDark
          ? LumoColors.darkSurfaceSecondary
          : LumoColors.lightSurfaceSecondary,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colors.secondaryContainer,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// Full home screen skeleton shown while data loads.
class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: LumoSpacing.space24),
          // Greeting skeleton
          const LumoSkeleton(width: 180, height: 28),
          const SizedBox(height: LumoSpacing.space8),
          const LumoSkeleton(width: 120, height: 18),
          const SizedBox(height: LumoSpacing.space24),
          // Search bar skeleton
          LumoSkeleton(
            width: double.infinity,
            height: 52,
            borderRadius: LumoRadius.borderPill,
          ),
          const SizedBox(height: LumoSpacing.space32),
          // Hero skeleton
          LumoSkeleton(
            width: double.infinity,
            height: size.height * 0.55,
            borderRadius: LumoRadius.borderXL,
          ),
          const SizedBox(height: LumoSpacing.space32),
          // Section header
          const LumoSkeleton(width: 140, height: 24),
          const SizedBox(height: LumoSpacing.space16),
          // Collections row
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: LumoSpacing.space12),
              itemBuilder: (_, __) => const LumoSkeleton(
                width: 160,
                height: 200,
                borderRadius: LumoRadius.borderLarge,
              ),
            ),
          ),
          const SizedBox(height: LumoSpacing.space32),
          // Section header
          const LumoSkeleton(width: 120, height: 24),
          const SizedBox(height: LumoSpacing.space16),
          // Products row
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: LumoSpacing.space16),
              itemBuilder: (_, __) => const LumoSkeleton(
                width: 180,
                height: 280,
                borderRadius: LumoRadius.borderLarge,
              ),
            ),
          ),
          const SizedBox(height: LumoSpacing.space64),
        ],
      ),
    );
  }
}
