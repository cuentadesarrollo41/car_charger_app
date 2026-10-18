import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';

// Widgets.
import 'package:project/src/widgets/generic/list/item_list_access.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class ItemLinkChargerOption extends StatefulWidget {
  final int index;
  final bool isLast;
  final FaIconData iconData;
  final String title;
  final String subtitle;
  final bool isSelected;

  final void Function() onClicked;

  const ItemLinkChargerOption({
    required this.index,
    required this.isLast,
    required this.iconData,
    required this.title,
    this.subtitle = Strings.emptyString,
    required this.isSelected,
    required this.onClicked,
    super.key
  });

  @override
  State<ItemLinkChargerOption> createState() => _ItemLinkChargerOptionState();
}

class _ItemLinkChargerOptionState extends State<ItemLinkChargerOption> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return ItemListAccess(
      index: widget.index,
      isLast: widget.isLast,
      isSelected: false,
      text: widget.title,
      leftWidget: _createLeftIcon(),
      content: _createContent(),
      rightWidget: widget.isSelected
        ? _createRightIcon()
        : null,
      onItemClicked: widget.onClicked
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the content.
  Widget _createContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Sizes.margin4,
    children: [
      TextInter(
        text: widget.title,
        fontSize: screenProperties.fontSmall,
        fontWeight: FontWeight.w700
      ),

      if (widget.subtitle.isNotEmpty) TextInter(
        text: widget.subtitle,
        fontSize: screenProperties.fontSmallest,
        color: CustomColors.textSecondary
      )
    ]
  );

  // Method that creates the left icon.
  Widget _createLeftIcon() => Container(
    width: Sizes.margin40,
    height: Sizes.margin40,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: CustomColors.lime12,
      borderRadius: BorderRadius.circular(Sizes.borderRadius10)
    ),
    child: FaIcon(
      widget.iconData,
      color: CustomColors.lime,
      size: Sizes.font16
    )
  );

  // Method that creates the right icon.
  Widget _createRightIcon() => FaIcon(
    FontAwesomeIcons.solidCircleCheck,
    color: CustomColors.lime,
    size: Sizes.font18
  );
}
