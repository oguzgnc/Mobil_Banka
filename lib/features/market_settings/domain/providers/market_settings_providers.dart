import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client.dart';
import '../../data/models/market_product_model.dart';
import '../../data/repositories/market_settings_repository.dart';

part 'market_settings_providers.g.dart';

// ─── Repository Provider ──────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
MarketSettingsRepository marketSettingsRepository(Ref ref) {
  return MarketSettingsRepository(ref.watch(apiClientProvider));
}

// ─── API veri kaynağı (AsyncValue) ───────────────────────────────────────────

@riverpod
Future<List<MarketProductModel>> marketTrendsBase(Ref ref) {
  return ref.watch(marketSettingsRepositoryProvider).getMarketTrends();
}

// ─── Notifier (UI = List<MarketProductModel> — arayüz değişmedi) ─────────────

@riverpod
class MarketSettingsNotifier extends _$MarketSettingsNotifier {
  // Backend kısıtı: etki_puani -2.0 ile +2.0 arasında olmalıdır
  static const double _min  = -2.0;
  static const double _max  =  2.0;
  static const double _step =  0.1;

  @override
  List<MarketProductModel> build() {
    // marketTrendsBaseProvider yüklenince state otomatik güncellenir.
    // Yükleme/hata durumunda boş liste döner — UI boş kart gösterir.
    return ref.watch(marketTrendsBaseProvider).valueOrNull ?? const [];
  }

  void increment(String id) => _updateFactor(id, (v) => v + _step);
  void decrement(String id) => _updateFactor(id, (v) => v - _step);

  void _updateFactor(String id, double Function(double) fn) {
    state = [
      for (final p in state)
        if (p.id == id)
          p.copyWith(
            riskFactor: double.parse(
              fn(p.riskFactor).clamp(_min, _max).toStringAsFixed(1),
            ),
          )
        else
          p,
    ];
  }

  /// PUT /api/market-trends/{id} — tüm değişiklikleri paralel kaydeder
  Future<void> save() async {
    await ref.read(marketSettingsRepositoryProvider).saveAll(state);
  }
}
