// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$applicationRepositoryHash() =>
    r'63fc686f2e5f1c9ba7e04a64870a182b9c2cb48a';

/// See also [applicationRepository].
@ProviderFor(applicationRepository)
final applicationRepositoryProvider =
    AutoDisposeProvider<ApplicationRepository>.internal(
      applicationRepository,
      name: r'applicationRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$applicationRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApplicationRepositoryRef =
    AutoDisposeProviderRef<ApplicationRepository>;
String _$applicationsHash() => r'6e256d39693ff69f2e4f75d089fa898146b64006';

/// Başvuru geçmişini getirir
///
/// Copied from [applications].
@ProviderFor(applications)
final applicationsProvider =
    AutoDisposeFutureProvider<List<ApplicationModel>>.internal(
      applications,
      name: r'applicationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$applicationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApplicationsRef = AutoDisposeFutureProviderRef<List<ApplicationModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
