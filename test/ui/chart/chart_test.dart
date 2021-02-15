import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/container/grades_chart_container.dart';
import 'package:dr/data.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:dr/ui/grades_chart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:built_collection/built_collection.dart';

AppState get _gradesState {
  return AppState(
    (b) {
      b.gradesState
        ..subjects = ListBuilder(
          [
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
                ..observations = MapBuilder(),
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
                ..observations = MapBuilder(),
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
  testGoldens(
    'grades chart interactions',
    (tester) async {
      final widget = ReduxProvider(
        store: Store<AppState, AppStateBuilder, AppActions>(
          appReducerBuilder.build(),
          _gradesState,
          AppActions(),
        ),
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale("de"),
          ],
          home: const Material(
            child: GradesChartContainer(
              isFullscreen: true,
            ),
          ),
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
        ),
      );

      await tester.pumpWidget(widget);
      expect(
        find.text("Tippe auf das Diagramm, um Details zu sehen"),
        findsOneWidget,
      );
      await expectLater(
        find.byType(GradesChartContainer),
        matchesGoldenFile("chart.png"),
      );
      await tester.tapAt(const Offset(750, 200));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await expectLater(
        find.byType(GradesChartContainer),
        matchesGoldenFile("chart_animating_label1.png"),
      );
      await tester.pumpAndSettle();
      expect(find.text("Fach1 · Schularbeit3: 7+"), findsOneWidget);
      expect(find.text("4. Januar"), findsOneWidget);
      await expectLater(
        find.byType(GradesChartContainer),
        matchesGoldenFile("chart_label1.png"),
      );
      await tester.tapAt(const Offset(50, 200));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await expectLater(
        find.byType(GradesChartContainer),
        matchesGoldenFile("chart_animating_label2.png"),
      );
      await tester.pumpAndSettle();
      expect(find.text("Fach2 · Test: 4"), findsOneWidget);
      expect(find.text("2. Januar"), findsOneWidget);
      await expectLater(
        find.byType(GradesChartContainer),
        matchesGoldenFile("chart_label2.png"),
      );
    },
  );
  testGoldens(
    'grades chart legend interactions',
    (tester) async {
      final widget = ReduxProvider(
        store: Store<AppState, AppStateBuilder, AppActions>(
          appReducerBuilder.build(),
          _gradesState,
          AppActions(),
        ),
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale("de"),
          ],
          home: const Material(
            child: GradesChartPage(),
          ),
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
        ),
      );

      await tester.pumpWidget(widget);
      expect(find.text("Legende"), findsOneWidget);
      await tester.tap(find.text("Legende"));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(GradesChartPage),
        matchesGoldenFile("page_legend_open.png"),
      );
      await tester.tapAt(const Offset(510, 515));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(GradesChartPage),
        matchesGoldenFile("page_legend_tapped.png"),
      );
    },
  );
  testWidgets(
    'changing the thickness of a subject clears the selection',
    (tester) async {
      final widget = ReduxProvider(
        store: Store<AppState, AppStateBuilder, AppActions>(
          appReducerBuilder.build(),
          _gradesState,
          AppActions(),
        ),
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale("de"),
          ],
          home: const Material(
            child: GradesChartPage(),
          ),
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
        ),
      );

      await tester.pumpWidget(widget);
      expect(find.text("Tippe auf das Diagramm, um Details zu sehen"),
          findsOneWidget);
      // select an item in the diagram
      await tester.tapAt(const Offset(750, 200));
      await tester.pumpAndSettle();
      expect(find.text("Tippe auf das Diagramm, um Details zu sehen"),
          findsNothing);
      expect(find.text("Fach1 · Schularbeit3: 7+"), findsOneWidget);

      expect(find.text("4. Januar"), findsOneWidget);
      expect(find.text("Legende"), findsOneWidget);
      // open the legend
      await tester.tap(find.text("Legende"));
      await tester.pumpAndSettle();
      // increase the thickness of a subject
      await tester.tapAt(const Offset(510, 515));
      await tester.pumpAndSettle();
      expect(find.text("Tippe auf das Diagramm, um Details zu sehen"),
          findsOneWidget);
      expect(find.text("Fach1 · Schularbeit3: 7+"), findsNothing);

      expect(find.text("4. Januar"), findsNothing);
    },
  );
}
