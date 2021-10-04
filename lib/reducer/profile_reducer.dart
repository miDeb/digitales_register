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

import '../actions/profile_actions.dart';
import '../app_state.dart';
import '../util.dart';

final profileReducerBuilder = NestedReducerBuilder<AppState, AppStateBuilder,
    ProfileState, ProfileStateBuilder>(
  (s) => s.profileState,
  (b) => b.profileState,
)
  ..add(ProfileActionsNames.loaded, _loaded)
  ..add(ProfileActionsNames.sendNotificationEmails, _sendNotificationEmails);

void _loaded(
    ProfileState? state, Action<Object> action, ProfileStateBuilder builder) {
  return builder.replace(tryParse(getMap(action.payload)!, _parseProfile));
}

void _sendNotificationEmails(
    ProfileState? state, Action<bool> action, ProfileStateBuilder builder) {
  builder.sendNotificationEmails = action.payload;
}

ProfileState _parseProfile(Map data) {
  return ProfileState(
    (b) => b
      ..name = getString(data["name"])
      ..email = getString(data["email"])
      ..roleName = getString(data["roleName"])
      ..sendNotificationEmails = getBool(data["notificationsEnabled"])
      ..username = getString(data["username"]),
  );
}
