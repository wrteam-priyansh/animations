import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../color_lerp_palette.dart';

class ColorLerpPaletteScreen extends StatefulWidget {
  const ColorLerpPaletteScreen({super.key});

  @override
  State<ColorLerpPaletteScreen> createState() => _ColorLerpPaletteScreenState();
}

class _ColorLerpPaletteScreenState extends State<ColorLerpPaletteScreen> {
  final _hexController = TextEditingController(text: 'E75480');
  String? _error;
  late ColorLerpPalette _palette;
  ChromaCurve _curve = ChromaCurve.soft;

  static const _curveOptions = <String, ChromaCurve>{
    'Soft':    ChromaCurve.soft,
    'Linear':  ChromaCurve.linear,
    'Ease In': ChromaCurve.easeIn,
    'Ease Out':ChromaCurve.easeOut,
    'S-Curve': ChromaCurve.sCurve,
  };

  @override
  void initState() {
    super.initState();
    final p = ColorLerpPalette.fromHex('989898');// //E75480
    _debugPrint(p);
    _palette = p;
  }

  void _debugPrint(ColorLerpPalette p) {
    debugPrint('=== ColorLerpPalette output ===');
    for (final tone in ColorLerpPalette.toneKeys) {
      final c   = p[tone];
      final hex = ColorLerpPalette.toHex(c);
      final r   = (c.r * 255).round();
      final g   = (c.g * 255).round();
      final b   = (c.b * 255).round();
      debugPrint('  $tone: $hex  rgb($r, $g, $b)');
    }
    debugPrint('================================');
  }

  void _rebuild(String hex) {
    final clean = hex.replaceAll('#', '').trim();
    if (clean.length != 6) {
      setState(() => _error = 'Enter a valid 6-char hex');
      return;
    }
    try {
      final p = ColorLerpPalette.fromHex(clean, curve: _curve);
      _debugPrint(p);
      setState(() {
        _palette = p;
        _error   = null;
      });
    } catch (_) {
      setState(() => _error = 'Invalid hex color');
    }
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Color Lerp Palette'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          _Controls(
            hexController: _hexController,
            error: _error,
            previewColor: _palette.t50,
            selectedCurve: _curve,
            curveOptions: _curveOptions,
            onHexChanged: _rebuild,
            onCurveChanged: (curve) {
              setState(() => _curve = curve);
              _rebuild(_hexController.text);
            },
          ),
          const Divider(height: 1),
          Expanded(child: _PaletteList(palette: _palette)),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  final TextEditingController hexController;
  final String? error;
  final Color previewColor;
  final ChromaCurve selectedCurve;
  final Map<String, ChromaCurve> curveOptions;
  final ValueChanged<String> onHexChanged;
  final ValueChanged<ChromaCurve> onCurveChanged;

  const _Controls({
    required this.hexController,
    required this.error,
    required this.previewColor,
    required this.selectedCurve,
    required this.curveOptions,
    required this.onHexChanged,
    required this.onCurveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: previewColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black12),
                ),
              ),
              const SizedBox(width: 10),
              const Text('#', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(width: 4),
              SizedBox(
                width: 110,
                child: TextField(
                  controller: hexController,
                  decoration: InputDecoration(
                    hintText: 'E75480',
                    errorText: error,
                    isDense: true,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 15),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onChanged: onHexChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: curveOptions.entries.map((entry) {
                final selected = selectedCurve == entry.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(entry.key, style: const TextStyle(fontSize: 12)),
                    selected: selected,
                    onSelected: (_) => onCurveChanged(entry.value),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaletteList extends StatelessWidget {
  final ColorLerpPalette palette;
  const _PaletteList({required this.palette});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ColorLerpPalette.toneKeys.length,
      itemBuilder: (context, i) {
        final tone    = ColorLerpPalette.toneKeys[i];
        final color   = palette[tone];
        final hex     = ColorLerpPalette.toHex(color);
        final r       = (color.r * 255).round();
        final g       = (color.g * 255).round();
        final b       = (color.b * 255).round();
        final onColor = color.computeLuminance() < 0.35 ? Colors.white : Colors.black87;

        return GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: hex));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$hex copied'),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Container(
            height: 64,
            color: color,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$tone',
                  style: TextStyle(color: onColor, fontWeight: FontWeight.w700, fontSize: 15),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(hex, style: TextStyle(color: onColor, fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'monospace')),
                    Text(
                      'rgb($r, $g, $b)',
                      style: TextStyle(color: onColor.withValues(alpha: 0.65), fontSize: 11, fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
