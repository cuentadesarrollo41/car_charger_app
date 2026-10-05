import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';

class PageIndicators extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int maxVisibleIndicators;

  final double pageIndicatorHeight;
  final double pageIndicatorWidth;
  final Color activeIndicatorColor;
  final Color inactiveIndicatorColor;

  const PageIndicators({
    required this.currentPage,
    required this.totalPages,
    this.maxVisibleIndicators = 5,
    this.pageIndicatorHeight = Numbers.noValueDouble,
    this.pageIndicatorWidth = Numbers.noValueDouble,
    this.activeIndicatorColor = CustomColors.lime,
    this.inactiveIndicatorColor = CustomColors.backgroundCard,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    int half = (maxVisibleIndicators / 2).floor();
    int start = currentPage - half;
    int end = currentPage + half + 1;

    if (start < 0) {
      end = end - start;
      start = 0;
    }

    if (end > totalPages) {
      start = start - (end - totalPages);
      end = totalPages;

      if (start < 0) {
        start = 0;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(end - start, (index) {
          final int actualIndex = start + index;
          final bool isActive = actualIndex == currentPage;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: pageIndicatorWidth,
            height: pageIndicatorHeight,
            decoration: BoxDecoration(
              color: isActive ? activeIndicatorColor : inactiveIndicatorColor,
              borderRadius: BorderRadius.circular(pageIndicatorHeight / 2)
            ),
          );
        }),
      ),
    );
  }
}
