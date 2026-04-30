import 'package:flutter/material.dart';

class ColorShades {
  final Color base;

  const ColorShades(this.base);

  Color shade(int tone) {
    if (tone <= 0) return Colors.black;
    if (tone >= 100) return Colors.white;
    if (tone <= 50) return Color.lerp(Colors.black, base, tone / 50)!;
    return Color.lerp(base, Colors.white, (tone - 50) / 50)!;
  }

  Color get s0   => Colors.black;
  Color get s10  => shade(10);
  Color get s20  => shade(20);
  Color get s30  => shade(30);
  Color get s40  => shade(40);
  Color get s50  => shade(50);
  Color get s60  => shade(60);
  Color get s70  => shade(70);
  Color get s80  => shade(80);
  Color get s90  => shade(90);
  Color get s95  => shade(95);
  Color get s98  => shade(98);
  Color get s99  => shade(99);
  Color get s100 => Colors.white;
}
