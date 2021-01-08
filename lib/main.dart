import 'dart:io';

import 'package:built_redux/built_redux.dart';
import 'package:dr/container/settings_page.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_scaffold/scaffold.dart';
import 'package:uni_links/uni_links.dart';

import 'actions/app_actions.dart';
import 'app_state.dart';
import 'container/change_email_container.dart';
import 'container/home_page.dart';
import 'container/login_page.dart';
import 'container/notifications_page_container.dart';
import 'container/pass_reset_container.dart';
import 'container/profile_container.dart';
import 'container/request_pass_reset_container.dart';
import 'middleware/middleware.dart';
import 'reducer/reducer.dart';
import 'ui/grades_chart_page.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();
GlobalKey<NavigatorState> nestedNavKey = GlobalKey();
GlobalKey<ResponsiveScaffoldState<Pages>> scaffoldKey = GlobalKey();

typedef SingleArgumentVoidCallback<T> = void Function(T arg);

void main() {
  final store = Store<AppState, AppStateBuilder, AppActions>(
    appReducerBuilder.build(),
    AppState(),
    AppActions(),
    middleware: middleware,
  );
  runApp(
    ReduxProvider(
      child: Listener(
        child: DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (brightness, overridePlatform) {
            TargetPlatform platform;
            if (overridePlatform && Platform.isAndroid) {
              platform = TargetPlatform.iOS;
            }
            return brightness == Brightness.dark
                ? ThemeData(
                    primarySwatch: Colors.teal,
                    brightness: brightness,
                    platform: platform,
                  )
                : ThemeData(
                    primarySwatch: Colors.deepOrange,
                    brightness: brightness,
                    platform: platform,
                  );
          },
          themedWidgetBuilder: (context, theme) => MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              GlobalCupertinoLocalizations.delegate,
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
                case "request_pass_reset":
                  return MaterialPageRoute(
                    builder: (_) => RequestPassResetContainer(),
                  );
                case "pass_reset":
                  return MaterialPageRoute(
                    builder: (_) => PassResetContainer(),
                  );
                case "change_email":
                  return MaterialPageRoute(
                    builder: (_) => ChangeEmailContainer(),
                  );
                case "profile":
                  return MaterialPageRoute(
                    builder: (_) => ProfileContainer(),
                  );
                case "notifications":
                  return MaterialPageRoute(
                    builder: (_) => NotificationPageContainer(),
                    fullscreenDialog: true,
                  );
                case "gradesChart":
                  return MaterialPageRoute(
                    builder: (_) => GradesChartPage(),
                    fullscreenDialog: true,
                  );
                case "settings":
                  return MaterialPageRoute(
                    builder: (_) => SettingsPageContainer(),
                    fullscreenDialog: true,
                  );
                default:
                  throw Exception("Unknown Route ${pathElements[1]}");
              }
            },
            theme: theme,
          ),
        ),
        onPointerDown: (_) => store.actions.loginActions.updateLogout(),
      ),
      store: store,
    ),
  );
  WidgetsBinding.instance
    ..addPostFrameCallback(
      (_) async {
        Uri uri;
        if (Platform.isAndroid) {
          uri = await getInitialUri();
          getUriLinksStream().listen((event) {
            store.actions.start(event);
          });
        }
        store.actions.start(uri);
        WidgetsBinding.instance
          ..addObserver(
            LifecycleObserver(
              () {
                store.actions.restarted();
              },
              // this might not finish in time:
              store.actions.saveState,
            ),
          );
      },
    );
}

class LifecycleObserver with WidgetsBindingObserver {
  final VoidCallback onReload;
  final VoidCallback onLogout;

  LifecycleObserver(this.onReload, this.onLogout);
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onReload();
    }
    if (state == AppLifecycleState.paused) {
      onLogout();
    }
  }
}
