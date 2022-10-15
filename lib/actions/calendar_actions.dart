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
import 'package:dr/app_state.dart';
import 'package:dr/data.dart';

import 'package:dr/utc_date_time.dart';

part 'calendar_actions.g.dart';

abstract class CalendarActions extends ReduxActions {
  factory CalendarActions() => _$CalendarActions();
  CalendarActions._();

  abstract final ActionDispatcher<UtcDateTime> load;
  abstract final ActionDispatcher<Map<String, dynamic>> loaded;
  abstract final ActionDispatcher<UtcDateTime> setCurrentMonday;
  abstract final ActionDispatcher<CalendarSelection?> select;
  abstract final ActionDispatcher<LessonContentSubmission> onDownloadFile;
  abstract final ActionDispatcher<LessonContentSubmission> onOpenFile;
  abstract final ActionDispatcher<LessonContentSubmission> fileAvailable;
}
