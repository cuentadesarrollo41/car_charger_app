import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';
import 'package:project/src/widgets/generic/images/image_logo.dart';

class AppBarCustom extends StatelessWidget implements PreferredSize {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showMenu;
  final Stream<bool>? endDrawerIsOpenedStream;

  final void Function()? onPendingTasksButtonClicked;
  final void Function()? onBackButtonClicked;

  AppBarCustom({
    this.scaffoldKey,
    this.showMenu = true,
    this.endDrawerIsOpenedStream,
    this.onPendingTasksButtonClicked,
    this.onBackButtonClicked,
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
    onBackButtonClicked: onBackButtonClicked,
    onPendingTasksButtonClicked: onPendingTasksButtonClicked,
  );
}

class _AppBarContent extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showMenu;
  final Stream<bool>? endDrawerIsOpenedStream;

  final void Function()? onPendingTasksButtonClicked;
  final void Function()? onBackButtonClicked;

  const _AppBarContent({
    this.scaffoldKey,
    this.showMenu = true,
    this.endDrawerIsOpenedStream,
    this.onPendingTasksButtonClicked,
    this.onBackButtonClicked,
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
      if (widget.onBackButtonClicked != null) _createBackButton(),
      SizedBox(width: widget.onBackButtonClicked == null ? Sizes.margin20 : 0),

      _createLogo(),
      const SizedBox(width: Sizes.margin10),

      const Spacer(),

      if (widget.showMenu) _createMenuIconButton(),
      SizedBox(width: widget.showMenu ? Sizes.margin20 : 0),
    ],
  );

  // Method that creates the back button.
  Widget _createBackButton() => InkWellCustom(
    onTap: widget.onBackButtonClicked!,
    child: Container(
      height: Sizes.appBarHeight - 2 * Sizes.margin8,
      margin: const EdgeInsets.symmetric(horizontal: Sizes.margin8),
      padding: const EdgeInsets.symmetric(horizontal: Sizes.margin12),
      alignment: Alignment.centerLeft,
      child: FaIcon(
        FontAwesomeIcons.chevronLeft,
        size: Sizes.font16,
        color: Colors.black,
      )
    ),
  );

  // Method that creates the logo.
  Widget _createLogo() => ImageLogo(
    height: 28,
    color: 'black',
  );

  // Method that creates the menu icon button.
  Widget _createMenuIconButton() => IconButton(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    icon: AnimatedIcon(
      icon: AnimatedIcons.menu_close,
      color: Colors.white,
      progress: animationController,
    ),
    onPressed: _onMenuButtonClicked
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the menu button.
  void _onMenuButtonClicked() {
    if (widget.scaffoldKey == null) {
      return;
    }

    widget.scaffoldKey!.currentState!.openEndDrawer();
  }
}
