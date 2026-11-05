// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$propertyDetailHash() => r'dbbec8ac2e514a7952697936149ef539622d11b6';

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

/// See also [propertyDetail].
@ProviderFor(propertyDetail)
const propertyDetailProvider = PropertyDetailFamily();

/// See also [propertyDetail].
class PropertyDetailFamily extends Family<AsyncValue<PropertyEntity>> {
  /// See also [propertyDetail].
  const PropertyDetailFamily();

  /// See also [propertyDetail].
  PropertyDetailProvider call(String id) {
    return PropertyDetailProvider(id);
  }

  @override
  PropertyDetailProvider getProviderOverride(
    covariant PropertyDetailProvider provider,
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
  String? get name => r'propertyDetailProvider';
}

/// See also [propertyDetail].
class PropertyDetailProvider extends AutoDisposeFutureProvider<PropertyEntity> {
  /// See also [propertyDetail].
  PropertyDetailProvider(String id)
    : this._internal(
        (ref) => propertyDetail(ref as PropertyDetailRef, id),
        from: propertyDetailProvider,
        name: r'propertyDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$propertyDetailHash,
        dependencies: PropertyDetailFamily._dependencies,
        allTransitiveDependencies:
            PropertyDetailFamily._allTransitiveDependencies,
        id: id,
      );

  PropertyDetailProvider._internal(
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
    FutureOr<PropertyEntity> Function(PropertyDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PropertyDetailProvider._internal(
        (ref) => create(ref as PropertyDetailRef),
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
  AutoDisposeFutureProviderElement<PropertyEntity> createElement() {
    return _PropertyDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PropertyDetailProvider && other.id == id;
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
mixin PropertyDetailRef on AutoDisposeFutureProviderRef<PropertyEntity> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PropertyDetailProviderElement
    extends AutoDisposeFutureProviderElement<PropertyEntity>
    with PropertyDetailRef {
  _PropertyDetailProviderElement(super.provider);

  @override
  String get id => (origin as PropertyDetailProvider).id;
}

String _$similarPropertiesHash() => r'7b2ab8f02a46ba0353912e3bbfe1d628f6b2744f';

/// See also [similarProperties].
@ProviderFor(similarProperties)
const similarPropertiesProvider = SimilarPropertiesFamily();

/// See also [similarProperties].
class SimilarPropertiesFamily extends Family<AsyncValue<List<PropertyEntity>>> {
  /// See also [similarProperties].
  const SimilarPropertiesFamily();

  /// See also [similarProperties].
  SimilarPropertiesProvider call(String id) {
    return SimilarPropertiesProvider(id);
  }

  @override
  SimilarPropertiesProvider getProviderOverride(
    covariant SimilarPropertiesProvider provider,
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
  String? get name => r'similarPropertiesProvider';
}

/// See also [similarProperties].
class SimilarPropertiesProvider
    extends AutoDisposeFutureProvider<List<PropertyEntity>> {
  /// See also [similarProperties].
  SimilarPropertiesProvider(String id)
    : this._internal(
        (ref) => similarProperties(ref as SimilarPropertiesRef, id),
        from: similarPropertiesProvider,
        name: r'similarPropertiesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$similarPropertiesHash,
        dependencies: SimilarPropertiesFamily._dependencies,
        allTransitiveDependencies:
            SimilarPropertiesFamily._allTransitiveDependencies,
        id: id,
      );

  SimilarPropertiesProvider._internal(
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
    FutureOr<List<PropertyEntity>> Function(SimilarPropertiesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SimilarPropertiesProvider._internal(
        (ref) => create(ref as SimilarPropertiesRef),
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
  AutoDisposeFutureProviderElement<List<PropertyEntity>> createElement() {
    return _SimilarPropertiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SimilarPropertiesProvider && other.id == id;
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
mixin SimilarPropertiesRef
    on AutoDisposeFutureProviderRef<List<PropertyEntity>> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SimilarPropertiesProviderElement
    extends AutoDisposeFutureProviderElement<List<PropertyEntity>>
    with SimilarPropertiesRef {
  _SimilarPropertiesProviderElement(super.provider);

  @override
  String get id => (origin as SimilarPropertiesProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
