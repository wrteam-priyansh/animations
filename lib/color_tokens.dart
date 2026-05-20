import 'package:flutter/material.dart';

class ColorTokens {
  ColorTokens._();

  // ── Seed / Brand Colors ──────────────────────────────────────────────────
  static const Color seedPrimary = Color(0xFFEF5388);// 
  static const Color seedNeutral = Color(0xFF808080);
  static const Color seedSuccess = Color(0xFF34C759);
  static const Color seedError = Color(0xFFB3261E);



  // ── Primary ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFEF5388);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFFD8E4);
  static const Color onPrimaryContainer = Color(0xFF3E001D);

  // ── Surface (derived from neutral #808080) ────────────────────────────────
  static const Color surfaceBright = Color(0xFFFFFBFF);
  static const Color surface = Color(0xFFFFFBFF);
  static const Color surfaceDim = Color(0xFFDDD9D9);

  // ── Elevation / Surface Containers ───────────────────────────────────────
  static const Color surfContainerHighest = Color(0xFFE6E1E1);
  static const Color surfContainerHigh = Color(0xFFEBE6E6);
  static const Color surfContainer = Color(0xFFF1ECEC);
  static const Color surfContainerLow = Color(0xFFF7F2F2);
  static const Color surfContainerLowest = Color(0xFFFFFFFF);

  // ── Utility ──────────────────────────────────────────────────────────────
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVar = Color(0xFF49454F);
  static const Color outlineHigh = Color(0xFF7A7575);
  static const Color outline = Color(0xFF7A7575);
  static const Color outlineDim = Color(0xFFCAC4C4);

  // ── Inverse ──────────────────────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFF313030);
  static const Color inverseOnSurface = Color(0xFFF4EFEF);
  static const Color inversePrimary = Color(0xFFFFB0C8);

  // ── Status & Feedback ────────────────────────────────────────────────────
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color success = Color(0xFF34C759);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFB8F5C8);

  // ── Fixed ────────────────────────────────────────────────────────────────
  static const Color primaryFixed = Color(0xFFFFD8E4);
  static const Color primaryFixedDim = Color(0xFFFFB0C8);
  static const Color onPrimaryFixed = Color(0xFF3E001D);
  static const Color onPrimaryFixedVariant = Color(0xFF7B1150);

  // ── Orange ───────────────────────────────────────────────────────────────
  static const Color orange = Color(0x00000000);
  static const Color orangeContainer = Color(0x00000000);
  static const Color onOrange = Color(0x00000000);

  // ── Purple ───────────────────────────────────────────────────────────────
  static const Color purple = Color(0x00000000);
  static const Color purpleContainer = Color(0x00000000);
  static const Color onPurple = Color(0x00000000);

  // ── Blue ─────────────────────────────────────────────────────────────────
  static const Color blue = Color(0x00000000);
  static const Color onBlue = Color(0x00000000);
  static const Color blueContainer = Color(0x00000000);
  static const Color onBlueContainer = Color(0x00000000);

  // ── Yellow ───────────────────────────────────────────────────────────────
  static const Color yellow = Color(0x00000000);
  static const Color yellowContainer = Color(0x00000000);
  static const Color onYellow = Color(0x00000000);

  // ── Missing from Material ColorScheme ────────────────────────────────────

  // Secondary (Material ColorScheme — not yet in design system)
  static const Color secondary = Color(0x00000000);
  static const Color onSecondary = Color(0x00000000);
  static const Color secondaryContainer = Color(0x00000000);
  static const Color onSecondaryContainer = Color(0x00000000);
  static const Color secondaryFixed = Color(0x00000000);
  static const Color secondaryFixedDim = Color(0x00000000);
  static const Color onSecondaryFixed = Color(0x00000000);
  static const Color onSecondaryFixedVariant = Color(0x00000000);

  // Tertiary (Material ColorScheme — not yet in design system)
  static const Color tertiary = Color(0x00000000);
  static const Color onTertiary = Color(0x00000000);
  static const Color tertiaryContainer = Color(0x00000000);
  static const Color onTertiaryContainer = Color(0x00000000);
  static const Color tertiaryFixed = Color(0x00000000);
  static const Color tertiaryFixedDim = Color(0x00000000);
  static const Color onTertiaryFixed = Color(0x00000000);
  static const Color onTertiaryFixedVariant = Color(0x00000000);

  // Error — missing variant (Material ColorScheme)
  static const Color onErrorContainer = Color(0x00000000);

  // Utility — missing (Material ColorScheme)
  static const Color outlineVariant = Color(0x00000000);
  static const Color shadow = Color(0x00000000);
  static const Color scrim = Color(0x00000000);

  // Inverse — missing (Material ColorScheme)
  static const Color onInverseSurface = Color(0x00000000);

  // Surface tint (Material ColorScheme)
  static const Color surfaceTint = Color(0x00000000);
}
