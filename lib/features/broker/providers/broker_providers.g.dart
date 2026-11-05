// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broker_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$brokerRepositoryHash() => r'c9fd1ff8788497a6e9e45ffeb8f69ca684a0776d';

/// See also [brokerRepository].
@ProviderFor(brokerRepository)
final brokerRepositoryProvider = AutoDisposeProvider<BrokerRepository>.internal(
  brokerRepository,
  name: r'brokerRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$brokerRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BrokerRepositoryRef = AutoDisposeProviderRef<BrokerRepository>;
String _$brokerProfileHash() => r'7209615f6f801cdf9ac0b663853f36e477b6ba0a';

/// See also [brokerProfile].
@ProviderFor(brokerProfile)
final brokerProfileProvider =
    AutoDisposeFutureProvider<BrokerProfileEntity>.internal(
      brokerProfile,
      name: r'brokerProfileProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$brokerProfileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BrokerProfileRef = AutoDisposeFutureProviderRef<BrokerProfileEntity>;
String _$brokerListingsHash() => r'e782eaa1cee7c1ab6a0d7de6355885e4c3a1053e';

/// See also [brokerListings].
@ProviderFor(brokerListings)
final brokerListingsProvider =
    AutoDisposeFutureProvider<List<BrokerListingEntity>>.internal(
      brokerListings,
      name: r'brokerListingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$brokerListingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BrokerListingsRef =
    AutoDisposeFutureProviderRef<List<BrokerListingEntity>>;
String _$listingSubmissionNotifierHash() =>
    r'd0c20c23185dfe0f77b98a952e24f6a7ce74f55a';

/// Handles the multi-step listing submission form state and submission.
///
/// Copied from [ListingSubmissionNotifier].
@ProviderFor(ListingSubmissionNotifier)
final listingSubmissionNotifierProvider =
    AutoDisposeNotifierProvider<
      ListingSubmissionNotifier,
      ListingSubmissionState
    >.internal(
      ListingSubmissionNotifier.new,
      name: r'listingSubmissionNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$listingSubmissionNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ListingSubmissionNotifier =
    AutoDisposeNotifier<ListingSubmissionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
