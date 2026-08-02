import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_providers.g.dart';

// ─── Settings State ───────────────────────────────────────────────────────────

final class SettingsState {
  const SettingsState({
    this.promotionsEnabled = true,
    this.orderUpdatesEnabled = true,
    this.newArrivalsEnabled = false,
    this.analyticsEnabled = true,
    this.personalisedAdsEnabled = false,
  });

  final bool promotionsEnabled;
  final bool orderUpdatesEnabled;
  final bool newArrivalsEnabled;
  final bool analyticsEnabled;
  final bool personalisedAdsEnabled;

  SettingsState copyWith({
    bool? promotionsEnabled,
    bool? orderUpdatesEnabled,
    bool? newArrivalsEnabled,
    bool? analyticsEnabled,
    bool? personalisedAdsEnabled,
  }) =>
      SettingsState(
        promotionsEnabled: promotionsEnabled ?? this.promotionsEnabled,
        orderUpdatesEnabled: orderUpdatesEnabled ?? this.orderUpdatesEnabled,
        newArrivalsEnabled: newArrivalsEnabled ?? this.newArrivalsEnabled,
        analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
        personalisedAdsEnabled:
            personalisedAdsEnabled ?? this.personalisedAdsEnabled,
      );
}

// ─── Keys ─────────────────────────────────────────────────────────────────────

const _kPromotions = 'lumo_setting_promotions';
const _kOrderUpdates = 'lumo_setting_order_updates';
const _kNewArrivals = 'lumo_setting_new_arrivals';
const _kAnalytics = 'lumo_setting_analytics';
const _kPersonalisedAds = 'lumo_setting_personalised_ads';

// ─── Notifier ─────────────────────────────────────────────────────────────────

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsState build() {
    _load();
    return const SettingsState();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      promotionsEnabled: prefs.getBool(_kPromotions) ?? true,
      orderUpdatesEnabled: prefs.getBool(_kOrderUpdates) ?? true,
      newArrivalsEnabled: prefs.getBool(_kNewArrivals) ?? false,
      analyticsEnabled: prefs.getBool(_kAnalytics) ?? true,
      personalisedAdsEnabled: prefs.getBool(_kPersonalisedAds) ?? false,
    );
  }

  Future<void> setPromotions(bool value) async {
    state = state.copyWith(promotionsEnabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPromotions, value);
  }

  Future<void> setOrderUpdates(bool value) async {
    state = state.copyWith(orderUpdatesEnabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOrderUpdates, value);
  }

  Future<void> setNewArrivals(bool value) async {
    state = state.copyWith(newArrivalsEnabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNewArrivals, value);
  }

  Future<void> setAnalytics(bool value) async {
    state = state.copyWith(analyticsEnabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAnalytics, value);
  }

  Future<void> setPersonalisedAds(bool value) async {
    state = state.copyWith(personalisedAdsEnabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPersonalisedAds, value);
  }
}
