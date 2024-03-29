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

import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/actions/dashboard_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/data.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:dr/utc_date_time.dart';
import 'package:dr/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('new entries are marked', () {
    mockNow = UtcDateTime(2020, 1, 10);
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState(
        (b) => b
          ..dashboardState.allDays.add(
                Day(
                  (b) => b
                    ..date = UtcDateTime(2020, 1, 5)
                    ..lastRequested = UtcDateTime(2020)
                    ..homework.add(
                      Homework(
                        (b) => b
                          ..checkable = true
                          ..checked = false
                          ..deleteable = false
                          ..deleted = false
                          ..firstSeen = UtcDateTime(2020)
                          ..id = 1
                          ..isChanged = false
                          ..isNew = false
                          ..label = "Fach"
                          ..lastNotSeen = UtcDateTime(2019, 12, 24)
                          ..subtitle = "Untertitel"
                          ..title = "Titel"
                          ..type = HomeworkType.lessonHomework
                          ..warningServerSaid = false,
                      ),
                    ),
                ),
              ),
      ),
      AppActions(),
      middleware: middleware(includeErrorMiddleware: false),
    );
    store.actions.dashboardActions.loaded(
      DaysLoadedPayload(
        (b) => b
          ..future = false
          ..markNewOrChangedEntries = true
          ..deduplicateEntries = false
          ..data = [
            {
              "items": [
                {
                  "id": 1,
                  "type": "lessonHomework",
                  "title": "Neuer Titel",
                  "subtitle": "Neuer Untertitel",
                  "label": "Fach",
                  "warning": false,
                  "checkable": true,
                  "checked": false,
                  "deleteable": false
                },
              ],
              "date": "2020-01-05",
            }
          ],
      ),
    );
    expect(
      store.state.dashboardState.allDays!.single.homework.single,
      Homework(
        (b) => b
          ..checkable = true
          ..checked = false
          ..deleteable = false
          ..deleted = false
          ..firstSeen = now
          ..id = 1
          ..isChanged = true
          ..isNew = false
          ..label = "Fach"
          ..lastNotSeen = UtcDateTime(2020)
          ..subtitle = "Neuer Untertitel"
          ..title = "Neuer Titel"
          ..type = HomeworkType.lessonHomework
          ..warningServerSaid = false
          ..previousVersion = (HomeworkBuilder()
            ..checkable = true
            ..checked = false
            ..deleteable = false
            ..deleted = false
            ..firstSeen = UtcDateTime(2020)
            ..id = 1
            ..isChanged = false
            ..isNew = false
            ..label = "Fach"
            ..lastNotSeen = UtcDateTime(2019, 12, 24)
            ..subtitle = "Untertitel"
            ..title = "Titel"
            ..type = HomeworkType.lessonHomework
            ..warningServerSaid = false),
      ),
    );
  });
}
