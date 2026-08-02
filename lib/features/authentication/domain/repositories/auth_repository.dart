import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user_entity.dart';

/// Lumo — Auth Repository Contract
abstract interface class AuthRepository {
  /// Stream of auth state changes — null means signed out.
  Stream<AuthUserEntity?> get authStateChanges;

  /// Currently signed-in user, or null.
  AuthUserEntity? get currentUser;

  Future<Either<LumoFailure, AuthUserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<LumoFailure, AuthUserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  Future<Either<LumoFailure, AuthUserEntity>> signInWithGoogle();

  Future<Either<LumoFailure, AuthUserEntity>> signInWithApple();

  Future<Either<LumoFailure, AuthUserEntity>> continueAsGuest();

  Future<Either<LumoFailure, void>> signOut();

  Future<Either<LumoFailure, void>> sendPasswordReset({required String email});
}
