// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wishlistBoxHash() => r'0d21cabc8deefce36a9026514474eeb0321db024';

/// See also [wishlistBox].
@ProviderFor(wishlistBox)
final wishlistBoxProvider =
    AutoDisposeProvider<Box<WishlistItemHiveModel>>.internal(
      wishlistBox,
      name: r'wishlistBoxProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$wishlistBoxHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WishlistBoxRef = AutoDisposeProviderRef<Box<WishlistItemHiveModel>>;
String _$wishlistRepositoryHash() =>
    r'afeb1f5dd49e785c0ebcff678e2c080ada8ab05f';

/// See also [wishlistRepository].
@ProviderFor(wishlistRepository)
final wishlistRepositoryProvider =
    AutoDisposeProvider<WishlistRepository>.internal(
      wishlistRepository,
      name: r'wishlistRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$wishlistRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WishlistRepositoryRef = AutoDisposeProviderRef<WishlistRepository>;
String _$wishlistNotifierHash() => r'bdd8974747eee22794ba4f28c5400126514d4f7d';

/// Single source of truth for the wishlist.
///
/// Copied from [WishlistNotifier].
@ProviderFor(WishlistNotifier)
final wishlistNotifierProvider =
    AutoDisposeNotifierProvider<
      WishlistNotifier,
      List<WishlistItemEntity>
    >.internal(
      WishlistNotifier.new,
      name: r'wishlistNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$wishlistNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WishlistNotifier = AutoDisposeNotifier<List<WishlistItemEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
