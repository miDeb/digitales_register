import 'package:built_redux/built_redux.dart';

import '../actions/app_actions.dart';
import '../app_state.dart';
import 'absences.dart';
import 'calendar.dart';
import 'certificate.dart';
import 'dashboard.dart';
import 'grades.dart';
import 'login.dart';
import 'messages.dart';
import 'network_protocol.dart';
import 'notifications.dart';
import 'profile_reducer.dart';
import 'settings.dart';

final appReducerBuilder = ReducerBuilder<AppState, AppStateBuilder>()
  ..add(AppActionsNames.mountAppState, _mountState)
  ..add(AppActionsNames.noInternet, _noInternet)
  ..add(AppActionsNames.setConfig, _config)
  ..add(AppActionsNames.setUrl, _setUrl)
  ..combineNested(absencesReducerBuilder)
  ..combineNested(calendarReducerBuilder)
  ..combineNested(dashboardReducerBuilder)
  ..combineNested(gradesReducerBuilder)
  ..combineNested(loginReducerBuilder)
  ..combineNested(networkProtocolReducerBuilder)
  ..combineNested(notificationsReducerBuilder)
  ..combineNested(settingsReducerBuilder)
  ..combineNested(certificateReducerBuilder)
  ..combineNested(profileReducerBuilder)
  ..combineNested(messagesReducerBuilder);

void _noInternet(AppState state, Action<bool> action, AppStateBuilder builder) {
  builder..noInternet = action.payload;
}

void _config(AppState state, Action<Config> action, AppStateBuilder builder) {
  builder..config.replace(action.payload);
}

void _mountState(
    AppState state, Action<AppState> action, AppStateBuilder builder) {
  builder.replace(action.payload);
}

void _setUrl(AppState state, Action<String> action, AppStateBuilder builder) {
  builder.url = action.payload;
}
