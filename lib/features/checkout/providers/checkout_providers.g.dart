// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkoutNotifierHash() => r'5de097fad1876785f7a5be43300a9a5955ac8b97';

/// Lumo — Checkout Notifier
/// Drives the three-step checkout flow: Delivery → Payment → Review.
///
/// Copied from [CheckoutNotifier].
@ProviderFor(CheckoutNotifier)
final checkoutNotifierProvider =
    AutoDisposeNotifierProvider<CheckoutNotifier, CheckoutState>.internal(
      CheckoutNotifier.new,
      name: r'checkoutNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$checkoutNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CheckoutNotifier = AutoDisposeNotifier<CheckoutState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
