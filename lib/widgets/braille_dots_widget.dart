import 'package:flutter/material.dart';
import '../models/barille_item.dart';

class BrailleDotsWidget extends StatelessWidget {
  final BrailleItem item;
  final double dotSize;

  const BrailleDotsWidget({
    Key? key,
    required this.item,
    this.dotSize = 35.0, // Increased default size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int> dotLayout = [1, 4, 2, 5, 3, 6];

    return SizedBox(
      width: dotSize * 2 + dotSize * 0.5, // 2 columns + spacing
      height: dotSize * 3 + dotSize * 0.8, // 3 rows + spacing
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0, // Make cells square-ish area
          mainAxisSpacing: dotSize * 0.2, // Spacing between rows
          crossAxisSpacing: dotSize * 0.2, // Spacing between columns
        ),
        itemCount: 6,
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final dotNumber =
              dotLayout[index]; // Get the dot number (1-6) for this grid cell
          final bool isFilled = item.hasDot(dotNumber);

          return Container(
            width: dotSize, // Explicit size for the dot container
            height: dotSize,
            decoration: BoxDecoration(
              color: isFilled
                  ? Colors.black87
                  : Colors.white, // Use slightly off-black
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black54, // Use softer grey for border
                width: 1.5, // Slightly thicker border
              ),
              boxShadow: isFilled // Add subtle shadow for filled dots
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2,
                        offset: const Offset(1, 1),
                      ),
                    ]
                  : null,
            ),
          );
        },
      ),
    );
  }
}
