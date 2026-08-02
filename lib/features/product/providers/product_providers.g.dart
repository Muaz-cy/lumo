// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productRemoteDataSourceHash() =>
    r'40c7a33614cf527d45da1f1ed7883ec78fac83ac';

/// See also [productRemoteDataSource].
@ProviderFor(productRemoteDataSource)
final productRemoteDataSourceProvider =
    AutoDisposeProvider<ProductRemoteDataSource>.internal(
      productRemoteDataSource,
      name: r'productRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$productRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProductRemoteDataSourceRef =
    AutoDisposeProviderRef<ProductRemoteDataSource>;
String _$productRepositoryHash() => r'7e65b7a9abd31c4bd93987f92325ed1b9f7d8ceb';

/// See also [productRepository].
@ProviderFor(productRepository)
final productRepositoryProvider =
    AutoDisposeProvider<ProductRepository>.internal(
      productRepository,
      name: r'productRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$productRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProductRepositoryRef = AutoDisposeProviderRef<ProductRepository>;
String _$getProductByIdHash() => r'b818224e21d48ee493206bffbe580841905fdfb8';

/// See also [getProductById].
@ProviderFor(getProductById)
final getProductByIdProvider = AutoDisposeProvider<GetProductById>.internal(
  getProductById,
  name: r'getProductByIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getProductByIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetProductByIdRef = AutoDisposeProviderRef<GetProductById>;
String _$getRelatedProductsHash() =>
    r'08dc19b338067683eea19cebda11829b1b845fc3';

/// See also [getRelatedProducts].
@ProviderFor(getRelatedProducts)
final getRelatedProductsProvider =
    AutoDisposeProvider<GetRelatedProducts>.internal(
      getRelatedProducts,
      name: r'getRelatedProductsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getRelatedProductsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetRelatedProductsRef = AutoDisposeProviderRef<GetRelatedProducts>;
String _$productDetailHash() => r'02dadb4b45f30e5eaeef94428dffa056c2d51cbb';

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

/// Fetches a single product by ID — auto-disposed when screen leaves.
///
/// Copied from [productDetail].
@ProviderFor(productDetail)
const productDetailProvider = ProductDetailFamily();

/// Fetches a single product by ID — auto-disposed when screen leaves.
///
/// Copied from [productDetail].
class ProductDetailFamily extends Family<AsyncValue<ProductEntity>> {
  /// Fetches a single product by ID — auto-disposed when screen leaves.
  ///
  /// Copied from [productDetail].
  const ProductDetailFamily();

  /// Fetches a single product by ID — auto-disposed when screen leaves.
  ///
  /// Copied from [productDetail].
  ProductDetailProvider call(String id) {
    return ProductDetailProvider(id);
  }

  @override
  ProductDetailProvider getProviderOverride(
    covariant ProductDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDetailProvider';
}

/// Fetches a single product by ID — auto-disposed when screen leaves.
///
/// Copied from [productDetail].
class ProductDetailProvider extends AutoDisposeFutureProvider<ProductEntity> {
  /// Fetches a single product by ID — auto-disposed when screen leaves.
  ///
  /// Copied from [productDetail].
  ProductDetailProvider(String id)
    : this._internal(
        (ref) => productDetail(ref as ProductDetailRef, id),
        from: productDetailProvider,
        name: r'productDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productDetailHash,
        dependencies: ProductDetailFamily._dependencies,
        allTransitiveDependencies:
            ProductDetailFamily._allTransitiveDependencies,
        id: id,
      );

  ProductDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<ProductEntity> Function(ProductDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailProvider._internal(
        (ref) => create(ref as ProductDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProductEntity> createElement() {
    return _ProductDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductDetailRef on AutoDisposeFutureProviderRef<ProductEntity> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ProductDetailProviderElement
    extends AutoDisposeFutureProviderElement<ProductEntity>
    with ProductDetailRef {
  _ProductDetailProviderElement(super.provider);

  @override
  String get id => (origin as ProductDetailProvider).id;
}

String _$relatedProductsHash() => r'84ca93e4c8d2b804aac2ad8fd46c746b95c76a03';

/// Fetches related products — keyed by productId + categoryId.
///
/// Copied from [relatedProducts].
@ProviderFor(relatedProducts)
const relatedProductsProvider = RelatedProductsFamily();

/// Fetches related products — keyed by productId + categoryId.
///
/// Copied from [relatedProducts].
class RelatedProductsFamily extends Family<AsyncValue<List<ProductEntity>>> {
  /// Fetches related products — keyed by productId + categoryId.
  ///
  /// Copied from [relatedProducts].
  const RelatedProductsFamily();

  /// Fetches related products — keyed by productId + categoryId.
  ///
  /// Copied from [relatedProducts].
  RelatedProductsProvider call({
    required String productId,
    required String categoryId,
  }) {
    return RelatedProductsProvider(
      productId: productId,
      categoryId: categoryId,
    );
  }

  @override
  RelatedProductsProvider getProviderOverride(
    covariant RelatedProductsProvider provider,
  ) {
    return call(productId: provider.productId, categoryId: provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'relatedProductsProvider';
}

/// Fetches related products — keyed by productId + categoryId.
///
/// Copied from [relatedProducts].
class RelatedProductsProvider
    extends AutoDisposeFutureProvider<List<ProductEntity>> {
  /// Fetches related products — keyed by productId + categoryId.
  ///
  /// Copied from [relatedProducts].
  RelatedProductsProvider({
    required String productId,
    required String categoryId,
  }) : this._internal(
         (ref) => relatedProducts(
           ref as RelatedProductsRef,
           productId: productId,
           categoryId: categoryId,
         ),
         from: relatedProductsProvider,
         name: r'relatedProductsProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$relatedProductsHash,
         dependencies: RelatedProductsFamily._dependencies,
         allTransitiveDependencies:
             RelatedProductsFamily._allTransitiveDependencies,
         productId: productId,
         categoryId: categoryId,
       );

  RelatedProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
    required this.categoryId,
  }) : super.internal();

  final String productId;
  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<List<ProductEntity>> Function(RelatedProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RelatedProductsProvider._internal(
        (ref) => create(ref as RelatedProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProductEntity>> createElement() {
    return _RelatedProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RelatedProductsProvider &&
        other.productId == productId &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RelatedProductsRef on AutoDisposeFutureProviderRef<List<ProductEntity>> {
  /// The parameter `productId` of this provider.
  String get productId;

  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _RelatedProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductEntity>>
    with RelatedProductsRef {
  _RelatedProductsProviderElement(super.provider);

  @override
  String get productId => (origin as RelatedProductsProvider).productId;
  @override
  String get categoryId => (origin as RelatedProductsProvider).categoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
