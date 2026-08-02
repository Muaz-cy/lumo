// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productReviewsHash() => r'f8bbaf27c15b1389bb83abca30e45a05d98c7262';

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

/// See also [productReviews].
@ProviderFor(productReviews)
const productReviewsProvider = ProductReviewsFamily();

/// See also [productReviews].
class ProductReviewsFamily extends Family<AsyncValue<List<ReviewEntity>>> {
  /// See also [productReviews].
  const ProductReviewsFamily();

  /// See also [productReviews].
  ProductReviewsProvider call({required String productId}) {
    return ProductReviewsProvider(productId: productId);
  }

  @override
  ProductReviewsProvider getProviderOverride(
    covariant ProductReviewsProvider provider,
  ) {
    return call(productId: provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productReviewsProvider';
}

/// See also [productReviews].
class ProductReviewsProvider
    extends AutoDisposeFutureProvider<List<ReviewEntity>> {
  /// See also [productReviews].
  ProductReviewsProvider({required String productId})
    : this._internal(
        (ref) => productReviews(ref as ProductReviewsRef, productId: productId),
        from: productReviewsProvider,
        name: r'productReviewsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productReviewsHash,
        dependencies: ProductReviewsFamily._dependencies,
        allTransitiveDependencies:
            ProductReviewsFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductReviewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    FutureOr<List<ReviewEntity>> Function(ProductReviewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductReviewsProvider._internal(
        (ref) => create(ref as ProductReviewsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ReviewEntity>> createElement() {
    return _ProductReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductReviewsProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductReviewsRef on AutoDisposeFutureProviderRef<List<ReviewEntity>> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductReviewsProviderElement
    extends AutoDisposeFutureProviderElement<List<ReviewEntity>>
    with ProductReviewsRef {
  _ProductReviewsProviderElement(super.provider);

  @override
  String get productId => (origin as ProductReviewsProvider).productId;
}

String _$ratingBreakdownHash() => r'0cc8ef3b5f8085d81042cdcb6c29aedf91650d97';

/// See also [ratingBreakdown].
@ProviderFor(ratingBreakdown)
const ratingBreakdownProvider = RatingBreakdownFamily();

/// See also [ratingBreakdown].
class RatingBreakdownFamily extends Family<AsyncValue<RatingBreakdown?>> {
  /// See also [ratingBreakdown].
  const RatingBreakdownFamily();

  /// See also [ratingBreakdown].
  RatingBreakdownProvider call({required String productId}) {
    return RatingBreakdownProvider(productId: productId);
  }

  @override
  RatingBreakdownProvider getProviderOverride(
    covariant RatingBreakdownProvider provider,
  ) {
    return call(productId: provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'ratingBreakdownProvider';
}

/// See also [ratingBreakdown].
class RatingBreakdownProvider
    extends AutoDisposeFutureProvider<RatingBreakdown?> {
  /// See also [ratingBreakdown].
  RatingBreakdownProvider({required String productId})
    : this._internal(
        (ref) =>
            ratingBreakdown(ref as RatingBreakdownRef, productId: productId),
        from: ratingBreakdownProvider,
        name: r'ratingBreakdownProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$ratingBreakdownHash,
        dependencies: RatingBreakdownFamily._dependencies,
        allTransitiveDependencies:
            RatingBreakdownFamily._allTransitiveDependencies,
        productId: productId,
      );

  RatingBreakdownProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    FutureOr<RatingBreakdown?> Function(RatingBreakdownRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RatingBreakdownProvider._internal(
        (ref) => create(ref as RatingBreakdownRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<RatingBreakdown?> createElement() {
    return _RatingBreakdownProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RatingBreakdownProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RatingBreakdownRef on AutoDisposeFutureProviderRef<RatingBreakdown?> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _RatingBreakdownProviderElement
    extends AutoDisposeFutureProviderElement<RatingBreakdown?>
    with RatingBreakdownRef {
  _RatingBreakdownProviderElement(super.provider);

  @override
  String get productId => (origin as RatingBreakdownProvider).productId;
}

String _$helpfulVotesHash() => r'c3452ffb715c62c8d4297e092618cef54eb0f710';

/// See also [HelpfulVotes].
@ProviderFor(HelpfulVotes)
final helpfulVotesProvider =
    AutoDisposeNotifierProvider<HelpfulVotes, Set<String>>.internal(
      HelpfulVotes.new,
      name: r'helpfulVotesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$helpfulVotesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HelpfulVotes = AutoDisposeNotifier<Set<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
