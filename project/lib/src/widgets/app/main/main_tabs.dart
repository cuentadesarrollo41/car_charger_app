import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/tabs.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';
import 'package:project/src/widgets/generic/containers/conditional_widget.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class MainTabs extends StatefulWidget {
  final bool hideMainContent;

  const MainTabs({
    required this.hideMainContent,
    super.key
  });

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  late MainBloc mainBloc;

  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return Container(
      padding: const EdgeInsets.only(
        top: Sizes.margin6
      ),
      decoration: BoxDecoration(
        color: CustomColors.backgroundCard,
        border: Border(
          top: BorderSide(color: CustomColors.backgroundLine, width: Sizes.defaultBorderSize)
        )
      ),
      child: SafeArea(
        child: StreamBuilder<Widget?>(
          stream: mainBloc.tabsExtraContentStream,
          builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createExtraContent(),
              _createMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  // Method that initializes the variables.
  void _init() {
    mainBloc = BlocProvider.mainBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the extra content.
  Widget _createExtraContent() => AnimatedContainer(
    duration: const Duration(milliseconds: Numbers.delayAnimation),
    child: ConditionalWidget(
      showChild: mainBloc.tabsExtraContent != null,
      createChild: () => mainBloc.tabsExtraContent ?? Container()
    ),
  );

  // Method that creates the main content.
  Widget _createMainContent() => AnimatedContainer(
    duration: const Duration(milliseconds: Numbers.delayAnimation),
    child: ConditionalWidget(
      showChild: !widget.hideMainContent,
      createChild: () => SizedBox(
        height: Sizes.bottomBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: _createTabItem(FontAwesomeIcons.solidHouse, Tabs.home)),
            Expanded(flex: 1, child: _createTabItem(FontAwesomeIcons.bolt, Tabs.charging)),
            Expanded(flex: 1, child: _createTabItem(FontAwesomeIcons.chartSimple, Tabs.history)),
            Expanded(flex: 1, child: _createTabItem(FontAwesomeIcons.gear, Tabs.settings)),
          ],
        ),
      ),
    ),
  );

  // Method that creates a tab item.
  Widget _createTabItem(FaIconData iconData, int tab) {
    bool isSelected = false;

    switch (tab) {
      case Tabs.charging:
      case Tabs.history:
      case Tabs.home:
      case Tabs.settings:
        isSelected = mainBloc.tab == tab;
        break;
      // In case other tabs that are not main need to activate selection, add them here.
      default: break;
    }

    return InkWellCustom(
      onTap: () => _onItemClicked(tab),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: Sizes.margin6,
        children: [
          FaIcon(
            iconData,
            size: Sizes.font20,
            color: isSelected ? CustomColors.lime : Colors.white,
          ),

          TextInter(
            text: AppLocalizations.of(context)!.translate(Tabs.bottomTabsKeys[tab]),
            fontSize: screenProperties.fontSmallest,
            color: isSelected ? CustomColors.lime : Colors.white,
          ),
        ],
      ),
    );
  }

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks a tab.
  void _onItemClicked(int tab) {
    if (tab == mainBloc.tab) {
      return;
    }

    mainBloc.changeTab(tab);
    // Rest of process is executed in change tab listener (defined in _init);
  }
}