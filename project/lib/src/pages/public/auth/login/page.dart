import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/glow_scroll_behavior.dart';
import 'package:project/src/commons/utils/routes.dart';
import 'package:project/src/commons/utils/utils.dart';

// Pages.
import 'package:project/src/pages/index.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/button_custom.dart';
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_white.dart';
import 'package:project/src/widgets/generic/clickables/text_clickable.dart';
import 'package:project/src/widgets/generic/containers/scaffold_custom.dart';
import 'package:project/src/widgets/generic/images/image_logo.dart';
import 'package:project/src/widgets/generic/inputs/titled_input_text_field.dart';
import 'package:project/src/widgets/generic/texts/section_introduction_texts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc loginBloc;

  late ScreenPropertiesModel screenProperties;

  late bool hasLoaded;

  @override
  void initState() {
    hasLoaded = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return ScaffoldCustom(
      showBackgroundLogo: false,
      leftPadding: screenProperties.paddingCardHorizontal,
      rightPadding: screenProperties.paddingCardHorizontal,
      createBody: _createContent,
    );
  }

  // Method that initializes the variables.
  void _init() {
    loginBloc = BlocProvider.loginBloc(context);

    screenProperties = ScreenPropertiesModel(context: context);

    if (hasLoaded) {
      return;
    }

    loginBloc.reset();

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

          _createLogo(),
          const SizedBox(height: Sizes.margin40),
          
          _createMainContent()
        ],
      ),
    ),
  );

  // Method that creates the logo.
  Widget _createLogo() => Align(
    alignment: Alignment.topCenter,
    child: ImageLogo(
      height: Sizes.logoPresentationHeight
    ),
  );

  // Method that creates the main content.
  Widget _createMainContent() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionIntroductionTexts(
        title: AppLocalizations.of(context)!.translate('login'),
        subtitle: AppLocalizations.of(context)!.translate('login_text')
      ),
      const SizedBox(height: Sizes.margin30),

      _createInput('email', AppLocalizations.of(context)!.translate('email_hint'), TextInputType.emailAddress, false, _onEmailChanged),
      const SizedBox(height: Sizes.margin16),

      _createInput('password', AppLocalizations.of(context)!.translate('password_hint').replaceFirst(Strings.replaceCode, Numbers.passwordLengthMin.toString()), TextInputType.text, true, _onPasswordChanged),
      const SizedBox(height: Sizes.margin16),

      _createRecoverPasswordLink(),
      const SizedBox(height: Sizes.margin30),

      _createButtons()
    ],
  );

  // Method that creates an input.
  Widget _createInput(String titleKey, String hint, TextInputType textInputType, bool isPassword, void Function(String value) onChanged) => TitledInputTextField(
    title: AppLocalizations.of(context)!.translate(titleKey),
    hint: hint,
    initialText: Strings.emptyString,
    titleFontSize: screenProperties.fontExtraSmall,
    fontSize: screenProperties.fontExtraSmall,
    isMandatory: true,
    textInputType: textInputType,
    allowShowText: isPassword,
    obscureText: isPassword,
    onValueChanged: onChanged
  );

  // Method that creates the recover password link.
  Widget _createRecoverPasswordLink() => Align(
    alignment: Alignment.center,
    child: TextClickable(
      text: AppLocalizations.of(context)!.translate('password_recover'),
      fontSize: screenProperties.fontExtraSmall,
      onClicked: _onRecoverPasswordTextClicked
    ),
  );

  // Method that creates the buttons.
  Widget _createButtons() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Sizes.margin16,
    children: [
      ButtonCustom(
        text: AppLocalizations.of(context)!.translate('access'),
        fontSize: screenProperties.fontExtraSmall,
        onClicked: _onLoginButtonClicked
      ),

      ButtonColoredWhite(
        text: AppLocalizations.of(context)!.translate('account_create'),
        fontSize: screenProperties.fontExtraSmall,
        mainAxisSize: MainAxisSize.max,
        onClicked: _onSignUpButtonClicked
      )
    ],
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the login button.
  void _onLoginButtonClicked() {} // TODO. => HelperLogin.onLoginButtonClicked(context);

  // Method that is called when the user clicks the recover password link.
  void _onRecoverPasswordTextClicked() => Utils.navigatorPush(context: context, child: ForgotPasswordPage(), routeName: Routes.forgotPassword);

  // Method that is called when the user clicks the sign up button.
  void _onSignUpButtonClicked() => Utils.navigatorPush(context: context, child: SignUpPage(), routeName: Routes.signUp);

  // ***************************************************************************
  // On change listeners.
  // ***************************************************************************
  void _onEmailChanged(String value) => loginBloc.changeEmail(value);
  void _onPasswordChanged(String value) => loginBloc.changePassword(value);
}
