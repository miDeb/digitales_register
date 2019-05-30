import 'package:built_collection/built_collection.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
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
import 'middleware/middleware.dart';
import 'reducer/reducer.dart';
import 'ui/grades_chart_page.dart';
import 'util.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

typedef void SingleArgumentVoidCallback<T>(T arg);

void main() {
  run();
}

final initialState = AppState((builder) {
  builder
    ..dayState = (DayStateBuilder()
      ..future = true
      ..loading = false
      ..blacklist = ListBuilder([]))
    ..loginState = (LoginStateBuilder()
      ..loading = false
      ..loggedIn = false
      ..userName = null
      ..errorMsg = null)
    ..notificationState = NotificationStateBuilder()
    ..currentRouteIsLogin = false
    ..noInternet = false
    ..settingsState = (SettingsStateBuilder()
      ..doubleTapForDone = false
      ..noAverageForAllSemester = true
      ..noDataSaving = false
      ..noPasswordSaving = false
      ..typeSorted = false
      ..showCancelled = false
      ..askWhenDelete = true
      ..deleteDataOnLogout = false)
    ..config = null
    ..gradesState = (GradesStateBuilder()
      ..semester = Semester.all
      ..subjects = ListBuilder([])
      ..loading = false
      ..serverSemester = null
      ..graphConfigs = MapBuilder({}))
    ..absenceState = null
    ..calendarState = (CalendarStateBuilder()
      ..currentMonday = toMonday(DateTime.now())
      ..days = MapBuilder());
});

void run() {
  final store = Store<AppState>(
    appReducer,
    middleware: createMiddleware(),
    initialState: initialState,
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
                  }
                },
                theme: theme,
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
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
