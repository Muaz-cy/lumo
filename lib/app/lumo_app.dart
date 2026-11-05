import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/router/app_router.dart';
import '../shared/design_system/design_system.dart';
import '../shared/providers/theme_provider.dart';
import '../shared/providers/locale_provider.dart';
import 'package:lumo/l10n/app_localizations.dart';

/// The root of Lumo.
/// Wires together: theme, routing, localization, and the provider scope.
class LumoApp extends ConsumerWidget {
  const LumoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(localeNotifierProvider);

    return MaterialApp.router(
      title: 'Lumo',
      debugShowCheckedModeBanner: false,
      theme: LumoTheme.light,
      darkTheme: LumoTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
