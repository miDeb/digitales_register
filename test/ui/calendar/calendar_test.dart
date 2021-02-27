import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/container/calendar_container.dart';
import 'package:dr/container/settings_page.dart';
import 'package:dr/data.dart';
import 'package:dr/main.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:dr/ui/dialog.dart';
import 'package:dr/util.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> main() async {
  Widget getCalendar(
      {required bool nicksBarEnabled, required bool hasSubjctWithoutNick}) {
    navigatorKey = GlobalKey();
    return ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        appReducerBuilder.build(),
        AppState(
          (b) {
            b.calendarState
              ..currentMonday = DateTime(2021, 2, 20)
              ..days = MapBuilder(
                <DateTime, CalendarDay>{
                  DateTime(2021, 2, 20): CalendarDay(
                    (b) => b
                      ..date = DateTime(2021, 2, 20)
                      ..hours = ListBuilder(
                        <CalendarHour>[
                          CalendarHour(
                            (b) => b
                              ..subject = "Fach1"
                              ..fromHour = 1
                              ..toHour = 2
                              ..rooms = ListBuilder()
                              ..homeworkExams = ListBuilder(
                                <HomeworkExam>[
                                  HomeworkExam(
                                    (b) => b
                                      ..deadline = DateTime.now()
                                      ..hasGradeGroupSubmissions = false
                                      ..hasGrades = false
                                      ..homework = false
                                      ..id = 5
                                      ..name = "Foo"
                                      ..online = false
                                      ..typeId = 500
                                      ..typeName = "Hausaufgabe",
                                  )
                                ],
                              ),
                          ),
                        ],
                      ),
                  ),
                },
              );
            b.settingsState.showCalendarNicksBar = nicksBarEnabled;
            if (!hasSubjctWithoutNick) {
              b.settingsState.subjectNicks = MapBuilder(<String, String>{
                "Fach1": "F",
              });
            }
          },
        ),
        AppActions(),
        middleware: [routingMiddleware.build()],
      ),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: CalendarContainer(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("de"),
        ],
        onGenerateRoute: (settings) {
          assert(settings.name == "/settings");
          return MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) => SettingsPageContainer(),
          );
        },
      ),
    );
  }

  group('Edit Subjects nicks bar', () {
    group('when disabled', () {
      testGoldens('and subject without nick', (WidgetTester tester) async {
        final widget =
            getCalendar(nicksBarEnabled: false, hasSubjctWithoutNick: true);
        await tester.pumpWidget(widget);
        await expectLater(find.byType(CalendarContainer),
            matchesGoldenFile("bar_not_shown.png"));
      });
      testGoldens('and no subject without nick', (WidgetTester tester) async {
        final widget =
            getCalendar(nicksBarEnabled: false, hasSubjctWithoutNick: false);
        await tester.pumpWidget(widget);
        await expectLater(find.byType(CalendarContainer),
            matchesGoldenFile("bar_not_shown_nick.png"));
      });
    });
    group('when enabled', () {
      testGoldens('and subject without nick', (WidgetTester tester) async {
        final widget =
            getCalendar(nicksBarEnabled: true, hasSubjctWithoutNick: true);
        await tester.pumpWidget(widget);
        await expectLater(
            find.byType(CalendarContainer), matchesGoldenFile("bar_shown.png"));
      });
      testGoldens('and no subject without nick', (WidgetTester tester) async {
        final widget =
            getCalendar(nicksBarEnabled: true, hasSubjctWithoutNick: false);
        await tester.pumpWidget(widget);
        await expectLater(find.byType(CalendarContainer),
            matchesGoldenFile("bar_not_shown_nick.png"));
      });
    });
  });
  testWidgets('jump to current week', (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        appReducerBuilder.build(),
        AppState(
          (b) {
            b.calendarState.currentMonday = DateTime(2021, 1, 20);
          },
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: CalendarContainer(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("de"),
        ],
      ),
    );
    // the shown week is the previous week
    mockNow = DateTime(2021, 1, 27);
    await tester.pumpWidget(widget);
    // one circular progressindicator on top, one on the body
    expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    expect(find.text("Aktuelle Woche"), findsOneWidget);
    await tester.tap(find.text("Aktuelle Woche"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    // weeks are animating, so there are two weeks that show a progress indicator
    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    expect(find.text("Aktuelle Woche"), findsNothing);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    expect(find.text("Aktuelle Woche"), findsNothing);
  });

  testWidgets("tapping the bar opens settings", (WidgetTester tester) async {
    final widget =
        getCalendar(nicksBarEnabled: true, hasSubjctWithoutNick: true);
    await tester.pumpWidget(
      DynamicTheme(
        data: (brightness, overridePlatform) {
          return ThemeData(
            primarySwatch: Colors.deepOrange,
            brightness: brightness,
          );
        },
        themedWidgetBuilder: (context, data) => widget,
      ),
    );
    await tester.tap(find.textContaining("Kürzel"));
    await tester.pumpAndSettle();
    // a dialog should be opened
    expect(find.byType(InfoDialog), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(InfoDialog),
        matching: find.text("Kürzel hinzufügen"),
      ),
      findsOneWidget,
    );
    expect(find.text("Fach1"), findsOneWidget);
  });
}
