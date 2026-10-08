import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/app_bar_modes.dart';
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';
import 'package:project/src/widgets/generic/images/image_logo.dart';

class AppBarCustom extends StatelessWidget implements PreferredSize {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showMenu;
  final Stream<bool>? endDrawerIsOpenedStream;
  final String appBarMode;

  final void Function()? onBackButtonClicked;
  final void Function()? onProfileButtonClicked;

  AppBarCustom({
    this.scaffoldKey,
    this.showMenu = false,
    this.endDrawerIsOpenedStream,
    required this.appBarMode,
    this.onBackButtonClicked,
    this.onProfileButtonClicked,
    super.key
  }) : preferredSize = Size.fromHeight(Sizes.appBarHeight);

  @override
  final Size preferredSize;
  @override
  Widget get child => throw UnimplementedError();

  @override
  Widget build(BuildContext context) => _AppBarContent(
    scaffoldKey: scaffoldKey,
    showMenu: showMenu,
    endDrawerIsOpenedStream: endDrawerIsOpenedStream,
    appBarMode: appBarMode,
    onBackButtonClicked: onBackButtonClicked,
    onProfileButtonClicked: onProfileButtonClicked,
  );
}

class _AppBarContent extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showMenu;
  final Stream<bool>? endDrawerIsOpenedStream;
  final String appBarMode;

  final void Function()? onBackButtonClicked;
  final void Function()? onProfileButtonClicked;

  const _AppBarContent({
    this.scaffoldKey,
    this.showMenu = true,
    this.endDrawerIsOpenedStream,
    required this.appBarMode,
    this.onBackButtonClicked,
    this.onProfileButtonClicked,
  });

  @override
  State<_AppBarContent> createState() => _AppBarContentState();
}

class _AppBarContentState extends State<_AppBarContent> with SingleTickerProviderStateMixin {
  late ScreenPropertiesModel screenProperties;

  late AnimationController animationController;
  StreamSubscription<bool>? endDrawerSubscription;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    // End drawer listener.
    if (widget.showMenu && widget.endDrawerIsOpenedStream != null) {
      endDrawerSubscription = widget.endDrawerIsOpenedStream!.listen((bool isOpen) {
        if (!mounted) {
          return;
        }

        if (isOpen) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    endDrawerSubscription?.cancel();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return AppBar(
      leadingWidth: 0,
      leading: Container(),
      titleSpacing: 0,
      title: _createContent(),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      toolbarHeight: double.maxFinite,
      elevation: Sizes.appBarElevation,
      actions: [Builder(builder: (BuildContext context) => Container())],
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the content.
  Widget _createContent() => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(width: screenProperties.paddingCardHorizontal),

      ...widget.appBarMode == AppBarModes.main ? _createMainAppBar()
        : widget.appBarMode == AppBarModes.public ? _createPublicAppBar()
        : widget.appBarMode == AppBarModes.text ? _createTextAppBar()
        : [ ],

      SizedBox(width: screenProperties.paddingCardHorizontal),
    ]
  );

  // Method that creates the public app bar.
  List <Widget> _createPublicAppBar() => [
    _createIconButton(FontAwesomeIcons.chevronLeft, widget.onBackButtonClicked),
    const SizedBox(width: Sizes.margin10),

    const Spacer(),
    _createLogo(),
    const Spacer(),

    SizedBox(width: 49),
  ];

  // Method that creates the main bar.
  List <Widget> _createMainAppBar() => [
    _createLogo(),
    const Spacer(),

    _createIconButton(FontAwesomeIcons.solidUser, widget.onProfileButtonClicked),
  ];

  // Method that creates the text app bar.
  List <Widget> _createTextAppBar() => [];

  // Method that creates an icon button.
  Widget _createIconButton(FaIconData icon, void Function()? onClicked) => InkWellCustom(
    onTap: onClicked,
    child: Container(
      height: Sizes.appBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.margin13),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CustomColors.backgroundGhost,
        border: Border.all(
          width: Sizes.defaultBorderSize,
          color: CustomColors.backgroundLine
        )
      ),
      child: FaIcon(
        icon,
        size: Sizes.font14,
        color: Colors.white,
      )
    ),
  );

  // Method that creates the logo.
  Widget _createLogo() => ImageLogo(
    height: Sizes.logoAppBarHeight,
  );

  // Method that creates the menu icon button.
  /*Widget _createMenuIconButton() => IconButton(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    icon: AnimatedIcon(
      icon: AnimatedIcons.menu_close,
      color: Colors.white,
      progress: animationController,
    ),
    onPressed: _onMenuButtonClicked
  );*/

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the menu button.
  /*void _onMenuButtonClicked() {
    if (widget.scaffoldKey == null) {
      return;
    }

    widget.scaffoldKey!.currentState!.openEndDrawer();
  }*/
}
