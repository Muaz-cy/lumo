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
    type: NotificationType.newArrival,
    title: 'New listing in Bole',
    body: '3-bedroom apartment just listed in Bole Medhanialem. ETB 8.5M — verified by Lumo.',
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    isRead: false,
    actionRoute: '/property/a0000000-0000-0000-0000-000000000001',
    imageUrl: 'https://res.cloudinary.com/vf4zqyla/image/upload/v1793848690/lumo/properties/apt_ext_01.jpg',
  ),
  NotificationEntity(
    id: 'n2',
    type: NotificationType.promo,
    title: 'Free consultation this week',
    body: 'Book a call with a Lumo property expert at no cost. Limited slots available.',
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    isRead: false,
  ),
  NotificationEntity(
    id: 'n3',
    type: NotificationType.newArrival,
    title: 'Price drop in CMC',
    body: 'A 5-bed villa in CMC was reduced by ETB 2M. Now listed at ETB 22M.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    isRead: false,
    actionRoute: '/property/b0000000-0000-0000-0000-000000000001',
    imageUrl: 'https://res.cloudinary.com/vf4zqyla/image/upload/v1793848696/lumo/properties/villa_01.jpg',
  ),
  NotificationEntity(
    id: 'n4',
    type: NotificationType.system,
    title: 'Your inquiry was received',
    body: 'A Lumo broker will contact you within 24 hours regarding the Old Airport property.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    isRead: true,
  ),
  NotificationEntity(
    id: 'n5',
    type: NotificationType.system,
    title: 'Welcome to Lumo',
    body: 'Your home, back home. Browse verified properties across Addis Ababa.',
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    isRead: true,
  ),
];
