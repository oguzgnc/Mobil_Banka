import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client.dart';
import '../../data/models/farmer_model.dart';
import '../../data/repositories/farmer_repository.dart';

part 'farmer_providers.g.dart';

@riverpod
FarmerRepository farmerRepository(Ref ref) {
  return FarmerRepository(ref.watch(apiClientProvider));
}

/// Tüm çiftçi listesini getirir
@riverpod
Future<List<FarmerModel>> farmers(Ref ref) {
  return ref.watch(farmerRepositoryProvider).getFarmers();
}

/// Tek çiftçi detayını getirir — farmerId parametresi ile aile provider'ı
@riverpod
Future<FarmerModel> farmerDetail(Ref ref, String farmerId) {
  return ref.watch(farmerRepositoryProvider).getFarmerById(farmerId);
}
