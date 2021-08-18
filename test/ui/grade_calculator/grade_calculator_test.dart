import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/ui/dialog.dart';
import 'package:dr/ui/grade_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens("welcome screen", (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState((b) => b.gradesState.loading = true),
        AppActions(),
      ),
      child: MaterialApp(
        home: const GradeCalculator(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
    await tester.pumpWidget(widget);
    await expectLater(
      find.byType(GradeCalculator),
      matchesGoldenFile("welcome.png"),
    );
  });
  testGoldens("add a grade", (WidgetTester tester) async {
    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState((b) => b.gradesState.loading = true),
        AppActions(),
      ),
      child: MaterialApp(
        home: const GradeCalculator(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
    await tester.pumpWidget(widget);
    await tester.tap(
      find.descendant(
        of: find.byType(Greeting),
        matching: find.text("Note hinzufügen"),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(InfoDialog), findsOneWidget);
    await expectLater(
      find.byType(InfoDialog),
      matchesGoldenFile("add_grade_dialog.png"),
    );

    await tester.enterText(
      find.ancestor(
        of: find.text("Note"),
        matching: find.byType(TextField),
      ),
      "9/10",
    );
    await tester.enterText(
      find.ancestor(
        of: find.text("Gewichtung"),
        matching: find.byType(TextField),
      ),
      "32",
    );
    await tester.pump();
    await tester.tap(find.text("Hinzufügen"));
    await tester.pumpAndSettle();
    expect(find.text("9,5"), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile("one_grade.png"),
    );
  });

  testWidgets("can scroll to grade", (WidgetTester tester) async {
    Future<void> addGrade(String grade, {required bool isFirst}) async {
      if (!isFirst) {
        await tester.scrollUntilVisible(
          find.byType(GradeTile).last,
          50,
          scrollable: find
              .descendant(
                of: find.byType(GradesList),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        await tester.pumpAndSettle();
      }

      await tester.tap(
        find.descendant(
          of: find.byType(isFirst ? Greeting : FloatingActionButton),
          matching: find.text("Note hinzufügen"),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find
            .ancestor(
              of: find.text("Note"),
              matching: find.byType(TextField),
            )
            .last,
        grade,
      );
      await tester.enterText(
        find
            .ancestor(
              of: find.text("Gewichtung"),
              matching: find.byType(TextField),
            )
            .last,
        "32",
      );
      await tester.pump();
      await tester.tap(find.text("Hinzufügen"));
      await tester.pumpAndSettle();
    }

    final widget = ReduxProvider(
      store: Store<AppState, AppStateBuilder, AppActions>(
        ReducerBuilder<AppState, AppStateBuilder>().build(),
        AppState((b) => b.gradesState.loading = true),
        AppActions(),
      ),
      child: MaterialApp(
        home: const GradeCalculator(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
    await tester.pumpWidget(widget);
    for (var i = 0; i < 11; i++) {
      await addGrade(i.toString(), isFirst: i == 0);
    }
    // The first grade does not show because it's out of frame.
    expect(find.text("0"), findsNothing);
    expect(find.text("10"), findsOneWidget);
    // We are able to scroll to the first grade
    await tester.scrollUntilVisible(find.text("0"), -50,
        scrollable: find
            .descendant(
              of: find.byType(GradesList),
              matching: find.byType(Scrollable),
            )
            .first);
  });
}
