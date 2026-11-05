// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trendingSearchesHash() => r'036b474fff63723c03fda66437d11527f163e0cf';

/// See also [trendingSearches].
@ProviderFor(trendingSearches)
final trendingSearchesProvider = AutoDisposeProvider<List<String>>.internal(
  trendingSearches,
  name: r'trendingSearchesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trendingSearchesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrendingSearchesRef = AutoDisposeProviderRef<List<String>>;
String _$searchResultsHash() => r'c36f06b1e61774647aa15b9b5ee3ad3cab559519';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [searchResults].
@ProviderFor(searchResults)
const searchResultsProvider = SearchResultsFamily();

/// See also [searchResults].
class SearchResultsFamily extends Family<AsyncValue<List<PropertyEntity>>> {
  /// See also [searchResults].
  const SearchResultsFamily();

  /// See also [searchResults].
  SearchResultsProvider call({
    required String query,
    required SearchFilters filters,
  }) {
    return SearchResultsProvider(query: query, filters: filters);
  }

  @override
  SearchResultsProvider getProviderOverride(
    covariant SearchResultsProvider provider,
  ) {
    return call(query: provider.query, filters: provider.filters);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchResultsProvider';
}

/// See also [searchResults].
class SearchResultsProvider
    extends AutoDisposeFutureProvider<List<PropertyEntity>> {
  /// See also [searchResults].
  SearchResultsProvider({required String query, required SearchFilters filters})
    : this._internal(
        (ref) => searchResults(
          ref as SearchResultsRef,
          query: query,
          filters: filters,
        ),
        from: searchResultsProvider,
        name: r'searchResultsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchResultsHash,
        dependencies: SearchResultsFamily._dependencies,
        allTransitiveDependencies:
            SearchResultsFamily._allTransitiveDependencies,
        query: query,
        filters: filters,
      );

  SearchResultsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.filters,
  }) : super.internal();

  final String query;
  final SearchFilters filters;

  @override
  Override overrideWith(
    FutureOr<List<PropertyEntity>> Function(SearchResultsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchResultsProvider._internal(
        (ref) => create(ref as SearchResultsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        filters: filters,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PropertyEntity>> createElement() {
    return _SearchResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchResultsProvider &&
        other.query == query &&
        other.filters == filters;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, filters.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchResultsRef on AutoDisposeFutureProviderRef<List<PropertyEntity>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `filters` of this provider.
  SearchFilters get filters;
}

class _SearchResultsProviderElement
    extends AutoDisposeFutureProviderElement<List<PropertyEntity>>
    with SearchResultsRef {
  _SearchResultsProviderElement(super.provider);

  @override
  String get query => (origin as SearchResultsProvider).query;
  @override
  SearchFilters get filters => (origin as SearchResultsProvider).filters;
}

String _$searchHistoryHash() => r'4aeff22299969cad0dee88ee24fef31ef135be8c';

/// See also [SearchHistory].
@ProviderFor(SearchHistory)
final searchHistoryProvider =
    AutoDisposeNotifierProvider<SearchHistory, List<String>>.internal(
      SearchHistory.new,
      name: r'searchHistoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$searchHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchHistory = AutoDisposeNotifier<List<String>>;
String _$searchQueryHash() => r'790bd96a8a13bb944767c7bf06a5378cfc78a54d';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
      SearchQuery.new,
      name: r'searchQueryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$searchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$searchFilterNotifierHash() =>
    r'bd3da16cafa236397341fa2527a04faca5d42483';

/// See also [SearchFilterNotifier].
@ProviderFor(SearchFilterNotifier)
final searchFilterNotifierProvider =
    AutoDisposeNotifierProvider<SearchFilterNotifier, SearchFilters>.internal(
      SearchFilterNotifier.new,
      name: r'searchFilterNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$searchFilterNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchFilterNotifier = AutoDisposeNotifier<SearchFilters>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
