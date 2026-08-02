import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/order_entity.dart';

part 'orders_providers.g.dart';

/// Lumo — Orders Provider
/// Returns the user's order history.
/// Mock data until Supabase orders table is wired.
@riverpod
Future<List<OrderEntity>> ordersList(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return _mockOrders;
}

@riverpod
Future<OrderEntity?> orderDetail(Ref ref, {required String orderId}) async {
  await Future.delayed(const Duration(milliseconds: 400));
  try {
    return _mockOrders.firstWhere((o) => o.id == orderId);
  } catch (_) {
    return null;
  }
}

// ─────────────────────────────────────────────
// Mock orders — replaced by Supabase queries
// ─────────────────────────────────────────────

final _mockOrders = [
  OrderEntity(
    id: 'ord_a1b2c3d4e5f6',
    status: OrderStatus.shipped,
    placedAt: DateTime.now().subtract(const Duration(days: 2)),
    subtotal: 248.00,
    shippingCost: 0.00,
    total: 248.00,
    deliveryAddress: '123 Main St, New York, NY 10001',
    paymentSummary: 'Visa ••••4242',
    trackingNumber: 'TRK-9821034',
    estimatedDelivery: DateTime.now().add(const Duration(days: 1)),
    items: const [
      OrderItemEntity(
        productId: 'p1',
        title: 'Merino Wool Crewneck',
        brand: 'Everlane',
        imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
        price: 98.00,
        quantity: 1,
      ),
      OrderItemEntity(
        productId: 'p2',
        title: 'Slim Fit Chinos',
        brand: 'Uniqlo',
        imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400',
        price: 75.00,
        quantity: 2,
      ),
    ],
    timeline: [
      OrderTimelineEvent(
        status: OrderStatus.pending,
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
        description: 'Order received',
      ),
      OrderTimelineEvent(
        status: OrderStatus.confirmed,
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
        description: 'Payment confirmed',
      ),
      OrderTimelineEvent(
        status: OrderStatus.preparing,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
        description: 'Being packed at warehouse',
      ),
      OrderTimelineEvent(
        status: OrderStatus.shipped,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        description: 'Picked up by courier',
      ),
    ],
  ),
  OrderEntity(
    id: 'ord_x9y8z7w6v5u4',
    status: OrderStatus.delivered,
    placedAt: DateTime.now().subtract(const Duration(days: 14)),
    subtotal: 129.00,
    shippingCost: 5.99,
    total: 134.99,
    deliveryAddress: '123 Main St, New York, NY 10001',
    paymentSummary: 'Mastercard ••••8891',
    items: const [
      OrderItemEntity(
        productId: 'p3',
        title: 'Leather Minimalist Wallet',
        brand: 'Bellroy',
        imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=400',
        price: 129.00,
        quantity: 1,
      ),
    ],
    timeline: [
      OrderTimelineEvent(
        status: OrderStatus.pending,
        timestamp: DateTime.now().subtract(const Duration(days: 14)),
        description: 'Order received',
      ),
      OrderTimelineEvent(
        status: OrderStatus.confirmed,
        timestamp: DateTime.now().subtract(const Duration(days: 13, hours: 22)),
        description: 'Payment confirmed',
      ),
      OrderTimelineEvent(
        status: OrderStatus.preparing,
        timestamp: DateTime.now().subtract(const Duration(days: 13)),
        description: 'Being packed at warehouse',
      ),
      OrderTimelineEvent(
        status: OrderStatus.shipped,
        timestamp: DateTime.now().subtract(const Duration(days: 12)),
        description: 'Picked up by courier',
      ),
      OrderTimelineEvent(
        status: OrderStatus.delivered,
        timestamp: DateTime.now().subtract(const Duration(days: 11)),
        description: 'Delivered to your door',
      ),
    ],
  ),
];
