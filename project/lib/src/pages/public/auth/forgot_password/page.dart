import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Helpers.
import './helpers/index.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/glow_scroll_behavior.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import 'package:project/src/widgets/generic/app_bar/app_bar_custom.dart';
import 'package:project/src/widgets/generic/clickables/buttons/button_custom.dart';
import 'package:project/src/widgets/generic/containers/scaffold_custom.dart';
import 'package:project/src/widgets/generic/inputs/titled_input_text_field.dart';
import 'package:project/src/widgets/generic/texts/section_introduction_texts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    super.key
  });

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late ForgotPasswordBloc forgotPasswordBloc;

  late ScreenPropertiesModel screenProperties;

  late bool hasLoaded;

  late Map<String, FocusNode> focusNodes;

  @override
  void initState() {
    hasLoaded = false;

    focusNodes = { Fields.email: FocusNode() };

    super.initState();
  }

  @override
  void dispose() {
    Utils.disposeFocusNodes(focusNodes: focusNodes.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return ScaffoldCustom(
      appBar: AppBarCustom(
        onBackButtonClicked: _onBackButtonClicked
      ),
      showBackgroundLogo: false,
      leftPadding: screenProperties.paddingCardHorizontal,
      rightPadding: screenProperties.paddingCardHorizontal,
      createBody: _createContent
    );
  }

  // Method that initializes the variables.
  void _init() {
    forgotPasswordBloc = BlocProvider.forgotPasswordBloc(context);

    screenProperties = ScreenPropertiesModel(context: context);

    if (hasLoaded) {
      return;
    }

    forgotPasswordBloc.reset();

    hasLoaded = true;

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) => setState(() {}));
  }

  // Method that creates the content.
  Widget _createContent() => ScrollConfiguration(
    behavior: GlowScrollBehavior(),
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Sizes.margin20),

          _createMainContent()
        ],
      ),
    ),
  );

  // Method that creates the main content.
  Widget _createMainContent() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionIntroductionTexts(
        title: AppLocalizations.of(context)!.translate('password_recover'),
        subtitle: AppLocalizations.of(context)!.translate('password_recover_text')
      ),
      const SizedBox(height: Sizes.margin30),

      _createInput(),
      const SizedBox(height: Sizes.margin30),

      ButtonCustom(
        text: AppLocalizations.of(context)!.translate('password_recover'),
        fontSize: screenProperties.fontExtraSmall,
        onClicked: _onRecoverPasswordButtonClicked
      )
    ],
  );

  // Method that creates the input.
  Widget _createInput() => StreamBuilder<Map<String, String>>(
    stream: forgotPasswordBloc.fieldErrorsStream,
    builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) => TitledInputTextField(
      title: AppLocalizations.of(context)!.translate('email'),
      hint: AppLocalizations.of(context)!.translate('email_hint'),
      initialText: Strings.emptyString,
      titleFontSize: screenProperties.fontExtraSmall,
      fontSize: screenProperties.fontSmall,
      isMandatory: true,
      textInputType: TextInputType.emailAddress,
      errorText: forgotPasswordBloc.fieldErrors[Fields.email] ?? Strings.emptyString,
      focusNode: focusNodes[Fields.email],
      onValueChanged: _onEmailChanged
    ),
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the back button.
  void _onBackButtonClicked() => Navigator.pop(context);

  // Method that is called when the user clicks the recover password button.
  void _onRecoverPasswordButtonClicked() => HelperForgotPassword.onRecoverPasswordButtonClicked(context: context, focusNodes: focusNodes);

  // ***************************************************************************
  // On change listeners.
  // ***************************************************************************
  void _onEmailChanged(String value) => forgotPasswordBloc.changeFieldValue(Fields.email, forgotPasswordBloc.changeEmail, value);
}
