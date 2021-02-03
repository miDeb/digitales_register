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
    ProfileState state, Action<Object> action, ProfileStateBuilder builder) {
  return builder.replace(tryParse(action.payload, _parseProfile));
}

void _sendNotificationEmails(
    ProfileState state, Action<bool> action, ProfileStateBuilder builder) {
  builder.sendNotificationEmails = action.payload;
}

ProfileState _parseProfile(data) {
  return ProfileState(
    (b) => b
      ..name = data["name"] as String
      ..email = data["email"] as String
      ..roleName = data["roleName"] as String
      ..sendNotificationEmails = data["notificationsEnabled"] as bool
      ..username = data["username"] as String,
  );
}
