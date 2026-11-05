import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/home_section.dart';
import '../../domain/repositories/home_repository.dart';

/// Lumo — Home Repository Implementation
/// Supabase integration wired in Phase 7.
/// Currently unused — app reads directly from home_providers.dart mock.
final class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl();

  @override
  Future<Either<LumoFailure, List<HomeSection>>> getHomeSections() async {
    return const Right([]);
  }
}
