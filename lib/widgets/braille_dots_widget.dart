import 'package:flutter/material.dart';
import '../models/barille_item.dart';

class BrailleDotsWidget extends StatelessWidget {
  final BrailleItem item;
  final double dotSize;
  final double cellSpacing;

  const BrailleDotsWidget({
    Key? key,
    required this.item,
    this.dotSize = 35.0,
    this.cellSpacing = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Standard braille layout
    const List<int> dotLayout = [1, 4, 2, 5, 3, 6];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(item.dots.length, (cellIndex) {
        final List<int> activeDots = item.dots[cellIndex];

        return Padding(
          padding: EdgeInsets.only(
            right: cellIndex == item.dots.length - 1 ? 0 : cellSpacing,
          ),
          child: SizedBox(
            width: dotSize * 2 + dotSize * 0.5,
            height: dotSize * 3 + dotSize * 0.8,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: dotSize * 0.2,
                crossAxisSpacing: dotSize * 0.2,
              ),
              itemBuilder: (context, index) {
                final dotNumber = dotLayout[index];
                final bool isFilled = activeDots.contains(dotNumber);

                return Container(
                  decoration: BoxDecoration(
                    color: isFilled ? Colors.black87 : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black54,
                      width: 1.5,
                    ),
                    boxShadow: isFilled
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
          ),
        );
      }),
    );
  }
}