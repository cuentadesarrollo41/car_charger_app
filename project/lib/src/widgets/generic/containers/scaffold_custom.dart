import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Widgets.
import 'package:project/src/widgets/generic/containers/content_custom.dart';
import 'package:project/src/widgets/generic/images/image_logo.dart';

class ScaffoldCustom extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final PreferredSizeWidget? appBar;
  final Widget? endDrawer;
  final Widget Function() createBody;
  final bool safeBottom;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final bool contentIsList;
  final bool showBackgroundLogo;

  const ScaffoldCustom({
    this.scaffoldKey,
    this.appBar,
    this.endDrawer,
    required this.createBody,
    this.safeBottom = false,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.contentIsList = false,
    this.showBackgroundLogo = true,
    super.key
  });

  @override
  State<ScaffoldCustom> createState() => _ScaffoldCustomState();
}

class _ScaffoldCustomState extends State<ScaffoldCustom> {
  late StateBloc stateBloc;

  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return Stack(
      children: [
        if (widget.showBackgroundLogo) _createBackgroundLogo(),

        _createScaffold(),
      ],
    );
  }

  // Method that initializes the variables.
  void _init() {
    stateBloc = BlocProvider.stateBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the background logo.
  Widget _createBackgroundLogo() => Positioned(
    top: 0,
    right: 20,
    child: Opacity(
      opacity: 0.4,
      child: ImageLogo(
        isLarge: false,
        height: Numbers.noValueDouble,
        width: screenProperties.size.width * 0.375,
      ),
    )
  );

  // Method that creates the scaffold.
  Widget _createScaffold() => Scaffold(
    key: widget.scaffoldKey,
    appBar: widget.appBar,
    backgroundColor: CustomColors.black,
    // resizeToAvoidBottomInset: false, // => Used in order to remove bottom space when opening keyboard.
    body: widget.contentIsList
      ? SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [_createContent(), const SizedBox(height: Sizes.defaultBottomMargin)],
        ),
      )
      : _createContent(),
    endDrawer: widget.endDrawer,
    onEndDrawerChanged: widget.endDrawer == null ? null : stateBloc.changeEndDrawerIsOpened,
  );

  // Method that creates the content.
  Widget _createContent() => ContentCustom(
    createChild: widget.createBody,
    safeBottom: widget.safeBottom,
    leftPadding: widget.leftPadding,
    rightPadding: widget.rightPadding,
    topPadding: widget.topPadding,
    bottomPadding: widget.bottomPadding,
  );
}
