import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/shared/design_system/design_system.dart';
import '../domain/entities/notification_entity.dart';
import '../providers/notifications_providers.dart';

/// Lumo Notifications Screen
/// Emotional purpose: Keep users informed without overwhelming them.
/// Every notification should feel relevant and timely.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsNotifierProvider);
    final notifier = ref.read(notificationsNotifierProvider.notifier);
    final colors = Theme.of(context).colorScheme;
    final unread = notifications.where((n) => !n.isRead).length;

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
          'Notifications',
          style: LumoTypography.titleLarge.copyWith(color: colors.onSurface),
        ),
        centerTitle: true,
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: notifier.markAllRead,
              child: Text(
                'Mark all read',
                style: LumoTypography.labelMedium.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const _EmptyNotifications()
          : _NotificationsList(
              notifications: notifications,
              notifier: notifier,
            ),
    );
  }
}

// ─── Notifications list ───────────────────────────────────────────────────────

class _NotificationsList extends StatelessWidget {
  const _NotificationsList({
    required this.notifications,
    required this.notifier,
  });

  final List<NotificationEntity> notifications;
  final NotificationsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    // Group by Today / Earlier
    final today = notifications
        .where((n) => _isToday(n.createdAt))
        .toList();
    final earlier = notifications
        .where((n) => !_isToday(n.createdAt))
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space16,
        LumoSpacing.space8,
        LumoSpacing.space16,
        LumoSpacing.space80,
      ),
      children: [
        if (today.isNotEmpty) ...[
          _GroupHeader(label: 'Today'),
          ...today.asMap().entries.map(
                (e) => _NotificationTile(
                  notification: e.value,
                  index: e.key,
                  onTap: () => _onTap(context, e.value, notifier),
                  onDismiss: () => notifier.dismiss(e.value.id),
                ),
              ),
        ],
        if (earlier.isNotEmpty) ...[
          if (today.isNotEmpty) const SizedBox(height: LumoSpacing.space8),
          _GroupHeader(label: 'Earlier'),
          ...earlier.asMap().entries.map(
                (e) => _NotificationTile(
                  notification: e.value,
                  index: today.length + e.key,
                  onTap: () => _onTap(context, e.value, notifier),
                  onDismiss: () => notifier.dismiss(e.value.id),
                ),
              ),
        ],
      ],
    );
  }

  void _onTap(
    BuildContext context,
    NotificationEntity n,
    NotificationsNotifier notifier,
  ) {
    notifier.markRead(n.id);
    if (n.actionRoute != null) context.push(n.actionRoute!);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space8,
        LumoSpacing.space8,
        LumoSpacing.space8,
        LumoSpacing.space4,
      ),
      child: Text(
        label,
        style: LumoTypography.labelMedium.copyWith(
          color: colors.onSurface.withValues(alpha: 0.4),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Notification tile ────────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.index,
    required this.onTap,
    required this.onDismiss,
  });

  final NotificationEntity notification;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: LumoSpacing.space24),
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: LumoRadius.borderLarge,
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: colors.error,
          size: 22,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: LumoMotion.fast,
          margin: const EdgeInsets.only(bottom: LumoSpacing.space8),
          padding: const EdgeInsets.all(LumoSpacing.space16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? colors.surface
                : colors.surfaceContainerHighest,
            borderRadius: LumoRadius.borderLarge,
            border: Border.all(
              color: notification.isRead
                  ? colors.outline
                  : colors.outline.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon or image
              _NotificationIcon(notification: notification),
              const SizedBox(width: LumoSpacing.space12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: LumoTypography.labelLarge.copyWith(
                              color: colors.onSurface,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: LumoSpacing.space8),
                        Text(
                          _formatTime(notification.createdAt),
                          style: LumoTypography.bodySmall.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.35),
                          ),
                        ),
                        if (!notification.isRead) ...[
                          const SizedBox(width: LumoSpacing.space8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: LumoSpacing.space4),
                    Text(
                      notification.body,
                      style: LumoTypography.bodySmall.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.6),
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideX(begin: 0.03, end: 0);
  }

  String _formatTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${(diff.inDays / 7).floor()}w';
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.notification});
  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (notification.imageUrl != null) {
      return ClipRRect(
        borderRadius: LumoRadius.borderMedium,
        child: CachedNetworkImage(
          imageUrl: notification.imageUrl!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            width: 48,
            height: 48,
            color: colors.surfaceContainerHighest,
          ),
          errorWidget: (_, __, ___) => _TypeIcon(
            type: notification.type,
            colors: colors,
          ),
        ),
      );
    }

    return _TypeIcon(type: notification.type, colors: colors);
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type, required this.colors});
  final NotificationType type;
  final ColorScheme colors;

  IconData get _icon => switch (type) {
        NotificationType.order => Icons.home_outlined,
        NotificationType.promo => Icons.calendar_today_outlined,
        NotificationType.newArrival => Icons.fiber_new_outlined,
        NotificationType.system => Icons.info_outline_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: LumoRadius.borderMedium,
      ),
      child: Icon(_icon, size: 22, color: colors.onPrimaryContainer),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LumoSpacing.space48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 56,
              color: colors.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: LumoSpacing.space24),
            Text(
              'All caught up',
              style: LumoTypography.headlineSmall.copyWith(
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: LumoSpacing.space8),
            Text(
              'No new notifications right now.',
              style: LumoTypography.bodyMedium.copyWith(
                color: colors.onSurface.withValues(alpha: 0.45),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: LumoMotion.deliberate, curve: LumoMotion.enter)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
}
