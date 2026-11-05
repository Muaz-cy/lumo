import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/broker_profile_entity.dart';
import '../entities/broker_listing_entity.dart';

/// Lumo — Broker Repository
/// Contract between domain and data. Supabase details stay in the impl.
abstract interface class BrokerRepository {
  /// Fetch the broker profile for the currently signed-in user.
  Future<Either<LumoFailure, BrokerProfileEntity>> getMyProfile();

  /// Fetch all listings submitted by the current broker.
  Future<Either<LumoFailure, List<BrokerListingEntity>>> getMyListings();

  /// Submit a new property listing for review.
  Future<Either<LumoFailure, BrokerListingEntity>> submitListing({
    required String title,
    required String titleAm,
    required double priceEtb,
    required String neighborhood,
    required String city,
    required String propertyType,
    required String purpose,
    required int bedrooms,
    required int bathrooms,
    required double areaSqm,
    String? descriptionEn,
    String? descriptionAm,
    List<String> imageUrls,
    List<String> amenities,
    double? latitude,
    double? longitude,
  });

  /// Save a draft without submitting for review.
  Future<Either<LumoFailure, BrokerListingEntity>> saveDraft({
    required String title,
    required String titleAm,
    required double priceEtb,
    required String neighborhood,
    required String city,
    required String propertyType,
    required String purpose,
    required int bedrooms,
    required int bathrooms,
    required double areaSqm,
    String? descriptionEn,
    String? descriptionAm,
    List<String> imageUrls,
    List<String> amenities,
    double? latitude,
    double? longitude,
  });
}
