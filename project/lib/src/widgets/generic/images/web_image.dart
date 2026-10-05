import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

class WebImage extends StatelessWidget {
  final String url;
  final double borderRadius;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final double? minHeight;
  final BoxFit boxFit;
  final FaIconData errorIconData;
  final double errorIconSize;
  final Color errorIconColor;
  final Alignment alignment;

  const WebImage({
    required this.url,
    this.borderRadius = 0,
    this.backgroundColor = Colors.white,
    required this.width,
    required this.height,
    this.minHeight,
    this.boxFit = BoxFit.cover,
    this.errorIconData = FontAwesomeIcons.image,
    this.errorIconSize = Sizes.font24,
    this.errorIconColor = CustomColors.lime,
    this.alignment = Alignment.centerLeft,
    super.key
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: Container(
      color: backgroundColor,
      width: width,
      height: height,
      child: CachedNetworkImage(
        imageUrl: url,
        alignment: alignment,
        fit: height == null ? BoxFit.fitWidth : boxFit,
        errorWidget: (BuildContext context, String url, Object error) => Container(
          alignment: alignment,
          height: minHeight,
          child: FaIcon(
            errorIconData,
            size: errorIconSize,
            color: errorIconColor,
          ),
        ),
      ),
    ),
  );
}
