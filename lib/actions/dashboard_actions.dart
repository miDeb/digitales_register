import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_redux/built_redux.dart';

import '../data.dart';

part 'dashboard_actions.g.dart';

abstract class DashboardActions extends ReduxActions {
  factory DashboardActions() => _$DashboardActions();
  DashboardActions._();

  ActionDispatcher<DaysLoadedPayload> loaded;
  ActionDispatcher<void> notLoaded;
  ActionDispatcher<bool> load;
  ActionDispatcher<void> switchFuture;
  ActionDispatcher<HomeworkAddedPayload> homeworkAdded;
  ActionDispatcher<AddReminderPayload> addReminder;
  ActionDispatcher<Homework> deleteHomework;
  ActionDispatcher<ToggleDonePayload> toggleDone;
  ActionDispatcher<Homework> markAsSeen;
  ActionDispatcher<Day> markDeletedHomeworkAsSeen;
  ActionDispatcher<void> markAllAsSeen;
  ActionDispatcher<BuiltList<HomeworkType>> updateBlacklist;
  ActionDispatcher<void> refresh;
  ActionDispatcher<GradeGroupSubmission> downloadAttachment;
  ActionDispatcher<GradeGroupSubmission> attachmentReady;
  ActionDispatcher<GradeGroupSubmission> openAttachment;
}

abstract class DaysLoadedPayload
    implements Built<DaysLoadedPayload, DaysLoadedPayloadBuilder> {
  factory DaysLoadedPayload([void Function(DaysLoadedPayloadBuilder) updates]) =
      _$DaysLoadedPayload;
  DaysLoadedPayload._();

  Object get data;
  bool get future;
  bool get markNewOrChangedEntries;
  bool get deduplicateEntries;
}

abstract class HomeworkAddedPayload
    implements Built<HomeworkAddedPayload, HomeworkAddedPayloadBuilder> {
  factory HomeworkAddedPayload(
          [void Function(HomeworkAddedPayloadBuilder) updates]) =
      _$HomeworkAddedPayload;
  HomeworkAddedPayload._();

  Object get data;
  DateTime get date;
}

abstract class AddReminderPayload
    implements Built<AddReminderPayload, AddReminderPayloadBuilder> {
  factory AddReminderPayload(
          [void Function(AddReminderPayloadBuilder) updates]) =
      _$AddReminderPayload;
  AddReminderPayload._();

  String get msg;
  DateTime get date;
}

abstract class ToggleDonePayload
    implements Built<ToggleDonePayload, ToggleDonePayloadBuilder> {
  factory ToggleDonePayload([void Function(ToggleDonePayloadBuilder) updates]) =
      _$ToggleDonePayload;
  ToggleDonePayload._();

  Homework get hw;
  bool get done;
}
