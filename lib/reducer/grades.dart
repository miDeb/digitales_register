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
  ..add(GradesActionsNames.cancelledDescriptionLoaded,
      _cancelledDescriptionLoaded)
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

void _updateSubjects(BuiltList<Subject> subjects,
    ListBuilder<Subject> subjectsBuilder, dynamic data, Semester semester) {
  for (final Map<String, dynamic> subject
      in List.from(data["subjects"] as List)) {
    final newId = subject["subject"]["id"];
    final oldSubject =
        subjects.singleWhere((s) => s.id == newId, orElse: () => null);
    if (oldSubject != null) {
      // just update the grades
      subjectsBuilder[subjects.indexOf(oldSubject)] = oldSubject.rebuild(
        (b) => b
          ..gradesAll[semester] = BuiltList(
            (subject["grades"] as List).map(
              (g) => _parseGradeAll(g),
            ),
          ),
      );
    } else {
      subjectsBuilder.add(
        Subject(
          (b) => b
            ..id = subject["subject"]["id"] as int
            ..name = subject["subject"]["name"] as String
            ..gradesAll = MapBuilder(
              {
                semester: BuiltList<GradeAll>(
                  (subject["grades"] as List).map(
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
                (data["grades"] as List).map(
                  (g) => _parseGrade(g).rebuild(
                    (d) => d
                      // we will also try to load the [cancelledDescription]
                      // again, but for now keep the old one
                      ..cancelledDescription = b.grades[action.payload.semester]
                          ?.firstWhere(
                            (gd) => gd.id == d.id,
                            orElse: () => null,
                          )
                          ?.cancelledDescription,
                  ),
                ),
              )
              ..observations[action.payload.semester] = BuiltList(
                (data["observations"] as List).map(
                  (o) => _parseObservation(o),
                ),
              ),
          )
        : s,
  );
}

void _cancelledDescriptionLoaded(
    GradesState state,
    Action<GradeCancelledDescriptionLoadedPayload> action,
    GradesStateBuilder builder) {
  builder.subjects.map(
    (s) => s.grades[action.payload.semester]?.contains(action.payload.grade) ==
            true
        ? s.rebuild(
            (b) => b
              ..grades[action.payload.semester] =
                  b.grades[action.payload.semester].rebuild(
                (b) => b
                  ..map(
                    (g) => g == action.payload.grade
                        ? _addCancelledDescription(g, action.payload.data)
                        : g,
                  ),
              ),
          )
        : s,
  );
}

Observation _parseObservation(dynamic data) {
  return Observation(
    (b) => b
      ..typeName = data["typeName"] as String
      ..cancelled = data["cancelled"] != 0
      ..created = data["created"] as String
      ..note = data["note"] as String
      ..date = DateTime.parse(data["date"] as String),
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
      ..grade = _parseGradeValue(data["grade"] as String)
      ..weightPercentage = data["weight"] as int
      ..date = DateTime.parse(data["date"] as String)
      ..cancelled = data["cancelled"] != 0
      ..type = data["type"] as String,
  );
}

GradeDetail _parseGrade(dynamic data) {
  return GradeDetail(
    (b) => b
      ..grade = _parseGradeValue(data["grade"] as String)
      ..date = DateTime.parse(data["date"] as String)
      ..weightPercentage = data["weight"] as int
      ..cancelled = data["cancelled"] != 0
      ..type = data["typeName"] as String
      ..created = data["created"] as String
      ..name = data["name"] as String
      ..description = data["description"] as String
      ..id = data["id"] as int
      ..competences = ListBuilder(
        (data["competences"] as List)?.map(
          (c) => _parseCompetence(c),
        ),
      ),
  );
}

GradeDetail _addCancelledDescription(GradeDetail grade, dynamic data) {
  return grade.rebuild(
    (b) => b..cancelledDescription = data["cancelledDescription"] as String,
  );
}

Competence _parseCompetence(dynamic data) {
  return Competence((b) => b
    ..typeName = data["typeName"] as String
    ..grade = double.parse(data["grade"] as String).toInt());
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
