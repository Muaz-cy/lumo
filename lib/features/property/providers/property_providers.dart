import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/property_entity.dart';

part 'property_providers.g.dart';

SupabaseClient get _db => Supabase.instance.client;

// Shared query columns — keeps both providers consistent.
const _propertySelect =
    '*, property_media(url), profiles(display_name, avatar_url)';

@riverpod
Future<PropertyEntity> propertyDetail(Ref ref, String id) async {
  final row = await _db
      .from('properties')
      .select(_propertySelect)
      .eq('id', id)
      .eq('status', 'approved')
      .single();
  return PropertyEntity.fromDb(row);
}

@riverpod
Future<List<PropertyEntity>> similarProperties(Ref ref, String id) async {
  // Fetch the subject property's type + neighborhood first.
  final subject = await ref.watch(propertyDetailProvider(id).future);

  final rows = await _db
      .from('properties')
      .select(_propertySelect)
      .eq('status', 'approved')
      .eq('property_type', subject.propertyType.name)
      .neq('id', id)
      .limit(4);

  return (rows as List).map((r) => PropertyEntity.fromDb(r)).toList();
}
