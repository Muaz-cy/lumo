import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/core/router/app_router.dart';
import 'package:lumo/features/authentication/providers/auth_providers.dart';
import 'package:lumo/features/orders/providers/orders_providers.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/widgets/lumo_skeleton.dart';

/// Lumo Profile Screen
/// Emotional purpose: Make the user feel known. This is their space.
/// Clean, personal, and a gateway to everything account-related.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final ordersAsync = ref.watch(ordersListProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _ProfileHeader(user: user),
            ),

            // Stats row
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: LumoSpacing.space24,
              ),
              sliver: SliverToBoxAdapter(
                child: ordersAsync.when(
                  loading: () => const _StatsSkeleton(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (orders) => _StatsRow(orderCount: orders.length),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: LumoSpacing.space32),
            ),

            // Menu sections
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: LumoSpacing.space24,
              ),
              sliver: SliverToBoxAdapter(
                child: _MenuSection(
                  title: 'Shopping',
                  items: [
                    _MenuItem(
                      icon: Icons.receipt_long_outlined,
                      label: 'My Orders',
                      onTap: () => context.push(LumoRoutes.orders),
                    ),
                    _MenuItem(
                      icon: Icons.favorite_border_rounded,
                      label: 'Wishlist',
                      onTap: () => context.go(LumoRoutes.wishlist),
                    ),
                    _MenuItem(
                      icon: Icons.location_on_outlined,
                      label: 'Saved Addresses',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.credit_card_outlined,
                      label: 'Payment Methods',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: LumoSpacing.space16),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: LumoSpacing.space24,
              ),
              sliver: SliverToBoxAdapter(
                child: _MenuSection(
                  title: 'Account',
                  items: [
                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      onTap: () => context.push(LumoRoutes.notifications),
                    ),
                    _MenuItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      onTap: () => context.push(LumoRoutes.settings),
                    ),
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & Support',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: LumoSpacing.space16),
            ),

            // Sign out
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: LumoSpacing.space24,
              ),
              sliver: SliverToBoxAdapter(
                child: _SignOutButton(
                  onTap: () async {
                    await ref.read(authNotifierProvider.notifier).signOut();
                    if (context.mounted) context.go(LumoRoutes.splash);
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: LumoSpacing.space80),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Header ───────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});
  final dynamic user; // AuthUserEntity?

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final name = user?.displayName ?? 'Guest';
    final email = user?.email ?? '';
    final avatarUrl = user?.avatarUrl;
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'G';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space32,
        LumoSpacing.space24,
        LumoSpacing.space24,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primaryContainer,
            ),
            clipBehavior: Clip.antiAlias,
            child: avatarUrl != null
                ? CachedNetworkImage(
                    imageUrl: avatarUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => _AvatarInitial(
                      initial: initials,
                      colors: colors,
                    ),
                  )
                : _AvatarInitial(initial: initials, colors: colors),
          ),
          const SizedBox(width: LumoSpacing.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: LumoTypography.headlineSmall.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: LumoSpacing.space2),
                  Text(
                    email,
                    style: LumoTypography.bodySmall.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit_outlined,
              size: 20,
              color: colors.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideY(begin: -0.05, end: 0);
  }
}

class _AvatarInitial extends StatelessWidget {
  const _AvatarInitial({required this.initial, required this.colors});
  final String initial;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initial,
        style: LumoTypography.headlineMedium.copyWith(
          color: colors.onPrimaryContainer,
        ),
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.orderCount});
  final int orderCount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: LumoSpacing.space20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: LumoRadius.borderLarge,
      ),
      child: Row(
        children: [
          _StatItem(value: '$orderCount', label: 'Orders'),
          _StatDivider(),
          _StatItem(value: '0', label: 'Reviews'),
          _StatDivider(),
          _StatItem(value: '0', label: 'Saved'),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideY(begin: 0.05, end: 0);
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: LumoTypography.headlineSmall.copyWith(
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: LumoSpacing.space4),
          Text(
            label,
            style: LumoTypography.bodySmall.copyWith(
              color: colors.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Theme.of(context).colorScheme.outline,
    );
  }
}

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton();

  @override
  Widget build(BuildContext context) {
    return LumoSkeleton(
      width: double.infinity,
      height: 80,
      borderRadius: LumoRadius.borderLarge,
    );
  }
}

// ─── Menu Section ─────────────────────────────────────────────────────────────

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.title, required this.items});
  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: LumoSpacing.space4,
            bottom: LumoSpacing.space8,
          ),
          child: Text(
            title,
            style: LumoTypography.labelMedium.copyWith(
              color: colors.onSurface.withValues(alpha: 0.4),
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: LumoRadius.borderLarge,
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  e.value,
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: LumoSpacing.space48,
                      color: colors.outline,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = destructive
        ? colors.error
        : colors.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: LumoRadius.borderLarge,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: LumoSpacing.space16,
          vertical: LumoSpacing.space14,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color.withValues(alpha: 0.7)),
            const SizedBox(width: LumoSpacing.space16),
            Expanded(
              child: Text(
                label,
                style: LumoTypography.bodyMedium.copyWith(color: color),
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: colors.onSurface.withValues(alpha: 0.25),
                ),
          ],
        ),
      ),
    );
  }
}

// ─── Sign Out ─────────────────────────────────────────────────────────────────

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: 0.4),
        borderRadius: LumoRadius.borderLarge,
      ),
      child: _MenuItem(
        icon: Icons.logout_rounded,
        label: 'Sign out',
        onTap: onTap,
        destructive: true,
        trailing: const SizedBox.shrink(),
      ),
    );
  }
}
