// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$marketSettingsRepositoryHash() =>
    r'a87d1d903bc1a587cad75aba6601ee3d9377fad8';

/// See also [marketSettingsRepository].
@ProviderFor(marketSettingsRepository)
final marketSettingsRepositoryProvider =
    Provider<MarketSettingsRepository>.internal(
      marketSettingsRepository,
      name: r'marketSettingsRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketSettingsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketSettingsRepositoryRef = ProviderRef<MarketSettingsRepository>;
String _$marketTrendsBaseHash() => r'1ac1a879acf44ebe34ffbe020b0693dbc0377db6';

/// See also [marketTrendsBase].
@ProviderFor(marketTrendsBase)
final marketTrendsBaseProvider =
    AutoDisposeFutureProvider<List<MarketProductModel>>.internal(
      marketTrendsBase,
      name: r'marketTrendsBaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketTrendsBaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketTrendsBaseRef =
    AutoDisposeFutureProviderRef<List<MarketProductModel>>;
String _$marketSettingsNotifierHash() =>
    r'f2e0c035d490b0508ff064e9ed9996b68ea4c551';

/// See also [MarketSettingsNotifier].
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
