import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/containers/card/card_container.dart';
import 'package:project/src/widgets/generic/containers/conditional_widget.dart';
import 'package:project/src/widgets/generic/list/item_list.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class ItemListAccess extends StatefulWidget {
  final int index;
  final FaIconData? leftIconData;
  final Widget? leftWidget;
  final String text;
  final Widget? content;
  final FaIconData? rightIconData;
  final Color? rightIconColor;
  final Widget? rightWidget;
  final bool isSelected;
  final FontWeight fontWeight;
  final bool isLast;
  final Widget? expandedContent;
  final Color primaryColor;

  final void Function() onItemClicked;

  const ItemListAccess({
    required this.index,
    this.leftIconData,
    this.leftWidget,
    required this.text,
    this.content,
    this.rightIconData,
    this.rightIconColor,
    this.rightWidget,
    required this.isSelected,
    this.fontWeight = FontWeight.w700,
    required this.isLast,
    this.expandedContent,
    this.primaryColor = Colors.white,
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
      marginBottom: Sizes.margin12,
      onClicked: widget.onItemClicked,
      child: CardContainer(
        verticalPadding: 0,
        horizontalPadding: 0,
        borderColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Sizes.margin16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.borderRadius16),
            border: Border.all(
              color: widget.isSelected ? CustomColors.lime : CustomColors.backgroundLine,
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
      spacing: Sizes.margin12,
      children: [
        ConditionalWidget(
          showChild: widget.leftWidget != null || widget.leftIconData != null,
          createChild: () => widget.leftWidget ?? _createIcon(widget.leftIconData!, widget.primaryColor, Sizes.font16)
        ),

        Expanded(child: widget.content ?? _createText()),

        if (widget.rightIconData != null) _createIcon(widget.rightIconData!, widget.rightIconColor ?? widget.primaryColor, Sizes.font12),
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
  Widget _createText() => TextInter(
    text: widget.text,
    fontSize: screenProperties.fontSmall,
    color: widget.primaryColor,
    fontWeight: widget.fontWeight,
  );
}
