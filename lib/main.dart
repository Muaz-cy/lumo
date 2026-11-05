import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/lumo_app.dart';
import 'core/config/supabase_config.dart';
import 'core/logging/lumo_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await _initializeSupabase();

  runApp(
    const ProviderScope(
      child: LumoApp(),
    ),
  );
}

Future<void> _initializeSupabase() async {
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      // ignore: deprecated_member_use
      anonKey: SupabaseConfig.anonKey,
    );
    LumoLogger.info('Supabase initialized successfully.');
  } catch (e, st) {
    LumoLogger.error('Supabase initialization failed.', e, st);
  }
}
