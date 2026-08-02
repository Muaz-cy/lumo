import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/search_result_entity.dart';

part 'search_providers.g.dart';

// ─── Recent History ───────────────────────────────────────────────────────────

const _historyKey = 'lumo_search_history';
const _maxHistory = 8;

@riverpod
class SearchHistory extends _$SearchHistory {
  @override
  List<String> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_historyKey) ?? [];
    state = saved;
  }

  Future<void> add(String query) async {
    if (query.trim().isEmpty) return;
    final updated = [
      query.trim(),
      ...state.where((q) => q != query.trim()),
    ].take(_maxHistory).toList();
    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, updated);
  }

  Future<void> remove(String query) async {
    final updated = state.where((q) => q != query).toList();
    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, updated);
  }

  Future<void> clear() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}

// ─── Trending ─────────────────────────────────────────────────────────────────

@riverpod
List<String> trendingSearches(Ref ref) {
  return [
    'Merino wool',
    'Minimalist wallet',
    'Linen shirt',
    'Leather sneakers',
    'Cashmere sweater',
    'Slim chinos',
    'Canvas tote',
    'Ceramic mug',
  ];
}

// ─── Search Query State ───────────────────────────────────────────────────────

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
  void clear() => state = '';
}

// ─── Search Results ───────────────────────────────────────────────────────────

@riverpod
Future<List<SearchResultEntity>> searchResults(
  Ref ref, {
  required String query,
}) async {
  if (query.trim().isEmpty) return [];
  // Simulate network latency
  await Future.delayed(const Duration(milliseconds: 500));
  final q = query.toLowerCase();
  return _mockProducts
      .where(
        (p) =>
            p.title.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.categoryId.toLowerCase().contains(q),
      )
      .toList();
}

// ─── Mock data — replaced by Supabase full-text search ───────────────────────

final _mockProducts = [
  const SearchResultEntity(
    productId: 'p1',
    title: 'Merino Wool Crewneck',
    brand: 'Everlane',
    price: 98,
    originalPrice: 128,
    imageUrl:
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
    rating: 4.7,
    categoryId: 'clothing',
  ),
  const SearchResultEntity(
    productId: 'p2',
    title: 'Slim Fit Chinos',
    brand: 'Uniqlo',
    price: 75,
    imageUrl:
        'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400',
    rating: 4.5,
    categoryId: 'clothing',
  ),
  const SearchResultEntity(
    productId: 'p3',
    title: 'Leather Minimalist Wallet',
    brand: 'Bellroy',
    price: 129,
    imageUrl:
        'https://images.unsplash.com/photo-1627123424574-724758594e93?w=400',
    rating: 4.9,
    categoryId: 'accessories',
  ),
  const SearchResultEntity(
    productId: 'p4',
    title: 'Linen Button-Down Shirt',
    brand: 'COS',
    price: 89,
    originalPrice: 110,
    imageUrl:
        'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
    rating: 4.6,
    categoryId: 'clothing',
  ),
  const SearchResultEntity(
    productId: 'p5',
    title: 'White Leather Sneakers',
    brand: 'Common Projects',
    price: 420,
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
    rating: 4.8,
    categoryId: 'footwear',
  ),
  const SearchResultEntity(
    productId: 'p6',
    title: 'Cashmere Turtleneck',
    brand: 'Everlane',
    price: 165,
    originalPrice: 200,
    imageUrl:
        'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400',
    rating: 4.7,
    categoryId: 'clothing',
  ),
  const SearchResultEntity(
    productId: 'p7',
    title: 'Canvas Tote Bag',
    brand: 'Baggu',
    price: 38,
    imageUrl:
        'https://images.unsplash.com/photo-1544816155-12df9643f363?w=400',
    rating: 4.4,
    categoryId: 'accessories',
  ),
  const SearchResultEntity(
    productId: 'p8',
    title: 'Ceramic Pour-Over Set',
    brand: 'Fellow',
    price: 95,
    imageUrl:
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
    rating: 4.9,
    categoryId: 'home',
  ),
  const SearchResultEntity(
    productId: 'p9',
    title: 'Wool Overcoat',
    brand: 'COS',
    price: 340,
    originalPrice: 420,
    imageUrl:
        'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=400',
    rating: 4.8,
    categoryId: 'clothing',
  ),
  const SearchResultEntity(
    productId: 'p10',
    title: 'Leather Derby Shoes',
    brand: 'Thursday Boot Co.',
    price: 199,
    imageUrl:
        'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?w=400',
    rating: 4.6,
    categoryId: 'footwear',
  ),
];
