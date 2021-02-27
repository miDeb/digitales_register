import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/container/absences_page_container.dart';
import 'package:dr/data.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:built_collection/built_collection.dart';

import '../../parse_test.dart';

void main() {
  testGoldens('simple absences', (WidgetTester tester) async {
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState(),
      AppActions(),
    );
    final widget = ReduxProvider(
      store: store,
      child: MaterialApp(
        home: AbsencesPageContainer(),
      ),
    );
    await tester.pumpWidget(widget);
    await store.actions.absencesActions.loaded(absencesJson);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(AbsencesPageContainer),
      matchesGoldenFile(
        "absences.png",
      ),
    );
  });

  testGoldens('no absences', (WidgetTester tester) async {
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState(
        (b) => b.absencesState
          ..absences = ListBuilder()
          ..statistic = AbsenceStatisticBuilder(),
      ),
      AppActions(),
    );
    final widget = ReduxProvider(
      store: store,
      child: MaterialApp(
        home: AbsencesPageContainer(),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.text("Noch keine Absenzen"), findsOneWidget);
    await expectLater(
      find.byType(AbsencesPageContainer),
      matchesGoldenFile(
        "no_absences.png",
      ),
    );
  });
}
