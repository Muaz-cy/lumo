/// Lumo — Address Entity
/// A delivery destination. Pure domain.
final class AddressEntity {
  const AddressEntity({
    required this.id,
    required this.fullName,
    required this.line1,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.line2,
    this.phone,
    this.isDefault = false,
  });

  final String id;
  final String fullName;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? phone;
  final bool isDefault;

  String get displayLine1 => line1;
  String get displayLine2 =>
      '${line2 != null ? '$line2, ' : ''}$city, $state $postalCode';
  String get displayFull => '$line1\n$displayLine2\n$country';
}
