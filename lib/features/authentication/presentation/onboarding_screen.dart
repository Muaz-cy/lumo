import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/design_system/design_system.dart';

/// Lumo Onboarding Screen
/// Instead of explaining features, show feelings.
/// Experienced users can skip instantly.
/// The final action flows naturally into the auth experience.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      headline: 'Discover\ndifferently.',
      subheadline: 'A curated world of products,\npersonalized for you.',
      accentIcon: Icons.explore_outlined,
    ),
    _OnboardingPage(
      headline: 'Shop with\nconfidence.',
      subheadline: 'Transparent pricing.\nHonest reviews. No surprises.',
      accentIcon: Icons.verified_outlined,
    ),
    _OnboardingPage(
      headline: 'Technology\nthat disappears.',
      subheadline: 'So effortless, you only\nnotice the experience.',
      accentIcon: Icons.auto_awesome_outlined,
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: LumoMotion.deliberate,
        curve: LumoMotion.silk,
      );
    } else {
      context.go(LumoRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  LumoSpacing.space24,
                  LumoSpacing.space16,
                  LumoSpacing.space24,
                  0,
                ),
                child: TextButton(
                  onPressed: () => context.go(LumoRoutes.login),
                  child: Text(
                    'Skip',
                    style: LumoTypography.labelMedium.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _pages[i],
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LumoSpacing.space24,
                LumoSpacing.space24,
                LumoSpacing.space24,
                LumoSpacing.space48,
              ),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: LumoMotion.fast,
                        curve: LumoMotion.snap,
                        margin: const EdgeInsets.symmetric(
                          horizontal: LumoSpacing.space4,
                        ),
                        width: _currentPage == i ? 24 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? colors.onSurface
                              : colors.onSurface.withValues(alpha: 0.2),
                          borderRadius: LumoRadius.borderPill,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: LumoSpacing.space32),

                  // CTA button
                  ElevatedButton(
                    onPressed: _next,
                    child: Text(isLast ? 'Get started' : 'Continue'),
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

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.headline,
    required this.subheadline,
    required this.accentIcon,
  });

  final String headline;
  final String subheadline;
  final IconData accentIcon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: LumoRadius.borderLarge,
            ),
            child: Icon(
              accentIcon,
              color: colors.onSurface,
              size: 28,
            ),
          )
              .animate()
              .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
              ),

          const SizedBox(height: LumoSpacing.space40),

          // Headline
          Text(
            headline,
            style: LumoTypography.displayMedium.copyWith(
              color: colors.onSurface,
            ),
          )
              .animate()
              .fadeIn(
                delay: 100.ms,
                duration: LumoMotion.normal,
                curve: LumoMotion.enter,
              )
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: LumoSpacing.space16),

          // Subheadline
          Text(
            subheadline,
            style: LumoTypography.bodyLarge.copyWith(
              color: colors.onSurface.withValues(alpha: 0.5),
              height: 1.7,
            ),
          )
              .animate()
              .fadeIn(
                delay: 200.ms,
                duration: LumoMotion.normal,
                curve: LumoMotion.enter,
              )
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}
