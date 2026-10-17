import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';
import 'package:project/src/models/link_charger/bluetooth_charger_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/containers/conditional_widget.dart';
import 'package:project/src/widgets/generic/list/item_list_access.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class ItemBluetoothCharger extends StatefulWidget {
  final int index;
  final bool isLast;
  final bool isSelected;
  final BluetoothChargerModel charger;

  final void Function() onClicked;

  const ItemBluetoothCharger({
    required this.index,
    required this.isLast,
    required this.isSelected,
    required this.charger,
    required this.onClicked,
    super.key
  });

  @override
  State<ItemBluetoothCharger> createState() => _ItemBluetoothChargerState();
}

class _ItemBluetoothChargerState extends State<ItemBluetoothCharger> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return ItemListAccess(
      index: widget.index,
      isLast: widget.isLast,
      isSelected: false,
      text: widget.charger.name,
      leftWidget: _createIcon(),
      content: _createContent(),
      rightWidget: ConditionalWidget(
        showChild: widget.isSelected,
        createChild: () => const FaIcon(FontAwesomeIcons.solidCircleCheck, color: CustomColors.lime, size: Sizes.font18)
      ),
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
      TextInter(text: widget.charger.name, fontSize: screenProperties.fontSmall, fontWeight: FontWeight.w700),
      ConditionalWidget(
        showChild: widget.charger.model.isNotEmpty,
        createChild: () => TextInter(text: widget.charger.model, fontSize: screenProperties.fontSmallest, color: CustomColors.textSecondary)
      )
    ]
  );

  // Method that creates the icon.
  Widget _createIcon() => Container(
    width: Sizes.margin40,
    height: Sizes.margin40,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: CustomColors.lime12,
      borderRadius: BorderRadius.circular(Sizes.borderRadius10)
    ),
    child: const FaIcon(FontAwesomeIcons.plug, color: CustomColors.lime, size: Sizes.font16)
  );
}
