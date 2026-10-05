import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Helpers.
import 'package:project/src/helpers/helper_app_update.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/page_transition.dart';
import 'package:project/src/commons/utils/routes.dart';
import 'package:project/src/commons/utils/utils.dart';

// Pages.
import 'package:project/src/pages/index.dart';

// Widgets.
import 'package:project/src/widgets/generic/containers/graco_stripe.dart';
import 'package:project/src/widgets/generic/containers/scaffold_custom.dart';
import 'package:project/src/widgets/generic/images/image_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late StateBloc stateBloc;

  late ScreenPropertiesModel screenProperties;

  late bool hasLoaded;

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  late AnimationController logoController;
  late Animation<double> logoScaleAnimation;

  @override
  void initState() {
    hasLoaded = false;

    // Animations.
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeIn,
    );

    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: Numbers.delaySplash)
    );

    logoScaleAnimation = Tween<double>(begin: 0.8, end: 1.0)
      .animate(CurvedAnimation(parent: logoController, curve: Cubic(0.2, 0.75, 0.2, 1.0)));

    super.initState();
  }

  @override
  void dispose() {
    fadeController.dispose();
    logoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return ScaffoldCustom(
      leftPadding: 0,
      rightPadding: 0,
      showBackgroundLogo: false,
      createBody: _createContent,
    );
  }

  // Method that initializes the variables.
  void _init() {
    stateBloc = BlocProvider.stateBloc(context);

    screenProperties = ScreenPropertiesModel(context: context);

    if (hasLoaded) {
      return;
    }

    stateBloc.reset();
  }

  // Method that creates the content.
  Widget _createContent() {
    if (hasLoaded) {
      return _createLoadedContent();
    }

    stateBloc.changeLoadingText(AppLocalizations.of(context)!.translate('loading'));

    return FutureBuilder(
      future: _loadPackageInfo(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return _createLoadedContent();
          case ConnectionState.done:
            break;
        }

        stateBloc.changeLoadingText(Strings.emptyString);

        hasLoaded = true;

        if (!fadeController.isAnimating && !fadeController.isCompleted) {
          fadeController.forward();
        }

        if (!logoController.isAnimating && !logoController.isCompleted) {
          logoController.forward();
        }

        Future.delayed(const Duration(milliseconds: Numbers.delaySplash), () => _loadPage());

        return _createLoadedContent();
      },
    );
  }

  // Method that creates the content.
  Widget _createLoadedContent() => FadeTransition(
    opacity: fadeAnimation,
    child: SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            _createContentBack(),
            _createContentFront(),
            _createLoader(),
          ],
        ),
      ),
    ),
  );

  // Method that creates the content back.
  Widget _createContentBack() => SizedBox.expand(
    child: Stack(
      children: [
        Positioned(
          left: -150,
          top: 50,
          child: GracoStripe(
            colors: const [ CustomColors.lime78, CustomColors.lime36, Colors.transparent, Colors.transparent ],
            stops: [ 0.0, 0.35, 0.75, 1.0 ]
          )
        ),
        Positioned(
          right: -150,
          bottom: 102,
          child: GracoStripe(
            colors: const [ Colors.transparent, Colors.transparent, CustomColors.lime36, CustomColors.lime78 ],
            stops: [ 0.0, 0.25, 0.65, 1.0 ]
          )
        )
      ]
    )
  );

  // Method that creates the content front.
  Widget _createContentFront() => Container(
    width: double.infinity,
    height: double.infinity,
    alignment: Alignment.center,
    child: ScaleTransition(
      scale: logoScaleAnimation,
      child: const ImageLogo(
        height: Sizes.logoPresentationHeight
      )
    )
  );

  // Method that creates the loader.
  Widget _createLoader() => Container(
    margin: const EdgeInsets.only(bottom: Sizes.appBarHeight),
    alignment: Alignment.bottomCenter,
  );

  // Method that loads the package info.
  Future<void> _loadPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    stateBloc.changeAppVersion(packageInfo.version);
  }

  // Method that loads the page.
  void _loadPage() async {
    if (await HelperAppUpdate.checkIsOutdated(context: context) || !mounted) {
      return;
    }

    Utils.navigatorPushAndRemoveUntil(
      context: context,
      type: PageTransitionType.fade,
      child: Utils.userIsAuthenticated() ? const MainPage() : const LoginPage(),
      routeName: Utils.userIsAuthenticated() ? Routes.main : Routes.login
    );
  }
}
