// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeRemoteDataSourceHash() =>
    r'2e43ca6f13823eae636cf8a5a3c6f5ef97a4cd07';

/// See also [homeRemoteDataSource].
@ProviderFor(homeRemoteDataSource)
final homeRemoteDataSourceProvider =
    AutoDisposeProvider<HomeRemoteDataSource>.internal(
      homeRemoteDataSource,
      name: r'homeRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$homeRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeRemoteDataSourceRef = AutoDisposeProviderRef<HomeRemoteDataSource>;
String _$homeRepositoryHash() => r'436b30460c7924bd03ff4476c09bf88ab370d3af';

/// See also [homeRepository].
@ProviderFor(homeRepository)
final homeRepositoryProvider = AutoDisposeProvider<HomeRepositoryImpl>.internal(
  homeRepository,
  name: r'homeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeRepositoryRef = AutoDisposeProviderRef<HomeRepositoryImpl>;
String _$getHomeSectionsHash() => r'ed79845a1fff669ffd45e7974ec0488ae830892e';

/// See also [getHomeSections].
@ProviderFor(getHomeSections)
final getHomeSectionsProvider = AutoDisposeProvider<GetHomeSections>.internal(
  getHomeSections,
  name: r'getHomeSectionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getHomeSectionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetHomeSectionsRef = AutoDisposeProviderRef<GetHomeSections>;
String _$homeNotifierHash() => r'82ff034bb026f7f0161279bbf5f9b009aaa4e65d';

/// See also [HomeNotifier].
@ProviderFor(HomeNotifier)
final homeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<HomeNotifier, List<HomeSection>>.internal(
      HomeNotifier.new,
      name: r'homeNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$homeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HomeNotifier = AutoDisposeAsyncNotifier<List<HomeSection>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
