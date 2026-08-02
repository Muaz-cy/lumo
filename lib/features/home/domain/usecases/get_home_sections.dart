import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/home_section.dart';
import '../repositories/home_repository.dart';

/// Lumo — GetHomeSections Use Case
/// Single responsibility: fetch and return the ordered home sections.
final class GetHomeSections {
  const GetHomeSections(this._repository);

  final HomeRepository _repository;

  Future<Either<LumoFailure, List<HomeSection>>> call() =>
      _repository.getHomeSections();
}
