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
  ActionDispatcher<LoadGradeCancelledDescriptionPayload>
      loadCancelledDescription;
  ActionDispatcher<SubjectsLoadedPayload> loaded;
  ActionDispatcher<SubjectDetailLoadedPayload> detailsLoaded;
  ActionDispatcher<GradeCancelledDescriptionLoadedPayload>
      cancelledDescriptionLoaded;
}

abstract class LoadSubjectDetailsPayload
    implements
        Built<LoadSubjectDetailsPayload, LoadSubjectDetailsPayloadBuilder> {
  LoadSubjectDetailsPayload._();
  factory LoadSubjectDetailsPayload(
          [void Function(LoadSubjectDetailsPayloadBuilder) updates]) =
      _$LoadSubjectDetailsPayload;

  Semester get semester;
  Subject get subject;
}

abstract class LoadGradeCancelledDescriptionPayload
    implements
        Built<LoadGradeCancelledDescriptionPayload,
            LoadGradeCancelledDescriptionPayloadBuilder> {
  LoadGradeCancelledDescriptionPayload._();
  factory LoadGradeCancelledDescriptionPayload(
      [void Function(LoadGradeCancelledDescriptionPayloadBuilder)
          updates]) = _$LoadGradeCancelledDescriptionPayload;

  Semester get semester;
  GradeDetail get grade;
}

abstract class SubjectsLoadedPayload
    implements Built<SubjectsLoadedPayload, SubjectsLoadedPayloadBuilder> {
  SubjectsLoadedPayload._();
  factory SubjectsLoadedPayload(
          [void Function(SubjectsLoadedPayloadBuilder) updates]) =
      _$SubjectsLoadedPayload;

  Semester get semester;
  Object get data;
}

abstract class SubjectDetailLoadedPayload
    implements
        Built<SubjectDetailLoadedPayload, SubjectDetailLoadedPayloadBuilder> {
  SubjectDetailLoadedPayload._();
  factory SubjectDetailLoadedPayload(
          [void Function(SubjectDetailLoadedPayloadBuilder) updates]) =
      _$SubjectDetailLoadedPayload;

  Semester get semester;
  Subject get subject;
  Object get data;
}

abstract class GradeCancelledDescriptionLoadedPayload
    implements
        Built<GradeCancelledDescriptionLoadedPayload,
            GradeCancelledDescriptionLoadedPayloadBuilder> {
  GradeCancelledDescriptionLoadedPayload._();
  factory GradeCancelledDescriptionLoadedPayload(
      [void Function(GradeCancelledDescriptionLoadedPayloadBuilder)
          updates]) = _$GradeCancelledDescriptionLoadedPayload;

  Semester get semester;
  GradeDetail get grade;
  Object get data;
}
