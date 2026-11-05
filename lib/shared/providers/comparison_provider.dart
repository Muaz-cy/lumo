import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/property/domain/entities/property_entity.dart';

part 'comparison_provider.g.dart';

const _maxComparison = 4;

@Riverpod(keepAlive: true)
class ComparisonNotifier extends _$ComparisonNotifier {
  @override
  List<PropertyEntity> build() => [];

  bool contains(String id) => state.any((p) => p.id == id);

  /// Returns false if already at max capacity.
  bool add(PropertyEntity property) {
    if (contains(property.id)) return true;
    if (state.length >= _maxComparison) return false;
    state = [...state, property];
    return true;
  }

  void remove(String id) => state = state.where((p) => p.id != id).toList();

  void clear() => state = [];
}
