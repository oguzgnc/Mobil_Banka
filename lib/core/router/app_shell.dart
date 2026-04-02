import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  static const _tabs = [
    _NavItem(
      index: 0,
      label: 'Gösterge Paneli',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
    ),
    _NavItem(
      index: 1,
      label: 'ÇKS Analizleri',
      icon: Icons.agriculture_outlined,
      activeIcon: Icons.agriculture,
    ),
    _NavItem(
      index: 2,
      label: 'Yeni Başvuru',
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
    ),
    _NavItem(
      index: 3,
      label: 'Piyasa Ayarları',
      icon: Icons.tune_outlined,
      activeIcon: Icons.tune,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[currentIndex].label),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menü',
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: _AppDrawer(
        currentIndex: currentIndex,
        onTap: _onTap,
      ),
      body: navigationShell,
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

// ─── Drawer Widget ────────────────────────────────────────────────────────────

class _AppDrawer extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _AppDrawer({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cardBackground,
      child: Column(
        children: [
          _DrawerHeader(),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: AppShell._tabs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (context, i) {
                final item = AppShell._tabs[i];
                final isActive = currentIndex == item.index;
                return _DrawerTile(
                  item: item,
                  isActive: isActive,
                  onTap: () {
                    Navigator.of(context).pop();
                    onTap(item.index);
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          _DrawerFooter(),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
      ),
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.grass,
              size: 30,
              color: AppColors.textOnPrimary,
            ),
          ),
          const Spacer(),
          Text(
            'Tarım Kredi',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Karar Destek Sistemi',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListTile(
        leading: Icon(
          isActive ? item.activeIcon : item.icon,
          color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
          size: 22,
        ),
        title: Text(
          item.label,
          style: isActive
              ? AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                )
              : AppTextStyles.titleMedium,
        ),
        selected: isActive,
        selectedTileColor: AppColors.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: onTap,
        dense: false,
        minLeadingWidth: 24,
      ),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.textDisabled),
          const SizedBox(width: 8),
          Text(
            'v1.0.0 — Tarım ve Orman Bakanlığı',
            style: AppTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}

// ─── Model ────────────────────────────────────────────────────────────────────

class _NavItem {
  final int index;
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
