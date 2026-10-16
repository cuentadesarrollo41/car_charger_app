import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';

class LinkChargerTabLayout extends StatefulWidget {
  final Widget child;

  const LinkChargerTabLayout({
    required this.child,
    super.key
  });

  @override
  State<LinkChargerTabLayout> createState() => _LinkChargerTabLayoutState();
}

class _LinkChargerTabLayoutState extends State<LinkChargerTabLayout> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: screenProperties.paddingCardHorizontal,
        right: screenProperties.paddingCardHorizontal,
        bottom: Sizes.margin20
      ),
      child: widget.child
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }
}
