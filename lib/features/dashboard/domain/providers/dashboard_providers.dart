import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client.dart';
import '../../data/models/dashboard_kpi_model.dart';
import '../../data/repositories/dashboard_repository.dart';

part 'dashboard_providers.g.dart';

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  return DashboardRepository(ref.watch(apiClientProvider));
}

@riverpod
Future<DashboardKpiModel> dashboardKpi(Ref ref) {
  return ref.watch(dashboardRepositoryProvider).getKpi();
}
