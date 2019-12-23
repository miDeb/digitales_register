import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_redux/built_redux.dart';

import '../data.dart';

part 'dashboard_actions.g.dart';

abstract class DashboardActions extends ReduxActions {
  DashboardActions._();
  factory DashboardActions() => new _$DashboardActions();

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
}

abstract class DaysLoadedPayload
    implements Built<DaysLoadedPayload, DaysLoadedPayloadBuilder> {
  DaysLoadedPayload._();
  factory DaysLoadedPayload([void Function(DaysLoadedPayloadBuilder) updates]) =
      _$DaysLoadedPayload;

  Object get data;
  bool get future;
  bool get markNewOrChangedEntries;
}

abstract class HomeworkAddedPayload
    implements Built<HomeworkAddedPayload, HomeworkAddedPayloadBuilder> {
  HomeworkAddedPayload._();
  factory HomeworkAddedPayload(
          [void Function(HomeworkAddedPayloadBuilder) updates]) =
      _$HomeworkAddedPayload;

  Object get data;
  DateTime get date;
}

abstract class AddReminderPayload
    implements Built<AddReminderPayload, AddReminderPayloadBuilder> {
  AddReminderPayload._();
  factory AddReminderPayload(
          [void Function(AddReminderPayloadBuilder) updates]) =
      _$AddReminderPayload;

  String get msg;
  DateTime get date;
}

abstract class ToggleDonePayload
    implements Built<ToggleDonePayload, ToggleDonePayloadBuilder> {
  ToggleDonePayload._();
  factory ToggleDonePayload([void Function(ToggleDonePayloadBuilder) updates]) =
      _$ToggleDonePayload;

  Homework get hw;
  bool get done;
}
