/// Lumo — Order Entity
/// Pure domain. No Flutter. No Supabase.
/// Represents a placed order with its full lifecycle.
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
  returned,
}

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
        OrderStatus.pending => 'Pending',
        OrderStatus.confirmed => 'Confirmed',
        OrderStatus.preparing => 'Preparing',
        OrderStatus.shipped => 'Shipped',
        OrderStatus.outForDelivery => 'Out for delivery',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.cancelled => 'Cancelled',
        OrderStatus.returned => 'Returned',
      };

  bool get isActive => switch (this) {
        OrderStatus.delivered ||
        OrderStatus.cancelled ||
        OrderStatus.returned =>
          false,
        _ => true,
      };
}

final class OrderItemEntity {
  const OrderItemEntity({
    required this.productId,
    required this.title,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  final String productId;
  final String title;
  final String brand;
  final String imageUrl;
  final double price;
  final int quantity;

  double get subtotal => price * quantity;
}

final class OrderTimelineEvent {
  const OrderTimelineEvent({
    required this.status,
    required this.timestamp,
    this.description,
  });

  final OrderStatus status;
  final DateTime timestamp;
  final String? description;
}

final class OrderEntity {
  const OrderEntity({
    required this.id,
    required this.status,
    required this.items,
    required this.placedAt,
    required this.subtotal,
    required this.shippingCost,
    required this.total,
    required this.deliveryAddress,
    required this.paymentSummary,
    this.timeline = const [],
    this.trackingNumber,
    this.estimatedDelivery,
  });

  final String id;
  final OrderStatus status;
  final List<OrderItemEntity> items;
  final DateTime placedAt;
  final double subtotal;
  final double shippingCost;
  final double total;
  final String deliveryAddress;
  final String paymentSummary;
  final List<OrderTimelineEvent> timeline;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  String get displayId => id.length > 8
      ? '#${id.substring(id.length - 8).toUpperCase()}'
      : '#${id.toUpperCase()}';
}
