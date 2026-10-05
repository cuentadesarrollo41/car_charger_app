import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class ButtonCustom extends StatefulWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final double? width;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color overlayColor;
  final Color overlayBorderColor;
  final double borderSize;
  final Color textColor;
  final Color overlayTextColor;
  final double elevation;
  final String? iconAssetLeft;
  final String? iconAssetRight;
  final FaIconData? iconDataLeft;
  final FaIconData? iconDataRight;
  final double iconSize;
  final bool adaptFontSizeToScreen;
  final MainAxisSize mainAxisSize;
  final double horizontalPadding;

  final void Function()? onClicked;

  const ButtonCustom({
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.w700,
    this.height = Sizes.buttonHeight,
    this.width,
    this.borderRadius = Sizes.borderRadius30,
    this.backgroundColor = CustomColors.lime,
    this.borderColor = CustomColors.lime,
    this.overlayColor = CustomColors.lime80,
    this.overlayBorderColor = CustomColors.lime80,
    this.borderSize = Sizes.inputBorderSize,
    this.textColor = Colors.black,
    this.overlayTextColor = Colors.black,
    this.elevation = Sizes.defaultElevation,
    this.iconAssetLeft,
    this.iconAssetRight,
    this.iconDataLeft,
    this.iconDataRight,
    this.iconSize = Sizes.font12,
    this.adaptFontSizeToScreen = true,
    this.mainAxisSize = MainAxisSize.max,
    this.horizontalPadding = Sizes.margin18,
    required this.onClicked,
    super.key
  });

  @override
  State<ButtonCustom> createState() => _ButtonCustomState();
}

class _ButtonCustomState extends State<ButtonCustom> {
  late bool isHovering;
  late bool isPressed;

  @override
  void initState() {
    isHovering = false;
    isPressed = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => InkWellCustom(
    onTap: widget.onClicked,
    onHover: (bool isHovering) => setState(() => this.isHovering = isHovering),
    onPressedChanged: (bool isPressed) => setState(() => this.isPressed = isPressed),
    child: AnimatedContainer(
      height: widget.height,
      width: widget.width,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      decoration: BoxDecoration(
        color: isHovering || isPressed ? widget.overlayColor : widget.backgroundColor,
        border: Border.all(
          width: widget.borderSize,
          color: isHovering || isPressed ? widget.overlayBorderColor : widget.borderColor
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: _createContent(),
    ),
  );

  // Method that creates the content.
  Widget _createContent() {
    bool deviceIsPhone = defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;

    return SizedBox(
      height: kIsWeb && !(deviceIsPhone) ? widget.height + Sizes.margin16 : widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: widget.mainAxisSize,
        children: [
          SizedBox(width: widget.iconDataRight == null && widget.iconAssetRight == null ? 0 : Sizes.margin8),

          widget.iconDataLeft == null
            ? Container()
            : FaIcon(
              widget.iconDataLeft,
              color: isHovering || isPressed ? widget.overlayTextColor : widget.textColor,
              size: widget.iconSize,
            ),
          SizedBox(width: widget.iconDataLeft == null ? 0 : Sizes.margin10),

          widget.iconAssetLeft == null
            ? Container()
            : Image(
              image: AssetImage(widget.iconAssetLeft!),
              width: widget.iconSize,
              fit: BoxFit.fitWidth
            ),
          SizedBox(width: widget.iconAssetLeft == null ? 0 : Sizes.margin16),

          Flexible(
            child: TextInter(
              text: widget.text,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              color: isHovering || isPressed ? widget.overlayTextColor : widget.textColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: widget.iconDataRight == null ? 0 : Sizes.margin52),

          widget.iconDataRight == null
            ? Container()
            : FaIcon(
              widget.iconDataRight,
              color: isHovering || isPressed ? widget.overlayTextColor : widget.textColor,
              size: widget.iconSize,
            ),

          SizedBox(width: widget.iconAssetRight == null ? 0 : Sizes.margin16),

          widget.iconAssetRight == null
            ? Container()
            : Image(
              image: AssetImage(widget.iconAssetRight!),
              width: widget.iconSize,
              fit: BoxFit.fitWidth,
            ),

          SizedBox(width: widget.iconDataLeft == null && widget.iconAssetLeft == null ? 0 : Sizes.margin8),
        ],
      ),
    );
  }
}
