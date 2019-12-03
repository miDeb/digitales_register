import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'actions.dart';
import 'app_state.dart';
import 'container/absences_page_container.dart';
import 'container/calendar_container.dart';
import 'container/grades_page_container.dart';
import 'container/home_page.dart';
import 'container/login_page.dart';
import 'container/notifications_page.dart';
import 'container/settings_page.dart';
import 'linux.dart';
import 'middleware/middleware.dart';
import 'reducer/reducer.dart';
import 'ui/grades_chart_page.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

typedef void SingleArgumentVoidCallback<T>(T arg);

void main() {
  _setTargetPlatformForDesktop();
  run();
}

void run() {
  final store = Store<AppState>(
    appReducer,
    middleware: createMiddleware(),
    initialState: AppState(),
  );
  runApp(
    StoreProvider(
      child: Listener(
        child: DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (brightness) {
            return brightness == Brightness.dark
                ? ThemeData(
                    primarySwatch: Colors.teal,
                    brightness: brightness,
                  )
                : ThemeData(
                    primarySwatch: Colors.blue,
                    brightness: brightness,
                  );
          },
          themedWidgetBuilder: (context, theme) => MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale("de"),
            ],
            navigatorKey: navigatorKey,
            initialRoute: "/",
            onGenerateRoute: (RouteSettings settings) {
              List<String> pathElements = settings.name.split("/");
              if (pathElements[0] != "") return null;
              switch (pathElements[1]) {
                case "":
                  return MaterialPageRoute(
                    builder: (_) => HomePage(),
                  );
                case "login":
                  return MaterialPageRoute(
                    builder: (_) => LoginPage(),
                  );
                case "notifications":
                  return MaterialPageRoute(
                    builder: (_) => NotificationPage(),
                    fullscreenDialog: true,
                  );
                case "settings":
                  return MaterialPageRoute(
                      builder: (_) => SettingsPageContainer());
                case "grades":
                  return MaterialPageRoute(
                    builder: (_) => GradesPageContainer(),
                  );
                case "absences":
                  return MaterialPageRoute(
                    builder: (_) => AbsencesPageContainer(),
                  );
                case "calendar":
                  return MaterialPageRoute(
                    builder: (_) => CalendarContainer(),
                  );
                case "gradesChart":
                  return MaterialPageRoute(
                    builder: (_) => GradesChartPage(),
                    fullscreenDialog: true,
                  );
                default:
                  throw Exception("Unknown Route");
              }
            },
            theme: theme,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
            ),
          ),
        ),
        onPointerDown: (_) => store.dispatch(TapAction()),
      ),
      store: store,
    ),
  );
  store.dispatch(LoadAction());
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}
