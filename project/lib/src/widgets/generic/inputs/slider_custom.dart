import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

class SliderCustom extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final void Function(double)? onChanged;
  final void Function(double)? onChangeEnd;

  const SliderCustom({
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.onChanged,
    this.onChangeEnd,
    super.key
  });

  @override
  Widget build(BuildContext context) => SliderTheme(
    data: SliderTheme.of(context).copyWith(
      activeTrackColor: CustomColors.lime,
      inactiveTrackColor: CustomColors.backgroundInput,
      thumbColor: CustomColors.lime,
      overlayColor: Colors.transparent,
      showValueIndicator: ShowValueIndicator.never,
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
      trackHeight: Sizes.margin6
    ),
    child: Slider(
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: onChanged,
      onChangeEnd: onChangeEnd
    )
  );
}
