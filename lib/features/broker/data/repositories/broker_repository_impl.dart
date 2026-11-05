import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/logging/lumo_logger.dart';
import '../../domain/entities/broker_listing_entity.dart';
import '../../domain/entities/broker_profile_entity.dart';
import '../../domain/repositories/broker_repository.dart';

/// Lumo — Broker Repository Implementation
/// All Supabase broker logic lives here. Domain never knows about Supabase.
final class BrokerRepositoryImpl implements BrokerRepository {
  const BrokerRepositoryImpl(this._client);

  final SupabaseClient _client;

  String get _userId => _client.auth.currentUser!.id;

  // ── Profile ────────────────────────────────────────────────────────────────

  @override
  Future<Either<LumoFailure, BrokerProfileEntity>> getMyProfile() async {
    try {
      final data = await _client
          .from('broker_profiles')
          .select()
          .eq('user_id', _userId)
          .single();
      return Right(_mapProfile(data));
    } on PostgrestException catch (e) {
      LumoLogger.error('Fetch broker profile failed', e);
      return Left(ServerFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Fetch broker profile unknown error', e, st);
      return const Left(UnknownFailure());
    }
  }

  // ── Listings ───────────────────────────────────────────────────────────────

  @override
  Future<Either<LumoFailure, List<BrokerListingEntity>>> getMyListings() async {
    try {
      final data = await _client
          .from('properties')
          .select()
          .eq('broker_id', _userId)
          .order('created_at', ascending: false);
      return Right((data as List).map((r) => _mapListing(r)).toList());
    } on PostgrestException catch (e) {
      LumoLogger.error('Fetch broker listings failed', e);
      return Left(ServerFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Fetch broker listings unknown error', e, st);
      return const Left(UnknownFailure());
    }
  }

  @override
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
    List<String> imageUrls = const [],
    List<String> amenities = const [],
    double? latitude,
    double? longitude,
  }) async {
    return _upsertListing(
      status: 'pending_review',
      title: title,
      titleAm: titleAm,
      priceEtb: priceEtb,
      neighborhood: neighborhood,
      city: city,
      propertyType: propertyType,
      purpose: purpose,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      areaSqm: areaSqm,
      descriptionEn: descriptionEn,
      descriptionAm: descriptionAm,
      imageUrls: imageUrls,
      amenities: amenities,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
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
    List<String> imageUrls = const [],
    List<String> amenities = const [],
    double? latitude,
    double? longitude,
  }) async {
    return _upsertListing(
      status: 'draft',
      title: title,
      titleAm: titleAm,
      priceEtb: priceEtb,
      neighborhood: neighborhood,
      city: city,
      propertyType: propertyType,
      purpose: purpose,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      areaSqm: areaSqm,
      descriptionEn: descriptionEn,
      descriptionAm: descriptionAm,
      imageUrls: imageUrls,
      amenities: amenities,
      latitude: latitude,
      longitude: longitude,
    );
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<Either<LumoFailure, BrokerListingEntity>> _upsertListing({
    required String status,
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
    List<String> imageUrls = const [],
    List<String> amenities = const [],
    double? latitude,
    double? longitude,
  }) async {
    try {
      final payload = {
        'broker_id': _userId,
        'title': title,
        'title_am': titleAm,
        'price_etb': priceEtb,
        'neighborhood': neighborhood,
        'city': city,
        'property_type': propertyType,
        'purpose': purpose,
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
        'area_sqm': areaSqm,
        'description_en': descriptionEn,
        'description_am': descriptionAm,
        'amenities': amenities,
        'status': status,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

      final data = await _client
          .from('properties')
          .insert(payload)
          .select()
          .single();

      // Insert image URLs into property_media table
      if (imageUrls.isNotEmpty) {
        final mediaPayload = imageUrls.asMap().entries.map((e) => {
              'property_id': data['id'],
              'url': e.value,
              'display_order': e.key,
            }).toList();
        await _client.from('property_media').insert(mediaPayload);
      }

      return Right(_mapListing(data));
    } on PostgrestException catch (e) {
      LumoLogger.error('Submit listing failed', e);
      return Left(ServerFailure(message: e.message));
    } catch (e, st) {
      LumoLogger.error('Submit listing unknown error', e, st);
      return const Left(UnknownFailure());
    }
  }

  BrokerProfileEntity _mapProfile(Map<String, dynamic> r) {
    return BrokerProfileEntity(
      id: r['id'] as String,
      userId: r['user_id'] as String,
      agencyName: r['agency_name'] as String? ?? '',
      phone: r['phone'] as String? ?? '',
      bio: r['bio'] as String?,
      avatarUrl: r['avatar_url'] as String?,
      isVerified: r['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(r['created_at'] as String),
    );
  }

  BrokerListingEntity _mapListing(Map<String, dynamic> r) {
    return BrokerListingEntity(
      id: r['id'] as String,
      brokerId: r['broker_id'] as String? ?? '',
      title: r['title'] as String,
      titleAm: r['title_am'] as String? ?? '',
      priceEtb: (r['price_etb'] as num).toDouble(),
      neighborhood: r['neighborhood'] as String? ?? '',
      city: r['city'] as String? ?? '',
      propertyType: r['property_type'] as String? ?? '',
      purpose: r['purpose'] as String? ?? '',
      bedrooms: r['bedrooms'] as int? ?? 0,
      bathrooms: r['bathrooms'] as int? ?? 0,
      areaSqm: (r['area_sqm'] as num?)?.toDouble() ?? 0,
      descriptionEn: r['description_en'] as String?,
      descriptionAm: r['description_am'] as String?,
      amenities: (r['amenities'] as List?)?.cast<String>() ?? [],
      status: BrokerListingStatusX.fromDb(
          r['status'] as String? ?? 'draft'),
      submittedAt: DateTime.parse(r['created_at'] as String),
      reviewNote: r['review_note'] as String?,
      reviewedAt: r['reviewed_at'] != null
          ? DateTime.parse(r['reviewed_at'] as String)
          : null,
      latitude: (r['latitude'] as num?)?.toDouble(),
      longitude: (r['longitude'] as num?)?.toDouble(),
    );
  }
}
