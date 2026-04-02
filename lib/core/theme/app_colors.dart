import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand — tarımsal yeşil skalası
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryContainer = Color(0xFFC8E6C9);
  static const Color onPrimaryContainer = Color(0xFF1B5E20);

  // Accent
  static const Color secondary = Color(0xFF558B2F);
  static const Color secondaryContainer = Color(0xFFDCEDC8);

  // Semantic
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57F17);
  static const Color error = Color(0xFFB71C1C);
  static const Color errorContainer = Color(0xFFFFCDD2);
  static const Color info = Color(0xFF0277BD);

  // Status — başvuru durumları için
  static const Color statusApproved = Color(0xFF2E7D32);
  static const Color statusPending = Color(0xFFF57F17);
  static const Color statusRejected = Color(0xFFB71C1C);
  static const Color statusUnderReview = Color(0xFF0277BD);

  // Neutral
  static const Color surface = Color(0xFFF9FBF7);
  static const Color surfaceVariant = Color(0xFFEEF2EA);
  static const Color background = Color(0xFFF1F5EE);
  static const Color onSurface = Color(0xFF1C2019);
  static const Color onSurfaceVariant = Color(0xFF43483F);
  static const Color outline = Color(0xFF73796E);
  static const Color outlineVariant = Color(0xFFC3C8BC);

  // Card & shadow
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color shadow = Color(0x1A000000);

  // Text
  static const Color textPrimary = Color(0xFF1C2019);
  static const Color textSecondary = Color(0xFF43483F);
  static const Color textDisabled = Color(0xFF9EA59A);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
}
