import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../property/domain/entities/property_entity.dart';

part 'saved_providers.g.dart';

/// Saved property — lightweight reference stored in memory.
/// Replaced with Supabase saved_properties table in Phase 4.
class SavedProperty {
  const SavedProperty({required this.property});
  final PropertyEntity property;
}

@riverpod
class SavedNotifier extends _$SavedNotifier {
  @override
  List<SavedProperty> build() => [];

  bool isSaved(String propertyId) =>
      state.any((s) => s.property.id == propertyId);

  void toggle(PropertyEntity property) {
    if (isSaved(property.id)) {
      state = state.where((s) => s.property.id != property.id).toList();
    } else {
      state = [...state, SavedProperty(property: property)];
    }
  }
}
