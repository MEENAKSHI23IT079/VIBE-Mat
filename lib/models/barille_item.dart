import 'package:flutter/foundation.dart';

@immutable
class BrailleItem {
  final String name;
  final String symbol;
  final List<int> dots;
  final String audioDescription;

  const BrailleItem({
    required this.name,
    this.symbol = '',
    required this.dots,
    required this.audioDescription,
  });

  bool hasDot(int dotNumber) {
    return dots.contains(dotNumber);
  }

  String get dotsAudioDescription {
    if (dots.isEmpty) {
      return "Braille has no dots raised";
    }
    final prefix = dots.length == 1 ? "Braille dot" : "Braille dots";
    return "$prefix ${dots.join(' ')}";
  }

  String get displayName {
    return name + (symbol.isNotEmpty && symbol != name ? ' ($symbol)' : '');
  }
}