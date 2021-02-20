import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:collection/collection.dart' show IterableExtension;

import '../actions/app_actions.dart';
import '../actions/grades_actions.dart';
import '../actions/login_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../util.dart';

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
  _updateSubjects(state.subjects, builder.subjects,
      getMap(action.payload.data)!, action.payload.semester);
  builder
    ..serverSemester.replace(action.payload.semester)
    ..loading = false;
}

void _updateSubjects(BuiltList<Subject> subjects,
    ListBuilder<Subject> subjectsBuilder, Map data, Semester semester) {
  for (final Map<String, dynamic> subject
      in List.from(getList(data["subjects"])!)) {
    final nestedSubject = getMap(subject["subject"])!;
    final newId = getInt(nestedSubject["id"]);
    final oldSubject = subjects.singleWhereOrNull((s) => s.id == newId);
    if (oldSubject != null) {
      // just update the grades
      subjectsBuilder[subjects.indexOf(oldSubject)] = oldSubject.rebuild(
        (b) => b
          ..gradesAll[semester] = BuiltList(
            getList(subject["grades"])!.map<GradeAll>(
              (dynamic g) => tryParse(getMap(g)!, _parseGradeAll),
            ),
          ),
      );
    } else {
      subjectsBuilder.add(
        Subject(
          (b) => b
            ..id = getInt(nestedSubject["id"])
            ..name = getString(nestedSubject["name"])
            ..gradesAll = MapBuilder(
              {
                semester: BuiltList<GradeAll>(
                  getList(subject["grades"])!.map<GradeAll>(
                    (dynamic g) => tryParse(getMap(g)!, _parseGradeAll),
                  ),
                ),
              },
            ),
        ),
      );
    }
    (data["subjects"] as List).remove(subject);
  }
  for (final subject in data["subjects"] as List) {
    subjectsBuilder.removeWhere((s) => s.id == subject["id"]);
  }
}

void _detailsLoaded(GradesState state,
    Action<SubjectDetailLoadedPayload> action, GradesStateBuilder builder) {
  final data = getMap(action.payload.data);
  builder.subjects.map(
    (s) => s.id == action.payload.subject.id
        ? s.rebuild(
            (b) => b
              ..grades[action.payload.semester] = BuiltList(
                getList(data!["grades"])!.map<GradeDetail>(
                  (dynamic g) => tryParse(getMap(g)!, _parseGrade).rebuild(
                    (d) => d
                      // we will also try to load the [cancelledDescription]
                      // again, but for now keep the old one
                      ..cancelledDescription = b.grades[action.payload.semester]
                          ?.firstWhereOrNull(
                            (gd) => gd.id == d.id,
                          )
                          ?.cancelledDescription,
                  ),
                ),
              )
              ..observations[action.payload.semester] = BuiltList(
                getList(data["observations"])!.map<Observation>(
                  (dynamic o) => tryParse(getMap(o)!, _parseObservation),
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
                  b.grades[action.payload.semester]!.rebuild(
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

Observation _parseObservation(Map data) {
  return Observation(
    (b) => b
      ..typeName = getString(data["typeName"])
      ..cancelled = data["cancelled"] != 0
      ..created = getString(data["created"])
      ..note = getString(data["note"])
      ..date = DateTime.parse(getString(data["date"])!),
  );
}

int? _parseGradeValue(String? grade) {
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

GradeAll _parseGradeAll(Map data) {
  return GradeAll(
    (b) => b
      ..grade = tryParse(getString(data["grade"]), _parseGradeValue)
      ..weightPercentage = getInt(data["weight"])
      ..date = DateTime.parse(getString(data["date"])!)
      ..cancelled = data["cancelled"] != 0
      ..type = getString(data["type"]),
  );
}

GradeDetail _parseGrade(Map data) {
  return GradeDetail(
    (b) => b
      ..grade = tryParse(getString(data["grade"]), _parseGradeValue)
      ..date = DateTime.parse(getString(data["date"])!)
      ..weightPercentage = getInt(data["weight"])
      ..cancelled = getBool(data["cancelled"])
      ..type = getString(data["typeName"])
      ..created = getString(data["created"])
      ..name = getString(data["name"])
      ..description = getString(data["description"])
      ..id = getInt(data["id"])
      ..competences = ListBuilder(
        getList(data["competences"])!.map<Competence>(
          (dynamic c) => tryParse(getMap(c)!, _parseCompetence),
        ),
      ),
  );
}

GradeDetail _addCancelledDescription(GradeDetail grade, dynamic data) {
  return grade.rebuild(
    (b) => b..cancelledDescription = getString(data["cancelledDescription"]),
  );
}

Competence _parseCompetence(Map data) {
  return Competence((b) => b
    ..typeName = getString(data["typeName"])
    ..grade = double.parse(getString(data["grade"])!).toInt());
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
