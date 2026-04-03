import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client.dart';
import '../../data/models/ai_opportunity_model.dart';
import '../../data/repositories/ai_opportunities_repository.dart';

part 'ai_opportunities_providers.g.dart';

@Riverpod(keepAlive: true)
AiOpportunitiesRepository aiOpportunitiesRepository(Ref ref) {
  return AiOpportunitiesRepository(ref.watch(apiClientProvider));
}

/// GET /api/ai-opportunities → fırsat listesi
@riverpod
Future<List<AiOpportunityModel>> aiOpportunities(Ref ref) {
  return ref.watch(aiOpportunitiesRepositoryProvider).getOpportunities();
}
