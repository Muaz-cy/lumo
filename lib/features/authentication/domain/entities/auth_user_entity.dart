/// Lumo — Auth User Entity
/// Pure domain model. No Supabase types leak into domain.
final class AuthUserEntity {
  const AuthUserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.isGuest = false,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final bool isGuest;

  String get firstName {
    if (displayName == null || displayName!.isEmpty) return '';
    return displayName!.split(' ').first;
  }
}
