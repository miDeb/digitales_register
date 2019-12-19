import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

import 'actions/app_actions.dart';
import 'actions/login_actions.dart';
import 'app_state.dart';
import 'container/absences_page_container.dart';
import 'container/calendar_container.dart';
import 'container/grades_page_container.dart';
import 'container/home_page.dart';
import 'container/login_page.dart';
import 'container/notifications_page.dart';
import 'container/settings_page.dart';
import 'linux.dart';
import 'main.dart';
import 'middleware/middleware.dart';
import 'reducer/reducer.dart';
import 'ui/grades_chart_page.dart';

void runDev() {
  final store = DevToolsStore(appReducer,
      middleware: createMiddleware(), initialState: AppState());
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
            theme: theme,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
            ),
            home: Scaffold(
              endDrawer: ReduxDevTools(store),
              body: MaterialApp(
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
          ),
        ),
        onPointerDown: (_) => store.dispatch(UpdateLogoutAction()),
      ),
      store: store,
    ),
  );
  store.dispatch(LoadAction());
}
