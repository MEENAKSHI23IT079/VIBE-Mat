import 'package:flutter/foundation.dart';

@immutable
class BrailleItem {
  final String name;
  final String symbol;
  final List<List<int>> dots;
  final String audioDescription;

  const BrailleItem({
    required this.name,
    this.symbol = '',
    required this.dots,
    required this.audioDescription,
  });

  // ✅ multi-cell safe
  bool hasDot(int dotNumber, [int cellIndex = 0]) {
    if (cellIndex >= dots.length) return false;
    return dots[cellIndex].contains(dotNumber);
  }

  // ✅ screen-reader friendly
  String get dotsAudioDescription {
    if (dots.isEmpty) {
      return "Braille has no dots raised";
    }

    if (dots.length == 1) {
      return "Braille dots ${dots.first.join(' ')}";
    }

    final parts = dots
        .map((cell) => "dots ${cell.join(' ')}")
        .join(", then ");

    return "Braille $parts";
  }

  String get displayName {
    return name +
        (symbol.isNotEmpty && symbol != name ? ' ($symbol)' : '');
  }
}