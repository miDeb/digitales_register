import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/actions/dashboard_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/data.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:dr/util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  test('new entries are marked', () {
    mockNow = DateTime(2020, 1, 10);
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState(
        (b) => b
          ..dashboardState.allDays.add(
                Day(
                  (b) => b
                    ..date = DateTime(2020, 1, 5)
                    ..lastRequested = DateTime(2020)
                    ..homework.add(
                      Homework(
                        (b) => b
                          ..checkable = true
                          ..checked = false
                          ..deleteable = false
                          ..deleted = false
                          ..firstSeen = DateTime(2020)
                          ..id = 1
                          ..isChanged = false
                          ..isNew = false
                          ..label = "Fach"
                          ..lastNotSeen = DateTime(2019, 12, 24)
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
      middleware: middleware,
    );
    store.actions.dashboardActions.loaded(
      DaysLoadedPayload(
        (b) => b
          ..future = false
          ..markNewOrChangedEntries = true
          ..deduplicateEntries = false
          ..data = BuiltList([
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
          ]),
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
          ..lastNotSeen = DateTime(2020)
          ..subtitle = "Neuer Untertitel"
          ..title = "Neuer Titel"
          ..type = HomeworkType.lessonHomework
          ..warningServerSaid = false
          ..previousVersion = (HomeworkBuilder()
            ..checkable = true
            ..checked = false
            ..deleteable = false
            ..deleted = false
            ..firstSeen = DateTime(2020)
            ..id = 1
            ..isChanged = false
            ..isNew = false
            ..label = "Fach"
            ..lastNotSeen = DateTime(2019, 12, 24)
            ..subtitle = "Untertitel"
            ..title = "Titel"
            ..type = HomeworkType.lessonHomework
            ..warningServerSaid = false),
      ),
    );
  });
}
