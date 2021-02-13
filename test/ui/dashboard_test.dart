import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/container/days_container.dart';
import 'package:dr/data.dart';
import 'package:dr/ui/days.dart';
import 'package:dr/ui/no_internet.dart';
import 'package:dr/ui/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> main() async {
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
              [
                Day(
                  (b) => b
                    ..date = DateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder()
                    ..lastRequested = DateTime.now(),
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
              [
                Day(
                  (b) => b
                    ..date = DateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder([
                      Homework(
                        (b) => b
                          ..checkable = true
                          ..checked = false
                          ..deleteable = false
                          ..deleted = false
                          ..firstSeen = DateTime.now()
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
                    ..lastRequested = DateTime.now(),
                ),
                Day(
                  (b) => b
                    ..date = DateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder()
                    ..lastRequested = DateTime.now(),
                ),
                Day(
                  (b) => b
                    ..date = DateTime.now()
                    ..deletedHomework = ListBuilder(
                      [
                        Homework(
                          (b) => b
                            ..checkable = true
                            ..checked = true
                            ..deleteable = false
                            ..deleted = true
                            ..firstSeen = DateTime.now()
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
                      [
                        Homework(
                          (b) => b
                            ..checkable = true
                            ..checked = true
                            ..deleteable = false
                            ..deleted = false
                            ..firstSeen = DateTime.now()
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
                            ..firstSeen = DateTime.now()
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
                    ..lastRequested = DateTime.now(),
                ),
                Day(
                  (b) => b
                    ..date = DateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder()
                    ..lastRequested = DateTime.now(),
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
              [
                Day(
                  (b) => b
                    ..date = DateTime.now()
                    ..deletedHomework = ListBuilder()
                    ..homework = ListBuilder()
                    ..lastRequested = DateTime.now(),
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
}
