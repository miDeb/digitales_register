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

import '../app_state.dart';
import 'absences_actions.dart';
import 'calendar_actions.dart';
import 'certificate_actions.dart';
import 'dashboard_actions.dart';
import 'grades_actions.dart';
import 'login_actions.dart';
import 'messages_actions.dart';
import 'notifications_actions.dart';
import 'profile_actions.dart';
import 'routing_actions.dart';
import 'save_pass_actions.dart';
import 'settings_actions.dart';

part 'app_actions.g.dart';

abstract class AppActions extends ReduxActions {
  factory AppActions() => _$AppActions();
  AppActions._();
  abstract final ActionDispatcher<Error> error;
  abstract final VoidActionDispatcher saveState;
  abstract final VoidActionDispatcher deleteData;
  abstract final ActionDispatcher<Uri?> start;
  abstract final VoidActionDispatcher load;
  abstract final VoidActionDispatcher refreshNoInternet;
  abstract final ActionDispatcher<bool> noInternet;
  abstract final ActionDispatcher<Config> setConfig;
  abstract final ActionDispatcher<AppState> mountAppState;
  abstract final ActionDispatcher<NetworkProtocolItem> addNetworkProtocolItem;
  abstract final ActionDispatcher<String> setUrl;
  abstract final VoidActionDispatcher restarted;
  abstract final AbsencesActions absencesActions;
  abstract final CalendarActions calendarActions;
  abstract final DashboardActions dashboardActions;
  abstract final GradesActions gradesActions;
  abstract final LoginActions loginActions;
  abstract final NotificationsActions notificationsActions;
  abstract final RoutingActions routingActions;
  abstract final SavePassActions savePassActions;
  abstract final SettingsActions settingsActions;
  abstract final ProfileActions profileActions;
  abstract final CertificateActions certificateActions;
  abstract final MessagesActions messagesActions;
}
