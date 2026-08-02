import 'address_entity.dart';
import 'payment_method_entity.dart';

/// Checkout step index — drives the progress indicator.
enum CheckoutStep { delivery, payment, review }

/// Lumo — Checkout State
/// Immutable. Every field is optional until the user fills it in.
final class CheckoutState {
  const CheckoutState({
    this.step = CheckoutStep.delivery,
    this.address,
    this.paymentMethod,
    this.isPlacingOrder = false,
  });

  final CheckoutStep step;
  final AddressEntity? address;
  final PaymentMethodEntity? paymentMethod;
  final bool isPlacingOrder;

  bool get canProceedFromDelivery => address != null;
  bool get canProceedFromPayment => paymentMethod != null;
  bool get canPlaceOrder => address != null && paymentMethod != null;

  CheckoutState copyWith({
    CheckoutStep? step,
    AddressEntity? address,
    PaymentMethodEntity? paymentMethod,
    bool? isPlacingOrder,
  }) =>
      CheckoutState(
        step: step ?? this.step,
        address: address ?? this.address,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      );
}
