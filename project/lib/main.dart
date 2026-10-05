import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Config.
import 'package:project/src/config/index.dart';

// Models.
import 'package:project/src/models/generic/session_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/route_tracker.dart';
import 'package:project/src/commons/utils/routes.dart';

// System UI style: light icons on the dark app.
const SystemUiOverlayStyle _systemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: CustomColors.black,
  systemNavigationBarIconBrightness: Brightness.light
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  // Initialize preferences.
  final preferences = Preferences();
  await preferences.initPreferences();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Status bar and navigation bar with light icons (dark app).
  SystemChrome.setSystemUIOverlayStyle(_systemUiOverlayStyle);

  // TODO - Firebase.
  // await FirebaseService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GlobalKey<NavigatorState> navigatorKey;
  late bool blocHasInitialized;

  @override
  void initState() {
    navigatorKey = GlobalKey<NavigatorState>();
    blocHasInitialized = false;

    // TODO - Initialize local notifications.
    /*localNotificationsService = LocalNotificationsService();
    localNotificationsService.init(navigatorKey);

    FirebaseService.getPushNotificationStream().listen((Map<String, dynamic> data) {
      if (data[Fields.pushNotification] != null) {
        if (data[Fields.open]) {
          localNotificationsService.notificationSelected(data[Fields.pushNotification]);
        } else {
          localNotificationsService.showNotification(data[Fields.pushNotification]);
        }
      }
    });*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    child: Builder(
      builder: (BuildContext context) {
        final StateBloc stateBloc = BlocProvider.stateBloc(context);

        if (!blocHasInitialized) {
          blocHasInitialized = true;
          stateBloc.reset();
        }

        return StreamBuilder<SessionModel>(
          stream: stateBloc.sessionStream.distinct((SessionModel prev, SessionModel next) => prev.languageCode == next.languageCode), // Listen changes only if language code is updated.
          builder: (BuildContext context, AsyncSnapshot<SessionModel> snapshot) => _createMaterialApp(),
        );
      },
    ),
  );

  // Method that creates the material app.
  Widget _createMaterialApp() {
    final SessionModel session = Preferences().session;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiOverlayStyle,
      child: MaterialApp(
        title: Strings.appName,
        navigatorObservers: [routeTracker],
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: Colors.white,
          textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: CustomColors.lime,
            selectionColor: CustomColors.lime80,
            cursorColor: CustomColors.lime,
          ),
          fontFamily: Strings.fontFamily,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: _systemUiOverlayStyle
          ),
        ),
        initialRoute: Routes.splash,
        routes: Routes.getRoutes(),
        supportedLocales: AppLocalizations.getSupportedLocales(),

        // Make sure that the localization data for the proper language is loaded.
        localizationsDelegates: [
          AppLocalizations.delegate, // A class which loads the translations from JSON files.
          GlobalMaterialLocalizations.delegate, // Built-in localization of basic text for Material widgets.
          GlobalCupertinoLocalizations.delegate, // Built-in localization of basic text for Cupertino widgets.
          GlobalWidgetsLocalizations.delegate, // Built-in localization for text direction LTR/RTL.
        ],

        // Returns a locale which will be used by the app.
        locale: session.languageCode.isNotEmpty
          ? AppLocalizations.getLocaleByLanguageCode(session.languageCode)
          : null,
        localeListResolutionCallback: _localeListResolutionCallback,
        builder: (BuildContext context, Widget? child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
          child: child!,
        ),
      )
    );
  }

  // Method that gets the locales.
  Locale _localeListResolutionCallback(List<Locale>? deviceLocales, Iterable<Locale> supported) {
    // Match country + language code.
    if (deviceLocales != null) {
      for (Locale deviceLocale in deviceLocales) {
        for (Locale supportedLocale in supported) {
          final String deviceCountryCode = (deviceLocale.countryCode ?? Strings.emptyString).toLowerCase();
          final String supportedCountryCode = (supportedLocale.countryCode ?? Strings.emptyString).toLowerCase();

          if (supportedLocale.languageCode == deviceLocale.languageCode && deviceCountryCode == supportedCountryCode) {
            return supportedLocale;
          }
        }
      }

      // Match language.
      for (Locale deviceLocale in deviceLocales) {
        for (Locale supportedLocale in supported) {
          if (supportedLocale.languageCode == deviceLocale.languageCode) {
            return supportedLocale;
          }
        }
      }
    }

    // If not valid, first supported.
    return supported.first;
  }
}
