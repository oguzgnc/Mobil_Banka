import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client.dart';
import '../../data/models/application_model.dart';
import '../../data/repositories/application_repository.dart';

part 'application_providers.g.dart';

@riverpod
ApplicationRepository applicationRepository(Ref ref) {
  return ApplicationRepository(ref.watch(apiClientProvider));
}

/// Başvuru geçmişini getirir
@riverpod
Future<List<ApplicationModel>> applications(Ref ref) {
  return ref.watch(applicationRepositoryProvider).getApplications();
}
