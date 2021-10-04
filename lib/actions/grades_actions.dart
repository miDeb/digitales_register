// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

import '../app_state.dart';
import '../data.dart';

part 'grades_actions.g.dart';

abstract class GradesActions extends ReduxActions {
  factory GradesActions() => _$GradesActions();
  GradesActions._();

  abstract final ActionDispatcher<Semester> setSemester;
  abstract final ActionDispatcher<Semester> load;
  abstract final ActionDispatcher<LoadSubjectDetailsPayload> loadDetails;
  abstract final ActionDispatcher<LoadGradeCancelledDescriptionPayload>
      loadCancelledDescription;
  abstract final ActionDispatcher<SubjectsLoadedPayload> loaded;
  abstract final ActionDispatcher<SubjectDetailLoadedPayload> detailsLoaded;
  abstract final ActionDispatcher<GradeCancelledDescriptionLoadedPayload>
      cancelledDescriptionLoaded;
}

abstract class LoadSubjectDetailsPayload
    implements
        Built<LoadSubjectDetailsPayload, LoadSubjectDetailsPayloadBuilder> {
  factory LoadSubjectDetailsPayload(
          [void Function(LoadSubjectDetailsPayloadBuilder)? updates]) =
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
      [void Function(LoadGradeCancelledDescriptionPayloadBuilder)?
          updates]) = _$LoadGradeCancelledDescriptionPayload;
  LoadGradeCancelledDescriptionPayload._();

  Semester get semester;
  GradeDetail get grade;
}

abstract class SubjectsLoadedPayload
    implements Built<SubjectsLoadedPayload, SubjectsLoadedPayloadBuilder> {
  factory SubjectsLoadedPayload(
          [void Function(SubjectsLoadedPayloadBuilder)? updates]) =
      _$SubjectsLoadedPayload;
  SubjectsLoadedPayload._();

  Semester get semester;
  Object get data;
}

abstract class SubjectDetailLoadedPayload
    implements
        Built<SubjectDetailLoadedPayload, SubjectDetailLoadedPayloadBuilder> {
  factory SubjectDetailLoadedPayload(
          [void Function(SubjectDetailLoadedPayloadBuilder)? updates]) =
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
      [void Function(GradeCancelledDescriptionLoadedPayloadBuilder)?
          updates]) = _$GradeCancelledDescriptionLoadedPayload;
  GradeCancelledDescriptionLoadedPayload._();

  Semester get semester;
  GradeDetail get grade;
  Object get data;
}
