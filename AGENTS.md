# GRACO — Project Norms for AI Agents

GRACO (client Norpoo) is an app for connecting to and charging electric
vehicles, on iOS and Android. It was built from the Blimbur Flutter
template, which provides the base architecture (BLoC, services, widgets,
helpers); the design and the domain features are still pending.

---

## Project Setup

| What | Where | Status |
|---|---|---|
| App name | `Strings.appName` in `lib/src/commons/constants/strings.dart` and `"app_name"` in `lang/es.json` | ✅ `GRACO` |
| Project description | `description` in `pubspec.yaml` | ✅ "Mobile app project for Norpoo - GRACO project" |
| Flutter / Dart version | `environment.sdk` in `pubspec.yaml` | ✅ Flutter 3.41.4 stable, Dart `^3.11.1` |
| Languages | `lang/es.json`, `lang/en.json` | ⏳ `lang/en.json` must be created (`es` is the default, `en` is already in `AppLocalizations.languageCodes`) |
| API base URL (dev / prod) | `Backend.baseUrl` in `lib/src/commons/constants/backend.dart` | ⏳ Empty — TODO for dev and prod |
| Environment variables | `.env` (never commit secrets) | ✅ `check_latest_version` defined |
| Bundle ID / application ID | `ios/Runner.xcodeproj`, `android/app/build.gradle(.kts)` | ✅ `com.graco.project` |
| Display name | `CFBundleDisplayName` in `ios/Runner/Info.plist`, `android:label` in `android/app/src/main/AndroidManifest.xml` | ⏳ Still "Project" (iOS) / "project" (Android) — must become GRACO |
| App icons and splash | `ios/Runner/Assets.xcassets`, `android/app/src/main/res` | ⏳ Flutter defaults |
| Fonts | `fonts/` and the `fonts:` section in `pubspec.yaml` | ✅ Inter 18pt, weights 100–900 + italics |
| Brand colors | `CustomColors` in `lib/src/commons/constants/custom_colors.dart` | ⏳ Placeholder colors — pending design |
| Store links | `Urls` in `lib/src/commons/constants/urls.dart` | ⏳ Generic links, no app ID yet |
| README | `README.md` | ⏳ Default Flutter text |

Remove leftovers from other projects when found.

---

## Stack

- **Platform:** iOS & Android — Flutter **3.41.4** stable (Dart SDK constraint `^3.11.1` in `pubspec.yaml`)
- **Material 3:** disabled (`useMaterial3: false`)
- **State management:** RxDart `BehaviorSubject` — custom BLoC pattern. **Do NOT use `flutter_bloc`.**
- **HTTP:** `http` package — only through `ApiService` (see Service Pattern)
- **Storage:** `SharedPreferences` via `Preferences()` singleton
- **Fonts:** Inter (static 18pt cuts, weights 100–900 with italics, in `fonts/`) — family name in `Strings.fontFamily`, never as a literal; always use the `TextInter` widget, never raw `Text`
- **i18n:** Custom JSON-based localisation via `AppLocalizations` — `es` (default) and `en`
- **Package name:** `project` (all imports start with `package:project/`)
- **Flutter project root:** `project/` — every path in this document is relative to it (`project/pubspec.yaml`, `project/lib/`, `project/lang/`, …)

---

## Folder Structure

```
project/
  lib/
    main.dart
    src/
      bloc/
        bloc_provider.dart          # Singleton InheritedWidget — registers all BLoCs
        state_bloc.dart             # Global app state
        public/                     # Unauthenticated BLoCs (login_bloc.dart)
        private/                    # Authenticated BLoCs (main_bloc.dart, [feature]/)
      config/
        preferences/preferences.dart
        permissions/
      models/
        generic/                    # SessionModel, ScreenPropertiesModel, FileModel
        [feature]/                  # Domain models of the project
        user_model.dart
      services/                     # API layer
        api_service.dart            # Single entry point for backend HTTP calls
      helpers/
        api/                        # ServiceCallHelper, InitialCommonCalls, ActionHelper…
      pages/
        public/[name]/page.dart     # splash, login
        private/[name]/page.dart    # main, …
      widgets/
        generic/                    # Reusable widgets (do not import app-specific things)
        app/                        # App-specific widgets
      commons/
        constants/                  # CustomColors, Fields, Strings, Numbers, Sizes, States, Backend, Tabs, Calendar, Urls
        utils/                      # Utils facade, AppLocalizations, Routes, helpers/
  lang/
    es.json
    en.json
```

---

## Domain

GRACO connects to and charges electric vehicles. The charger and charging
features are not implemented yet: their models will live in
`lib/src/models/[feature]/` and their BLoCs in
`lib/src/bloc/private/[feature]/` once the design arrives. Until then, do
not invent endpoints, models or `Fields` keys — add only what the design
confirms, following the Model Pattern and the Service Pattern below.

---

## BLoC Pattern

**Reference files:** `lib/src/bloc/public/login_bloc.dart`, `lib/src/bloc/state_bloc.dart`, `lib/src/bloc/private/main_bloc.dart`

Every BLoC follows this exact structure:

```dart
import 'package:rxdart/rxdart.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';

class XBloc {
  // Private controllers — suffix: Controller
  final _xController = BehaviorSubject<T>();
  final _loadingTextController = BehaviorSubject<String>(); // always present

  // Streams (read)
  Stream<T> get xStream => _xController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;

  // Setters (write)
  Function(T) get changeX => _xController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;

  // Current values
  T get x => _xController.value;
  String get loadingText => _loadingTextController.value;

  // Dispose — close all controllers
  void dispose() {
    _xController.close();
    _loadingTextController.close();
  }

  // Reset — initialise all values
  void reset() {
    changeX(defaultValue);
    changeLoadingText(Strings.emptyString);
  }

  // Always last method
  bool blocIsInit() => _loadingTextController.hasValue;
}
```

**Rules:**
- Register in `lib/src/bloc/bloc_provider.dart`: add a private `final _xBloc = XBloc();` field and a static accessor `static XBloc xBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._xBloc;`
- Export via `lib/src/bloc/index.dart` (and the matching sub-index)
- Access everywhere as: `BlocProvider.xBloc(context)`
- Unauthenticated BLoCs → `lib/src/bloc/public/`
- Authenticated BLoCs → `lib/src/bloc/private/[feature]/`

---

## Model Pattern

**Reference files:** `lib/src/models/user_model.dart`, `lib/src/models/generic/session_model.dart`

```dart
import 'dart:convert';

// Models (nested models).
import 'package:project/src/models/...';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/states.dart';
import 'package:project/src/commons/constants/strings.dart';

// Top-level functions — always present
XModel xModelFromJson(String str) => XModel.fromJson(json.decode(str));
String xModelToJson(XModel data) => json.encode(data.toJson());

class XModel {
  String id;
  String name;
  String state;
  DateTime creationDate;
  DateTime modificationDate;

  XModel({
    this.id = Strings.emptyString,
    this.name = Strings.emptyString,
    this.state = States.ok,
    DateTime? creationDate,
    DateTime? modificationDate
  }) :
    creationDate = creationDate ?? DateTime.now(),
    modificationDate = modificationDate ?? DateTime.now();

  factory XModel.fromJson(Map<String, dynamic> json) => XModel(
    id: json[Fields.id] ?? Strings.emptyString,
    name: json[Fields.name] ?? Strings.emptyString,
    state: json[Fields.state] ?? States.ok,
    creationDate: json[Fields.creationDate] == null ? DateTime.now() : DateTime.parse(json[Fields.creationDate]),
    modificationDate: json[Fields.modificationDate] == null ? DateTime.now() : DateTime.parse(json[Fields.modificationDate])
  );

  Map<String, dynamic> toJson() => {
    Fields.id: id,
    Fields.name: name,
    Fields.state: state,
    Fields.creationDate: creationDate.toString(),
    Fields.modificationDate: modificationDate.toString()
  };

  bool isActive() => state == States.ok; // include when relevant
}
```

**Rules:**
- Domain models go in `lib/src/models/[feature]/`
- JSON field keys → always `Fields.xxx`, never string literals
- Default values → `Strings.emptyString`, `States.ok`, `DateTime.now()`
- Nested objects → `NestedModel.fromJson(json[Fields.nested] ?? {})`
- Lists → `(json[Fields.list] as List? ?? []).map((e) => XModel.fromJson(e)).toList()`
- Dates → `json[Fields.date] == null ? DateTime.now() : DateTime.parse(json[Fields.date])`

---

## Service Pattern

**Reference files:** `lib/src/services/api_service.dart`, `lib/src/services/auth_service.dart`, `lib/src/services/user_service.dart`

All backend calls go through `ApiService`, which has two public methods:

| Method | Use it for |
|---|---|
| `ApiService.requestJson` | JSON requests (`body` is a `Map`, sent as JSON) |
| `ApiService.requestMultipart` | `multipart/form-data` requests (files + text fields) |

Both build the URL and headers, send the request, decode the response,
catch errors and return the same normalised map:

| Key | Value |
|---|---|
| `Fields.statusCode` | HTTP status code (`Backend.code500` on exception) |
| `Fields.title` | `title` from the backend response |
| `Fields.text` | `message` from the backend response |
| `Fields.data` | raw `data` from the backend response |
| extra keys | whatever the `mapData` callback returns |

### JSON requests

```dart
// Models.
import 'package:project/src/models/user_model.dart';

// Services.
import 'package:project/src/services/api_service.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';

abstract class UserService {
  // Method that gets one user by id.
  static Future<Map<String, dynamic>> getOne({ required String id, required String language, required String token }) => ApiService.requestJson(
    method: Backend.get,
    endpoint: '${ Backend.getUser }/$id',
    language: language,
    token: token,
    mapData: (Map<String, dynamic> data) => {
      Fields.item: UserModel.fromJson(data[Fields.user] ?? {}),
      Fields.updateUserLastDate: DateTime.now()
    }
  );

  // Method that updates the password.
  static Future<Map<String, dynamic>> updatePassword({ required String id, required String oldPassword, required String newPassword, required String language, required String token }) => ApiService.requestJson(
    method: Backend.patch,
    endpoint: '${ Backend.updatePassword }/$id',
    language: language,
    token: token,
    body: { Fields.oldPassword: oldPassword, Fields.newPassword: newPassword }
  );
}
```

### Multipart requests (files + fields)

Illustrative example (`Backend.createIncident`, `Fields.description`,
`Fields.documents` and `IncidentModel` are placeholders):

```dart
// Method that creates an incident with attached documents.
static Future<Map<String, dynamic>> create({ required String description, required List<FileModel> documents, required String language, required String token }) => ApiService.requestMultipart(
  method: Backend.post,
  endpoint: Backend.createIncident,
  language: language,
  token: token,
  fields: { Fields.description: description },
  files: { Fields.documents: documents },
  mapData: (Map<String, dynamic> data) => { Fields.item: IncidentModel.fromJson(data[Fields.incident] ?? {}) }
);
```

- `fields` → `Map<String, dynamic>`: `String` values are sent as is, any other value is sent as `json.encode(value)`, and `null` values are skipped
- `files` → `Map<String, List<FileModel>>`: the key is the form field name; only `FileModel`s with `bytes` are sent, using `FileModel.name` as the filename
- Never set `Content-Type` for multipart requests: `http` sets it with the boundary

**Rules:**
- Always `abstract class` with `static` methods that return `ApiService.requestJson(...)` or `ApiService.requestMultipart(...)`
- Never import `http` or `dart:convert` in a backend service — only `ApiService` talks to `http`. Exceptions: non-backend or binary calls (`DownloadService`, `AppVersionService`)
- HTTP verbs → `Backend.get` / `Backend.post` / `Backend.put` / `Backend.patch` / `Backend.delete`
- Endpoint → a `Backend` constant; path params appended as `'${ Backend.x }/$id'`
- Public endpoints → omit `token`
- Extra response keys → only through `mapData`, which receives `data` (always a `Map`, never null). Always declare the parameter type: `mapData: (Map<String, dynamic> data) => { … }`
- New endpoint → add `static const String endpointName = 'api/v1/.../...';` to `lib/src/commons/constants/backend.dart`
- Status codes are consumed by the caller (`ServiceCallHelper.handle`), never handled inside the service

---

## Page Pattern

**Reference file:** `lib/src/pages/public/splash/page.dart`
**Mixin:** `lib/src/widgets/generic/mixins/page_handler.dart`

```dart
// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Commons.
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import 'package:project/src/widgets/generic/containers/scaffold_custom.dart';

class XPage extends StatefulWidget {
  const XPage({ super.key });

  @override
  State<XPage> createState() => _XPageState();
}

class _XPageState extends State<XPage> with PageHandler<XPage> {
  late XBloc _bloc;

  @override
  void onInit() {
    _bloc = BlocProvider.xBloc(context);
    _bloc.reset();
  }

  @override
  void updateRefreshDateTime() => _bloc.changeRefreshDateTime(DateTime.now());

  @override
  Widget build(BuildContext context) {
    initPage(context); // always first line of build()

    return ScaffoldCustom(
      scaffoldKey: scaffoldKey,
      createBody: _createContent
    );
  }

  Widget _createContent() {
    // build UI here — screenProperties is available from the mixin
  }
}
```

**Rules:**
- `initPage(context)` must be the first call inside `build()`
- `scaffoldKey` and `screenProperties` are provided by `PageHandler` — do not declare them
- `onInit()` → reset BLoCs and initialise variables (called once)
- `updateRefreshDateTime()` → trigger data reload (called on every reload)
- UI builder methods are private and named `_createXxx()`
- Register new pages in `lib/src/pages/index.dart` and their route in `Routes`

---

## Content Widget with Data Loading

**Reference:** `lib/src/widgets/generic/mixins/initial_load_handler.dart`

For sub-widgets that load async data, extend `RefreshableWidget` and use `InitialLoadHandler`:

```dart
// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

class XContent extends RefreshableWidget {
  const XContent({ required super.refreshDateTime, super.key });

  @override
  State<XContent> createState() => _XContentState();
}

class _XContentState extends State<XContent> with InitialLoadHandler<XContent> {
  @override
  StateBloc get stateBloc => BlocProvider.stateBloc(context);

  @override
  Future<Map<String, dynamic>> getData() async {
    final session = stateBloc.session;
    return XService.getX(language: session.languageCode, token: session.token);
  }

  @override
  void handleResponse(Map<String, dynamic> data) {
    // populate BLoCs with data[Fields.xxx]
  }

  @override
  Widget buildContent() {
    // return UI widget tree — data is already loaded
  }

  @override
  Widget build(BuildContext context) => buildInitialDataContent();
}
```

---

## Form Validation

- Errors are shown **inline**, below the input, via the `errorText` of `InputTextField` / `TitledInputTextField` — never in a dialog
- Validate in field order and show only the **first** error; move the focus to that input (`focusNode`); clear a field's error when its value changes
- Errors live in the BLoC as `fieldErrors` (`Map<String, String>` keyed by `Fields.xxx`), set with `setFieldError` and removed with `clearFieldError`
- Validation and the submit action live in a `HelperX` class (e.g. `HelperLogin`) in `lib/src/helpers/`. Once inline validation passes, the call goes through `ActionHelper.exec` with `validateFields: () => Strings.emptyString`, because there is nothing left to report in a dialog
- Error texts come from existing translation keys: `error_<screen>_<field>_validation` (e.g. `error_login_email_validation`)

---

## Widgets — Always Use Custom Widgets

| Use this | Never use this |
|---|---|
| `TextInter` | `Text` |
| `ButtonCustom` | `ElevatedButton`, `TextButton`, `OutlinedButton`, `FilledButton` |
| `InkWellCustom` | `InkWell`, `GestureDetector` |
| `ScaffoldCustom` | `Scaffold` |
| `CardCustom` / `CardContainer` | `Card` |
| `ConditionalWidget` | inline `if` in widget tree |
| `InputTextField` | `TextField`, `TextFormField` |
| `ImageLogo` | raw SVG logo |
| `WebImage` | `Image.network`, `CachedNetworkImage` directly |
| `LoaderDots` | `CircularProgressIndicator` (for animated dot loader) |
| `HtmlWidgetCustom` | `flutter_widget_from_html` directly |
| `AlignedGridViewCustom` | `GridView` |
| `FutureLoadingDataContent` | `FutureBuilder` directly |

Before creating a new widget, check `lib/src/widgets/generic/` for an existing one.

**Responsive font sizes** (always via `screenProperties`):

| Property | Approx size |
|---|---|
| `screenProperties.fontExtraSmall` | 12–13 |
| `screenProperties.fontSmall` | 15–16 |
| `screenProperties.fontText` | 17–19 |
| `screenProperties.fontSubtitle` | 20–22 |
| `screenProperties.fontTitle` | 22–24 |
| `screenProperties.fontBigTitle` | 26–28 |
| `screenProperties.fontExtraTitle` | 30–32 |

---

## Constants — Where to Put Things

| What | Class | File |
|---|---|---|
| Colors | `CustomColors` | `lib/src/commons/constants/custom_colors.dart` |
| Strings, symbols, app name, font family | `Strings` | `lib/src/commons/constants/strings.dart` |
| Numeric limits, delays, counts | `Numbers` | `lib/src/commons/constants/numbers.dart` |
| Sizes, margins, font sizes | `Sizes` | `lib/src/commons/constants/sizes.dart` |
| JSON / API / form field keys | `Fields` | `lib/src/commons/constants/fields.dart` |
| Entity states | `States` | `lib/src/commons/constants/states.dart` |
| API base URL, endpoints, HTTP verbs, status codes, headers | `Backend` | `lib/src/commons/constants/backend.dart` |
| External URLs (stores, web) | `Urls` | `lib/src/commons/constants/urls.dart` |
| Navigation tab names | `Tabs` | `lib/src/commons/constants/tabs.dart` |
| Route names | `Routes` | `lib/src/commons/utils/routes.dart` |
| Calendar month/day names | `Calendar` | `lib/src/commons/constants/calendar.dart` |

---

## Localisation

- Every visible string must be added to **both** `lang/es.json` AND `lang/en.json` with the same key
- Group keys by section using a comment entry: `"_section_name": "--- Section ---"`
- Access: `AppLocalizations.of(context)!.translate('key')`
- Default language: Spanish (`es`)

---

## Responsive Design

`screenProperties` is a `ScreenPropertiesModel` instance:

| Property | Meaning |
|---|---|
| `screenProperties.isPhone` | width ≤ 450 px |
| `screenProperties.isTablet` | 450 < width ≤ 1150 px |
| `screenProperties.isMonitor` | width > 1150 px |
| `screenProperties.hasHamburgerMenu` | width ≤ 975 px |
| `screenProperties.size` | `MediaQuery.of(context).size` |
| `screenProperties.paddingCardHorizontal` | adaptive horizontal padding |
| `screenProperties.paddingCardVertical` | adaptive vertical padding |

In pages using `PageHandler`, `screenProperties` is already available as a mixin property.
Elsewhere, instantiate: `final screenProperties = ScreenPropertiesModel(context: context);`

---

## Import Order

Always group imports with a comment label, in this order:

```dart
// Config.
import 'package:project/src/config/...';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/...';

// Services.
import 'package:project/src/services/...';

// Commons.
import 'package:project/src/commons/constants/...';
import 'package:project/src/commons/utils/...';

// Pages.
import 'package:project/src/pages/index.dart';

// Widgets.
import 'package:project/src/widgets/...';
```

---

## Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `user_model.dart` |
| Classes | `PascalCase` | `UserModel` |
| Methods & variables | `camelCase` | `updateSession()` |
| Constants (in static classes) | `camelCase` with `static const` | `static const String emptyString = ''` |
| BLoC controllers | `_xController` (private, suffix `Controller`) | `_emailController` |
| BLoC stream getters | `xStream` | `emailStream` |
| BLoC value getters | `x` | `email` |
| BLoC setter getters | `changeX` | `changeEmail` |
| Pages | suffix `Page` | `LoginPage` |
| Custom widgets | suffix `Custom` | `ButtonCustom`, `CardCustom` |
| Helpers | suffix `Helper` | `DialogHelper`, `DateHelper` |
| Services | suffix `Service` | `AuthService` |
| BLoCs | suffix `Bloc` | `LoginBloc`, `StateBloc` |
| Models | suffix `Model` | `UserModel`, `SessionModel` |
| UI builder methods | private, prefix `_create` | `_createContent()`, `_createHeader()` |

---

## Code Formatting

**Do NOT run `dart format`** — it rewrites the house style below. Format code by hand:

- **Indentation:** 2 spaces
- **Named-parameter braces:** spaces inside — `({ required String id, super.key })`
- **Interpolations with expressions:** spaces inside — `'${ Backend.baseUrl }/$id'` (simple `$id` stays as is)
- **Trailing commas:** none after the last parameter, list element or map entry (`super.key`, last child, last entry)
- **Line length:** keep short signatures and calls on one line; when a line gets long (~120 characters), put each named parameter on its own line
- **Closing parenthesis:** on its own line, aligned with the start of the call, when the call spans multiple lines
- **Closure parameters:** always typed — `(Map<String, dynamic> data) => …`, never `(data) => …`
- **`const`:** add wherever the compiler allows it

**Correct:**
```dart
static Future<Map<String, dynamic>> getOne({ required String id, required String language, required String token }) => ApiService.requestJson(
  method: Backend.get,
  endpoint: '${ Backend.getUser }/$id',
  language: language,
  token: token,
  mapData: (Map<String, dynamic> data) => { Fields.item: UserModel.fromJson(data[Fields.user] ?? {}) }
);

TextInter(
  text: item.name,
  fontSize: screenProperties.fontSmall,
  fontWeight: FontWeight.w600
)
```

**Incorrect:**
```dart
static Future<Map<String, dynamic>> getOne({required String id, required String language, required String token}) =>
    ApiService.requestJson(method: Backend.get, endpoint: '${Backend.getUser}/$id', language: language, token: token, mapData: (data) => {Fields.item: UserModel.fromJson(data[Fields.user] ?? {})},);
```

---

## Strict Rules — Never Break These

1. **Never use `Text(...)`** — always use `TextInter`
2. **Never use `ElevatedButton`, `TextButton`, `OutlinedButton`** — always use `ButtonCustom`
3. **Never use `InkWell`** — always use `InkWellCustom`
4. **Never use `Scaffold`** — always use `ScaffoldCustom`
5. **Never import or use `flutter_bloc`** — the project has its own BLoC implementation with RxDart
6. **Never use string literals as JSON keys** in `fromJson`/`toJson` — always use `Fields.xxx`
7. **Never hardcode visible strings** in widgets — always use `AppLocalizations.of(context)!.translate('key')`
8. **Never use `Color(0xff...)` literals** — always use `CustomColors.xxx`
9. **Never use magic numbers** for sizes or margins — always use `Sizes.xxx` or `Numbers.xxx`
10. **Never call `initPage(context)` anywhere other than the first line of `build()`**
11. **New endpoints** must be added as constants to `Backend` — never inline URL strings in services
12. **New JSON / form fields** must be added as constants to `Fields` — never use raw strings
13. **Never call `http` directly in backend services** — always use `ApiService.requestJson` or `ApiService.requestMultipart`
14. **Never run `dart format`** — follow the Code Formatting section by hand
15. **Never leave content from other projects** (names, endpoints, translation keys of another app)