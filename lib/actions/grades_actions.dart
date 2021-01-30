import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

import '../app_state.dart';
import '../data.dart';

part 'grades_actions.g.dart';

abstract class GradesActions extends ReduxActions {
  factory GradesActions() => _$GradesActions();
  GradesActions._();

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
  factory LoadSubjectDetailsPayload(
          [void Function(LoadSubjectDetailsPayloadBuilder) updates]) =
      _$LoadSubjectDetailsPayload;
  LoadSubjectDetailsPayload._();

  Semester get semester;
  Subject get subject;
}

abstract class LoadGradeCancelledDescriptionPayload
    implements
        Built<LoadGradeCancelledDescriptionPayload,
            LoadGradeCancelledDescriptionPayloadBuilder> {
  factory LoadGradeCancelledDescriptionPayload(
      [void Function(LoadGradeCancelledDescriptionPayloadBuilder)
          updates]) = _$LoadGradeCancelledDescriptionPayload;
  LoadGradeCancelledDescriptionPayload._();

  Semester get semester;
  GradeDetail get grade;
}

abstract class SubjectsLoadedPayload
    implements Built<SubjectsLoadedPayload, SubjectsLoadedPayloadBuilder> {
  factory SubjectsLoadedPayload(
          [void Function(SubjectsLoadedPayloadBuilder) updates]) =
      _$SubjectsLoadedPayload;
  SubjectsLoadedPayload._();

  Semester get semester;
  Object get data;
}

abstract class SubjectDetailLoadedPayload
    implements
        Built<SubjectDetailLoadedPayload, SubjectDetailLoadedPayloadBuilder> {
  factory SubjectDetailLoadedPayload(
          [void Function(SubjectDetailLoadedPayloadBuilder) updates]) =
      _$SubjectDetailLoadedPayload;
  SubjectDetailLoadedPayload._();

  Semester get semester;
  Subject get subject;
  Object get data;
}

abstract class GradeCancelledDescriptionLoadedPayload
    implements
        Built<GradeCancelledDescriptionLoadedPayload,
            GradeCancelledDescriptionLoadedPayloadBuilder> {
  factory GradeCancelledDescriptionLoadedPayload(
      [void Function(GradeCancelledDescriptionLoadedPayloadBuilder)
          updates]) = _$GradeCancelledDescriptionLoadedPayload;
  GradeCancelledDescriptionLoadedPayload._();

  Semester get semester;
  GradeDetail get grade;
  Object get data;
}
