import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/currency.dart';

// Widgets.
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class InputTextField extends StatefulWidget {
  final String hint;
  final Function(String value) onValueChanged;
  final bool allowShowText;

  final bool obscureText;
  final String initialText;
  final double borderRadiusTopLeft;
  final double borderRadiusTopRight;
  final double borderRadiusBottomLeft;
  final double borderRadiusBottomRight;
  final Color borderColor;
  final double borderSize;
  final Color backgroundColor;
  final Color hintColor;
  final Color textColor;
  final Color iconColor;
  final double fontSize;
  final double iconSize;
  final bool enabled;
  final IconData? iconData;
  final String? iconAsset;
  final TextInputType textInputType;
  final bool hasClearButton;
  final int minLines;
  final int? maxLines;
  final double? height;
  final IconData? extraIconData;
  final String? extraIconAsset;
  final double? extraIconAssetWidth;
  final List<TextInputFormatter> inputFormatters;
  final double? leftPadding;
  final double? rightPadding;
  final bool isPrice;
  final bool isDouble;
  final int? maxLength;
  final String label;
  final String errorText;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final void Function()? onExtraIconClicked;
  final void Function()? onTapOutside;

  const InputTextField({
    required this.hint,
    required this.onValueChanged,
    this.allowShowText = false,
    this.obscureText = false,
    this.initialText = Strings.emptyString,
    this.borderRadiusTopLeft = Sizes.borderRadius10,
    this.borderRadiusTopRight = Sizes.borderRadius10,
    this.borderRadiusBottomLeft = Sizes.borderRadius10,
    this.borderRadiusBottomRight = Sizes.borderRadius10,
    this.borderColor = CustomColors.backgroundLine,
    this.borderSize = Sizes.inputBorderSize,
    this.backgroundColor = CustomColors.backgroundInput,
    this.hintColor = CustomColors.textPlaceholder,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    required this.fontSize,
    this.iconSize = Sizes.font20,
    this.iconData,
    this.iconAsset,
    this.enabled = true,
    this.controller,
    required this.textInputType,
    this.hasClearButton = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.height = Sizes.inputHeight,
    this.extraIconData,
    this.extraIconAsset,
    this.extraIconAssetWidth,
    this.onExtraIconClicked,
    this.onTapOutside,
    this.inputFormatters = const [],
    this.leftPadding,
    this.rightPadding,
    this.isPrice = false,
    this.isDouble = false,
    this.maxLength,
    this.label = Strings.emptyString,
    this.errorText = Strings.emptyString,
    this.focusNode,
    super.key
  });

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  late TextEditingController controller;

  late bool obscureText;

  late FocusNode internalFocusNode;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController(text: widget.initialText);
    obscureText = widget.obscureText;

    internalFocusNode = widget.focusNode ?? FocusNode();
    internalFocusNode.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }

    if (widget.focusNode == null) {
      internalFocusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: Sizes.margin3,
      children: [
        widget.label.isEmpty ? _createBoxedInput() : _createLabeledInput(),
        if (widget.errorText.isNotEmpty) _createErrorText()
      ]
    );
  }

  // Method that creates the error text.
  Widget _createErrorText() => TextInter(
    text: widget.errorText,
    fontSize: widget.fontSize - 2,
    color: CustomColors.lime
  );

  // Method that creates the boxed input.
  Widget _createBoxedInput() => Container(
    height: widget.height,
    padding: EdgeInsets.only(
      left: widget.iconData == null && widget.iconAsset == null
        ? (widget.leftPadding == null ? Sizes.margin12 : widget.leftPadding!)
        : Sizes.margin2,
      right: widget.rightPadding == null
        ? widget.onExtraIconClicked == null ? Sizes.margin12 : 0
        : widget.rightPadding!,
    ),
    decoration: BoxDecoration(
      color: widget.backgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(widget.borderRadiusTopLeft),
        topRight: Radius.circular(widget.borderRadiusTopRight),
        bottomLeft: Radius.circular(widget.borderRadiusBottomLeft),
        bottomRight: Radius.circular(widget.borderRadiusBottomRight),
      ),
      border: Border.all(
        //color: focusNode.hasFocus ? CustomColors.lime : widget.borderColor,
        color: widget.borderColor,
        width: Sizes.inputBorderSize,
      )
    ),
    alignment: Alignment.centerLeft,
    child: TextField(
      enabled: widget.enabled,
      controller: controller,
      focusNode: internalFocusNode,
      style: TextStyle(
        color: widget.textColor,
        fontSize: widget.fontSize,
        fontFamily: Strings.fontFamily,
        fontWeight: FontWeight.w500
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: widget.hintColor,
          fontSize: widget.fontSize,
        ),
        isDense: true,
        prefixIcon: _createPrefixIcon(),
        suffixIcon: _createSuffixIcon(),
        contentPadding: EdgeInsets.symmetric(vertical: Sizes.margin12),
        counterText: Strings.emptyString,
      ),
      keyboardType: widget.textInputType,
      obscureText: obscureText,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      onTapOutside: _onTapOutside,
      onChanged: (String? value) => _onValueChanged(value!),
    )
  );

  // Method that creates the labeled input.
  Widget _createLabeledInput() => TextField(
    enabled: widget.enabled,
    controller: controller,
    focusNode: internalFocusNode,
    style: TextStyle(
      color: widget.textColor,
      fontSize: widget.fontSize,
      fontFamily: Strings.fontFamily
    ),
    decoration: InputDecoration(
      hintText: widget.hint,
      hintStyle: TextStyle(
        color: widget.hintColor,
        fontSize: widget.fontSize,
      ),
      isDense: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      label: TextInter(
        text: widget.label,
        fontSize: widget.fontSize,
        color: widget.textColor,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: widget.borderColor,
          width: widget.borderSize
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: CustomColors.backgroundLine,
          width: widget.borderSize * 2
        ),
      ),
      prefixIcon: _createPrefixIcon(),
      suffixIcon: _createSuffixIcon(),
    ),
    keyboardType: widget.textInputType,
    obscureText: obscureText,
    minLines: widget.minLines,
    maxLines: widget.maxLines,
    maxLength: widget.maxLength,
    inputFormatters: widget.inputFormatters,
    onTapOutside: _onTapOutside,
    onChanged: (String? value) => _onValueChanged(value!),
  );

  // Method that creates the prefix icon.
  Widget? _createPrefixIcon() => widget.iconData == null
    ? widget.iconAsset == null ? null
      : Image(
        image: AssetImage(widget.iconAsset!),
        width: widget.iconSize,
      )
    : Icon(
      widget.iconData,
      color: widget.iconColor,
      size: widget.iconSize,
    );

  // Method that creates the suffix icon.
  Widget? _createSuffixIcon() => widget.hasClearButton && controller.text.isNotEmpty || widget.allowShowText && controller.text.isNotEmpty || widget.extraIconData != null || widget.extraIconAsset != null
    ? Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.hasClearButton && controller.text.isNotEmpty) _createClearButton()!,
        if (widget.allowShowText && controller.text.isNotEmpty) _createShowTextButton()!,
        if (widget.extraIconData != null || widget.extraIconAsset != null) _createExtraIcon()!,
        SizedBox(width: widget.label.isEmpty ? 0 : widget.rightPadding ?? Sizes.margin12)
      ],
    )
    : null;

  // Method that creates the clear button.
  Widget? _createClearButton() => !widget.hasClearButton || controller.text.isEmpty
    ? null
    : InkWell(
      key: Key('input_text_field_clear${ DateTime.now() }'),
      onTap: _onClearButtonClicked,
      child: Icon(
        Icons.cancel,
        color: widget.iconColor,
        size: Sizes.font20,
      ),
    );

  // Method that creates the show text button.
  Widget? _createShowTextButton() => !widget.allowShowText || controller.text.isEmpty
    ? Container()
    : InkWell(
      key: Key('input_text_field_show${ DateTime.now() }'),
      onTap: _onShowHideButtonClicked,
      child: FaIcon(
        obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
        color: widget.iconColor,
        size: Sizes.font16,
      ),
    );

  // Method that creates the extra icon.
  Widget? _createExtraIcon() => widget.extraIconData == null && widget.extraIconAsset == null
    ? Container()
    : InkWell(
      key: Key('input_text_field_extra${ DateTime.now() }'),
      onTap: widget.onExtraIconClicked,
      child: Container(
        padding: const EdgeInsets.only(left: Sizes.margin10),
        alignment: Alignment.center,
        child: widget.extraIconData == null
          ? Image(
            image: AssetImage(widget.extraIconAsset!),
            width: widget.extraIconAssetWidth!,
          )
          : Icon(
            widget.extraIconData,
            color: widget.iconColor,
            size: Sizes.font22,
          ),
      ),
    );

  // Method that is called when the user changes the value.
  void _onValueChanged(String value) {
    if (!widget.isPrice && ! widget.isDouble) {
      widget.onValueChanged(value);
      setState(() {});
      return;
    }

    final int maxDecimals = widget.isPrice ? 2 : 10;
    final regex = widget.isPrice
      ? RegExp(r'^\d*(\.\d{0,' + maxDecimals.toString() + r'})?€?$')
      : RegExp(r'^\d*(\.\d{0,' + maxDecimals.toString() + r'})?$');

    if (regex.hasMatch(value)) {
      widget.onValueChanged(value.isEmpty
        ? Strings.emptyString
        : widget.isPrice
          ? (double.parse(value.replaceFirst(Currency.euro, Strings.emptyString)) * 100).ceil().toString()
          : value
      );
    } else {
      String newValue = value;
      newValue = newValue.replaceAll(RegExp(r'[^\d\.\$]'), '');

      // Allow only 1 decimal.
      final dotIndex = newValue.indexOf(Strings.dot);

      if (dotIndex != -1) {
        final List<String> parts = newValue.split(Strings.dot);
        newValue = '${ parts[0] }.${ parts[1].substring(0, parts[1].length > maxDecimals ? maxDecimals : parts[1].length) }';
      }

      // Currency symbol at the end.
      if (newValue.contains(Currency.euro)) {
        newValue = '${ newValue.replaceAll(Currency.euro, Strings.emptyString) }${ Currency.euro }';
      }

      controller.value = TextEditingValue(
        text: newValue,
        selection: TextSelection.collapsed(offset: newValue.length),
      );
    }
  }

  // Method that is called when the user clicks the clear button.
  void _onClearButtonClicked() {
    controller.text = Strings.emptyString;
    widget.onValueChanged(Strings.emptyString);
    setState(() {});

    internalFocusNode.requestFocus();
  }

  // Method that is called when the user clicks the show/hide button.
  void _onShowHideButtonClicked() {
    obscureText = !obscureText;
    setState(() {});
  }

  // Method that is called when the user taps outside de input.
  void _onTapOutside(PointerDownEvent event) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (widget.onTapOutside == null) {
      return;
    }

    widget.onTapOutside!();
  }
}
