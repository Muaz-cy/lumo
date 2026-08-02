import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/datasources/home_remote_data_source.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/entities/home_section.dart';
import '../domain/usecases/get_home_sections.dart';

part 'home_providers.g.dart';

@riverpod
HomeRemoteDataSource homeRemoteDataSource(Ref ref) =>
    HomeRemoteDataSource(Supabase.instance.client);

@riverpod
HomeRepositoryImpl homeRepository(Ref ref) =>
    HomeRepositoryImpl(ref.watch(homeRemoteDataSourceProvider));

@riverpod
GetHomeSections getHomeSections(Ref ref) =>
    GetHomeSections(ref.watch(homeRepositoryProvider));

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  Future<List<HomeSection>> build() => _fetch();

  Future<List<HomeSection>> _fetch() async {
    final result = await ref.watch(getHomeSectionsProvider).call();
    return result.fold(
      (failure) => throw failure,
      (sections) => sections,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}
