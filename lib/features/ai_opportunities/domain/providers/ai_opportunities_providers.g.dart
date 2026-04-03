// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_opportunities_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiOpportunitiesRepositoryHash() =>
    r'332904402e8dad57c4869f9758f07b175db2d9a0';

/// See also [aiOpportunitiesRepository].
@ProviderFor(aiOpportunitiesRepository)
final aiOpportunitiesRepositoryProvider =
    Provider<AiOpportunitiesRepository>.internal(
      aiOpportunitiesRepository,
      name: r'aiOpportunitiesRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aiOpportunitiesRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiOpportunitiesRepositoryRef = ProviderRef<AiOpportunitiesRepository>;
String _$aiOpportunitiesHash() => r'eba5c58aff343352c8aed0b383211a0050a1061c';

/// GET /api/ai-opportunities → fırsat listesi
///
/// Copied from [aiOpportunities].
@ProviderFor(aiOpportunities)
final aiOpportunitiesProvider =
    AutoDisposeFutureProvider<List<AiOpportunityModel>>.internal(
      aiOpportunities,
      name: r'aiOpportunitiesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aiOpportunitiesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiOpportunitiesRef =
    AutoDisposeFutureProviderRef<List<AiOpportunityModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
