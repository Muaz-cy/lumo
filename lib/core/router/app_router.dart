import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/authentication/presentation/splash_screen.dart';
import '../../features/authentication/presentation/onboarding_screen.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/register_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/property/presentation/property_detail_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/wishlist/presentation/wishlist_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/broker/presentation/broker_dashboard_screen.dart';
import '../../features/broker/presentation/broker_listings_screen.dart';
import '../../features/broker/presentation/broker_shell.dart';
import '../../features/broker/presentation/submit_listing_screen.dart';
import '../../features/inquiry/presentation/inquiries_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/consultation/presentation/consultation_screen.dart';
import '../../features/property/presentation/comparison_screen.dart';
import '../../shared/widgets/lumo_shell.dart';

part 'app_router.g.dart';

abstract final class LumoRoutes {
  // Auth
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';

  // Shell tabs
  static const home = '/home';
  static const search = '/search';
  static const map = '/map';
  static const wishlist = '/wishlist';
  static const profile = '/profile';

  // Property
  static const propertyDetail = '/property/:id';

  // Account
  static const inquiries = '/inquiries';
  static const settings = '/settings';
  static const notifications = '/notifications';
  static const consultation = '/consultation';

  // Map (standalone — used for property-specific navigation)
  static const mapDetail = '/map/property/:id';

  // Comparison
  static const comparison = '/compare';

  // Broker
  static const brokerDashboard = '/broker/dashboard';
  static const brokerListings = '/broker/listings';
  static const brokerSubmit = '/broker/submit';
  static const brokerProfile = '/broker/profile';
  static const brokerApply = '/broker/apply';
}

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: LumoRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // ── Auth ─────────────────────────────────────────
      GoRoute(
        path: LumoRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: LumoRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: LumoRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: LumoRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── Property detail ──────────────────────────────
      GoRoute(
        path: LumoRoutes.propertyDetail,
        builder: (context, state) => PropertyDetailScreen(
          propertyId: state.pathParameters['id']!,
        ),
      ),

      // ── Account (no shell) ───────────────────────────
      GoRoute(
        path: LumoRoutes.inquiries,
        builder: (context, state) => const InquiriesScreen(),
      ),
      GoRoute(
        path: LumoRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: LumoRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: LumoRoutes.consultation,
        builder: (context, state) => const ConsultationScreen(),
      ),

      // ── Map detail (property-focused, no shell) ───────
      GoRoute(
        path: LumoRoutes.mapDetail,
        builder: (context, state) => MapScreen(
          focusPropertyId: state.pathParameters['id'],
        ),
      ),

      // ── Comparison ───────────────────────────────────
      GoRoute(
        path: LumoRoutes.comparison,
        builder: (context, state) => const ComparisonScreen(),
      ),

      // ── Broker apply (placeholder) ───────────────────
      GoRoute(
        path: LumoRoutes.brokerApply,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Broker application — coming soon')),
        ),
      ),

      // ── Broker shell ─────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BrokerShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: LumoRoutes.brokerDashboard,
              builder: (context, state) => const BrokerDashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: LumoRoutes.brokerListings,
              builder: (context, state) => const BrokerListingsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: LumoRoutes.brokerSubmit,
              builder: (context, state) => const SubmitListingScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: LumoRoutes.brokerProfile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),

      // ── Main shell ───────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            LumoShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: LumoRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: LumoRoutes.search,
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return SearchScreen(
                  initialNeighborhood: extra?['neighborhood'] as String?,
                );
              },
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: LumoRoutes.map,
              builder: (context, state) => const MapScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: LumoRoutes.wishlist,
              builder: (context, state) => const WishlistScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: LumoRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
}
