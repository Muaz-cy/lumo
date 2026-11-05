import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/core/router/app_router.dart';
import 'package:lumo/features/authentication/providers/auth_providers.dart';
import 'package:lumo/features/inquiry/providers/inquiry_providers.dart';
import 'package:lumo/features/wishlist/providers/saved_providers.dart';
import 'package:lumo/shared/design_system/design_system.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final savedCount = ref.watch(savedNotifierProvider).length;
    final inquiryCount = ref.watch(inquiryNotifierProvider).length;

    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _Header(user: user)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
              sliver: SliverToBoxAdapter(
                child: _StatsRow(savedCount: savedCount, inquiryCount: inquiryCount),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: LumoSpacing.space32)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
              sliver: SliverToBoxAdapter(
                child: _MenuSection(
                  title: 'My Activity',
                  items: [
                    _MenuItem(
                      icon: Icons.bookmark_border_rounded,
                      label: 'Saved Properties',
                      onTap: () => context.go(LumoRoutes.wishlist),
                    ),
                    _MenuItem(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'My Inquiries',
                      onTap: () => context.push(LumoRoutes.inquiries),
                    ),
                    _MenuItem(
                      icon: Icons.history_rounded,
                      label: 'Recently Viewed',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: LumoSpacing.space16)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
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
                      icon: Icons.language_outlined,
                      label: 'Language',
                      onTap: () {},
                      trailing: Text(
                        'English',
                        style: LumoTypography.bodySmall.copyWith(
                          color: LumoColors.lightTextSecondary,
                        ),
                      ),
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

            const SliverToBoxAdapter(child: SizedBox(height: LumoSpacing.space16)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
              sliver: SliverToBoxAdapter(
                child: _SignOutButton(
                  onTap: () async {
                    await ref.read(authNotifierProvider.notifier).signOut();
                    if (context.mounted) context.go(LumoRoutes.splash);
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: LumoSpacing.space80)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final isGuest = user == null || user.isGuest;
    final name = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : (user?.email?.isNotEmpty == true ? user!.email!.split('@').first : 'Guest');
    final email = user?.email ?? '';
    final avatarUrl = user?.avatarUrl;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'G';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24, LumoSpacing.space32,
        LumoSpacing.space24, LumoSpacing.space24,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64, height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: LumoColors.lightSurfaceSecondary,
            ),
            clipBehavior: Clip.antiAlias,
            child: avatarUrl != null
                ? CachedNetworkImage(
                    imageUrl: avatarUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => _Initial(initial: initial),
                  )
                : _Initial(initial: initial),
          ),
          const SizedBox(width: LumoSpacing.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: LumoTypography.headlineSmall.copyWith(
                          color: LumoColors.lightPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: LumoSpacing.space8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: LumoSpacing.space8, vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: LumoColors.lightSurfaceSecondary,
                        borderRadius: LumoRadius.borderPill,
                        border: Border.all(color: LumoColors.lightBorder),
                      ),
                      child: Text(
                        isGuest ? 'Guest' : 'Member',
                        style: LumoTypography.labelSmall.copyWith(
                          color: LumoColors.lightTextSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LumoSpacing.space4),
                if (email.isNotEmpty)
                  Text(
                    email,
                    style: LumoTypography.bodySmall.copyWith(
                      color: LumoColors.lightTextSecondary,
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => context.go(LumoRoutes.login),
                    child: Text(
                      'Sign in to save properties',
                      style: LumoTypography.labelMedium.copyWith(
                        color: LumoColors.lightGold,
                      ),
                    ),
                  ),
              ],
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

class _Initial extends StatelessWidget {
  const _Initial({required this.initial});
  final String initial;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initial,
        style: LumoTypography.headlineMedium.copyWith(
          color: LumoColors.lightTextSecondary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Stats row
// ─────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.savedCount, required this.inquiryCount});
  final int savedCount;
  final int inquiryCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: LumoSpacing.space20),
      decoration: BoxDecoration(
        color: LumoColors.lightSurface,
        borderRadius: LumoRadius.borderLarge,
        border: Border.all(color: LumoColors.lightBorder),
      ),
      child: Row(
        children: [
          _StatItem(value: '$savedCount', label: 'Saved'),
          Container(width: 1, height: 28, color: LumoColors.lightDivider),
          _StatItem(value: '$inquiryCount', label: 'Inquiries'),
          Container(width: 1, height: 28, color: LumoColors.lightDivider),
          const _StatItem(value: '0', label: 'Viewed'),
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
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: LumoTypography.headlineSmall.copyWith(
              color: LumoColors.lightPrimary,
            ),
          ),
          const SizedBox(height: LumoSpacing.space4),
          Text(
            label,
            style: LumoTypography.bodySmall.copyWith(
              color: LumoColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Menu section
// ─────────────────────────────────────────────

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.title, required this.items});
  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: LumoSpacing.space4,
            bottom: LumoSpacing.space10,
          ),
          child: Text(
            title.toUpperCase(),
            style: LumoTypography.labelSmall.copyWith(
              color: LumoColors.lightTextTertiary,
              letterSpacing: 1.2,
              fontSize: 10,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: LumoColors.lightSurface,
            borderRadius: LumoRadius.borderLarge,
            border: Border.all(color: LumoColors.lightBorder),
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
                      indent: LumoSpacing.space52,
                      color: LumoColors.lightDivider,
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
    final labelColor = destructive ? LumoColors.lightError : LumoColors.lightPrimary;
    final iconColor = destructive ? LumoColors.lightError : LumoColors.lightTextSecondary;

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
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: LumoSpacing.space16),
            Expanded(
              child: Text(
                label,
                style: LumoTypography.bodyMedium.copyWith(color: labelColor),
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: LumoColors.lightTextTertiary,
                ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sign out
// ─────────────────────────────────────────────

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LumoColors.lightSurface,
        borderRadius: LumoRadius.borderLarge,
        border: Border.all(color: LumoColors.lightBorder),
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
