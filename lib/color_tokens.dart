import 'package:flutter/material.dart';

import 'color_shades.dart';

class ColorTokens {
  ColorTokens._();

  // ── Seed Palettes ─────────────────────────────────────────────────────────
  static final primary = ColorShades(const Color(0xFFEF5388));
  static final neutral = ColorShades(const Color(0xFF808080));
  static final error   = ColorShades(const Color(0xFFB3261E));
  static final success = ColorShades(const Color(0xFF34C759));
  static final orange  = ColorShades(const Color(0xFFFA5A4A));
  static final purple  = ColorShades(const Color(0xFF8A56F2));
  static final blue    = ColorShades(const Color(0xFF2093FC));
  static final yellow  = ColorShades(const Color(0xFFD5A400));

  // ── Light ColorScheme ─────────────────────────────────────────────────────
  static ColorScheme lightScheme() {
    return ColorScheme(
      brightness: Brightness.light,

      // Primary
      primary:            primary.shadeHct(60),
      onPrimary:          primary.shadeHct(100),
      primaryContainer:   primary.shadeHct(95),
      onPrimaryContainer: primary.shadeHct(10),
      primaryFixed:          primary.shadeHct(95),
      primaryFixedDim:       primary.shadeHct(90),
      onPrimaryFixed:        primary.shadeHct(10),
      onPrimaryFixedVariant: primary.shadeHct(30),

      // Secondary — TODO: no seed yet, mirrors primary
      secondary:               primary.shadeHct(60),
      onSecondary:             primary.shadeHct(100),
      secondaryContainer:      primary.shadeHct(95),
      onSecondaryContainer:    primary.shadeHct(10),
      secondaryFixed:          primary.shadeHct(95),
      secondaryFixedDim:       primary.shadeHct(90),
      onSecondaryFixed:        primary.shadeHct(10),
      onSecondaryFixedVariant: primary.shadeHct(30),

      // Error
      error:            error.shadeHct(50),
      onError:          error.shadeHct(90),
      errorContainer:   error.shadeHct(95),
      onErrorContainer: error.shadeHct(10),

      // Surface
      surface:       neutral.shadeHct(99),
      surfaceBright: neutral.shadeHct(100),
      surfaceDim:    neutral.shadeHct(98),

      // Surface Containers
      surfaceContainerLowest:  neutral.shadeHct(100),
      surfaceContainerLow:     neutral.shadeHct(99),
      surfaceContainer:        neutral.shadeHct(98),
      surfaceContainerHigh:    neutral.shadeHct(95),
      surfaceContainerHighest: neutral.shadeHct(90),

      // Utility
      onSurface:        neutral.shadeHct(10),
      onSurfaceVariant: neutral.shadeHct(70),
      outline:          neutral.shadeHct(95),
      outlineVariant:   neutral.shadeHct(98),
      shadow:           neutral.shadeHct(0),
      scrim:            neutral.shadeHct(0),

      // Inverse
      inverseSurface:   neutral.shadeHct(10),
      onInverseSurface: neutral.shadeHct(99),
      inversePrimary:   primary.shadeHct(80),

      // Surface tint
      surfaceTint: primary.shadeHct(60),
    );
  }

  // ── Dark ColorScheme ──────────────────────────────────────────────────────
  static ColorScheme darkScheme() {
    return ColorScheme(
      brightness: Brightness.dark,

      // Primary
      primary:            primary.shadeHct(60),
      onPrimary:          primary.shadeHct(100),
      primaryContainer:   primary.shadeHct(10),
      onPrimaryContainer: primary.shadeHct(10),
      primaryFixed:          neutral.shadeHct(0),
      primaryFixedDim:       primary.shadeHct(20),
      onPrimaryFixed:        primary.shadeHct(90),
      onPrimaryFixedVariant: primary.shadeHct(95),

      // Secondary — TODO: no seed yet, mirrors primary
      secondary:               primary.shadeHct(60),
      onSecondary:             primary.shadeHct(100),
      secondaryContainer:      primary.shadeHct(10),
      onSecondaryContainer:    primary.shadeHct(10),
      secondaryFixed:          neutral.shadeHct(0),
      secondaryFixedDim:       primary.shadeHct(20),
      onSecondaryFixed:        primary.shadeHct(90),
      onSecondaryFixedVariant: primary.shadeHct(95),

      // Error
      error:            error.shadeHct(50),
      onError:          error.shadeHct(90),
      errorContainer:   error.shadeHct(10),
      onErrorContainer: error.shadeHct(10),

      // Surface
      surface:       neutral.shadeHct(0),
      surfaceBright: neutral.shadeHct(0),
      surfaceDim:    neutral.shadeHct(20),

      // Surface Containers
      surfaceContainerLowest:  neutral.shadeHct(10),
      surfaceContainerLow:     neutral.shadeHct(30),
      surfaceContainer:        neutral.shadeHct(30),
      surfaceContainerHigh:    neutral.shadeHct(40),
      surfaceContainerHighest: neutral.shadeHct(50),

      // Utility
      onSurface:        neutral.shadeHct(98),
      onSurfaceVariant: neutral.shadeHct(80),
      outline:          neutral.shadeHct(60),
      outlineVariant:   neutral.shadeHct(30),
      shadow:           neutral.shadeHct(0),
      scrim:            neutral.shadeHct(0),

      // Inverse
      inverseSurface:   neutral.shadeHct(99),
      onInverseSurface: neutral.shadeHct(20),
      inversePrimary:   primary.shadeHct(30),

      // Surface tint
      surfaceTint: primary.shadeHct(60),
    );
  }

  // ── Custom Light Tokens ───────────────────────────────────────────────────
  // (not part of Material ColorScheme — access separately)

  // Outline variants
  static Color get outlineHighLight => neutral.shadeHct(0);
  static Color get outlineDimLight  => neutral.shadeHct(98);

  // Success
  static Color get successLight          => success.shadeHct(60);
  static Color get onSuccessLight        => success.shadeHct(99);
  static Color get successContainerLight => success.shadeHct(98);

  // Orange
  static Color get orangeLight          => orange.shadeHct(60);
  static Color get orangeContainerLight => orange.shadeHct(95);
  static Color get onOrangeLight        => orange.shadeHct(98);

  // Purple
  static Color get purpleLight          => purple.shadeHct(50);
  static Color get purpleContainerLight => purple.shadeHct(95);
  static Color get onPurpleLight        => purple.shadeHct(10);

  // Blue
  static Color get blueLight            => blue.shadeHct(60);
  static Color get onBlueLight          => blue.shadeHct(98);
  static Color get blueContainerLight   => blue.shadeHct(95);
  static Color get onBlueContainerLight => blue.shadeHct(10);

  // Yellow
  static Color get yellowLight          => yellow.shadeHct(70);
  static Color get yellowContainerLight => yellow.shadeHct(98);
  static Color get onYellowLight        => yellow.shadeHct(10);

  // ── Custom Dark Tokens ────────────────────────────────────────────────────

  // Outline variants
  static Color get outlineHighDark => neutral.shadeHct(95);
  static Color get outlineDimDark  => neutral.shadeHct(30);

  // Success
  static Color get successDark          => success.shadeHct(60);
  static Color get onSuccessDark        => success.shadeHct(99);
  static Color get successContainerDark => success.shadeHct(10);

  // Orange
  static Color get orangeDark          => orange.shadeHct(60);
  static Color get orangeContainerDark => orange.shadeHct(10);
  static Color get onOrangeDark        => orange.shadeHct(99);

  // Purple
  static Color get purpleDark          => purple.shadeHct(50);
  static Color get purpleContainerDark => purple.shadeHct(10);
  static Color get onPurpleDark        => purple.shadeHct(98);

  // Blue
  static Color get blueDark            => blue.shadeHct(60);
  static Color get onBlueDark          => blue.shadeHct(98);
  static Color get blueContainerDark   => blue.shadeHct(10);
  static Color get onBlueContainerDark => blue.shadeHct(98);

  // Yellow
  static Color get yellowDark          => yellow.shadeHct(70);
  static Color get yellowContainerDark => yellow.shadeHct(10);
  static Color get onYellowDark        => yellow.shadeHct(98);
}
