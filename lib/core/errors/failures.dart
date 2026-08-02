/// Lumo — Domain Failures
/// Every failure in the application is represented here.
/// UI never receives raw exceptions — only typed failures.
sealed class LumoFailure {
  const LumoFailure({required this.message});
  final String message;
}

final class NetworkFailure extends LumoFailure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

final class ServerFailure extends LumoFailure {
  const ServerFailure({super.message = 'Something went wrong. Please try again.', this.statusCode});
  final int? statusCode;
}

final class AuthenticationFailure extends LumoFailure {
  const AuthenticationFailure({super.message = 'Authentication failed. Please sign in again.'});
}

final class TimeoutFailure extends LumoFailure {
  const TimeoutFailure({super.message = 'Request timed out. Please try again.'});
}

final class CacheFailure extends LumoFailure {
  const CacheFailure({super.message = 'Could not load saved data.'});
}

final class ValidationFailure extends LumoFailure {
  const ValidationFailure({required super.message});
}

final class NotFoundFailure extends LumoFailure {
  const NotFoundFailure({super.message = 'The requested item could not be found.'});
}

final class UnknownFailure extends LumoFailure {
  const UnknownFailure({super.message = 'An unexpected error occurred.'});
}
