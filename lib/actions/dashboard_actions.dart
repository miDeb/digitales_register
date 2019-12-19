import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import '../data.dart';

part 'dashboard_actions.g.dart';

abstract class DaysLoadedAction
    implements Built<DaysLoadedAction, DaysLoadedActionBuilder> {
  DaysLoadedAction._();
  factory DaysLoadedAction([void Function(DaysLoadedActionBuilder) updates]) =
      _$DaysLoadedAction;

  Object get data;
  bool get future;
  bool get markNewOrChangedEntries;
}

abstract class DaysNotLoadedAction
    implements Built<DaysNotLoadedAction, DaysNotLoadedActionBuilder> {
  DaysNotLoadedAction._();
  factory DaysNotLoadedAction(
          [void Function(DaysNotLoadedActionBuilder) updates]) =
      _$DaysNotLoadedAction;
  static void _initializeBuilder(DaysNotLoadedActionBuilder builder) {
    builder..noInternet = false;
  }

  @nullable
  String get errorMsg;
  bool get noInternet;
}

abstract class LoadDaysAction
    implements Built<LoadDaysAction, LoadDaysActionBuilder> {
  LoadDaysAction._();
  factory LoadDaysAction([void Function(LoadDaysActionBuilder) updates]) =
      _$LoadDaysAction;

  bool get future;
}

abstract class SwitchFutureAction
    implements Built<SwitchFutureAction, SwitchFutureActionBuilder> {
  SwitchFutureAction._();
  factory SwitchFutureAction(
          [void Function(SwitchFutureActionBuilder) updates]) =
      _$SwitchFutureAction;
}

abstract class HomeworkAddedAction
    implements Built<HomeworkAddedAction, HomeworkAddedActionBuilder> {
  HomeworkAddedAction._();
  factory HomeworkAddedAction(
          [void Function(HomeworkAddedActionBuilder) updates]) =
      _$HomeworkAddedAction;

  Object get data;
  DateTime get date;
}

abstract class AddReminderAction
    implements Built<AddReminderAction, AddReminderActionBuilder> {
  AddReminderAction._();
  factory AddReminderAction([void Function(AddReminderActionBuilder) updates]) =
      _$AddReminderAction;

  String get msg;
  DateTime get date;
}

abstract class DeleteHomeworkAction
    implements Built<DeleteHomeworkAction, DeleteHomeworkActionBuilder> {
  DeleteHomeworkAction._();
  factory DeleteHomeworkAction(
          [void Function(DeleteHomeworkActionBuilder) updates]) =
      _$DeleteHomeworkAction;

  Homework get hw;
  DateTime get date;
}

abstract class ToggleDoneAction
    implements Built<ToggleDoneAction, ToggleDoneActionBuilder> {
  ToggleDoneAction._();
  factory ToggleDoneAction([void Function(ToggleDoneActionBuilder) updates]) =
      _$ToggleDoneAction;

  Homework get hw;
  bool get done;
}

abstract class MarkAsNotNewOrChangedAction
    implements
        Built<MarkAsNotNewOrChangedAction, MarkAsNotNewOrChangedActionBuilder> {
  MarkAsNotNewOrChangedAction._();
  factory MarkAsNotNewOrChangedAction(
          [void Function(MarkAsNotNewOrChangedActionBuilder) updates]) =
      _$MarkAsNotNewOrChangedAction;

  Homework get homework;
}

abstract class MarkDeletedHomeworkAsSeenAction
    implements
        Built<MarkDeletedHomeworkAsSeenAction,
            MarkDeletedHomeworkAsSeenActionBuilder> {
  MarkDeletedHomeworkAsSeenAction._();
  factory MarkDeletedHomeworkAsSeenAction(
          [void Function(MarkDeletedHomeworkAsSeenActionBuilder) updates]) =
      _$MarkDeletedHomeworkAsSeenAction;

  Day get day;
}

abstract class MarkAllAsNotNewOrChangedAction
    implements
        Built<MarkAllAsNotNewOrChangedAction,
            MarkAllAsNotNewOrChangedActionBuilder> {
  MarkAllAsNotNewOrChangedAction._();
  factory MarkAllAsNotNewOrChangedAction(
          [void Function(MarkAllAsNotNewOrChangedActionBuilder) updates]) =
      _$MarkAllAsNotNewOrChangedAction;
}

abstract class UpdateHomeworkFilterBlacklistAction
    implements
        Built<UpdateHomeworkFilterBlacklistAction,
            UpdateHomeworkFilterBlacklistActionBuilder> {
  UpdateHomeworkFilterBlacklistAction._();
  factory UpdateHomeworkFilterBlacklistAction(
          [void Function(UpdateHomeworkFilterBlacklistActionBuilder) updates]) =
      _$UpdateHomeworkFilterBlacklistAction;

  BuiltList<HomeworkType> get blacklist;
}

abstract class RefreshAction
    implements Built<RefreshAction, RefreshActionBuilder> {
  RefreshAction._();
  factory RefreshAction([void Function(RefreshActionBuilder) updates]) =
      _$RefreshAction;
}
