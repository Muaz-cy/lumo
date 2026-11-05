import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../property/domain/entities/property_entity.dart';

part 'search_providers.g.dart';

SupabaseClient get _db => Supabase.instance.client;

const _propertySelect =
    '*, property_media(url), profiles(display_name, avatar_url)';

// ── Recent History ─────────────────────────────────────────────────────────────

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
    state = prefs.getStringList(_historyKey) ?? [];
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

// ── Trending searches ──────────────────────────────────────────────────────────

@riverpod
List<String> trendingSearches(Ref ref) => [
      'Bole apartment',
      'Villa for sale',
      'CMC house',
      '3 bedroom Addis',
      'Furnished studio',
      'Old Airport rent',
      'Kazanchis condo',
      'Land for sale',
    ];

// ── Query state ────────────────────────────────────────────────────────────────

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';
  void update(String query) => state = query;
  void clear() => state = '';
}

// ── Filter state ───────────────────────────────────────────────────────────────

class SearchFilters {
  const SearchFilters({this.purpose, this.type});
  final ListingPurpose? purpose;
  final PropertyType? type;

  SearchFilters copyWith({ListingPurpose? purpose, PropertyType? type}) =>
      SearchFilters(
        purpose: purpose ?? this.purpose,
        type: type ?? this.type,
      );
}

@riverpod
class SearchFilterNotifier extends _$SearchFilterNotifier {
  @override
  SearchFilters build() => const SearchFilters();

  void setPurpose(ListingPurpose? purpose) =>
      state = SearchFilters(purpose: purpose, type: state.type);

  void setType(PropertyType? type) =>
      state = SearchFilters(purpose: state.purpose, type: type);

  void reset() => state = const SearchFilters();
}

// ── Supabase search ────────────────────────────────────────────────────────────

@riverpod
Future<List<PropertyEntity>> searchResults(
  Ref ref, {
  required String query,
  required SearchFilters filters,
}) async {
  if (query.trim().isEmpty &&
      filters.purpose == null &&
      filters.type == null) {
    return [];
  }

  var q = _db
      .from('properties')
      .select(_propertySelect)
      .eq('status', 'approved');

  if (filters.purpose != null) {
    q = q.eq('purpose', filters.purpose!.name);
  }

  if (filters.type != null) {
    q = q.eq('property_type', filters.type!.name);
  }

  if (query.trim().isNotEmpty) {
    // Supabase full-text search on the title column.
    // Requires a tsvector index on properties(title) in Supabase.
    q = q.textSearch('title', query.trim(), config: 'english');
  }

  final rows = await q.order('created_at', ascending: false).limit(30);
  return (rows as List).map((r) => PropertyEntity.fromDb(r)).toList();
}
