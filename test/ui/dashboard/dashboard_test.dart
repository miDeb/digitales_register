// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:core';

import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/container/days_container.dart';
import 'package:dr/data.dart';
import 'package:dr/main.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:dr/ui/days.dart';
import 'package:dr/ui/no_internet.dart';
import 'package:dr/ui/sidebar.dart';
import 'package:dr/utc_date_time.dart';
import 'package:dr/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

class MockWrapper extends Mock implements Wrapper {}

Future<void> main() async {
  testGoldens('Open drawer in phone mode', (WidgetTester tester) async {
    ScaffoldState getScaffoldState() {
      return tester.state(find.byType(Scaffold));
    }

    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(),
        AppActions(),
      ),
      child: MaterialApp(home: DaysContainer()),
    );
    await tester.pumpWidget(
      Center(
        child: SizedBox(
          width: 300,
          child: widget,
        ),
      ),
    );
    expect(getScaffoldState().isDrawerOpen, isFalse);
    // scroll vertically
    await tester.fling(find.byType(Scaffold), const Offset(0, 500), 1000);
    expect(getScaffoldState().isDrawerOpen, isFalse);
    // scroll vertically, but also a bit horizontally
    await tester.fling(find.byType(Scaffold), const Offset(30, 100), 1000);
    expect(getScaffoldState().isDrawerOpen, isFalse);
    // scroll mostly horizontally
    await tester.fling(find.byType(Scaffold), const Offset(100, 30), 1000);
    expect(getScaffoldState().isDrawerOpen, isTrue);
  });
  testWidgets('Home page shows no internet message',
      (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState((b) => b.noInternet = true),
        AppActions(),
      ),
      child: MaterialApp(home: DaysContainer()),
    );
    await tester.pumpWidget(widget);
    expect(find.text("Keine Verbindung"), findsNWidgets(2));
    expect(find.byType(NoInternet), findsOneWidget);
    expect(find.text("Vergangenheit"), findsOneWidget);
    expect(find.text("Zukunft"), findsNothing);
    expect(find.byType(Sidebar), findsOneWidget);
  });

  testGoldens('Long user name is wrapped', (WidgetTester tester) async {
    const longName = "Michael Debertol Elternaccount-1";
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(
          (b) => b..loginState.username = longName,
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: DaysContainer(),
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
      ),
    );
    await tester.pumpWidget(widget);
    await expectLater(find.text(longName), matchesGoldenFile('long_name.png'));
  });

  testGoldens('shows circular progress indicator if there are no entries',
      (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(
          (b) => b..dashboardState.loading = true,
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: DaysContainer(),
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
      ),
    );
    await tester.pumpWidget(widget);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    await expectLater(
        find.byType(DaysWidget), matchesGoldenFile("loading_empty.png"));
  });
  testGoldens(
      'shows linear progress indicator if there are one or more entries',
      (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(
          (b) => b.dashboardState
            ..loading = true
            ..allDays = ListBuilder(
              <Day>[
                Day(
                  (b) => b
                    ..date = UtcDateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder()
                    ..lastRequested = UtcDateTime.now(),
                ),
              ],
            ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: DaysContainer(),
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
      ),
    );
    await tester.pumpWidget(widget);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byType(DayWidget), findsOneWidget);
    await expectLater(
        find.byType(ReduxProvider), matchesGoldenFile("loading_not_empty.png"));
  });

  testGoldens('Multiple Entries', (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(
          (b) => b.dashboardState
            ..allDays = ListBuilder(
              <Day>[
                Day(
                  (b) => b
                    ..date = UtcDateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder(<Homework>[
                      Homework(
                        (b) => b
                          ..checkable = true
                          ..checked = false
                          ..deleteable = false
                          ..deleted = false
                          ..firstSeen = UtcDateTime.now()
                          ..id = 1
                          ..isChanged = false
                          ..isNew = false
                          ..type = HomeworkType.lessonHomework
                          ..warningServerSaid = true
                          ..title = "Test"
                          ..subtitle = "Subtitle"
                          ..gradeFormatted = "7/9",
                      ),
                    ])
                    ..lastRequested = UtcDateTime.now(),
                ),
                Day(
                  (b) => b
                    ..date = UtcDateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder()
                    ..lastRequested = UtcDateTime.now(),
                ),
                Day(
                  (b) => b
                    ..date = UtcDateTime.now()
                    ..deletedHomework = ListBuilder(
                      <Homework>[
                        Homework(
                          (b) => b
                            ..checkable = true
                            ..checked = true
                            ..deleteable = false
                            ..deleted = true
                            ..firstSeen = UtcDateTime.now()
                            ..id = 1234
                            ..isChanged = false
                            ..isNew = false
                            ..type = HomeworkType.lessonHomework
                            ..warningServerSaid = false
                            ..title = "Titel"
                            ..subtitle = "Subtitle",
                        ),
                      ],
                    )
                    ..homework = ListBuilder(
                      <Homework>[
                        Homework(
                          (b) => b
                            ..checkable = true
                            ..checked = true
                            ..deleteable = false
                            ..deleted = false
                            ..firstSeen = UtcDateTime.now()
                            ..id = 0
                            ..isChanged = false
                            ..isNew = false
                            ..type = HomeworkType.lessonHomework
                            ..warningServerSaid = false
                            ..title = "Title"
                            ..subtitle = "Subtitle",
                        ),
                        Homework(
                          (b) => b
                            ..checkable = true
                            ..checked = false
                            ..deleteable = false
                            ..deleted = false
                            ..firstSeen = UtcDateTime.now()
                            ..id = 1
                            ..isChanged = false
                            ..isNew = false
                            ..type = HomeworkType.lessonHomework
                            ..warningServerSaid = true
                            ..title = "Test"
                            ..subtitle = "Subtitle",
                        ),
                      ],
                    )
                    ..lastRequested = UtcDateTime.now(),
                ),
                Day(
                  (b) => b
                    ..date = UtcDateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder()
                    ..lastRequested = UtcDateTime.now(),
                ),
              ],
            ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: DaysContainer(),
        theme:
            ThemeData(primarySwatch: Colors.teal, brightness: Brightness.dark),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.byType(DayWidget), findsNWidgets(4));
    expect(find.byType(ItemWidget), findsNWidgets(3));
    expect(find.byIcon(Icons.delete), findsOneWidget);
    await expectLater(
        find.byType(DaysWidget), matchesGoldenFile("multiple_entries.png"));
  });

  testGoldens('dark mode', (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(
          (b) => b.dashboardState
            ..allDays = ListBuilder(
              <Day>[
                Day(
                  (b) => b
                    ..date = UtcDateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder()
                    ..lastRequested = UtcDateTime.now(),
                ),
              ],
            ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: DaysContainer(),
        theme:
            ThemeData(primarySwatch: Colors.teal, brightness: Brightness.dark),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.byType(DayWidget), findsOneWidget);
    await expectLater(
        find.byType(DaysWidget), matchesGoldenFile("dark_not_empty.png"));
  });

  testWidgets('tooltips', (WidgetTester tester) async {
    const username = "Michael Debertol";
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(
          (b) => b.loginState.username = username,
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: DaysContainer(),
        theme:
            ThemeData(primarySwatch: Colors.teal, brightness: Brightness.dark),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byTooltip(username), findsOneWidget);
    expect(find.byTooltip("Hausaufgaben"), findsOneWidget);
    expect(find.byTooltip("Noten"), findsOneWidget);
    expect(find.byTooltip("Absenzen"), findsOneWidget);
    expect(find.byTooltip("Kalender"), findsOneWidget);
    expect(find.byTooltip("Einstellungen"), findsOneWidget);
    expect(find.byTooltip("Abmelden"), findsOneWidget);
    expect(find.byTooltip("Einklappen"), findsOneWidget);
    expect(find.byTooltip("Ausklappen"), findsNothing);
  });

  testWidgets('correct collapse label', (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState(
          (b) => b.settingsState.drawerFullyExpanded = false,
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: DaysContainer(),
        theme:
            ThemeData(primarySwatch: Colors.teal, brightness: Brightness.dark),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byTooltip("Einklappen"), findsNothing);
    expect(find.byTooltip("Ausklappen"), findsOneWidget);
  });

  testGoldens('new entries are animated', (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        appReducerBuilder.build(),
        AppState(
          (b) => b.dashboardState
            ..allDays = ListBuilder(
              <Day>[
                Day(
                  (b) => b
                    ..date = UtcDateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder(<Homework>[
                      Homework(
                        (b) => b
                          ..checkable = true
                          ..checked = false
                          ..deleteable = false
                          ..deleted = false
                          ..firstSeen = UtcDateTime.now()
                          ..id = 0
                          ..isChanged = false
                          ..isNew = false
                          ..type = HomeworkType.lessonHomework
                          ..warningServerSaid = false
                          ..title = "Title"
                          ..subtitle = "Subtitle",
                      ),
                    ])
                    ..lastRequested = UtcDateTime.now(),
                ),
              ],
            ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: DaysContainer(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
    await tester.pumpWidget(widget);
    await expectLater(find.byType(DaysWidget),
        matchesGoldenFile("new_entry_not_yet_animating.png"));
    // start the entry animation
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 75));
    // should now be halfway opened
    expect(find.byType(ItemWidget), findsOneWidget);
    await expectLater(
        find.byType(DaysWidget), matchesGoldenFile("new_entry_animating.png"));
    await tester.pump(const Duration(milliseconds: 200));
    // should be fully opened
    await tester.pump();
    expect(find.byType(ItemWidget), findsOneWidget);
    await expectLater(
        find.byType(DaysWidget), matchesGoldenFile("new_entry_animated.png"));
  });

  testGoldens('animation for reminder deletion', (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        appReducerBuilder.build(),
        AppState(
          (b) => b.dashboardState
            ..allDays = ListBuilder(
              <Day>[
                Day(
                  (b) => b
                    ..date = UtcDateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder(<Homework>[
                      Homework(
                        (b) => b
                          ..checkable = true
                          ..checked = true
                          ..deleteable = true
                          ..deleted = false
                          ..firstSeen = UtcDateTime.now()
                              // do not show a entry animation
                              .subtract(const Duration(seconds: 10))
                          ..id = 0
                          ..isChanged = false
                          ..isNew = false
                          ..type = HomeworkType.homework
                          ..warningServerSaid = false
                          ..title = "Title"
                          ..subtitle = "Subtitle",
                      ),
                    ])
                    ..lastRequested = UtcDateTime.now(),
                ),
              ],
            ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: DaysContainer(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byType(ItemWidget), findsOneWidget);
    await expectLater(
        find.byType(DaysWidget), matchesGoldenFile("reminder.png"));
    // trigger the close animation
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    // should now be halfway closed
    expect(find.byType(ItemWidget), findsOneWidget);
    await expectLater(
        find.byType(DaysWidget), matchesGoldenFile("reminder_deleting.png"));
    await tester.pump(const Duration(milliseconds: 200));
    // should be gone
    await tester.pump();
    expect(find.byType(ItemWidget), findsNothing);
  });

  testGoldens('animation for checking an item', (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        appReducerBuilder.build(),
        AppState(
          (b) => b.dashboardState
            ..allDays = ListBuilder(
              <Day>[
                Day(
                  (b) => b
                    ..date = UtcDateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder(<Homework>[
                      Homework(
                        (b) => b
                          ..checkable = true
                          ..checked = false
                          ..deleteable = true
                          ..deleted = false
                          ..firstSeen = UtcDateTime.now()
                              // do not show a entry animation
                              .subtract(const Duration(seconds: 10))
                          ..id = 0
                          ..isChanged = false
                          ..isNew = false
                          ..type = HomeworkType.homework
                          ..warningServerSaid = false
                          ..title = "Title"
                          ..subtitle = "Subtitle",
                      ),
                    ])
                    ..lastRequested = UtcDateTime.now(),
                ),
              ],
            ),
        ),
        AppActions(),
      ),
      child: MaterialApp(
        home: DaysContainer(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byType(ItemWidget), findsOneWidget);
    // trigger the checkbox animation
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));
    // should now be halfway checked
    await expectLater(find.byType(DaysWidget),
        matchesGoldenFile("item_checking_animation.png"));
    await tester.pump(const Duration(milliseconds: 250));
    // should be fully checked
    await tester.pump();
    await expectLater(
        find.byType(DaysWidget), matchesGoldenFile("item_checked.png"));
  });

  testWidgets("check box when offline but not yet in offline mode",
      (WidgetTester tester) async {
    secureStorage = const FlutterSecureStorage();
    scaffoldMessengerKey = GlobalKey();
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState(
        (b) => b.dashboardState
          ..allDays = ListBuilder(
            <Day>[
              Day(
                (b) => b
                  ..date = UtcDateTime.now()
                  ..deletedHomework = ListBuilder()
                  ..homework = ListBuilder(<Homework>[
                    Homework(
                      (b) => b
                        ..checkable = true
                        ..checked = false
                        ..deleteable = true
                        ..deleted = false
                        ..firstSeen = UtcDateTime(2021, 2, 2)
                        ..id = 0
                        ..isChanged = false
                        ..isNew = false
                        ..type = HomeworkType.homework
                        ..warningServerSaid = false
                        ..title = "Title"
                        ..subtitle = "Subtitle",
                    ),
                  ])
                  ..lastRequested = UtcDateTime.now(),
              ),
            ],
          ),
      ),
      AppActions(),
      middleware: middleware(includeErrorMiddleware: false),
    );
    final widget = ReduxProvider(
      store: store,
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: DaysContainer(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
    wrapper = MockWrapper();
    when(() => wrapper.noInternet).thenReturn(true);
    when(() => wrapper.refreshNoInternet())
        .thenAnswer((_) => Future.value(true));
    when(() => wrapper.send(
          "api/student/dashboard/toggle_reminder",
          args: {
            "id": 0,
            "type": "homework",
            "value": true,
          },
        )).thenAnswer((_) => Future<dynamic>.value());
    await tester.pumpWidget(widget);
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
    await store.actions.refreshNoInternet();
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).onChanged, isNull);
  });
}
