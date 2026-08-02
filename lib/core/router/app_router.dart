import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/authentication/presentation/splash_screen.dart';
import '../../features/authentication/presentation/onboarding_screen.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/register_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/product/presentation/product_detail_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/wishlist/presentation/wishlist_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/orders/presentation/order_confirmation_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/orders/presentation/order_detail_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/categories/presentation/categories_screen.dart';
import '../../features/discovery/presentation/discovery_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/reviews/presentation/reviews_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../shared/widgets/lumo_shell.dart';

part 'app_router.g.dart';

/// Route name constants — never use raw strings for navigation.
abstract final class LumoRoutes {
  // Auth
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';

  // Shell tabs
  static const home = '/home';
  static const search = '/search';
  static const wishlist = '/wishlist';
  static const cart = '/cart';
  static const profile = '/profile';

  // Product
  static const productDetail = '/product/:id';

  // Checkout funnel
  static const checkout = '/checkout';
  static const orderConfirmation = '/order-confirmation/:id';
  static const orders = '/orders';
  static const orderDetail = '/orders/:id';

  // Discovery
  static const discovery = '/discovery';
  static const categories = '/categories';
  static const categoryDetail = '/categories/:id';

  // Reviews
  static const reviews = '/reviews/:productId';

  // Account
  static const settings = '/settings';
  static const notifications = '/notifications';
}

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: LumoRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // ── Auth (no shell) ──────────────────────────────
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

      // ── Product detail (no shell — full screen) ──────
      GoRoute(
        path: LumoRoutes.productDetail,
        builder: (context, state) => ProductDetailScreen(
          productId: state.pathParameters['id']!,
        ),
      ),

      // ── Checkout funnel (no shell) ───────────────────
      GoRoute(
        path: LumoRoutes.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: LumoRoutes.orderConfirmation,
        builder: (context, state) => OrderConfirmationScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: LumoRoutes.orders,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: LumoRoutes.orderDetail,
        builder: (context, state) => OrderDetailScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),

      // ── Discovery (no shell — full screen) ───────────
      GoRoute(
        path: LumoRoutes.discovery,
        builder: (context, state) => const DiscoveryScreen(),
      ),
      GoRoute(
        path: LumoRoutes.categories,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: LumoRoutes.categoryDetail,
        builder: (context, state) => CategoryDetailScreen(
          categoryId: state.pathParameters['id']!,
        ),
      ),

      // ── Account (no shell) ───────────────────────────
      GoRoute(
        path: LumoRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: LumoRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: LumoRoutes.reviews,
        builder: (context, state) => ReviewsScreen(
          productId: state.pathParameters['productId']!,
        ),
      ),

      // ── Main shell — persistent bottom nav ───────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            LumoShell(navigationShell: navigationShell),
        branches: [
          // 0 — Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: LumoRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // 1 — Search
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: LumoRoutes.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          // 2 — Wishlist
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: LumoRoutes.wishlist,
                builder: (context, state) => const WishlistScreen(),
              ),
            ],
          ),
          // 3 — Cart
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: LumoRoutes.cart,
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          // 4 — Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: LumoRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

