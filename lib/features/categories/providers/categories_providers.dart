import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/category_entity.dart';
import '../../search/domain/entities/search_result_entity.dart';

part 'categories_providers.g.dart';

@riverpod
Future<List<CategoryEntity>> categoriesList(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return _mockCategories;
}

@riverpod
Future<CategoryEntity?> categoryDetail(
  Ref ref, {
  required String categoryId,
}) async {
  await Future.delayed(const Duration(milliseconds: 300));
  try {
    return _mockCategories.firstWhere((c) => c.id == categoryId);
  } catch (_) {
    return null;
  }
}

@riverpod
Future<List<SearchResultEntity>> categoryProducts(
  Ref ref, {
  required String categoryId,
}) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return _mockCategoryProducts[categoryId] ?? [];
}

// ─── Mock data ────────────────────────────────────────────────────────────────

final _mockCategories = [
  const CategoryEntity(
    id: 'clothing',
    name: 'Clothing',
    imageUrl:
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
    productCount: 142,
    description: 'Timeless pieces built to last.',
  ),
  const CategoryEntity(
    id: 'footwear',
    name: 'Footwear',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    productCount: 68,
    description: 'Every step, considered.',
  ),
  const CategoryEntity(
    id: 'accessories',
    name: 'Accessories',
    imageUrl:
        'https://images.unsplash.com/photo-1627123424574-724758594e93?w=800',
    productCount: 95,
    description: 'The details that define you.',
  ),
  const CategoryEntity(
    id: 'home',
    name: 'Home',
    imageUrl:
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800',
    productCount: 54,
    description: 'Objects worth living with.',
  ),
  const CategoryEntity(
    id: 'beauty',
    name: 'Beauty',
    imageUrl:
        'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800',
    productCount: 37,
    description: 'Rituals, refined.',
  ),
  const CategoryEntity(
    id: 'tech',
    name: 'Tech',
    imageUrl:
        'https://images.unsplash.com/photo-1491933382434-500287f9b54b?w=800',
    productCount: 29,
    description: 'Tools that disappear into life.',
  ),
];

final _mockCategoryProducts = <String, List<SearchResultEntity>>{
  'clothing': [
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
  ],
  'footwear': [
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
      productId: 'p10',
      title: 'Leather Derby Shoes',
      brand: 'Thursday Boot Co.',
      price: 199,
      imageUrl:
          'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?w=400',
      rating: 4.6,
      categoryId: 'footwear',
    ),
  ],
  'accessories': [
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
      productId: 'p7',
      title: 'Canvas Tote Bag',
      brand: 'Baggu',
      price: 38,
      imageUrl:
          'https://images.unsplash.com/photo-1544816155-12df9643f363?w=400',
      rating: 4.4,
      categoryId: 'accessories',
    ),
  ],
  'home': [
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
  ],
};
