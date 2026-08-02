import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/notification_entity.dart';

part 'notifications_providers.g.dart';

@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  List<NotificationEntity> build() => _mockNotifications;

  void markRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  void markAllRead() {
    state = [for (final n in state) n.copyWith(isRead: true)];
  }

  void dismiss(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  int get unreadCount => state.where((n) => !n.isRead).length;
}

// ─── Mock data ────────────────────────────────────────────────────────────────

final _mockNotifications = [
  NotificationEntity(
    id: 'n1',
    type: NotificationType.order,
    title: 'Your order is on its way',
    body: 'Order #ORD-A1B2 has been picked up by the courier and is heading to you.',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    isRead: false,
    actionRoute: '/orders/ord_a1b2c3d4e5f6',
  ),
  NotificationEntity(
    id: 'n2',
    type: NotificationType.promo,
    title: 'Weekend offer — 20% off',
    body: 'Use code LUMO20 at checkout. Valid on all clothing until Sunday.',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    isRead: false,
    imageUrl:
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
  ),
  NotificationEntity(
    id: 'n3',
    type: NotificationType.newArrival,
    title: 'New arrivals in Footwear',
    body: 'The Spring collection just dropped. Explore new styles from Common Projects and more.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    isRead: false,
    actionRoute: '/categories/footwear',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
  ),
  NotificationEntity(
    id: 'n4',
    type: NotificationType.order,
    title: 'Order delivered',
    body: 'Your order #ORD-X9Y8 was delivered. We hope you love it.',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    isRead: true,
    actionRoute: '/orders/ord_x9y8z7w6v5u4',
  ),
  NotificationEntity(
    id: 'n5',
    type: NotificationType.system,
    title: 'Welcome to Lumo',
    body: 'Discover a curated world of premium products. Your wishlist and cart are always saved.',
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    isRead: true,
  ),
];
