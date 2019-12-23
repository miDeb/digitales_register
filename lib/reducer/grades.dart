import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../actions/app_actions.dart';
import '../actions/grades_actions.dart';
import '../actions/login_actions.dart';
import '../app_state.dart';
import '../data.dart';

final gradesReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    GradesState, GradesStateBuilder>(
  (s) => s.gradesState,
  (b) => b.gradesState,
)
  ..add(GradesActionsNames.load, _loading)
  ..add(GradesActionsNames.loaded, _loaded)
  ..add(GradesActionsNames.setSemester, _setSemester)
  ..add(LoginActionsNames.automaticallyReloggedIn, _afterAutoRelogin)
  ..add(GradesActionsNames.detailsLoaded, _detailsLoaded)
  ..add(AppActionsNames.setConfig, _setConfig);

void _loading(
    GradesState state, Action<Semester> action, GradesStateBuilder builder) {
  builder.loading = true;
}

void _loaded(GradesState state, Action<SubjectsLoadedPayload> action,
    GradesStateBuilder builder) {
  _updateSubjects(state.subjects, builder.subjects, action.payload.data,
      action.payload.semester);
  builder
    ..serverSemester.replace(action.payload.semester)
    ..loading = false;
}

_updateSubjects(BuiltList<Subject> subjects,
    ListBuilder<Subject> subjectsBuilder, dynamic data, Semester semester) {
  for (final subject in List.of(data["subjects"])) {
    final newId = subject["subject"]["id"];
    final oldSubject =
        subjects.singleWhere((s) => s.id == newId, orElse: () => null);
    if (oldSubject != null) {
      // just update the grades
      subjectsBuilder[subjects.indexOf(oldSubject)] = oldSubject.rebuild(
        (b) => b
          ..gradesAll[semester] = BuiltList(
            subject["grades"].map(
              (g) => _parseGradeAll(g),
            ),
          ),
      );
    } else {
      subjectsBuilder.add(
        Subject(
          (b) => b
            ..id = subject["subject"]["id"]
            ..name = subject["subject"]["name"]
            ..gradesAll = MapBuilder(
              {
                semester: BuiltList<GradeAll>(
                  subject["grades"].map(
                    (g) => _parseGradeAll(g),
                  ),
                ),
              },
            ),
        ),
      );
    }
    data["subjects"].remove(subject);
  }
  for (final subject in data["subjects"]) {
    subjectsBuilder.removeWhere((s) => s.id == subject["id"]);
  }
}

void _detailsLoaded(GradesState state,
    Action<SubjectDetailLoadedPayload> action, GradesStateBuilder builder) {
  final data = action.payload.data as Map;
  builder.subjects.map(
    (s) => s.id == action.payload.subject.id
        ? s.rebuild(
            (b) => b
              ..grades[action.payload.semester] = BuiltList(
                data["grades"].map(
                  (g) => _parseGrade(g),
                ),
              )
              ..observations[action.payload.semester] = BuiltList(
                data["observations"].map(
                  (o) => _parseObservation(o),
                ),
              ),
          )
        : s,
  );
}

Observation _parseObservation(dynamic data) {
  return Observation(
    (b) => b
      ..typeName = data["typeName"]
      ..cancelled = data["cancelled"] != 0
      ..created = data["created"]
      ..note = data["note"]
      ..date = DateTime.parse(data["date"]),
  );
}

int _parseGradeValue(String grade) {
  if (grade == null || grade == "") return null;
  final gradeSplitted = grade
      .split(".")
      .map(
        (s) => int.parse(s),
      )
      .toList();
  final gradeValue = gradeSplitted[0] * 100 + gradeSplitted[1];
  return gradeValue;
}

GradeAll _parseGradeAll(dynamic data) {
  return GradeAll(
    (b) => b
      ..grade = _parseGradeValue(
        data["grade"],
      )
      ..weightPercentage = data["weight"]
      ..date = DateTime.parse(data["date"])
      ..cancelled = data["cancelled"] != 0
      ..type = data["type"],
  );
}

GradeDetail _parseGrade(dynamic data) {
  return GradeDetail(
    (b) => b
      ..grade = _parseGradeValue(data["grade"])
      ..date = DateTime.parse(data["date"])
      ..weightPercentage = data["weight"]
      ..cancelled = data["cancelled"] != 0
      ..type = data["typeName"] ?? data["type"]
      ..created = data["created"]
      ..name = data["name"]
      ..id = data["id"]
      ..competences = ListBuilder(
        data["competences"]?.map(
          (c) => _parseCompetence(c),
        ),
      ),
  );
}

Competence _parseCompetence(dynamic data) {
  return Competence((b) => b
    ..typeName = data["typeName"]
    ..grade = data["grade"]);
}

void _setSemester(
    GradesState state, Action<Semester> action, GradesStateBuilder builder) {
  builder.semester.replace(action.payload);
}

void _afterAutoRelogin(
    GradesState state, Action<void> action, GradesStateBuilder builder) {
  builder.serverSemester = null;
}

void _setConfig(
    GradesState state, Action<Config> action, GradesStateBuilder builder) {
  if (action.payload.currentSemesterMaybe == 1) {
    builder.semester.replace(Semester.first);
  }
  if (action.payload.currentSemesterMaybe == 2) {
    builder.semester.replace(Semester.second);
  }
}
