import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/inquiry_entity.dart';

part 'inquiry_providers.g.dart';

@riverpod
class InquiryNotifier extends _$InquiryNotifier {
  @override
  List<InquiryEntity> build() => [];

  Future<void> submit({
    required String propertyId,
    required String propertyTitle,
    required String propertyImage,
    required String message,
  }) async {
    // Simulate network latency — replaced with Supabase insert in Phase 5
    await Future.delayed(const Duration(milliseconds: 800));

    final inquiry = InquiryEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      propertyImage: propertyImage,
      message: message,
      submittedAt: DateTime.now(),
    );

    state = [inquiry, ...state];
  }

  bool hasInquiredAbout(String propertyId) =>
      state.any((i) => i.propertyId == propertyId);
}
