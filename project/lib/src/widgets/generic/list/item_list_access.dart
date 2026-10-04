import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/containers/card/card_container.dart';
import 'package:project/src/widgets/generic/list/item_list.dart';
import 'package:project/src/widgets/generic/texts/text_neue_haas.dart';

class ItemListAccess extends StatefulWidget {
  final int index;
  final FaIconData leftIconData;
  final String text;
  final Widget? content;
  final FaIconData? rightIconData;
  final Widget? rightWidget;
  final bool isSelected;
  final FontWeight fontWeight;
  final bool isLast;
  final Widget? expandedContent;

  final void Function() onItemClicked;

  const ItemListAccess({
    required this.index,
    required this.leftIconData,
    required this.text,
    this.content,
    this.rightIconData,
    this.rightWidget,
    required this.isSelected,
    this.fontWeight = FontWeight.w500,
    required this.isLast,
    this.expandedContent,
    required this.onItemClicked,
    super.key
  });

  @override
  State<ItemListAccess> createState() => _ItemListAccessState();
}

class _ItemListAccessState extends State<ItemListAccess> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return ItemList(
      index: widget.index,
      isLast: widget.isLast,
      marginTop: 0,
      marginLeft: 0,
      marginRight: 0,
      marginBottom: Sizes.margin6,
      onClicked: widget.onItemClicked,
      child: CardContainer(
        verticalPadding: 0,
        horizontalPadding: 0,
        borderRadius: Sizes.borderRadius10,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Sizes.margin12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Sizes.borderRadius10),
            border: Border.all(
              color: widget.isSelected ? CustomColors.redPrimary : Colors.white,
              width: Sizes.defaultBorderSize
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createContent(),
              if (widget.expandedContent != null) widget.expandedContent!
            ],
          ),
        ),
      )
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the content.
  Widget _createContent() => Padding(
    padding: const EdgeInsets.symmetric(vertical: Sizes.margin3, horizontal: Sizes.margin16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: Sizes.margin16,
      children: [
        _createIcon(widget.leftIconData, CustomColors.redPrimary, Sizes.font20),

        Expanded(child: widget.content ?? _createText()),

        if (widget.rightIconData != null) _createIcon(widget.rightIconData!, Colors.black, Sizes.font14),
        if (widget.rightWidget != null) widget.rightWidget!
      ],
    ),
  );

  // Method that creates the icon.
  Widget _createIcon(FaIconData iconData, Color color, double size) => FaIcon(
    iconData,
    color: color,
    size: size,
  );

  // Method that creates the text.
  Widget _createText() => TextNeueHaas(
    text: widget.text,
    fontSize: screenProperties.fontSmall,
    color: Colors.black,
    fontWeight: widget.fontWeight,
  );
}
