import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Models.
import 'package:project/src/models/charging_session_model.dart';
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/list/item_list_access.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class ItemChargingSession extends StatefulWidget {
  final int index;
  final bool isLast;
  final ChargingSessionModel chargingSession;

  final void Function() onClicked;

  const ItemChargingSession({
    required this.index,
    required this.isLast,
    required this.chargingSession,
    required this.onClicked,
    super.key
  });

  @override
  State<ItemChargingSession> createState() => _ItemChargingSessionState();
}

class _ItemChargingSessionState extends State<ItemChargingSession> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return ItemListAccess(
      index: widget.index,
      isLast: widget.isLast,
      isSelected: false,
      text: widget.chargingSession.getTitle(context: context),
      leftWidget: _createIcon(),
      content: _createContent(),
      rightIconData: FontAwesomeIcons.chevronRight,
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
      TextInter(text: widget.chargingSession.getTitle(context: context), fontSize: screenProperties.fontSmall, fontWeight: FontWeight.w700),
      TextInter(text: widget.chargingSession.getTime(), fontSize: screenProperties.fontSmallest, color: CustomColors.textSecondary)
    ]
  );

  // Method that creates the icon.
  Widget _createIcon() => Container(
    width: Sizes.margin40,
    height: Sizes.margin40,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: CustomColors.lime5,
      borderRadius: BorderRadius.circular(Sizes.borderRadius10)
    ),
    child: const FaIcon(FontAwesomeIcons.calendar, color: CustomColors.lime, size: Sizes.font16)
  );
}
