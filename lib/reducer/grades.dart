import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';

import '../actions.dart';
import '../app_state.dart';
import '../data.dart';

final gradesReducer = combineReducers<GradesStateBuilder>([
  _loadSubjectsReducer,
  TypedReducer<GradesStateBuilder, SubjectsLoadedAction>(
    _subjectsLoadedReducer,
  ),
  TypedReducer<GradesStateBuilder, SubjectLoadedAction>(
    _subjectLoadedReducer,
  ),
  TypedReducer<GradesStateBuilder, SetGradesSemesterAction>(
    _setGradesSemesterReducer,
  ),
  TypedReducer<GradesStateBuilder, LoggedInAgainAutomatically>(
    _afterAutoRelogin,
  ),
  TypedReducer<GradesStateBuilder, SetConfigAction>(
    _setCurrentSemester,
  ),
]);

GradesStateBuilder _loadSubjectsReducer(GradesStateBuilder state, action) {
  if (action is LoadSubjectsAction) {
    print("HERE");
    return state..loading = true;
  } else if (action is NoInternetAction) {
    return state..loading = false;
  } else
    return state;
}

GradesStateBuilder _subjectsLoadedReducer(
    GradesStateBuilder state, SubjectsLoadedAction action) {
  _updateSubjects(
      state.subjects.build(), state.subjects, action.data, action.semester);
  return state
    ..serverSemester = action.semester.toBuilder()
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

GradesStateBuilder _subjectLoadedReducer(
    GradesStateBuilder state, SubjectLoadedAction action) {
  return state
    ..subjects.map(
      (s) => s.id == action.subject.id
          ? s.rebuild(
              (b) => b
                ..grades[action.semester] = BuiltList(
                  action.data["grades"].map(
                    (g) => _parseGrade(g),
                  ),
                )
                ..observations[action.semester] = BuiltList(
                  action.data["observations"].map(
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

GradesStateBuilder _setGradesSemesterReducer(
    GradesStateBuilder state, SetGradesSemesterAction action) {
  print(" setsemester: ${state.loading}");
  return state..semester.replace(action.newSemester);
}

GradesStateBuilder _afterAutoRelogin(
    GradesStateBuilder state, LoggedInAgainAutomatically action) {
  return state..serverSemester = null;
}

GradesStateBuilder _setCurrentSemester(
    GradesStateBuilder state, SetConfigAction action) {
  if (action.config.currentSemesterMaybe == 1) {
    state..semester = Semester.first.toBuilder();
  }
  if (action.config.currentSemesterMaybe == 2) {
    state..semester = Semester.second.toBuilder();
  }
  return state;
}
