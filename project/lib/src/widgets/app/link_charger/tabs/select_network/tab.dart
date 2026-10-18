import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';
import 'package:project/src/models/link_charger/wifi_network_model.dart';

// Helpers.
import 'package:project/src/pages/private/link_charger/helpers/index.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/app/link_charger/common/index.dart';
import 'package:project/src/widgets/generic/inputs/titled_input_text_field.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';
import 'package:project/src/widgets/generic/texts/text_not_found.dart';

class TabLinkChargerSelectNetwork extends StatefulWidget {
  const TabLinkChargerSelectNetwork({
    super.key
  });

  @override
  State<TabLinkChargerSelectNetwork> createState() => _TabLinkChargerSelectNetworkState();
}

class _TabLinkChargerSelectNetworkState extends State<TabLinkChargerSelectNetwork> {
  late LinkChargerBloc linkChargerBloc;
  late ScreenPropertiesModel screenProperties;
  late GlobalKey passwordKey;

  @override
  void initState() {
    passwordKey = GlobalKey();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    linkChargerBloc = BlocProvider.linkChargerBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<void>(
    stream: linkChargerBloc.selectNetworkChangesStream,
    builder: (BuildContext context, AsyncSnapshot<void> snapshot) => linkChargerBloc.isLoadingNetworks
      ? const Center(child: CircularProgressIndicator(color: CustomColors.lime))
      : _createContent()
  );

  // Method that creates the content of the tab: the text, the options and the password field.
  Widget _createContent() => LinkChargerTabLayout(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createDescription(),
        const SizedBox(height: Sizes.margin16),

        Platform.isIOS
          ? _createIosOptions()
          : _createAndroidOptions(),
        const SizedBox(height: Sizes.margin20),

        if (linkChargerBloc.selectedNetworkSsid.isNotEmpty || linkChargerBloc.isOtherNetwork) _createInput(
          key: passwordKey,
          title: _getPasswordTitle(),
          initialText: linkChargerBloc.networkPassword,
          textInputType: TextInputType.visiblePassword,
          isPassword: true,
          onChanged: _onPasswordChanged
        )
      ]
    )
  );

  // Method that creates the description.
  Widget _createDescription() => TextInter(
    text: AppLocalizations.of(context)!.translate('charger_link_wifi_text'),
    fontSize: screenProperties.fontSmall,
    color: CustomColors.textSecondary,
    fontWeight: FontWeight.w400
  );

  // Method that creates the list of scanned networks and the search again link.
  Widget _createAndroidOptions() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Sizes.margin16,
    children: [
      linkChargerBloc.networks.isEmpty
        ? const TextNotFound(topMargin: Sizes.margin20)
        : _createNetworks(),
      LinkChargerSearchAgain(onClicked: _onSearchAgainClicked)
    ]
  );

  // Method that creates the items of the scanned networks.
  Widget _createNetworks() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ...linkChargerBloc.networks.asMap().entries.map((MapEntry<int, WifiNetworkModel> entry) => ItemLinkChargerOption(
        index: entry.key,
        isLast: false,
        iconData: FontAwesomeIcons.wifi,
        title: entry.value.ssid,
        isSelected: !linkChargerBloc.isOtherNetwork && entry.value.ssid == linkChargerBloc.selectedNetworkSsid,
        onClicked: () => _onNetworkClicked(entry.value.ssid)
      ))
    ]
  );

  // Method that creates the iOS options: the current network when it is known and the option to type another one.
  Widget _createIosOptions() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (linkChargerBloc.currentNetworkName.isNotEmpty) ItemLinkChargerOption(
        index: 0,
        isLast: false,
        iconData: FontAwesomeIcons.wifi,
        title: linkChargerBloc.currentNetworkName,
        isSelected: !linkChargerBloc.isOtherNetwork && linkChargerBloc.currentNetworkName == linkChargerBloc.selectedNetworkSsid,
        onClicked: () => _onNetworkClicked(linkChargerBloc.currentNetworkName)
      ),

      ItemLinkChargerOption(
        index: linkChargerBloc.currentNetworkName.isEmpty ? 0 : 1,
        isLast: false,
        iconData: FontAwesomeIcons.pen,
        title: AppLocalizations.of(context)!.translate('charger_link_wifi_other'),
        isSelected: linkChargerBloc.isOtherNetwork,
        onClicked: _onOtherNetworkClicked
      ),
      SizedBox(height: linkChargerBloc.isOtherNetwork ? Sizes.margin16 : 0),

      if (linkChargerBloc.isOtherNetwork) _createInput(
        title: AppLocalizations.of(context)!.translate('charger_link_wifi_name'),
        initialText: linkChargerBloc.otherNetworkName,
        textInputType: TextInputType.text,
        onChanged: _onOtherNetworkNameChanged
      )
    ]
  );

  // Method that creates a titled input of the tab.
  Widget _createInput({
    Key? key,
    required String title,
    required String initialText,
    required TextInputType textInputType,
    bool isPassword = false,
    required void Function(String value) onChanged
  }) => TitledInputTextField(
    key: key,
    title: title,
    hint: Strings.emptyString,
    initialText: initialText,
    titleFontSize: screenProperties.fontExtraSmall,
    fontSize: screenProperties.fontSmall,
    textInputType: textInputType,
    obscureText: isPassword,
    allowShowText: isPassword,
    onValueChanged: onChanged
  );

  // Method that gets the title of the password field: the generic password text when another network is typed, or the chosen network name.
  String _getPasswordTitle() => linkChargerBloc.isOtherNetwork
    ? AppLocalizations.of(context)!.translate('password')
    : AppLocalizations.of(context)!.translate('charger_link_wifi_password').replaceFirst(Strings.replaceCode, linkChargerBloc.selectedNetworkSsid);

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks a network of the list.
  void _onNetworkClicked(String ssid) {
    linkChargerBloc.changeIsOtherNetwork(false);
    linkChargerBloc.changeSelectedNetworkSsid(ssid);

    _scrollToPassword();
  }

  // Method that is called when the user clicks the other network option.
  void _onOtherNetworkClicked() {
    linkChargerBloc.changeIsOtherNetwork(true);
    linkChargerBloc.changeSelectedNetworkSsid(Strings.emptyString);

    _scrollToPassword();
  }

  // Method that is called when the user clicks the search again link.
  void _onSearchAgainClicked() => HelperWifi.searchNetworks(context: context);

  // Method that scrolls the tab until the password field is visible, once it has been built.
  void _scrollToPassword() => Future.delayed(const Duration(milliseconds: Numbers.delayWaitScroll), () {
    final BuildContext? passwordContext = passwordKey.currentContext;

    if (!mounted || passwordContext == null || !passwordContext.mounted) {
      return;
    }

    Scrollable.ensureVisible(
      passwordContext,
      duration: const Duration(milliseconds: Numbers.delayScroll),
      curve: Curves.decelerate,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd
    );
  });

  // ***************************************************************************
  // On change listeners.
  // ***************************************************************************
  void _onOtherNetworkNameChanged(String value) => linkChargerBloc.changeOtherNetworkName(value);
  void _onPasswordChanged(String value) => linkChargerBloc.changeNetworkPassword(value);
}
