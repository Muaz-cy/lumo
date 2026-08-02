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
      await _client.auth.signInWithOAuth(OAuthProvider.google);
      final user = _mapUser(_client.auth.currentUser);
      if (user == null) return const Left(AuthenticationFailure());
      return Right(user);
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
      await _client.auth.signInWithOAuth(OAuthProvider.apple);
      final user = _mapUser(_client.auth.currentUser);
      if (user == null) return const Left(AuthenticationFailure());
      return Right(user);
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
    );
  }
}
