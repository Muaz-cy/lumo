// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exchangeRateNotifierHash() =>
    r'1d51f44f36290aa7185b09b45f06d73a7eedc5dd';

/// See also [ExchangeRateNotifier].
@ProviderFor(ExchangeRateNotifier)
final exchangeRateNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      ExchangeRateNotifier,
      ExchangeRateState
    >.internal(
      ExchangeRateNotifier.new,
      name: r'exchangeRateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exchangeRateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExchangeRateNotifier = AutoDisposeAsyncNotifier<ExchangeRateState>;
String _$currencyDisplayNotifierHash() =>
    r'e5260a9a9ddfe8d2dce484765e0882c6131bec0c';

/// See also [CurrencyDisplayNotifier].
@ProviderFor(CurrencyDisplayNotifier)
final currencyDisplayNotifierProvider =
    AutoDisposeNotifierProvider<
      CurrencyDisplayNotifier,
      CurrencyDisplay
    >.internal(
      CurrencyDisplayNotifier.new,
      name: r'currencyDisplayNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currencyDisplayNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrencyDisplayNotifier = AutoDisposeNotifier<CurrencyDisplay>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
