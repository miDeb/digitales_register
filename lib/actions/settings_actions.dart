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

import 'package:dr/app_state.dart';

part 'settings_actions.g.dart';

abstract class SettingsActions extends ReduxActions {
  factory SettingsActions() => _$SettingsActions();
  SettingsActions._();

  abstract final ActionDispatcher<bool> saveNoPass;
  abstract final ActionDispatcher<bool> saveNoData;
  abstract final ActionDispatcher<bool> deleteDataOnLogout;
  abstract final ActionDispatcher<BuiltMap<String, String>> subjectNicks;
  abstract final ActionDispatcher<BuiltList<String>> ignoreSubjectsForAverage;
  abstract final ActionDispatcher<MapEntry<String, SubjectTheme>>
      setSubjectTheme;
  abstract final ActionDispatcher<List<String>> updateSubjectThemes;
  abstract final ActionDispatcher<bool> askWhenDeleteReminder;
  abstract final ActionDispatcher<bool> gradesTypeSorted;
  abstract final ActionDispatcher<bool> showCancelledGrades;
  abstract final ActionDispatcher<bool> showGradesDiagram;
  abstract final ActionDispatcher<bool> showAllSubjectsAverage;
  abstract final ActionDispatcher<bool> markNotSeenDashboardEntries;
  abstract final ActionDispatcher<bool> deduplicateDashboardEntries;
  abstract final ActionDispatcher<bool> showCalendarSubjectNicksBar;
  abstract final ActionDispatcher<bool> drawerExpandedChange;
  abstract final ActionDispatcher<bool> dashboardColorBorders;
  abstract final ActionDispatcher<bool> dashboardColorTestsInRed;
}
