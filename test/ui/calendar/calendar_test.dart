import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/container/calendar_container.dart';
import 'package:dr/data.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> main() async {
  group('Edit Subjects nicks bar', () {
    Widget getCalendar(
        {required bool nicksBarEnabled, required bool hasSubjctWithoutNick}) {
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
    }

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
        await expectLater(find.byType(CalendarContainer),
            matchesGoldenFile("bar_shown.png"));
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
}
