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

import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

import 'package:dr/data.dart';
import 'package:dr/utc_date_time.dart';

part 'dashboard_actions.g.dart';

abstract class DashboardActions extends ReduxActions {
  factory DashboardActions() => _$DashboardActions();
  DashboardActions._();

  abstract final ActionDispatcher<DaysLoadedPayload> loaded;
  abstract final VoidActionDispatcher notLoaded;
  abstract final ActionDispatcher<bool> load;
  abstract final VoidActionDispatcher switchFuture;
  abstract final ActionDispatcher<HomeworkAddedPayload> homeworkAdded;
  abstract final ActionDispatcher<AddReminderPayload> addReminder;
  abstract final ActionDispatcher<Homework> deleteHomework;
  abstract final ActionDispatcher<ToggleDonePayload> toggleDone;
  abstract final ActionDispatcher<Homework> markAsSeen;
  abstract final ActionDispatcher<Day> markDeletedHomeworkAsSeen;
  abstract final VoidActionDispatcher markAllAsSeen;
  abstract final ActionDispatcher<BuiltList<HomeworkType>> updateBlacklist;
  abstract final VoidActionDispatcher refresh;
  abstract final ActionDispatcher<GradeGroupSubmission> downloadAttachment;
  abstract final ActionDispatcher<GradeGroupSubmission> attachmentReady;
  abstract final ActionDispatcher<GradeGroupSubmission> openAttachment;
}

abstract class DaysLoadedPayload
    implements Built<DaysLoadedPayload, DaysLoadedPayloadBuilder> {
  factory DaysLoadedPayload(
      [void Function(DaysLoadedPayloadBuilder)? updates]) = _$DaysLoadedPayload;
  DaysLoadedPayload._();

  Object get data;
  bool get future;
  bool get markNewOrChangedEntries;
  bool get deduplicateEntries;
}

abstract class HomeworkAddedPayload
    implements Built<HomeworkAddedPayload, HomeworkAddedPayloadBuilder> {
  factory HomeworkAddedPayload(
          [void Function(HomeworkAddedPayloadBuilder)? updates]) =
      _$HomeworkAddedPayload;
  HomeworkAddedPayload._();

  Object get data;
  UtcDateTime get date;
}

abstract class AddReminderPayload
    implements Built<AddReminderPayload, AddReminderPayloadBuilder> {
  factory AddReminderPayload(
          [void Function(AddReminderPayloadBuilder)? updates]) =
      _$AddReminderPayload;
  AddReminderPayload._();

  String get msg;
  UtcDateTime get date;
}

abstract class ToggleDonePayload
    implements Built<ToggleDonePayload, ToggleDonePayloadBuilder> {
  factory ToggleDonePayload(
      [void Function(ToggleDonePayloadBuilder)? updates]) = _$ToggleDonePayload;
  ToggleDonePayload._();

  int get homeworkId;
  String get type;
  bool get done;
}
