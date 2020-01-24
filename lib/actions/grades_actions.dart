import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

import '../app_state.dart';
import '../data.dart';

part 'grades_actions.g.dart';

abstract class GradesActions extends ReduxActions {
  GradesActions._();
  factory GradesActions() => _$GradesActions();

  ActionDispatcher<Semester> setSemester;
  ActionDispatcher<Semester> load;
  ActionDispatcher<LoadSubjectDetailsPayload> loadDetails;
  ActionDispatcher<SubjectsLoadedPayload> loaded;
  ActionDispatcher<SubjectDetailLoadedPayload> detailsLoaded;
}

abstract class LoadSubjectDetailsPayload
    implements Built<LoadSubjectDetailsPayload, LoadSubjectDetailsPayloadBuilder> {
  LoadSubjectDetailsPayload._();
  factory LoadSubjectDetailsPayload([void Function(LoadSubjectDetailsPayloadBuilder) updates]) =
      _$LoadSubjectDetailsPayload;

  Semester get semester;
  Subject get subject;
}

abstract class SubjectsLoadedPayload
    implements Built<SubjectsLoadedPayload, SubjectsLoadedPayloadBuilder> {
  SubjectsLoadedPayload._();
  factory SubjectsLoadedPayload([void Function(SubjectsLoadedPayloadBuilder) updates]) =
      _$SubjectsLoadedPayload;

  Semester get semester;
  Object get data;
}

abstract class SubjectDetailLoadedPayload
    implements Built<SubjectDetailLoadedPayload, SubjectDetailLoadedPayloadBuilder> {
  SubjectDetailLoadedPayload._();
  factory SubjectDetailLoadedPayload([void Function(SubjectDetailLoadedPayloadBuilder) updates]) =
      _$SubjectDetailLoadedPayload;

  Semester get semester;
  Subject get subject;
  Object get data;
}
