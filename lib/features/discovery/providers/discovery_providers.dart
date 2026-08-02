import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/editorial_card_entity.dart';

part 'discovery_providers.g.dart';

@riverpod
Future<List<EditorialCardEntity>> discoveryFeed(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return _mockFeed;
}

// ─── Mock editorial feed ──────────────────────────────────────────────────────

final _mockFeed = [
  const EditorialCardEntity(
    id: 'ed1',
    headline: 'The New\nMinimalism',
    subheadline: 'Less, but better. A curated edit of pieces that earn their place.',
    imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=900',
    size: EditorialCardSize.hero,
    tag: 'Editorial',
    actionLabel: 'Explore',
    actionRoute: '/categories/clothing',
  ),
  const EditorialCardEntity(
    id: 'ed2',
    headline: 'Walk Quietly',
    subheadline: 'Footwear that speaks through restraint.',
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=700',
    size: EditorialCardSize.wide,
    tag: 'Footwear',
    actionLabel: 'Shop now',
    actionRoute: '/categories/footwear',
  ),
  const EditorialCardEntity(
    id: 'ed3',
    headline: 'Objects\nof Desire',
    subheadline: 'Home goods worth living with.',
    imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600',
    size: EditorialCardSize.square,
    tag: 'Home',
    actionLabel: 'Discover',
    actionRoute: '/categories/home',
  ),
  const EditorialCardEntity(
    id: 'ed4',
    headline: 'The Detail\nIs the Design',
    subheadline: 'Accessories that complete the picture.',
    imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600',
    size: EditorialCardSize.square,
    tag: 'Accessories',
    actionLabel: 'Shop',
    actionRoute: '/categories/accessories',
  ),
  const EditorialCardEntity(
    id: 'ed5',
    headline: 'Dressed for\nEverywhere',
    subheadline: 'Versatile pieces that move with your life.',
    imageUrl: 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=900',
    size: EditorialCardSize.hero,
    tag: 'New Arrivals',
    actionLabel: 'See collection',
    actionRoute: '/categories/clothing',
  ),
  const EditorialCardEntity(
    id: 'ed6',
    headline: 'Morning\nRitual',
    subheadline: 'Beauty essentials, stripped back.',
    imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=700',
    size: EditorialCardSize.wide,
    tag: 'Beauty',
    actionLabel: 'Explore',
    actionRoute: '/categories/beauty',
  ),
];
