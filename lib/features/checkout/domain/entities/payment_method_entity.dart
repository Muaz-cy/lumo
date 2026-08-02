/// Lumo — Payment Method Entity
/// Represents a saved or entered payment method. Pure domain.
enum PaymentType { card, applePay, googlePay }

final class PaymentMethodEntity {
  const PaymentMethodEntity({
    required this.id,
    required this.type,
    this.last4,
    this.brand,
    this.expiryMonth,
    this.expiryYear,
    this.isDefault = false,
  });

  final String id;
  final PaymentType type;
  final String? last4;
  final String? brand;
  final int? expiryMonth;
  final int? expiryYear;
  final bool isDefault;

  String get displayName {
    switch (type) {
      case PaymentType.applePay:
        return 'Apple Pay';
      case PaymentType.googlePay:
        return 'Google Pay';
      case PaymentType.card:
        return '${brand ?? 'Card'} ••••${last4 ?? ''}';
    }
  }
}
