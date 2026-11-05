import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/repositories/broker_repository_impl.dart';
import '../domain/entities/broker_listing_entity.dart';
import '../domain/entities/broker_profile_entity.dart';
import '../domain/repositories/broker_repository.dart';

part 'broker_providers.g.dart';

@riverpod
BrokerRepository brokerRepository(Ref ref) =>
    BrokerRepositoryImpl(Supabase.instance.client);

@riverpod
Future<BrokerProfileEntity> brokerProfile(Ref ref) async {
  final result = await ref.watch(brokerRepositoryProvider).getMyProfile();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (profile) => profile,
  );
}

@riverpod
Future<List<BrokerListingEntity>> brokerListings(Ref ref) async {
  final result = await ref.watch(brokerRepositoryProvider).getMyListings();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (listings) => listings,
  );
}

/// Handles the multi-step listing submission form state and submission.
@riverpod
class ListingSubmissionNotifier extends _$ListingSubmissionNotifier {
  @override
  ListingSubmissionState build() => const ListingSubmissionState();

  void updateStep1({
    required String title,
    required String titleAm,
    required double priceEtb,
    required String propertyType,
    required String purpose,
  }) {
    state = state.copyWith(
      title: title,
      titleAm: titleAm,
      priceEtb: priceEtb,
      propertyType: propertyType,
      purpose: purpose,
    );
  }

  void updateStep2({
    required String neighborhood,
    required String city,
    double? latitude,
    double? longitude,
  }) {
    state = state.copyWith(
      neighborhood: neighborhood,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
  }

  void updateStep3({
    required int bedrooms,
    required int bathrooms,
    required double areaSqm,
    required List<String> amenities,
    String? descriptionEn,
    String? descriptionAm,
  }) {
    state = state.copyWith(
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      areaSqm: areaSqm,
      amenities: amenities,
      descriptionEn: descriptionEn,
      descriptionAm: descriptionAm,
    );
  }

  void updateStep4({required List<String> imageUrls}) {
    state = state.copyWith(imageUrls: imageUrls);
  }

  Future<bool> submit() async {
    state = state.copyWith(isSubmitting: true, error: null);
    final result = await ref.read(brokerRepositoryProvider).submitListing(
          title: state.title,
          titleAm: state.titleAm,
          priceEtb: state.priceEtb,
          neighborhood: state.neighborhood,
          city: state.city,
          propertyType: state.propertyType,
          purpose: state.purpose,
          bedrooms: state.bedrooms,
          bathrooms: state.bathrooms,
          areaSqm: state.areaSqm,
          descriptionEn: state.descriptionEn,
          descriptionAm: state.descriptionAm,
          imageUrls: state.imageUrls,
          amenities: state.amenities,
          latitude: state.latitude,
          longitude: state.longitude,
        );

    return result.fold(
      (failure) {
        state = state.copyWith(isSubmitting: false, error: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isSubmitting: false);
        // Invalidate listings so My Listings refreshes
        ref.invalidate(brokerListingsProvider);
        return true;
      },
    );
  }

  void reset() => state = const ListingSubmissionState();
}

/// Immutable form state for the multi-step submission flow.
class ListingSubmissionState {
  const ListingSubmissionState({
    this.title = '',
    this.titleAm = '',
    this.priceEtb = 0,
    this.propertyType = 'apartment',
    this.purpose = 'sale',
    this.neighborhood = '',
    this.city = 'Addis Ababa',
    this.bedrooms = 1,
    this.bathrooms = 1,
    this.areaSqm = 0,
    this.amenities = const [],
    this.imageUrls = const [],
    this.descriptionEn,
    this.descriptionAm,
    this.latitude,
    this.longitude,
    this.isSubmitting = false,
    this.error,
  });

  final String title;
  final String titleAm;
  final double priceEtb;
  final String propertyType;
  final String purpose;
  final String neighborhood;
  final String city;
  final int bedrooms;
  final int bathrooms;
  final double areaSqm;
  final List<String> amenities;
  final List<String> imageUrls;
  final String? descriptionEn;
  final String? descriptionAm;
  final double? latitude;
  final double? longitude;
  final bool isSubmitting;
  final String? error;

  ListingSubmissionState copyWith({
    String? title,
    String? titleAm,
    double? priceEtb,
    String? propertyType,
    String? purpose,
    String? neighborhood,
    String? city,
    int? bedrooms,
    int? bathrooms,
    double? areaSqm,
    List<String>? amenities,
    List<String>? imageUrls,
    String? descriptionEn,
    String? descriptionAm,
    double? latitude,
    double? longitude,
    bool? isSubmitting,
    String? error,
  }) {
    return ListingSubmissionState(
      title: title ?? this.title,
      titleAm: titleAm ?? this.titleAm,
      priceEtb: priceEtb ?? this.priceEtb,
      propertyType: propertyType ?? this.propertyType,
      purpose: purpose ?? this.purpose,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      areaSqm: areaSqm ?? this.areaSqm,
      amenities: amenities ?? this.amenities,
      imageUrls: imageUrls ?? this.imageUrls,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAm: descriptionAm ?? this.descriptionAm,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}
