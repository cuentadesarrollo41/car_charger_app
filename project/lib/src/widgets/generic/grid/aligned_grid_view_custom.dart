import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';

class AlignedGridViewCustom extends StatelessWidget {
  final int crossAxisCount;
  final List<Widget?> items;

  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const AlignedGridViewCustom({
    required this.crossAxisCount,
    required this.items,
    this.mainAxisSpacing = Sizes.margin20,
    this.crossAxisSpacing = Sizes.margin20,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget?> validItems = items.where((Widget? item) => item != null).toList();

    return AlignedGridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      itemCount: validItems.length,
      itemBuilder: (BuildContext context, int index) => Align(
        alignment: Alignment.topLeft,
        child: validItems[index],
      ),
    );
  }
}
