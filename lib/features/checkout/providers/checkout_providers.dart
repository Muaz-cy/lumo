import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/address_entity.dart';
import '../domain/entities/checkout_state.dart';
import '../domain/entities/payment_method_entity.dart';

part 'checkout_providers.g.dart';

/// Lumo — Checkout Notifier
/// Drives the three-step checkout flow: Delivery → Payment → Review.
@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
  @override
  CheckoutState build() => const CheckoutState();

  void setAddress(AddressEntity address) {
    state = state.copyWith(address: address);
  }

  void setPaymentMethod(PaymentMethodEntity method) {
    state = state.copyWith(paymentMethod: method);
  }

  void goToStep(CheckoutStep step) {
    state = state.copyWith(step: step);
  }

  void nextStep() {
    switch (state.step) {
      case CheckoutStep.delivery:
        if (state.canProceedFromDelivery) {
          state = state.copyWith(step: CheckoutStep.payment);
        }
      case CheckoutStep.payment:
        if (state.canProceedFromPayment) {
          state = state.copyWith(step: CheckoutStep.review);
        }
      case CheckoutStep.review:
        break;
    }
  }

  void previousStep() {
    switch (state.step) {
      case CheckoutStep.delivery:
        break;
      case CheckoutStep.payment:
        state = state.copyWith(step: CheckoutStep.delivery);
      case CheckoutStep.review:
        state = state.copyWith(step: CheckoutStep.payment);
    }
  }

  Future<String?> placeOrder() async {
    if (!state.canPlaceOrder) return null;
    state = state.copyWith(isPlacingOrder: true);
    // Simulate network — real Supabase order insertion wired in orders feature.
    await Future.delayed(const Duration(milliseconds: 1500));
    state = state.copyWith(isPlacingOrder: false);
    // Return a mock order ID — replaced with real ID when orders feature is built.
    return 'order_${DateTime.now().millisecondsSinceEpoch}';
  }

  void reset() => state = const CheckoutState();
}
