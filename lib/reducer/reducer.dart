import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import 'absences.dart';
import 'calendar.dart';
import 'days.dart';
import 'grades.dart';
import 'login.dart';
import 'network_protocol.dart';
import 'notifications.dart';
import 'settings.dart';

Reducer<AppState> appReducer = (AppState state, action) {
  if (action is MountAppStateAction) {
    return action.appState;
  }
  final newState = AppState((builder) {
    builder
      ..dayState = dayReducer(state.dayState.toBuilder(), action)
      ..loginState = loginReducer(state.loginState.toBuilder(), action)
      ..noInternet = _noInternetReducer(state.noInternet, action)
      ..notificationState =
          notificationsReducer(state.notificationState.toBuilder(), action)
      ..currentRouteIsLogin =
          _createCurrentRouteReducer()(state.currentRouteIsLogin, action)
      ..config = _configReducer(state.config?.toBuilder(), action)
      ..gradesState = gradesReducer(state.gradesState.toBuilder(), action)
      ..settingsState =
          settingsStateReducer(state.settingsState.toBuilder(), action)
      ..absenceState = absenceReducer(state.absenceState?.toBuilder(), action)
      ..calendarState =
          calendarReducer(state.calendarState?.toBuilder(), action)
      ..networkProtocolState = networkProtocolReducer(
          state.networkProtocolState?.toBuilder(), action);
  });
  return newState;
};

final _noInternetReducer =
    TypedReducer<bool, NoInternetAction>((_, action) => action.noInternet);

TypedReducer<bool, SetIsLoginRouteAction> _createCurrentRouteReducer() {
  return TypedReducer((bool state, SetIsLoginRouteAction action) {
    return action.isLogin;
  });
}

final _configReducer = TypedReducer(
    (ConfigBuilder config, SetConfigAction action) =>
        (config ?? ConfigBuilder())..replace(action.config));
