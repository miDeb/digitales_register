import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/container/grades_page_container.dart';
import 'package:dr/data.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:dr/ui/sorted_grades_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

AppState _getGradesState({bool loading = false}) {
  return AppState(
    (b) {
      b.gradesState
        ..loading = loading
        ..subjects = ListBuilder(
          <Subject>[
            Subject(
              (b) => b
                ..name = "Fach1"
                ..grades = MapBuilder()
                ..gradesAll = MapBuilder(
                  {
                    Semester.first: [
                      GradeAll(
                        (b) => b
                          ..weightPercentage = 100
                          ..cancelled = false
                          ..date = DateTime(2021, 1, 2)
                          ..grade = 7 * 100 + 75 // 8-
                          ..type = "Schularbeit1",
                      ),
                      GradeAll(
                        (b) => b
                          ..weightPercentage = 100
                          ..cancelled = false
                          ..date = DateTime(2021, 1, 3)
                          ..grade = 7 * 100 + 50 // 7/8
                          ..type = "Schularbeit2",
                      ),
                      GradeAll(
                        (b) => b
                          ..weightPercentage = 100
                          ..cancelled = false
                          ..date = DateTime(2021, 1, 4)
                          ..grade = 7 * 100 + 25 // 7+
                          ..type = "Schularbeit3",
                      ),
                    ].toBuiltList(),
                  },
                )
                ..grades = MapBuilder(
                  {
                    Semester.first: [
                      GradeDetail(
                        (b) => b
                          ..name = "Erste Schularbeit"
                          ..id = 0
                          ..weightPercentage = 100
                          ..cancelled = false
                          ..date = DateTime(2021, 1, 2)
                          ..created = "am 3. 2. erstellt"
                          ..grade = 7 * 100 + 75 // 8-
                          ..type = "Schularbeit1",
                      ),
                      GradeDetail(
                        (b) => b
                          ..name = "Zweite Schularbeit"
                          ..id = 1
                          ..weightPercentage = 100
                          ..cancelled = false
                          ..date = DateTime(2021, 1, 3)
                          ..created = "am 4. 2. erstellt"
                          ..grade = 7 * 100 + 50 // 7/8
                          ..type = "Schularbeit2",
                      ),
                      GradeDetail(
                        (b) => b
                          ..name = "Dritte Schularbeit"
                          ..id = 2
                          ..weightPercentage = 100
                          ..cancelled = false
                          ..date = DateTime(2021, 1, 4)
                          ..created = "am 5. 2. erstellt"
                          ..grade = 7 * 100 + 25 // 7+
                          ..type = "Schularbeit3",
                      ),
                    ].toBuiltList(),
                  },
                )
                ..observations =
                    MapBuilder({Semester.first: <Observation>[].toBuiltList()}),
            ),
            Subject(
              (b) => b
                ..name = "Fach2"
                ..grades = MapBuilder()
                ..gradesAll = MapBuilder(
                  {
                    Semester.first: [
                      GradeAll(
                        (b) => b
                          ..weightPercentage = 25
                          ..cancelled = false
                          ..date = DateTime(2021, 1, 2)
                          ..grade = 4 * 100
                          ..type = "Test",
                      ),
                    ].toBuiltList(),
                  },
                )
                ..observations =
                    MapBuilder({Semester.first: <Observation>[].toBuiltList()}),
            ),
          ],
        )
        ..semester = Semester.first.toBuilder();
      b.settingsState.subjectThemes = MapBuilder(
        {
          "Fach1": SubjectTheme(
            (b) => b
              ..color = Colors.red.value
              ..thick = 5,
          ),
          "Fach2": SubjectTheme(
            (b) => b
              ..color = Colors.green.value
              ..thick = 4,
          ),
        },
      );
    },
  );
}

void main() {
  testGoldens('grades page loading when empty', (tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        appReducerBuilder.build(),
        AppState((b) => b.gradesState.loading = true),
        AppActions(),
      ),
      child: MaterialApp(
        home: const GradesPageContainer(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    await expectLater(
      find.byType(GradesPageContainer),
      matchesGoldenFile("loading_empty.png"),
    );
  });
  testGoldens('grades page loading when not empty', (tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        appReducerBuilder.build(),
        _getGradesState(loading: true),
        AppActions(),
      ),
      child: MaterialApp(
        home: const GradesPageContainer(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await expectLater(
      find.byType(GradesPageContainer),
      matchesGoldenFile("loading_not_empty.png"),
    );
  });
  testGoldens('grades page interactions', (tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        appReducerBuilder.build(),
        _getGradesState(),
        AppActions(),
      ),
      child: MaterialApp(
        home: const GradesPageContainer(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.text("Dritte Schularbeit"), findsNothing);
    await tester.tap(find.text("Fach1"));
    await tester.pumpAndSettle();
    expect(find.text("Dritte Schularbeit"), findsOneWidget);
    await expectLater(
      find.byType(GradesPageContainer),
      matchesGoldenFile("open_unsorted.png"),
    );
    await tester.tap(find.text("Noten nach Art sortieren"));
    await tester.pumpAndSettle();

    expect(
      find.byType(GradeTypeWidget),
      findsNWidgets(3),
    );
    await expectLater(
      find.byType(GradesPageContainer),
      matchesGoldenFile("open_sorted.png"),
    );
  });
}
