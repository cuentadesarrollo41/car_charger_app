import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';

class ImageLogo extends StatelessWidget {
  final bool isLarge;
  final double height;
  final double? width;
  final String color;

  const ImageLogo({
    this.isLarge = true,
    required this.height,
    this.width,
    this.color = Strings.emptyString,
    super.key
  });

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/img/logo/logo_${ isLarge ? 'large' : 'short' }${ color.isEmpty ? Strings.emptyString : '_$color' }.svg',
    height: width == null ? height : null,
    width: width,
    fit: width == null ? BoxFit.fitHeight : BoxFit.fitWidth,
    alignment: Alignment.center,
  );
}
