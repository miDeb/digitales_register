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
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../actions/dashboard_actions.dart';
import '../app_state.dart';
import '../data.dart';
import '../ui/days.dart';

part 'days_container.g.dart';

class DaysContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, DaysViewModel>(
      builder: (context, vm, actions) {
        return DaysWidget(
          vm: vm,
          onSwitchFuture: actions.dashboardActions.switchFuture,
          refresh: actions.dashboardActions.refresh,
          addReminderCallback: (day, msg) {
            actions.dashboardActions.addReminder(
              AddReminderPayload(
                (b) => b
                  ..msg = msg
                  ..date = day.date,
              ),
            );
          },
          removeReminderCallback: (hw, day) {
            actions.dashboardActions.deleteHomework(hw);
          },
          toggleDoneCallback: (hw, done) {
            actions.dashboardActions.toggleDone(
              ToggleDonePayload(
                (b) => b
                  ..homeworkId = hw.id
                  ..type = hw.type.name
                  ..done = done,
              ),
            );
          },
          setDoNotAskWhenDeleteCallback: () {
            actions.settingsActions.askWhenDeleteReminder(false);
          },
          markAsSeenCallback: actions.dashboardActions.markAsSeen,
          markDeletedHomeworkAsSeenCallback:
              actions.dashboardActions.markDeletedHomeworkAsSeen,
          markAllAsSeenCallback: actions.dashboardActions.markAllAsSeen,
          refreshNoInternet: actions.refreshNoInternet,
          onDownloadAttachment: actions.dashboardActions.downloadAttachment,
          onOpenAttachment: actions.dashboardActions.openAttachment,
        );
      },
      connect: (state) {
        return DaysViewModel.from(state);
      },
    );
  }
}

typedef AddReminderCallback = void Function(Day day, String reminder);
typedef RemoveReminderCallback = void Function(Homework hw, Day day);
typedef ToggleDoneCallback = void Function(Homework hw, bool done);
typedef MarkAsNotNewOrChangedCallback = void Function(Homework hw);
typedef MarkDeletedHomeworkAsSeenCallback = void Function(Day day);
typedef AttachmentCallback = void Function(GradeGroupSubmission ggs);

abstract class DaysViewModel
    implements Built<DaysViewModel, DaysViewModelBuilder> {
  bool get future;
  bool get askWhenDelete;
  bool get noInternet;
  bool get loading;
  bool get showAddReminder;
  bool get colorBorders;
  bool get colorTestsInRed;
  BuiltMap<String, SubjectTheme> get subjectThemes;

  bool get showNotifications;
  BuiltList<Day> get days;

  factory DaysViewModel([void Function(DaysViewModelBuilder)? updates]) =
      _$DaysViewModel;
  DaysViewModel._();

  factory DaysViewModel.from(AppState state) {
    final unorderedDays = state.dashboardState.allDays
            ?.where((day) => day.future == state.dashboardState.future)
            .map(
              (day) => day.rebuild(
                (b) => b
                  ..deletedHomework.where(
                    (hw) => !isBlacklisted(hw, state.dashboardState.blacklist!),
                  )
                  ..homework.where(
                    (hw) => !isBlacklisted(hw, state.dashboardState.blacklist!),
                  ),
              ),
            )
            .toList() ??
        [];

    return DaysViewModel(
      (b) => b
        ..days = ListBuilder(
          !state.dashboardState.future ? unorderedDays.reversed : unorderedDays,
        )
        ..noInternet = state.noInternet
        ..future = state.dashboardState.future
        ..loading = state.dashboardState.loading || state.loginState.loading
        ..askWhenDelete = state.settingsState.askWhenDelete
        ..showAddReminder =
            !state.dashboardState.blacklist!.contains(HomeworkType.homework)
        ..showNotifications =
            (state.notificationState.notifications?.length ?? 0) > 0
        ..colorBorders = state.settingsState.dashboardColorBorders
        ..colorTestsInRed = state.settingsState.dashboardColorTestsInRed
        ..subjectThemes = state.settingsState.subjectThemes.toBuilder(),
    );
  }
}

// Map all (previously by the server used) homework types to the titles they
// would have been used with. Probably incomplete.
const typesToTitles = {
  HomeworkType.grade: ["Bewertung"],
  HomeworkType.gradeGroup: ["Testarbeit", "Schularbeit", "Prüfung"],
  HomeworkType.homework: ["Erinnerung"],
  HomeworkType.lessonHomework: ["Hausaufgabe"],
  HomeworkType.observation: ["Beobachtung"],
};

bool isBlacklisted(Homework homework, BuiltList<HomeworkType> blacklist) {
  return blacklist.any((blacklisted) {
    return typesToTitles[blacklisted]!
        .any((blacklistedTitle) => homework.title.contains(blacklistedTitle));
  });
}
