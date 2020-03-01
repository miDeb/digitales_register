import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/actions/dashboard_actions.dart';
import 'package:dr/actions/grades_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:dr/requests/absences.dart';
import 'package:dr/requests/calendar.dart';
import 'package:dr/requests/dashboard.dart';
import 'package:dr/requests/grades_first.dart' as first;
import 'package:dr/requests/grades_second.dart' as second;
import 'package:dr/requests/profil.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('parse test', () {
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState(),
      AppActions(),
      middleware: middleware,
    );
    test('parse absences', () {
      expect(store.state.absencesState == null, true);
      store.actions.absencesActions.loaded(absences);
      expect(store.state.absencesState != null, true);
      expect(store.state.absencesState.absences.length, 6);
    });
    test('parse dashboard', () {
      expect(store.state.dashboardState.allDays, null);
      store.actions.dashboardActions.loaded(DaysLoadedPayload(
        (b) => b
          ..data = fullSchoolYear
          ..future = false
          ..markNewOrChangedEntries = true,
      ));
      expect(store.state.dashboardState.allDays.length, 177);
    });
    test('parse calendar', () {
      expect(store.state.calendarState.days.isEmpty, true);
      store.actions.calendarActions.loaded(calendar1);
      expect(store.state.calendarState.days.length, 5);
      store.actions.calendarActions.loaded(calendar2);
      expect(store.state.calendarState.days.length, 10);
      store.actions.calendarActions.loaded(calendar2);
      expect(store.state.calendarState.days.length, 10);
    });
    test('parse grades', () {
      expect(store.state.gradesState.hasGrades, false);
      expect(store.state.gradesState.subjects.isEmpty, true);
      store.actions.gradesActions.loaded(
        SubjectsLoadedPayload(
          (b) => b
            ..data = first.all
            ..semester = Semester.first.toBuilder(),
        ),
      );
      expect(store.state.gradesState.subjects.length, 13);
      expect(store.state.gradesState.hasGrades, true);
      expect(
        store.state.gradesState.subjects[0].detailEntries(Semester.first),
        null,
      );
      for (var i = 0; i < store.state.gradesState.subjects.length; i++) {
        store.actions.gradesActions.detailsLoaded(
          SubjectDetailLoadedPayload(
            (b) => b
              ..data = first.detail[i]
              ..subject = store.state.gradesState.subjects[i].toBuilder()
              ..semester = Semester.first.toBuilder(),
          ),
        );
      }
      for (var i = 0; i < store.state.gradesState.subjects.length; i++) {
        store.actions.gradesActions.detailsLoaded(
          SubjectDetailLoadedPayload(
            (b) => b
              ..data = second.detail[i]
              ..subject = store.state.gradesState.subjects[i].toBuilder()
              ..semester = Semester.second.toBuilder(),
          ),
        );
      }
      expect(
        store.state.gradesState.subjects[0]
            .detailEntries(Semester.first)
            .length,
        6,
      );
    });
    test('parse profile', () {
      store.actions.profileActions.loaded(profile);
      expect(
        store.state.profileState,
        ProfileState(
          (b) => b
            ..name = "Debertol Michael"
            ..email = "st-debmic-03@vinzentinum.it"
            ..username = "st-debmic-03"
            ..roleName = "Schüler/in"
            ..sendNotificationEmails = false,
        ),
      );
    });
  });
}
