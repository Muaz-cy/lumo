import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/home_section.dart';

/// Lumo — Home Repository Contract
/// Domain defines the contract. Data layer implements it.
/// UI never knows where data comes from.
abstract interface class HomeRepository {
  Future<Either<LumoFailure, List<HomeSection>>> getHomeSections();
}
