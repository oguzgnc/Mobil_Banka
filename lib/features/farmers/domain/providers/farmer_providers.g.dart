// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$farmerRepositoryHash() => r'31871f4820a1dd60a7ba6b57c4c35e00b8dd92e2';

/// See also [farmerRepository].
@ProviderFor(farmerRepository)
final farmerRepositoryProvider = AutoDisposeProvider<FarmerRepository>.internal(
  farmerRepository,
  name: r'farmerRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$farmerRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FarmerRepositoryRef = AutoDisposeProviderRef<FarmerRepository>;
String _$farmersHash() => r'e14cf9a90a26ea2fe863bf35859d23b5ec54c72e';

/// Tüm çiftçi listesini getirir
///
/// Copied from [farmers].
@ProviderFor(farmers)
final farmersProvider = AutoDisposeFutureProvider<List<FarmerModel>>.internal(
  farmers,
  name: r'farmersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$farmersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FarmersRef = AutoDisposeFutureProviderRef<List<FarmerModel>>;
String _$farmerDetailHash() => r'10bc423480d4f4f7e27fb4137806619729216286';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Tek çiftçi detayını getirir — farmerId parametresi ile aile provider'ı
///
/// Copied from [farmerDetail].
@ProviderFor(farmerDetail)
const farmerDetailProvider = FarmerDetailFamily();

/// Tek çiftçi detayını getirir — farmerId parametresi ile aile provider'ı
///
/// Copied from [farmerDetail].
class FarmerDetailFamily extends Family<AsyncValue<FarmerModel>> {
  /// Tek çiftçi detayını getirir — farmerId parametresi ile aile provider'ı
  ///
  /// Copied from [farmerDetail].
  const FarmerDetailFamily();

  /// Tek çiftçi detayını getirir — farmerId parametresi ile aile provider'ı
  ///
  /// Copied from [farmerDetail].
  FarmerDetailProvider call(String farmerId) {
    return FarmerDetailProvider(farmerId);
  }

  @override
  FarmerDetailProvider getProviderOverride(
    covariant FarmerDetailProvider provider,
  ) {
    return call(provider.farmerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'farmerDetailProvider';
}

/// Tek çiftçi detayını getirir — farmerId parametresi ile aile provider'ı
///
/// Copied from [farmerDetail].
class FarmerDetailProvider extends AutoDisposeFutureProvider<FarmerModel> {
  /// Tek çiftçi detayını getirir — farmerId parametresi ile aile provider'ı
  ///
  /// Copied from [farmerDetail].
  FarmerDetailProvider(String farmerId)
    : this._internal(
        (ref) => farmerDetail(ref as FarmerDetailRef, farmerId),
        from: farmerDetailProvider,
        name: r'farmerDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$farmerDetailHash,
        dependencies: FarmerDetailFamily._dependencies,
        allTransitiveDependencies:
            FarmerDetailFamily._allTransitiveDependencies,
        farmerId: farmerId,
      );

  FarmerDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmerId,
  }) : super.internal();

  final String farmerId;

  @override
  Override overrideWith(
    FutureOr<FarmerModel> Function(FarmerDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FarmerDetailProvider._internal(
        (ref) => create(ref as FarmerDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmerId: farmerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FarmerModel> createElement() {
    return _FarmerDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmerDetailProvider && other.farmerId == farmerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FarmerDetailRef on AutoDisposeFutureProviderRef<FarmerModel> {
  /// The parameter `farmerId` of this provider.
  String get farmerId;
}

class _FarmerDetailProviderElement
    extends AutoDisposeFutureProviderElement<FarmerModel>
    with FarmerDetailRef {
  _FarmerDetailProviderElement(super.provider);

  @override
  String get farmerId => (origin as FarmerDetailProvider).farmerId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
