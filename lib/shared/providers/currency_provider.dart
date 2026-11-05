import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'currency_provider.g.dart';

// ── Keys ──────────────────────────────────────────────────────────────────────

const _kRate = 'lumo_etb_per_usd';
const _kRateTs = 'lumo_etb_per_usd_ts';
const _kShowUsd = 'lumo_show_usd';

// 12-hour cache — aligns with the project's manual-rate philosophy
const _cacheDuration = Duration(hours: 12);

// ── Exchange rate state ───────────────────────────────────────────────────────

final class ExchangeRateState {
  const ExchangeRateState({
    required this.etbPerUsd,
    required this.updatedAt,
    required this.isStale,
  });

  /// How many ETB equal 1 USD.
  final double etbPerUsd;

  /// When this rate was last fetched.
  final DateTime updatedAt;

  /// True when the cached rate is older than [_cacheDuration].
  final bool isStale;

  double toUsd(double etb) => etb / etbPerUsd;
}

// ── Exchange rate notifier ────────────────────────────────────────────────────

@riverpod
class ExchangeRateNotifier extends _$ExchangeRateNotifier {
  static const _apiUrl =
      'https://open.er-api.com/v6/latest/USD';

  @override
  Future<ExchangeRateState> build() => _load();

  Future<ExchangeRateState> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedRate = prefs.getDouble(_kRate);
    final cachedTs = prefs.getInt(_kRateTs);

    final now = DateTime.now();

    if (cachedRate != null && cachedTs != null) {
      final savedAt = DateTime.fromMillisecondsSinceEpoch(cachedTs);
      final age = now.difference(savedAt);
      if (age < _cacheDuration) {
        return ExchangeRateState(
          etbPerUsd: cachedRate,
          updatedAt: savedAt,
          isStale: false,
        );
      }
    }

    // Cache miss or stale — fetch fresh rate.
    return _fetchAndCache(prefs, cachedRate);
  }

  Future<ExchangeRateState> _fetchAndCache(
    SharedPreferences prefs,
    double? fallback,
  ) async {
    try {
      final dio = Dio();
      final response = await dio
          .get(_apiUrl)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final rates = data['rates'] as Map<String, dynamic>;
        final rate = (rates['ETB'] as num).toDouble();
        final now = DateTime.now();

        await prefs.setDouble(_kRate, rate);
        await prefs.setInt(_kRateTs, now.millisecondsSinceEpoch);

        return ExchangeRateState(
          etbPerUsd: rate,
          updatedAt: now,
          isStale: false,
        );
      }
    } catch (_) {
      // Network failure — fall through to fallback.
    }

    // Use cached fallback if available, otherwise use a conservative estimate.
    final rate = fallback ?? 125.0;
    return ExchangeRateState(
      etbPerUsd: rate,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        prefs.getInt(_kRateTs) ?? 0,
      ),
      isStale: true,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final prefs = await SharedPreferences.getInstance();
    state = await AsyncValue.guard(() => _fetchAndCache(prefs, null));
  }
}

// ── Currency display toggle ───────────────────────────────────────────────────

enum CurrencyDisplay { etb, usd }

@riverpod
class CurrencyDisplayNotifier extends _$CurrencyDisplayNotifier {
  @override
  CurrencyDisplay build() {
    _load();
    return CurrencyDisplay.etb;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kShowUsd) == true) {
      state = CurrencyDisplay.usd;
    }
  }

  Future<void> toggle() async {
    final next = state == CurrencyDisplay.etb
        ? CurrencyDisplay.usd
        : CurrencyDisplay.etb;
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kShowUsd, next == CurrencyDisplay.usd);
  }

  Future<void> set(CurrencyDisplay display) async {
    state = display;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kShowUsd, display == CurrencyDisplay.usd);
  }
}
