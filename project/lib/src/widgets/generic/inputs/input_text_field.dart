import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/currency.dart';

// Widgets.
import 'package:project/src/widgets/generic/texts/text_neue_haas.dart';

class InputTextField extends StatefulWidget {
  final String hint;
  final Function(String value) onValueChanged;
  final bool allowShowPassword;

  final bool obscureText;
  final String initialText;
  final double borderRadius;
  final Color borderColor;
  final double borderSize;
  final Color backgroundColor;
  final Color hintColor;
  final Color textColor;
  final Color iconColor;
  final double fontSize;
  final double iconSize;
  final bool enabled;
  final FaIconData? iconData;
  final String? iconAsset;
  final TextInputType textInputType;
  final bool hasClearButton;
  final int minLines;
  final int? maxLines;
  final double? height;
  final FaIconData? extraIconData;
  final String? extraIconAsset;
  final double? extraIconAssetWidth;
  final List<TextInputFormatter> inputFormatters;
  final double? leftPadding;
  final double? rightPadding;
  final bool isPrice;
  final String label;
  final bool unfocusOnOutsideTap;

  final TextEditingController? controller;

  final void Function()? onExtraIconClicked;
  final void Function()? onTapOutside;

  const InputTextField({
    required this.hint,
    required this.onValueChanged,
    this.allowShowPassword = false,
    this.obscureText = false,
    this.initialText = Strings.emptyString,
    this.borderRadius = Sizes.borderRadius10,
    this.borderColor = Colors.white,
    this.borderSize = Sizes.inputBorderSize,
    this.backgroundColor = Colors.white,
    this.hintColor = CustomColors.grayHomeItem,
    this.textColor = Colors.black,
    this.iconColor = CustomColors.redPrimary,
    required this.fontSize,
    this.iconSize = Sizes.font18,
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
    this.label = Strings.emptyString,
    this.unfocusOnOutsideTap = true,
    super.key
  });

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  late TextEditingController controller;

  late bool obscureText;

  late FocusNode focusNode;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController(text: widget.initialText);
    obscureText = widget.obscureText;

    focusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.label.isEmpty
    ? _createBoxedInput()
    : _createLabeledInput()
  ;

  // Method that creates the boxed input.
  Widget _createBoxedInput() => Container(
    height: widget.height,
    padding: EdgeInsets.only(
      left: widget.iconData == null && widget.iconAsset == null ? (widget.leftPadding == null ? Sizes.margin12 : widget.leftPadding!) : Sizes.margin2,
      right: widget.rightPadding == null
        ? widget.onExtraIconClicked == null
          ? Sizes.margin12
          : 0
        : widget.rightPadding!,
    ),
    decoration: BoxDecoration(
      color: widget.backgroundColor,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      border: Border.all(
        color: widget.borderColor,
        width: Sizes.inputBorderSize,
      )
    ),
    alignment: Alignment.centerLeft,
    child: TextField(
      enabled: widget.enabled,
      controller: controller,
      focusNode: focusNode,
      style: TextStyle(
        color: widget.textColor,
        fontSize: widget.fontSize,
        fontFamily: 'NeueHaasDisplay'
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
        contentPadding: const EdgeInsets.only(top: Sizes.margin12)
      ),
      keyboardType: widget.textInputType,
      obscureText: obscureText,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      inputFormatters: widget.inputFormatters,
      onTapOutside: _onTapOutside,
      onChanged: (String? value) => _onValueChanged(value!),
    )
  );

  // Method that creates the labeled input.
  Widget _createLabeledInput() => TextField(
    enabled: widget.enabled,
    controller: controller,
    focusNode: focusNode,
    style: TextStyle(
      color: widget.textColor,
      fontSize: widget.fontSize,
      fontFamily: 'NeueHaasDisplay'
    ),
    decoration: InputDecoration(
      hintText: widget.hint,
      hintStyle: TextStyle(
        color: widget.hintColor,
        fontSize: widget.fontSize,
      ),
      isDense: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      label: TextNeueHaas(
        text: widget.label,
        fontSize: widget.fontSize,
        color: widget.textColor,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: widget.borderColor, width: widget.borderSize),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: CustomColors.redPrimary, width: widget.borderSize * 2),
      ),
      prefixIcon: _createPrefixIcon(),
      suffixIcon: _createSuffixIcon(),
    ),
    keyboardType: widget.textInputType,
    obscureText: obscureText,
    minLines: widget.minLines,
    maxLines: widget.maxLines,
    inputFormatters: widget.inputFormatters,
    onTapOutside: _onTapOutside,
    onChanged: (String? value) => _onValueChanged(value!),
  );

  // Method that creates the prefix icon.
  Widget? _createPrefixIcon() => widget.iconData == null
    ? widget.iconAsset == null
      ? null
      : Image(
        image: AssetImage(widget.iconAsset!),
        width: widget.iconSize,
      )
    : Container(
      alignment: Alignment.centerLeft,
      width: widget.iconSize,
      padding: EdgeInsets.only(left: widget.leftPadding ?? Sizes.margin12),
      child: FaIcon(
        widget.iconData,
        color: widget.iconColor,
        size: widget.iconSize,
      ),
    );

  // Method that creates the suffix icon.
  Widget? _createSuffixIcon() => widget.hasClearButton && controller.text.isNotEmpty || widget.allowShowPassword && controller.text.isNotEmpty || widget.extraIconData != null || widget.extraIconAsset != null
    ? Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.hasClearButton && controller.text.isNotEmpty) _createClearButton()!,
        if (widget.allowShowPassword && controller.text.isNotEmpty) _createShowPasswordButton()!,
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

  // Method that creates the show password button.
  Widget? _createShowPasswordButton() => !widget.allowShowPassword || controller.text.isEmpty
    ? Container()
    : InkWell(
      key: Key('input_text_field_show${DateTime.now()}'),
      onTap: _onShowHideButtonClicked,
      child: Icon(
        obscureText ? Icons.visibility : Icons.visibility_off,
        color: widget.iconColor,
        size: Sizes.font22,
      ),
    );

  // Method that creates the extra icon.
  Widget? _createExtraIcon() => widget.extraIconData == null && widget.extraIconAsset == null
    ? Container()
    : InkWell(
      key: Key('input_text_field_extra${DateTime.now()}'),
      onTap: widget.onExtraIconClicked,
      child: Container(
        padding: const EdgeInsets.only(left: Sizes.margin10),
        alignment: Alignment.center,
        child: widget.extraIconData == null
          ? Image(
            image: AssetImage(widget.extraIconAsset!),
            width: widget.extraIconAssetWidth!,
          )
          : FaIcon(
            widget.extraIconData,
            color: widget.iconColor,
            size: Sizes.font22,
          ),
      ),
    );

  // Method that is called when the user changes the value.
  void _onValueChanged(String value) {
    if (!widget.isPrice) {
      widget.onValueChanged(value);
      setState(() {});
      return;
    }

    final regex = RegExp(r'^\d*(\.\d{0,2})?€?$');

    if (regex.hasMatch(value)) {
      widget.onValueChanged(value.isEmpty ? Strings.emptyString : (double.parse(value.replaceFirst(Currency.euro, Strings.emptyString)) * 100).ceil().toString());
    } else {
      String newValue = value;
      newValue = newValue.replaceAll(RegExp(r'[^\d\.\$]'), '');

      // Allow only 1 decimal.
      final dotIndex = newValue.indexOf(Strings.dot);
      if (dotIndex != -1) {
        final List<String> parts = newValue.split(Strings.dot);
        newValue = '${parts[0]}.${parts[1].substring(0, parts[1].length > 2 ? 2 : parts[1].length)}';
      }

      // Currency symbol at the end.
      if (newValue.contains(Currency.euro)) {
        newValue = '${newValue.replaceAll(Currency.euro, Strings.emptyString)}${Currency.euro}';
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

    focusNode.requestFocus();
  }

  // Method that is called when the user clicks the show/hide button.
  void _onShowHideButtonClicked() {
    obscureText = !obscureText;
    setState(() {});
  }

  // Method that is called when the user taps outside de input.
  void _onTapOutside(PointerDownEvent event) {
    if (widget.unfocusOnOutsideTap) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    if (widget.onTapOutside == null) {
      return;
    }

    widget.onTapOutside!();
  }
}
