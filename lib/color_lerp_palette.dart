import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A 2D control point for [ChromaCurve].
/// [x] = position along the palette (0=darkest tone, 1=lightest tone).
/// [y] = interpolation output (0=dark anchor, 1=light anchor).
class PalettePoint {
  final double x;
  final double y;
  const PalettePoint(this.x, this.y);
}

/// Catmull-Rom spline curve — identical to ChromaCraft's brightness-curve engine.
///
/// Control points run from (0,0) → (1,1):
///   x=0, y=0  : darkest tone (tone 0)   maps to dark anchor (#000000)
///   x=0.5,y=0.5: mid tone (tone 50)  maps to the base/seed color
///   x=1, y=1  : lightest tone (tone 100) maps to light anchor (#FFFFFF)
///
/// ChromaCraft stores the curve inverted (y=1 at dark end), so the presets
/// below are Y-flipped to match our dark→base→light lerp convention.
class ChromaCurve {
  final List<PalettePoint> points;
  const ChromaCurve(this.points);

  // ── Presets (match ChromaCraft exactly) ─────────────────────────────────

  /// Smooth S-curve — ChromaCraft "Soft" preset. Default.
  static const soft = ChromaCurve([
    PalettePoint(0,    0   ),
    PalettePoint(0.25, 0.15),
    PalettePoint(0.5,  0.5 ),
    PalettePoint(0.75, 0.85),
    PalettePoint(1,    1   ),
  ]);

  /// Straight line — no easing.
  static const linear = ChromaCurve([
    PalettePoint(0,   0  ),
    PalettePoint(0.5, 0.5),
    PalettePoint(1,   1  ),
  ]);

  /// Slow at the dark end, fast at the light end.
  static const easeIn = ChromaCurve([
    PalettePoint(0,   0  ),
    PalettePoint(0.4, 0.1),
    PalettePoint(0.7, 0.5),
    PalettePoint(1,   1  ),
  ]);

  /// Fast at the dark end, slow at the light end.
  static const easeOut = ChromaCurve([
    PalettePoint(0,   0  ),
    PalettePoint(0.3, 0.5),
    PalettePoint(0.6, 0.9),
    PalettePoint(1,   1  ),
  ]);

  /// Steeper S-curve — ChromaCraft "S-curve" preset.
  static const sCurve = ChromaCurve([
    PalettePoint(0,   0   ),
    PalettePoint(0.2, 0.08),
    PalettePoint(0.4, 0.35),
    PalettePoint(0.6, 0.65),
    PalettePoint(0.8, 0.92),
    PalettePoint(1,   1   ),
  ]);

  // ── Catmull-Rom evaluation ───────────────────────────────────────────────

  /// Evaluates the spline at position [t] (0→1), returns output (0→1).
  double transform(double t) {
    final n = points.length;

    // Find which segment t falls into.
    int seg = 0;
    for (int i = 0; i < n - 1; i++) {
      if (t >= points[i].x && t <= points[i + 1].x) {
        seg = i;
        break;
      }
    }

    // Grab 4 surrounding control points (clamp at the ends).
    final p0 = points[math.max(0, seg - 1)];
    final p1 = points[seg];
    final p2 = points[math.min(n - 1, seg + 1)];
    final p3 = points[math.min(n - 1, seg + 2)];

    final dt = p2.x - p1.x;
    // Local parameter u within this segment.
    final u  = dt < 1e-9 ? 0.0 : ((t - p1.x) / dt).clamp(0.0, 1.0);
    final u2 = u * u;
    final u3 = u2 * u;

    // Standard Catmull-Rom formula.
    final v = 0.5 * ((2 * p1.y)
        + (-p0.y + p2.y) * u
        + (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * u2
        + (-p0.y + 3 * p1.y - 3 * p2.y + p3.y) * u3);

    return v.clamp(0.0, 1.0);
  }
}

/// Generates an 11-tone color palette from a single base color.
///
/// Algorithm — exact port of ChromaCraft RGB mode:
///   1. Place 3 anchors: darkEnd (#000000) — base (seed) — lightEnd (#FFFFFF)
///   2. For each of the 11 tones, compute position t = i / (n-1)  →  0.0 to 1.0
///   3. Evaluate the [ChromaCurve] Catmull-Rom spline at t  →  ct (0=dark, 1=light)
///   4. Bilinear lerp:
///        ct ∈ [0, 0.5]  →  Color.lerp(darkEnd, base, ct × 2)
///        ct ∈ [0.5, 1]  →  Color.lerp(base, lightEnd, (ct − 0.5) × 2)
///
/// Usage:
///   final palette = ColorLerpPalette.fromHex('E75480');
///   palette.t50   // base color
///   palette[30]   // darker shade
///   palette.all   // full `Map<int, Color>`
class ColorLerpPalette {
  /// Tone keys for the 11 slots (0–100 scale).
  /// Index 0 = tone 0 (darkEnd), index 5 = tone 50 (base), index 10 = tone 100 (lightEnd).
  static const List<int> toneKeys = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];

  /// The brand / source color. Always sits at tone 50 (the midpoint).
  final Color base;

  /// Darkest anchor. Default: #000000.
  final Color darkEnd;

  /// Lightest anchor. Default: #FFFFFF (matches ChromaCraft).
  final Color lightEnd;

  /// Brightness distribution curve. Default: [ChromaCurve.soft] — exact ChromaCraft "Soft".
  final ChromaCurve curve;

  late final Map<int, Color> _palette;

  ColorLerpPalette({
    required this.base,
    this.darkEnd  = const Color(0xFF000000),
    this.lightEnd = const Color(0xFFFFFFFF),
    this.curve    = ChromaCurve.soft,
  }) {
    _palette = _generate();
  }

  /// Convenience constructor — pass a hex string like `'E75480'` or `'#E75480'`.
  factory ColorLerpPalette.fromHex(
    String hex, {
    Color darkEnd  = const Color(0xFF000000),
    Color lightEnd = const Color(0xFFFFFFFF),
    ChromaCurve curve = ChromaCurve.soft,
  }) {
    final h = hex.replaceAll('#', '');
    return ColorLerpPalette(
      base:      Color(int.parse('FF$h', radix: 16)),
      darkEnd:   darkEnd,
      lightEnd:  lightEnd,
      curve:     curve,
    );
  }

  Map<int, Color> _generate() {
    final result = <int, Color>{};
    final n = toneKeys.length; // 11

    for (int i = 0; i < n; i++) {
      // Normalized position: 0.0 at tone 0 (darkEnd), 1.0 at tone 100 (lightEnd).
      final t = i / (n - 1);

      // Catmull-Rom curve maps position → brightness (0=dark anchor, 1=light anchor).
      final ct = curve.transform(t);

      // Bilinear lerp through the 3 anchors.
      // ct=0 → darkEnd, ct=0.5 → base, ct=1.0 → lightEnd
      final Color color;
      if (ct <= 0.5) {
        color = Color.lerp(darkEnd, base, ct * 2)!;         // dark half
      } else {
        color = Color.lerp(base, lightEnd, (ct - 0.5) * 2)!; // light half
      }
      result[toneKeys[i]] = color;
    }
    return result;
  }

  /// Access by tone number, e.g. `palette[30]`. Falls back to [base] for unknown tones.
  Color operator [](int tone) => _palette[tone] ?? base;

  // Named getters — tone 0 = darkest, tone 50 = base, tone 100 = lightest.
  Color get t0   => _palette[0]!;
  Color get t10  => _palette[10]!;
  Color get t20  => _palette[20]!;
  Color get t30  => _palette[30]!;
  Color get t40  => _palette[40]!;
  Color get t50  => _palette[50]!;  // always == base
  Color get t60  => _palette[60]!;
  Color get t70  => _palette[70]!;
  Color get t80  => _palette[80]!;
  Color get t90  => _palette[90]!;
  Color get t100 => _palette[100]!;

  /// All 11 tones as an unmodifiable map — useful for iterating or serialising.
  Map<int, Color> get all => Map.unmodifiable(_palette);

  /// Converts a [Color] to a `'#RRGGBB'` hex string (no alpha).
  static String toHex(Color c) =>
      '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}
