/// Lumo — Notification Entity
enum NotificationType { order, promo, newArrival, system }

extension NotificationTypeX on NotificationType {
  String get label => switch (this) {
        NotificationType.order => 'Order',
        NotificationType.promo => 'Offer',
        NotificationType.newArrival => 'New',
        NotificationType.system => 'Info',
      };
}

final class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.imageUrl,
    this.actionRoute,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? imageUrl;

  /// Optional deep-link route on tap.
  final String? actionRoute;

  NotificationEntity copyWith({bool? isRead}) => NotificationEntity(
        id: id,
        type: type,
        title: title,
        body: body,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
        imageUrl: imageUrl,
        actionRoute: actionRoute,
      );
}
