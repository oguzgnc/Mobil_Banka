import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/farmers/presentation/screens/farmers_screen.dart';
import '../../features/farmers/presentation/screens/farmer_detail_screen.dart';
import '../../features/application/presentation/screens/new_application_screen.dart';
import '../../features/market_settings/presentation/screens/market_settings_screen.dart';
import '../../features/ai_opportunities/presentation/screens/ai_opportunities_screen.dart';
import 'app_shell.dart';

part 'app_router.g.dart';

// Route path sabitleri
abstract final class AppRoutes {
  static const dashboard       = '/';
  static const farmers         = '/farmers';
  static const farmerDetail    = '/farmers/:id';
  static const newApplication  = '/application';
  static const marketSettings  = '/market-settings';
  static const aiOpportunities = '/ai-opportunities';
}

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // Branch 0 — Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashboardScreen(),
                ),
              ),
            ],
          ),

          // Branch 1 — ÇKS / Farmers
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.farmers,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: FarmersScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => FarmerDetailScreen(
                      farmerId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Branch 2 — Yeni Başvuru
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.newApplication,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: NewApplicationScreen(),
                ),
              ),
            ],
          ),

          // Branch 3 — Piyasa Ayarları
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.marketSettings,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MarketSettingsScreen(),
                ),
              ),
            ],
          ),

          // Branch 4 — VIP Fırsatlar (AI Opportunities)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.aiOpportunities,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AiOpportunitiesScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Sayfa bulunamadı',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(state.error?.message ?? ''),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.dashboard),
              child: const Text('Ana Sayfaya Dön'),
            ),
          ],
        ),
      ),
    ),
  );
}
