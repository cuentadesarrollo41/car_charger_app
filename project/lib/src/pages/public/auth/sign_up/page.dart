import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Helpers.
import './helpers/index.dart';

// Commons.
import 'package:project/src/commons/constants/app_bar_modes.dart';
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/constants/urls.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/glow_scroll_behavior.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import 'package:project/src/widgets/generic/app_bar/app_bar_custom.dart';
import 'package:project/src/widgets/generic/clickables/buttons/button_custom.dart';
import 'package:project/src/widgets/generic/containers/scaffold_custom.dart';
import 'package:project/src/widgets/generic/inputs/titled_input_text_field.dart';
import 'package:project/src/widgets/generic/stream_builders/keyboard_visibility_builder.dart';
import 'package:project/src/widgets/generic/texts/rich_text_custom.dart';
import 'package:project/src/widgets/generic/texts/section_introduction_texts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late SignUpBloc signUpBloc;

  late ScreenPropertiesModel screenProperties;

  late bool hasLoaded;

  late Map<String, FocusNode> focusNodes;

  late TapGestureRecognizer accessRecognizer;

  late TapGestureRecognizer termsRecognizer;

  late TapGestureRecognizer privacyRecognizer;

  @override
  void initState() {
    hasLoaded = false;
    focusNodes = { Fields.email: FocusNode(), Fields.password: FocusNode() };

    accessRecognizer = TapGestureRecognizer()..onTap = _onAccessTextClicked;
    termsRecognizer = TapGestureRecognizer()..onTap = _onTermsTextClicked;
    privacyRecognizer = TapGestureRecognizer()..onTap = _onPrivacyTextClicked;

    super.initState();
  }

  @override
  void dispose() {
    Utils.disposeFocusNodes(focusNodes: focusNodes.values);
    accessRecognizer.dispose();
    termsRecognizer.dispose();
    privacyRecognizer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return ScaffoldCustom(
      appBar: AppBarCustom(
        appBarMode: AppBarModes.public,
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
    signUpBloc = BlocProvider.signUpBloc(context);

    screenProperties = ScreenPropertiesModel(context: context);

    if (hasLoaded) {
      return;
    }

    signUpBloc.reset();

    hasLoaded = true;

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) => setState(() {}));
  }

  // Method that creates the content.
  Widget _createContent() => Column(
    children: [
      Expanded(
        child: ScrollConfiguration(
          behavior: GlowScrollBehavior(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Sizes.margin20),
                _createMainContent()
              ]
            )
          )
        )
      ),

      _createTerms()
    ]
  );

  // Method that creates the main content.
  Widget _createMainContent() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionIntroductionTexts(
        title: AppLocalizations.of(context)!.translate('account_create'),
        subtitle: AppLocalizations.of(context)!.translate('account_create_text')
      ),
      const SizedBox(height: Sizes.margin30),

      _createInputs(),
      const SizedBox(height: Sizes.margin16),

      _createSignUpButton(),
      const SizedBox(height: Sizes.margin16),

      _createLoginLink()
    ],
  );

  // Method that creates the inputs.
  Widget _createInputs() => StreamBuilder<Map<String, String>>(
    stream: signUpBloc.fieldErrorsStream,
    builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createInput('email', Fields.email, AppLocalizations.of(context)!.translate('email_hint'), TextInputType.emailAddress, false, _onEmailChanged),
        const SizedBox(height: Sizes.margin16),

        _createInput('password', Fields.password, AppLocalizations.of(context)!.translate('password_hint').replaceFirst(Strings.replaceCode, Numbers.passwordLengthMin.toString()), TextInputType.text, true, _onPasswordChanged)
      ],
    ),
  );

  // Method that creates an input.
  Widget _createInput(String titleKey, String field, String hint, TextInputType textInputType, bool isPassword, void Function(String value) onChanged) => TitledInputTextField(
    title: AppLocalizations.of(context)!.translate(titleKey),
    hint: hint,
    initialText: Strings.emptyString,
    titleFontSize: screenProperties.fontExtraSmall,
    fontSize: screenProperties.fontSmall,
    isMandatory: true,
    textInputType: textInputType,
    allowShowText: isPassword,
    obscureText: isPassword,
    errorText: signUpBloc.fieldErrors[field] ?? Strings.emptyString,
    focusNode: focusNodes[field],
    onValueChanged: onChanged
  );

  // Method that creates the sign up button.
  Widget _createSignUpButton() => ButtonCustom(
    text: AppLocalizations.of(context)!.translate('account_create'),
    fontSize: screenProperties.fontExtraSmall,
    onClicked: _onSignUpButtonClicked
  );

  // Method that creates the login link.
  Widget _createLoginLink() => RichTextCustom(
    fontSize: screenProperties.fontSmall,
    color: CustomColors.textSecondary,
    backgroundColor: Colors.transparent,
    textAlign: TextAlign.center,
    children: [
      TextSpan(text: '${ AppLocalizations.of(context)!.translate('already_account') }${ Strings.oneSpace }'),
      TextSpan(
        text: AppLocalizations.of(context)!.translate('access'),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        recognizer: accessRecognizer
      )
    ]
  );

  // Method that creates the terms text.
  Widget _createTerms() => KeyboardVisibilityBuilder(
    child: SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: screenProperties.paddingCardHorizontal,
          right: screenProperties.paddingCardHorizontal,
          bottom: Sizes.margin10,
        ),
        child: RichTextCustom(
          fontSize: screenProperties.fontExtraSmall,
          color: CustomColors.textSecondary,
          backgroundColor: Colors.transparent,
          textAlign: TextAlign.center,
          children: [
            TextSpan(text: AppLocalizations.of(context)!.translate('terms_1')),
            TextSpan(text: AppLocalizations.of(context)!.translate('terms_2'), style: const TextStyle(color: Colors.white), recognizer: termsRecognizer),
            TextSpan(text: AppLocalizations.of(context)!.translate('terms_3')),
            TextSpan(text: AppLocalizations.of(context)!.translate('terms_4'), style: const TextStyle(color: Colors.white), recognizer: privacyRecognizer)
          ]
        ),
      ),
    )
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the back button.
  void _onBackButtonClicked() => Navigator.pop(context);

  // Method that is called when the user clicks the sign up button.
  void _onSignUpButtonClicked() => HelperSignUp.onSignUpButtonClicked(context: context, focusNodes: focusNodes);

  // Method that is called when the user clicks the access text.
  void _onAccessTextClicked() => Navigator.pop(context);

  // Method that is called when the user clicks the terms text.
  void _onTermsTextClicked() => Utils.loadUrl(url: Urls.terms);

  // Method that is called when the user clicks the privacy text.
  void _onPrivacyTextClicked() => Utils.loadUrl(url: Urls.privacy);

  // ***************************************************************************
  // On change listeners.
  // ***************************************************************************
  void _onEmailChanged(String value) => signUpBloc.changeFieldValue(Fields.email, signUpBloc.changeEmail, value);
  void _onPasswordChanged(String value) => signUpBloc.changeFieldValue(Fields.password, signUpBloc.changePassword, value);
}
