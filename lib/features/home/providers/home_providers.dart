import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/home_section.dart';
import '../../property/domain/entities/property_entity.dart';

part 'home_providers.g.dart';

SupabaseClient get _db => Supabase.instance.client;

const _propertySelect =
    '*, property_media(url), profiles(display_name, avatar_url)';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  Future<List<HomeSection>> build() => _fetch();

  Future<List<HomeSection>> _fetch() async {
    final results = await Future.wait([
      _fetchFeatured(),
      _fetchForSale(),
      _fetchForRent(),
      _fetchNeighborhoods(),
    ]);

    final featured = results[0] as List<PropertyEntity>;
    final forSale = results[1] as List<PropertyEntity>;
    final forRent = results[2] as List<PropertyEntity>;
    final neighborhoods = results[3] as List<NeighborhoodItem>;

    return [
      if (featured.isNotEmpty) FeaturedSection(properties: featured),
      if (neighborhoods.isNotEmpty) NeighborhoodSection(neighborhoods: neighborhoods),
      if (forSale.isNotEmpty) ForSaleSection(properties: forSale),
      if (forRent.isNotEmpty) ForRentSection(properties: forRent),
    ];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<List<PropertyEntity>> _fetchFeatured() async {
    final rows = await _db
        .from('properties')
        .select(_propertySelect)
        .eq('status', 'approved')
        .eq('is_featured', true)
        .order('created_at', ascending: false)
        .limit(6);
    return (rows as List).map((r) => PropertyEntity.fromDb(r)).toList();
  }

  Future<List<PropertyEntity>> _fetchForSale() async {
    final rows = await _db
        .from('properties')
        .select(_propertySelect)
        .eq('status', 'approved')
        .eq('purpose', 'sale')
        .order('created_at', ascending: false)
        .limit(8);
    return (rows as List).map((r) => PropertyEntity.fromDb(r)).toList();
  }

  Future<List<PropertyEntity>> _fetchForRent() async {
    final rows = await _db
        .from('properties')
        .select(_propertySelect)
        .eq('status', 'approved')
        .eq('purpose', 'rent')
        .order('created_at', ascending: false)
        .limit(8);
    return (rows as List).map((r) => PropertyEntity.fromDb(r)).toList();
  }

  Future<List<NeighborhoodItem>> _fetchNeighborhoods() async {
    // Aggregate listing counts per neighborhood from approved properties.
    final rows = await _db
        .from('properties')
        .select('neighborhood, city')
        .eq('status', 'approved');

    final counts = <String, int>{};
    for (final r in rows as List) {
      final key = r['neighborhood'] as String? ?? '';
      if (key.isNotEmpty) counts[key] = (counts[key] ?? 0) + 1;
    }

    return counts.entries
        .map((e) => NeighborhoodItem(
              name: e.key,
              nameAm: '',
              city: 'Addis Ababa',
              listingCount: e.value,
            ))
        .toList()
      ..sort((a, b) => b.listingCount.compareTo(a.listingCount));
  }

}
