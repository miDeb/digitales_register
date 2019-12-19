import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

import '../app_state.dart';
import '../data.dart';

part 'grades_actions.g.dart';

abstract class SetSemesterAction
    implements Built<SetSemesterAction, SetSemesterActionBuilder> {
  SetSemesterAction._();
  factory SetSemesterAction([void Function(SetSemesterActionBuilder) updates]) =
      _$SetSemesterAction;

  Semester get semester;
}

abstract class LoadSubjectsAction
    implements Built<LoadSubjectsAction, LoadSubjectsActionBuilder> {
  LoadSubjectsAction._();
  factory LoadSubjectsAction(
          [void Function(LoadSubjectsActionBuilder) updates]) =
      _$LoadSubjectsAction;

  Semester get semester;
}

abstract class LoadSubjectDetailsAction
    implements
        Built<LoadSubjectDetailsAction, LoadSubjectDetailsActionBuilder> {
  LoadSubjectDetailsAction._();
  factory LoadSubjectDetailsAction(
          [void Function(LoadSubjectDetailsActionBuilder) updates]) =
      _$LoadSubjectDetailsAction;

  Semester get semester;
  Subject get subject;
}

abstract class SubjectsLoadedAction
    implements Built<SubjectsLoadedAction, SubjectsLoadedActionBuilder> {
  SubjectsLoadedAction._();
  factory SubjectsLoadedAction(
          [void Function(SubjectsLoadedActionBuilder) updates]) =
      _$SubjectsLoadedAction;

  Semester get semester;
  Object get data;
}

abstract class SubjectDetailLoadedAction
    implements
        Built<SubjectDetailLoadedAction, SubjectDetailLoadedActionBuilder> {
  SubjectDetailLoadedAction._();
  factory SubjectDetailLoadedAction(
          [void Function(SubjectDetailLoadedActionBuilder) updates]) =
      _$SubjectDetailLoadedAction;

  Semester get semester;
  Subject get subject;
  Object get data;
}

abstract class UpdateGraphConfigsAction
    implements
        Built<UpdateGraphConfigsAction, UpdateGraphConfigsActionBuilder> {
  UpdateGraphConfigsAction._();
  factory UpdateGraphConfigsAction(
          [void Function(UpdateGraphConfigsActionBuilder) updates]) =
      _$UpdateGraphConfigsAction;

  BuiltList<Subject> get subjects;
}
