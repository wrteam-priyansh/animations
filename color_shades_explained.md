# ColorShades — How It Works

---

## 1. What is Lerp?

**Lerp = Linear Interpolation**

It answers one question:
> "What value is X% of the way between A and B?"

### The Equation

```
result = A + (B - A) * t
```

| Variable | Meaning |
|----------|---------|
| `A` | Starting point |
| `B` | Ending point |
| `t` | How far between A and B (0.0 to 1.0) |
| `result` | The output |

### Examples

```
A = 0, B = 100

t = 0.0  →  result = 0    (at A)
t = 0.5  →  result = 50   (midpoint)
t = 1.0  →  result = 100  (at B)
t = 0.2  →  result = 20   (20% of the way)
```

---

## 2. What is `Color.lerp`?

`Color.lerp` is Flutter's built-in lerp **for colors**. It runs the lerp equation on each color channel (R, G, B) independently.

### Signature

```dart
Color.lerp(Color a, Color b, double t)
```

### Internal Equation

```
result.R = a.R + (b.R - a.R) * t
result.G = a.G + (b.G - a.G) * t
result.B = a.B + (b.B - a.B) * t
```

### Example

```dart
Color.lerp(Colors.black, Colors.white, 0.5)
// black  = R:0,   G:0,   B:0
// white  = R:255, G:255, B:255
// t = 0.5

// R = 0 + (255 - 0) * 0.5 = 127
// G = 0 + (255 - 0) * 0.5 = 127
// B = 0 + (255 - 0) * 0.5 = 127
// result = grey (#7F7F7F)
```

---

## 3. Why Black and White?

Black and white are the **natural extremes** of any shade scale:

```
darkest possible  = black  (R:0,   G:0,   B:0  )
lightest possible = white  (R:255, G:255, B:255 )
```

When you lerp any color **toward black** → every channel moves toward 0 → gets darker.
When you lerp any color **toward white** → every channel moves toward 255 → gets lighter.

They are not special to `Color.lerp` — they are just the endpoints we **choose** to build a shade scale.

---

## 4. The Tone Scale

The tone scale goes from **0 to 100**:

```
0          50          100
■ --------- ■ --------- □
black    base color    white
```

| Tone | Meaning |
|------|---------|
| 0    | Pure black |
| 10   | Very dark shade |
| 50   | The base color itself |
| 90   | Very light shade |
| 100  | Pure white |

---

## 5. The `shade()` Equation

We split the scale into two halves:

### Dark side — tone 0 to 50 (black → base)

```dart
Color.lerp(Colors.black, base, tone / 50)
```

```
tone = 0   →  t = 0/50 = 0.0  →  pure black
tone = 25  →  t = 25/50 = 0.5 →  halfway between black and base
tone = 50  →  t = 50/50 = 1.0 →  base color itself
```

### Light side — tone 50 to 100 (base → white)

```dart
Color.lerp(base, Colors.white, (tone - 50) / 50)
```

```
tone = 50  →  t = (50-50)/50 = 0.0  →  base color itself
tone = 75  →  t = (75-50)/50 = 0.5  →  halfway between base and white
tone = 100 →  t = (100-50)/50 = 1.0 →  pure white
```

> We subtract 50 from tone first so t always stays between 0.0 and 1.0.

---

## 6. The Full `shade()` Function

```dart
Color shade(int tone) {
  if (tone <= 0)  return Colors.black;   // edge case
  if (tone >= 100) return Colors.white;  // edge case

  if (tone <= 50) {
    return Color.lerp(Colors.black, base, tone / 50)!;
  } else {
    return Color.lerp(base, Colors.white, (tone - 50) / 50)!;
  }
}
```

---

## 7. Real Example — base color `#EF5388`

| Tone | t calculation | Result color |
|------|--------------|--------------|
| 0    | —            | #000000 (black) |
| 20   | 20/50 = 0.4  | dark pink |
| 50   | 50/50 = 1.0  | #EF5388 (base) |
| 80   | (80-50)/50 = 0.6 | light pink |
| 100  | —            | #FFFFFF (white) |

---

## 8. Named Getters

Shortcuts so you don't have to write `shade(10)` every time:

```dart
final pink = ColorShades(Color(0xFFEF5388));

pink.s20   // same as pink.shade(20)
pink.s80   // same as pink.shade(80)
pink.s100  // white
```

---

## 9. How We Use It in the Button

```dart
Color get _shadowColor => Color.lerp(color, Colors.black, 0.30)!;
// 30% toward black = darker shade for shadow

Color get _bottomColor => Color.lerp(color, Colors.white, 0.10)!;
// 10% toward white = slightly lighter for gradient bottom
```

Change just the `color` property and shadow + gradient update automatically.

---

## Summary

| Concept | What it does |
|---------|-------------|
| `lerp` | Finds a value between two points |
| `Color.lerp(a, b, t)` | Blends two colors by percentage t |
| `t` | Input percentage (0.0 → 1.0), calculated from tone |
| `tone` | The shade level you want (0–100) |
| `tone / 50` | Converts tone to t for the dark half |
| `(tone - 50) / 50` | Converts tone to t for the light half |
| Black & White | Natural endpoints of any shade scale |
