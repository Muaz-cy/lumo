import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/lumo_app.dart';
import 'core/config/supabase_config.dart';
import 'core/logging/lumo_logger.dart';
import 'features/cart/data/models/cart_item_hive_model.dart';
import 'features/wishlist/data/models/wishlist_item_hive_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait until tablet/desktop layouts are ready
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar — Lumo owns the full canvas
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await _initializeHive();
  await _initializeSupabase();

  runApp(
    const ProviderScope(
      child: LumoApp(),
    ),
  );
}

Future<void> _initializeHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemHiveModelAdapter());
  Hive.registerAdapter(WishlistItemHiveModelAdapter());
  await Hive.openBox<CartItemHiveModel>('lumo_cart');
  await Hive.openBox<WishlistItemHiveModel>('lumo_wishlist');
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
