import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/app/link_charger/common/index.dart';

class TabLinkChargerConnecting extends StatefulWidget {
  const TabLinkChargerConnecting({
    super.key
  });

  @override
  State<TabLinkChargerConnecting> createState() => _TabLinkChargerConnectingState();
}

class _TabLinkChargerConnectingState extends State<TabLinkChargerConnecting> {
  @override
  Widget build(BuildContext context) => LinkChargerWaiting(
    title: AppLocalizations.of(context)!.translate('charger_link_connecting'),
    text: AppLocalizations.of(context)!.translate('charger_link_connecting_text')
  );
}
