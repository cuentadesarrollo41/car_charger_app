import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Helpers.
import '../helpers/index.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/tabs.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import 'package:project/src/widgets/generic/lines/line.dart';
import 'package:project/src/widgets/generic/list/item_list_access.dart';
import 'package:project/src/widgets/generic/modal_bottom_sheets/modal_bottom_sheet_confirmation.dart';
import 'package:project/src/widgets/generic/texts/section_introduction_texts.dart';

class SectionManagement extends StatefulWidget {
  const SectionManagement({
    super.key
  });

  @override
  State<SectionManagement> createState() => _SectionManagementState();
}

class _SectionManagementState extends State<SectionManagement> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionIntroductionTexts(
          title: AppLocalizations.of(context)!.translate('account_manage'),
          subtitle: AppLocalizations.of(context)!.translate('account_manage_text')
        ),
        const SizedBox(height: Sizes.margin16),

        _createItem(FontAwesomeIcons.userPen, 'user_name', _onUserNameItemClicked),

        _createItem(FontAwesomeIcons.lock, 'password_change', _onChangePasswordItemClicked),
        const SizedBox(height: Sizes.margin4),

        _createLine(),
        const SizedBox(height: Sizes.margin16),

        _createItem(FontAwesomeIcons.rightFromBracket, 'logout', _onLogoutItemClicked),
        _createItem(FontAwesomeIcons.trashCan, 'account_delete_my', _onDeleteAccountItemClicked, color: CustomColors.red)
      ]
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates an item.
  Widget _createItem(FaIconData leftIconData, String textKey, void Function() onClicked, { Color color = Colors.white }) => ItemListAccess(
    index: 0,
    leftIconData: leftIconData,
    text: AppLocalizations.of(context)!.translate(textKey),
    isSelected: false,
    isLast: false,
    rightIconData: FontAwesomeIcons.chevronRight,
    primaryColor: color,
    onItemClicked: onClicked
  );

  // Method that creates a line.
  Widget _createLine() => Line(
    height: Sizes.defaultBorderSize,
    width: double.infinity,
    color: CustomColors.backgroundLine,
    verticalMargin: 0
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the user name item.
  void _onUserNameItemClicked() => BlocProvider.myProfileBloc(context).changeTab(Tabs.userName);

  // Method that is called when the user clicks the change password item.
  void _onChangePasswordItemClicked() => BlocProvider.myProfileBloc(context).changeTab(Tabs.updatePassword);

  // Method that is called when the user clicks the logout item.
  void _onLogoutItemClicked() => Utils.showModalBottomSheetCustom(
    context: context,
    bottomSheet: ModalBottomSheetConfirmation(
      title: AppLocalizations.of(context)!.translate('logout'),
      texts: [ TextSpan(text: AppLocalizations.of(context)!.translate('logout_text')) ],
      primaryButtonText: AppLocalizations.of(context)!.translate('logout'),
      secondaryButtonText: AppLocalizations.of(context)!.translate('cancel'),
      primaryButtonColor: CustomColors.redDark,
      secondaryButtonColor: CustomColors.backgroundGhost,
      onPrimaryButtonClicked: () {
        Navigator.pop(context);
        Utils.logout(context: context);
      },
      onSecondaryButtonClicked: () => Navigator.pop(context)
    )
  );

  // Method that is called when the user clicks the delete account item.
  void _onDeleteAccountItemClicked() => HelperDeleteAccount.onDeleteAccountConfirmed(context: context);
}
