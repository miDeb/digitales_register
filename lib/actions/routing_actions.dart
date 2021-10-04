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

part 'routing_actions.g.dart';

abstract class RoutingActions extends ReduxActions {
  factory RoutingActions() => _$RoutingActions();
  RoutingActions._();

  abstract final VoidActionDispatcher showLogin;
  abstract final VoidActionDispatcher showProfile;
  abstract final VoidActionDispatcher showChangeEmail;
  abstract final ActionDispatcher<String> showRequestPassReset;
  abstract final ActionDispatcher<ShowPassResetPayload> showPassReset;
  abstract final VoidActionDispatcher showAbsences;
  abstract final VoidActionDispatcher showNotifications;
  abstract final VoidActionDispatcher showSettings;
  abstract final VoidActionDispatcher showGrades;
  abstract final VoidActionDispatcher showGradesChart;
  abstract final VoidActionDispatcher showGradeCalculator;
  abstract final VoidActionDispatcher showCalendar;
  abstract final VoidActionDispatcher showCertificate;
  abstract final VoidActionDispatcher showMessages;
  abstract final ActionDispatcher<int> showMessage;
  abstract final VoidActionDispatcher showEditCalendarSubjectNicks;
  abstract final VoidActionDispatcher showEditGradesAverageSettings;
}

abstract class ShowPassResetPayload
    implements Built<ShowPassResetPayload, ShowPassResetPayloadBuilder> {
  factory ShowPassResetPayload(
          [void Function(ShowPassResetPayloadBuilder)? updates]) =
      _$ShowPassResetPayload;
  ShowPassResetPayload._();

  String get token;
  String get email;

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ShowPassResetPayload')
          //..add('token', token) // do not include the token
          ..add('email', email))
        .toString();
  }
}
