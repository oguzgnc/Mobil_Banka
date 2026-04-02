import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/market_product_model.dart';

part 'market_settings_providers.g.dart';

// ─── Varsayılan ürün listesi ───────────────────────────────────────────────────

const _defaultProducts = [
  MarketProductModel(id: 'bugday',      name: 'Buğday',       emoji: '🌾', riskFactor: 1.5),
  MarketProductModel(id: 'misir',       name: 'Mısır',        emoji: '🌽', riskFactor: 1.8),
  MarketProductModel(id: 'aycicegi',    name: 'Ayçiçeği',     emoji: '🌻', riskFactor: 2.2),
  MarketProductModel(id: 'pamuk',       name: 'Pamuk',        emoji: '☁️', riskFactor: 3.0),
  MarketProductModel(id: 'arpa',        name: 'Arpa',         emoji: '🫘', riskFactor: 1.6),
  MarketProductModel(id: 'domates',     name: 'Domates',      emoji: '🍅', riskFactor: 2.8),
  MarketProductModel(id: 'patates',     name: 'Patates',      emoji: '🥔', riskFactor: 2.5),
  MarketProductModel(id: 'sekerp',      name: 'Şeker Pancarı',emoji: '🌿', riskFactor: 1.9),
  MarketProductModel(id: 'zeytin',      name: 'Zeytin',       emoji: '🫒', riskFactor: 2.1),
  MarketProductModel(id: 'celtik',      name: 'Çeltik',       emoji: '🍚', riskFactor: 3.4),
  MarketProductModel(id: 'nohut',       name: 'Nohut',        emoji: '🟡', riskFactor: 1.7),
  MarketProductModel(id: 'fasulye',     name: 'Fasulye',      emoji: '🫘', riskFactor: 2.0),
];

// ─── Notifier ─────────────────────────────────────────────────────────────────

/// React'taki `useReducer` / Redux reducer mantığının Riverpod karşılığı.
/// State değişiklikleri immutable liste güncellemesiyle yapılır.
@riverpod
class MarketSettingsNotifier extends _$MarketSettingsNotifier {
  static const double _min = 1.0;
  static const double _max = 5.0;
  static const double _step = 0.1;

  @override
  List<MarketProductModel> build() => List.unmodifiable(_defaultProducts);

  void increment(String id) => _updateFactor(id, (v) => v + _step);

  void decrement(String id) => _updateFactor(id, (v) => v - _step);

  void _updateFactor(String id, double Function(double) fn) {
    state = [
      for (final p in state)
        if (p.id == id)
          p.copyWith(
            // toStringAsFixed + parse — floating point drift'i önler (0.1+0.2≠0.3)
            riskFactor: double.parse(
              fn(p.riskFactor).clamp(_min, _max).toStringAsFixed(1),
            ),
          )
        else
          p,
    ];
  }

  /// Dummy save — backend hazır olduğunda PUT /market/products ile değiştirilecek
  Future<void> save() async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: await _client.dio.put(ApiConstants.marketProducts, data: state.map(...).toList());
  }
}
