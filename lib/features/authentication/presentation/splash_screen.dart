import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/design_system/design_system.dart';
import 'package:lumo/features/authentication/providers/auth_providers.dart';
import 'package:lumo/shared/providers/theme_provider.dart';

/// Lumo Splash Screen
/// The first signature moment. Users should feel they are entering
/// a premium experience. Calm. Intentional. Inevitable.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    await ref.read(themeNotifierProvider.notifier).initialize();
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final rawUser = Supabase.instance.client.auth.currentUser;
    if (rawUser == null) {
      context.go(LumoRoutes.onboarding);
      return;
    }

    // Fetch full user with role from profiles table
    final user = await ref
        .read(authRepositoryProvider)
        .fetchUserWithRole(rawUser);

    if (!mounted) return;

    if (user == null) {
      context.go(LumoRoutes.onboarding);
    } else if (user.isBroker) {
      context.go(LumoRoutes.brokerDashboard);
    } else {
      context.go(LumoRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo mark — a soft glowing dot above the wordmark
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: colors.onSurface,
                shape: BoxShape.circle,
              ),
            )
                .animate()
                .fadeIn(
                  delay: 300.ms,
                  duration: LumoMotion.slow,
                  curve: LumoMotion.enter,
                )
                .scale(begin: const Offset(0.4, 0.4), end: const Offset(1, 1)),

            const SizedBox(height: LumoSpacing.space16),

            // Wordmark
            Text(
              'LUMO',
              style: LumoTypography.displayMedium.copyWith(
                color: colors.onSurface,
                letterSpacing: 16,
                fontWeight: FontWeight.w300,
              ),
            )
                .animate()
                .fadeIn(
                  delay: 500.ms,
                  duration: LumoMotion.slow,
                  curve: LumoMotion.enter,
                )
                .slideY(begin: 0.15, end: 0),

            const SizedBox(height: LumoSpacing.space12),

            // Tagline
            Text(
              'Your home, back home.',
              style: LumoTypography.bodySmall.copyWith(
                color: colors.onSurface.withValues(alpha: 0.4),
                letterSpacing: 1.5,
              ),
            )
                .animate()
                .fadeIn(
                  delay: 800.ms,
                  duration: LumoMotion.slow,
                  curve: LumoMotion.enter,
                ),
          ],
        ),
      ),
    );
  }
}
