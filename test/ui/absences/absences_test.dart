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

import 'package:built_collection/built_collection.dart';
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
