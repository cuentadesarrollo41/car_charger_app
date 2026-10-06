import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';
import 'package:project/src/widgets/generic/inputs/input_text_field.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';
import 'package:project/src/widgets/generic/texts/title_input.dart';

class TitledInputTextField extends StatelessWidget {
  final String title;
  final String extraTitle;
  final String hint;
  final String introductionText;
  final String initialText;
  final double titleFontSize;
  final double fontSize;
  final double borderRadiusTopLeft;
  final double borderRadiusTopRight;
  final double borderRadiusBottomLeft;
  final double borderRadiusBottomRight;
  final Color borderColor;
  final Color iconColor;
  final IconData? iconData;
  final String? iconAsset;
  final double iconSize;
  final bool obscureText;
  final TextInputType textInputType;
  final double? height;
  final int minLines;
  final int? maxLines;
  final bool allowShowText;
  final bool enabled;
  final bool isMandatory;
  final FontWeight fontWeight;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController? controller;
  final bool isPrice;
  final bool isDouble;
  final int? maxLength;
  final String errorText;
  final FocusNode? focusNode;
  final Widget Function()? createTitleLeftWidget;
  final Widget Function()? createTitleRightWidget;

  final void Function(String value) onValueChanged;
  final void Function()? onItemClicked;

  const TitledInputTextField({
    required this.title,
    this.extraTitle = Strings.emptyString,
    required this.hint,
    this.introductionText = Strings.emptyString,
    this.initialText = Strings.emptyString,
    required this.titleFontSize,
    required this.fontSize,
    this.borderRadiusTopLeft = Sizes.borderRadius10,
    this.borderRadiusTopRight = Sizes.borderRadius10,
    this.borderRadiusBottomLeft = Sizes.borderRadius10,
    this.borderRadiusBottomRight = Sizes.borderRadius10,
    this.borderColor = CustomColors.backgroundLine,
    this.iconColor = Colors.white,
    this.iconData,
    this.iconAsset,
    this.iconSize = Sizes.font24 * 1.2,
    this.obscureText = false,
    required this.textInputType,
    required this.onValueChanged,
    this.height = Sizes.inputHeight,
    this.minLines = 1,
    this.maxLines = 1,
    this.allowShowText = false,
    this.enabled = true,
    this.isMandatory = false,
    this.fontWeight = FontWeight.w700,
    this.inputFormatters = const [],
    this.controller,
    this.isPrice = false,
    this.isDouble = false,
    this.maxLength,
    this.errorText = Strings.emptyString,
    this.focusNode,
    this.createTitleLeftWidget,
    this.createTitleRightWidget,
    this.onItemClicked,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: Sizes.margin8,
          children: [
            if (createTitleLeftWidget != null) createTitleLeftWidget!(),

            TitleInput(
              title: title,
              extraTitle: extraTitle,
              isMandatory: isMandatory,
              fontWeight: fontWeight,
              fontSize: titleFontSize,
            ),

            if (createTitleRightWidget != null) createTitleRightWidget!(),
          ],
        ),
        SizedBox(height: introductionText.isEmpty ? Sizes.margin8 : Sizes.margin4),

        introductionText.isEmpty
          ? Container()
          : TextInter(
            text: introductionText,
            fontSize: fontSize
          ),
        SizedBox(height: introductionText.isEmpty ? 0 : Sizes.margin12),

        onItemClicked == null
          ? _createInput()
          : _createClickableInput()
      ],
    );
  }

  // Method that creates the input.
  Widget _createInput() => InputTextField(
    initialText: initialText,
    hint: hint,
    borderRadiusTopLeft: borderRadiusTopLeft,
    borderRadiusTopRight: borderRadiusTopRight,
    borderRadiusBottomLeft: borderRadiusBottomLeft,
    borderRadiusBottomRight: borderRadiusBottomRight,
    borderColor: borderColor,
    iconColor: iconColor,
    iconData: iconData,
    iconAsset: iconAsset,
    iconSize: iconSize,
    fontSize: fontSize,
    obscureText: obscureText,
    textInputType: textInputType,
    height: height,
    minLines: minLines,
    maxLines: maxLines,
    allowShowText: allowShowText,
    enabled: enabled,
    inputFormatters: inputFormatters,
    controller: controller,
    isPrice: isPrice,
    isDouble: isDouble,
    maxLength: maxLength,
    errorText: errorText,
    focusNode: focusNode,
    onValueChanged: onValueChanged,
  );

  // Method that creates the clickable input.
  Widget _createClickableInput() => Stack(
    children: [
      _createInput(),
      InkWellCustom(
        onTap: onItemClicked!,
        child: SizedBox(
          width: double.infinity,
          height: Sizes.inputHeight
        )
      ),
    ],
  );
}
