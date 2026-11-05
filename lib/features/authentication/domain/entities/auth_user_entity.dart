/// Lumo — Auth User Entity
/// Pure domain model. No Supabase types leak into domain.
final class AuthUserEntity {
  const AuthUserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.isGuest = false,
    this.role = UserRole.buyer,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final bool isGuest;
  final UserRole role;

  bool get isBroker => role == UserRole.broker;
  bool get isAdmin => role == UserRole.admin;

  String get firstName {
    if (displayName == null || displayName!.isEmpty) return '';
    return displayName!.split(' ').first;
  }
}

enum UserRole { buyer, broker, admin }

extension UserRoleX on UserRole {
  static UserRole fromDb(String? value) => switch (value) {
        'broker' => UserRole.broker,
        'admin' => UserRole.admin,
        _ => UserRole.buyer,
      };
}
