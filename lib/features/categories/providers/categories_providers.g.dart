// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesListHash() => r'029ec455c124212f7e3a93193f6c76715d8e29ab';

/// See also [categoriesList].
@ProviderFor(categoriesList)
final categoriesListProvider =
    AutoDisposeFutureProvider<List<CategoryEntity>>.internal(
      categoriesList,
      name: r'categoriesListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoriesListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesListRef = AutoDisposeFutureProviderRef<List<CategoryEntity>>;
String _$categoryDetailHash() => r'4ff9c274298b8436091e3fdb9c44ff87d6106e39';

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

/// See also [categoryDetail].
@ProviderFor(categoryDetail)
const categoryDetailProvider = CategoryDetailFamily();

/// See also [categoryDetail].
class CategoryDetailFamily extends Family<AsyncValue<CategoryEntity?>> {
  /// See also [categoryDetail].
  const CategoryDetailFamily();

  /// See also [categoryDetail].
  CategoryDetailProvider call({required String categoryId}) {
    return CategoryDetailProvider(categoryId: categoryId);
  }

  @override
  CategoryDetailProvider getProviderOverride(
    covariant CategoryDetailProvider provider,
  ) {
    return call(categoryId: provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryDetailProvider';
}

/// See also [categoryDetail].
class CategoryDetailProvider
    extends AutoDisposeFutureProvider<CategoryEntity?> {
  /// See also [categoryDetail].
  CategoryDetailProvider({required String categoryId})
    : this._internal(
        (ref) =>
            categoryDetail(ref as CategoryDetailRef, categoryId: categoryId),
        from: categoryDetailProvider,
        name: r'categoryDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoryDetailHash,
        dependencies: CategoryDetailFamily._dependencies,
        allTransitiveDependencies:
            CategoryDetailFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  CategoryDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<CategoryEntity?> Function(CategoryDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryDetailProvider._internal(
        (ref) => create(ref as CategoryDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CategoryEntity?> createElement() {
    return _CategoryDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryDetailProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryDetailRef on AutoDisposeFutureProviderRef<CategoryEntity?> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategoryDetailProviderElement
    extends AutoDisposeFutureProviderElement<CategoryEntity?>
    with CategoryDetailRef {
  _CategoryDetailProviderElement(super.provider);

  @override
  String get categoryId => (origin as CategoryDetailProvider).categoryId;
}

String _$categoryProductsHash() => r'427be018ced6fdb7b3359976ed3c87dc4e1da56c';

/// See also [categoryProducts].
@ProviderFor(categoryProducts)
const categoryProductsProvider = CategoryProductsFamily();

/// See also [categoryProducts].
class CategoryProductsFamily
    extends Family<AsyncValue<List<SearchResultEntity>>> {
  /// See also [categoryProducts].
  const CategoryProductsFamily();

  /// See also [categoryProducts].
  CategoryProductsProvider call({required String categoryId}) {
    return CategoryProductsProvider(categoryId: categoryId);
  }

  @override
  CategoryProductsProvider getProviderOverride(
    covariant CategoryProductsProvider provider,
  ) {
    return call(categoryId: provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryProductsProvider';
}

/// See also [categoryProducts].
class CategoryProductsProvider
    extends AutoDisposeFutureProvider<List<SearchResultEntity>> {
  /// See also [categoryProducts].
  CategoryProductsProvider({required String categoryId})
    : this._internal(
        (ref) => categoryProducts(
          ref as CategoryProductsRef,
          categoryId: categoryId,
        ),
        from: categoryProductsProvider,
        name: r'categoryProductsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoryProductsHash,
        dependencies: CategoryProductsFamily._dependencies,
        allTransitiveDependencies:
            CategoryProductsFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  CategoryProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<List<SearchResultEntity>> Function(CategoryProductsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryProductsProvider._internal(
        (ref) => create(ref as CategoryProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SearchResultEntity>> createElement() {
    return _CategoryProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryProductsProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryProductsRef
    on AutoDisposeFutureProviderRef<List<SearchResultEntity>> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategoryProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<SearchResultEntity>>
    with CategoryProductsRef {
  _CategoryProductsProviderElement(super.provider);

  @override
  String get categoryId => (origin as CategoryProductsProvider).categoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
