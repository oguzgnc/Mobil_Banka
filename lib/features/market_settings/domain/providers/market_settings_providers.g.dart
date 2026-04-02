// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$marketSettingsNotifierHash() =>
    r'33073f4aa29d3676a4bef68d3004bddd4f0c7c6c';

/// React'taki `useReducer` / Redux reducer mantığının Riverpod karşılığı.
/// State değişiklikleri immutable liste güncellemesiyle yapılır.
///
/// Copied from [MarketSettingsNotifier].
@ProviderFor(MarketSettingsNotifier)
final marketSettingsNotifierProvider =
    AutoDisposeNotifierProvider<
      MarketSettingsNotifier,
      List<MarketProductModel>
    >.internal(
      MarketSettingsNotifier.new,
      name: r'marketSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarketSettingsNotifier =
    AutoDisposeNotifier<List<MarketProductModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
