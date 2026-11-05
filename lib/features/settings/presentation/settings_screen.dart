import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import 'package:lumo/shared/providers/currency_provider.dart';
import 'package:lumo/shared/providers/locale_provider.dart';
import 'package:lumo/shared/providers/theme_provider.dart';
import '../providers/settings_providers.dart';

/// Lumo Settings Screen
/// Emotional purpose: Give users control without overwhelming them.
/// Every setting has a clear purpose. Nothing is buried.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeNotifierProvider);
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final locale = ref.watch(localeNotifierProvider);
    final currency = ref.watch(currencyDisplayNotifierProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: LumoTypography.titleLarge.copyWith(color: colors.onSurface),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          LumoSpacing.space24,
          LumoSpacing.space16,
          LumoSpacing.space24,
          LumoSpacing.space80,
        ),
        children: [
          // Language
          _SettingsSection(
            title: 'Language',
            children: [
              _LanguageSelector(currentLocale: locale, ref: ref),
            ],
          ),

          const SizedBox(height: LumoSpacing.space16),

          // Currency
          _SettingsSection(
            title: 'Currency Display',
            children: [
              _CurrencySelector(current: currency, ref: ref),
            ],
          ),

          const SizedBox(height: LumoSpacing.space16),

          // Appearance
          _SettingsSection(
            title: 'Appearance',
            children: [
              _ThemeSelector(currentMode: themeMode, ref: ref),
            ],
          ),

          const SizedBox(height: LumoSpacing.space16),

          // Notifications
          _SettingsSection(
            title: 'Notifications',
            children: [
              _ToggleTile(
                icon: Icons.local_offer_outlined,
                label: 'Promotions & offers',
                value: settings.promotionsEnabled,
                onChanged: notifier.setPromotions,
              ),
              _ToggleTile(
                icon: Icons.inventory_2_outlined,
                label: 'Order updates',
                value: settings.orderUpdatesEnabled,
                onChanged: notifier.setOrderUpdates,
              ),
              _ToggleTile(
                icon: Icons.new_releases_outlined,
                label: 'New arrivals',
                value: settings.newArrivalsEnabled,
                onChanged: notifier.setNewArrivals,
              ),
            ],
          ),

          const SizedBox(height: LumoSpacing.space16),

          // Privacy
          _SettingsSection(
            title: 'Privacy',
            children: [
              _ToggleTile(
                icon: Icons.analytics_outlined,
                label: 'Analytics',
                subtitle: 'Help improve Lumo',
                value: settings.analyticsEnabled,
                onChanged: notifier.setAnalytics,
              ),
              _ToggleTile(
                icon: Icons.ads_click_outlined,
                label: 'Personalised ads',
                value: settings.personalisedAdsEnabled,
                onChanged: notifier.setPersonalisedAds,
              ),
            ],
          ),

          const SizedBox(height: LumoSpacing.space16),

          // About
          _SettingsSection(
            title: 'About',
            children: [
              _InfoTile(
                icon: Icons.info_outline_rounded,
                label: 'Version',
                value: '1.0.0',
              ),
              _TapTile(
                icon: Icons.description_outlined,
                label: 'Terms of Service',
                onTap: () {},
              ),
              _TapTile(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: LumoSpacing.space32),

          // Danger zone
          _DangerSection(),
        ],
      )
          .animate()
          .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter),
    );
  }
}

// ─── Section wrapper ──────────────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

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
            children: children.asMap().entries.map((e) {
              final isLast = e.key == children.length - 1;
              return Column(
                children: [
                  e.value,
                  if (!isLast)
                    Divider(height: 1, color: colors.outline),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ─── Language Selector ───────────────────────────────────────────────────────

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.currentLocale, required this.ref});
  final Locale currentLocale;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final isEn = currentLocale.languageCode == 'en';
    return _SettingRow(
      icon: Icons.language_rounded,
      label: 'Language',
      control: _SegmentedRow(
        options: const ['English', 'አማርኛ'],
        selectedIndex: isEn ? 0 : 1,
        onSelect: (i) => i == 0
            ? ref.read(localeNotifierProvider.notifier).setEnglish()
            : ref.read(localeNotifierProvider.notifier).setAmharic(),
      ),
    );
  }
}

// ─── Currency Selector ────────────────────────────────────────────────────────

class _CurrencySelector extends StatelessWidget {
  const _CurrencySelector({required this.current, required this.ref});
  final CurrencyDisplay current;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final isUsd = current == CurrencyDisplay.usd;
    return _SettingRow(
      icon: Icons.currency_exchange_rounded,
      label: 'Price display',
      sublabel: 'ETB is the listing price. USD is an estimate.',
      control: _SegmentedRow(
        options: const ['ETB', 'USD'],
        selectedIndex: isUsd ? 1 : 0,
        onSelect: (i) => ref
            .read(currencyDisplayNotifierProvider.notifier)
            .set(i == 0 ? CurrencyDisplay.etb : CurrencyDisplay.usd),
      ),
    );
  }
}

// ─── Shared setting row ───────────────────────────────────────────────────────

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.control,
    this.sublabel,
  });
  final IconData icon;
  final String label;
  final String? sublabel;
  final Widget control;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: LumoSpacing.space16,
        vertical: LumoSpacing.space14,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.onSurface.withValues(alpha: 0.5)),
          const SizedBox(width: LumoSpacing.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: LumoTypography.bodyMedium
                        .copyWith(color: colors.onSurface)),
                if (sublabel != null)
                  Text(sublabel!,
                      style: LumoTypography.labelSmall.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.35))),
              ],
            ),
          ),
          const SizedBox(width: LumoSpacing.space16),
          control,
        ],
      ),
    );
  }
}

// ─── Segmented row — minimal underline style ──────────────────────────────────

class _SegmentedRow extends StatelessWidget {
  const _SegmentedRow({
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
  });
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outline.withValues(alpha: 0.5)),
        borderRadius: LumoRadius.borderSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.asMap().entries.map((e) {
          final isSelected = e.key == selectedIndex;
          final isFirst = e.key == 0;
          final isLast = e.key == options.length - 1;
          return GestureDetector(
            onTap: () => onSelect(e.key),
            child: AnimatedContainer(
              duration: LumoMotion.fast,
              padding: const EdgeInsets.symmetric(
                horizontal: LumoSpacing.space12,
                vertical: LumoSpacing.space8,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.onSurface.withValues(alpha: 0.06)
                    : Colors.transparent,
                borderRadius: BorderRadius.horizontal(
                  left: isFirst ? const Radius.circular(LumoRadius.small - 1) : Radius.zero,
                  right: isLast ? const Radius.circular(LumoRadius.small - 1) : Radius.zero,
                ),
                border: isSelected
                    ? Border(
                        bottom: BorderSide(
                          color: colors.onSurface.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      )
                    : null,
              ),
              child: Text(
                e.value,
                style: LumoTypography.labelMedium.copyWith(
                  color: isSelected
                      ? colors.onSurface
                      : colors.onSurface.withValues(alpha: 0.4),
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Theme Selector ───────────────────────────────────────────────────────────

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.currentMode, required this.ref});
  final ThemeMode currentMode;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(LumoSpacing.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.palette_outlined,
                size: 20,
                color: colors.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: LumoSpacing.space16),
              Text(
                'Theme',
                style: LumoTypography.bodyMedium.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: LumoSpacing.space16),
          Row(
            children: [
              _ThemeOption(
                label: 'Light',
                icon: Icons.light_mode_rounded,
                isSelected: currentMode == ThemeMode.light,
                onTap: () => ref
                    .read(themeNotifierProvider.notifier)
                    .setTheme(ThemeMode.light),
              ),
              const SizedBox(width: LumoSpacing.space8),
              _ThemeOption(
                label: 'Dark',
                icon: Icons.dark_mode_rounded,
                isSelected: currentMode == ThemeMode.dark,
                onTap: () => ref
                    .read(themeNotifierProvider.notifier)
                    .setTheme(ThemeMode.dark),
              ),
              const SizedBox(width: LumoSpacing.space8),
              _ThemeOption(
                label: 'System',
                icon: Icons.brightness_auto_rounded,
                isSelected: currentMode == ThemeMode.system,
                onTap: () => ref
                    .read(themeNotifierProvider.notifier)
                    .setTheme(ThemeMode.system),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: LumoMotion.fast,
          curve: LumoMotion.snap,
          padding: const EdgeInsets.symmetric(vertical: LumoSpacing.space12),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : colors.surface,
            borderRadius: LumoRadius.borderMedium,
            border: Border.all(
              color: isSelected ? colors.primary : colors.outline,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? colors.onPrimary
                    : colors.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(height: LumoSpacing.space4),
              Text(
                label,
                style: LumoTypography.labelSmall.copyWith(
                  color: isSelected
                      ? colors.onPrimary
                      : colors.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Toggle Tile ──────────────────────────────────────────────────────────────

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: LumoSpacing.space16,
        vertical: LumoSpacing.space12,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.onSurface.withValues(alpha: 0.7)),
          const SizedBox(width: LumoSpacing.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: LumoTypography.bodyMedium.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: LumoTypography.bodySmall.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colors.primary,
          ),
        ],
      ),
    );
  }
}

// ─── Info Tile ────────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: LumoSpacing.space16,
        vertical: LumoSpacing.space14,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.onSurface.withValues(alpha: 0.7)),
          const SizedBox(width: LumoSpacing.space16),
          Expanded(
            child: Text(
              label,
              style: LumoTypography.bodyMedium.copyWith(
                color: colors.onSurface,
              ),
            ),
          ),
          Text(
            value,
            style: LumoTypography.bodyMedium.copyWith(
              color: colors.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tap Tile ─────────────────────────────────────────────────────────────────

class _TapTile extends StatelessWidget {
  const _TapTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
            Icon(icon, size: 20, color: colors.onSurface.withValues(alpha: 0.7)),
            const SizedBox(width: LumoSpacing.space16),
            Expanded(
              child: Text(
                label,
                style: LumoTypography.bodyMedium.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
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

// ─── Danger Zone ─────────────────────────────────────────────────────────────

class _DangerSection extends StatelessWidget {
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
            'Danger Zone',
            style: LumoTypography.labelMedium.copyWith(
              color: colors.error.withValues(alpha: 0.6),
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.errorContainer.withValues(alpha: 0.3),
            borderRadius: LumoRadius.borderLarge,
          ),
          child: InkWell(
            onTap: () => _showDeleteDialog(context),
            borderRadius: LumoRadius.borderLarge,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LumoSpacing.space16,
                vertical: LumoSpacing.space14,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: colors.error,
                  ),
                  const SizedBox(width: LumoSpacing.space16),
                  Expanded(
                    child: Text(
                      'Delete Account',
                      style: LumoTypography.bodyMedium.copyWith(
                        color: colors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Delete Account',
          style: LumoTypography.titleLarge.copyWith(color: colors.onSurface),
        ),
        content: Text(
          'This action is permanent and cannot be undone. All your data will be deleted.',
          style: LumoTypography.bodyMedium.copyWith(
            color: colors.onSurface.withValues(alpha: 0.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Delete',
              style: TextStyle(color: colors.error),
            ),
          ),
        ],
      ),
    );
  }
}
