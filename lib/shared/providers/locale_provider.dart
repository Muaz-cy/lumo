import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

/// Lumo — Locale Provider
/// Persists the user's language choice across sessions.
/// Supported: English (en), Amharic (am).
/// Arabic (ar) is architecturally ready — add to supportedLocales when needed.
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  static const _key = 'lumo_locale';

  @override
  Locale build() {
    _loadSavedLocale();
    return const Locale('en'); // default until prefs load
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) {
      state = Locale(code);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }

  void setEnglish() => setLocale(const Locale('en'));
  void setAmharic() => setLocale(const Locale('am'));
}
