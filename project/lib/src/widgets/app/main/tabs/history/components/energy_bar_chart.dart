import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class EnergyBarChart extends StatelessWidget {
  final List<int> values;
  final List<String> labels;
  final bool isScrollable;

  const EnergyBarChart({
    required this.values,
    required this.labels,
    this.isScrollable = false,
    super.key
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: Sizes.historyChartHeight,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.margin16),
      child: isScrollable ? _createScrollableChart() : _createChart()
    )
  );

  // Method that creates the chart with all the bars fitting the width.
  Widget _createChart() => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) => Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: Sizes.margin8,
      children: values.asMap().entries.map((MapEntry<int, int> entry) => Expanded(
        child: _createBar(value: entry.value, label: labels[entry.key], maxHeight: constraints.maxHeight, width: Sizes.margin24)
      )).toList()
    )
  );

  // Method that creates the chart with horizontal scroll.
  Widget _createScrollableChart() => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: Sizes.margin8,
        children: values.asMap().entries.map((MapEntry<int, int> entry) => SizedBox(
          width: Sizes.margin20,
          child: _createBar(value: entry.value, label: labels[entry.key], maxHeight: constraints.maxHeight, width: Sizes.margin20)
        )).toList()
      )
    )
  );

  // Method that creates a bar with its label.
  Widget _createBar({ required int value, required String label, required double maxHeight, required double width }) {
    final double maxBarHeight = maxHeight - Sizes.margin16 - Sizes.margin6;
    final double barHeight = (maxBarHeight * value / _getMaxValue()).clamp(Sizes.margin8, maxBarHeight).toDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: width,
          height: barHeight,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ CustomColors.lime, CustomColors.limeDark ]
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Sizes.borderRadius5))
          )
        ),
        const SizedBox(height: Sizes.margin6),

        TextInter(
          text: label,
          fontSize: Sizes.font9,
          color: CustomColors.textSecondary,
          textAlign: TextAlign.center
        )
      ]
    );
  }

  // Method that returns the biggest value of the chart (1 if all of them are 0).
  int _getMaxValue() {
    final int max = values.isEmpty ? Numbers.zero : values.reduce((int current, int value) => value > current ? value : current);

    return max == Numbers.zero ? Numbers.one : max;
  }
}
