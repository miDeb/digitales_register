import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

import '../data.dart';

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
  DateTime get date;
}

abstract class AddReminderPayload
    implements Built<AddReminderPayload, AddReminderPayloadBuilder> {
  factory AddReminderPayload(
          [void Function(AddReminderPayloadBuilder)? updates]) =
      _$AddReminderPayload;
  AddReminderPayload._();

  String get msg;
  DateTime get date;
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
