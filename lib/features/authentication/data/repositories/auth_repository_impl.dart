import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/logging/lumo_logger.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Lumo — Auth Repository Implementation
/// All Supabase auth logic lives here. Domain never knows about Supabase.
final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Stream<AuthUserEntity?> get authStateChanges => _client.auth.onAuthStateChange
      .map((event) => _mapUser(event.session?.user));

  @override
  AuthUserEntity? get currentUser => _mapUser(_client.auth.currentUser);

  @override
  Future<Either<LumoFailure, AuthUserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = _mapUser(response.user);
      if (user == null) return const Left(AuthenticationFailure());
      return Right(user);
    } on AuthException catch (e) {
      LumoLogger.error('Sign in failed', e);
      return Left(AuthenticationFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Sign in unknown error', e, st);
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<LumoFailure, AuthUserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName},
      );
      final user = _mapUser(response.user);
      if (user == null) return const Left(AuthenticationFailure());
      return Right(user);
    } on AuthException catch (e) {
      LumoLogger.error('Register failed', e);
      return Left(AuthenticationFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Register unknown error', e, st);
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<LumoFailure, AuthUserEntity>> signInWithGoogle() async {
    try {
      // signInWithOAuth opens a browser and returns immediately on mobile.
      // The actual sign-in result arrives via the authStateChanges stream
      // once the deep-link redirect brings the user back to the app.
      // Navigation is handled by the authStateChanges listener in the UI.
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: _oauthRedirectUrl,
      );
      // Return a placeholder — the real user arrives via the stream.
      return const Left(AuthenticationFailure(message: 'oauth_pending'));
    } on AuthException catch (e) {
      LumoLogger.error('Google sign in failed', e);
      return Left(AuthenticationFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Google sign in unknown error', e, st);
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<LumoFailure, AuthUserEntity>> signInWithApple() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: _oauthRedirectUrl,
      );
      return const Left(AuthenticationFailure(message: 'oauth_pending'));
    } on AuthException catch (e) {
      LumoLogger.error('Apple sign in failed', e);
      return Left(AuthenticationFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Apple sign in unknown error', e, st);
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<LumoFailure, AuthUserEntity>> continueAsGuest() async {
    try {
      // Anonymous sign-in must be enabled in Supabase:
      // Dashboard → Authentication → Providers → Anonymous → Enable
      final response = await _client.auth.signInAnonymously();
      final user = _mapUser(response.user);
      if (user == null) return const Left(AuthenticationFailure());
      return Right(user);
    } on AuthException catch (e) {
      LumoLogger.error('Guest sign in failed', e);
      return Left(AuthenticationFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Guest sign in unknown error', e, st);
      return const Left(UnknownFailure());
    }
  }

  /// Redirect URL registered in Supabase → Authentication → URL Configuration.
  /// For mobile: use a custom scheme e.g. 'io.lumo.app://login-callback'
  /// For web: use the site URL e.g. 'https://lumo.app/auth/callback'
  static const _oauthRedirectUrl = 'io.lumo.app://login-callback';

  @override
  Future<Either<LumoFailure, void>> signOut() async {
    try {
      await _client.auth.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      LumoLogger.error('Sign out failed', e);
      return Left(AuthenticationFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Sign out unknown error', e, st);
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<LumoFailure, void>> sendPasswordReset({
    required String email,
  }) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return const Right(null);
    } on AuthException catch (e) {
      LumoLogger.error('Password reset failed', e);
      return Left(AuthenticationFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Password reset unknown error', e, st);
      return const Left(UnknownFailure());
    }
  }

  AuthUserEntity? _mapUser(User? user) {
    if (user == null) return null;
    return AuthUserEntity(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String? ??
          user.userMetadata?['full_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
      isGuest: user.isAnonymous,
      // Role is fetched separately via fetchUserWithRole — default to buyer here
      // so the stream mapping stays synchronous.
    );
  }

  /// Fetches the user with their role from the profiles table.
  /// Called after sign-in to get the full user context for routing.
  @override
  Future<AuthUserEntity?> fetchUserWithRole(User? user) async {
    if (user == null) return null;
    try {
      final profile = await _client
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();
      final role = UserRoleX.fromDb(profile?['role'] as String?);
      return AuthUserEntity(
        id: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['display_name'] as String? ??
            user.userMetadata?['full_name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
        isGuest: user.isAnonymous,
        role: role,
      );
    } catch (_) {
      return _mapUser(user);
    }
  }
}
