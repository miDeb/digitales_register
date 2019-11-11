import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../main.dart';
import '../wrapper.dart';

List<Middleware<AppState>> routingMiddlewares(Wrapper wrapper) => [
      TypedMiddleware<AppState, ShowLoginAction>(
        (store, _, __) => _showLogin(wrapper, store),
      ),
      TypedMiddleware<AppState, ShowNotificationsAction>(
        (store, action, next) => _showNotifications(next, action),
      ),
      TypedMiddleware<AppState, ShowSettingsAction>(
        (store, action, next) => _showSettings(next, action),
      ),
      TypedMiddleware<AppState, ShowEditCalendarSubjectNicksAction>(
        (store, action, next) => _showEditCalendarSubjectNicks(next, action),
      ),
      TypedMiddleware<AppState, ShowCalendarAction>(
        (store, action, next) => _showCalendar(next, action),
      ),
      TypedMiddleware<AppState, ShowGradesAction>(
        (store, action, next) => _showGrades(store, next, action),
      ),
      TypedMiddleware<AppState, ShowAbsencesAction>(
        (store, action, next) => _showAbsences(store, next, action),
      ),
      TypedMiddleware<AppState, ShowFullscreenChartAciton>(
        (store, action, next) => _showGradesChart(next, action),
      ),
    ];

void _showLogin(Wrapper wrapper, Store<AppState> store) async {
  if (await wrapper.noInternet)
    store.dispatch(NoInternetAction(true));
  else
    store.dispatch(NoInternetAction(false));
  if (store.state.currentRouteIsLogin) return;
  navigatorKey.currentState.pushNamed("/login");
  store.dispatch(SetIsLoginRouteAction(true));
}

void _showNotifications(NextDispatcher next, ShowNotificationsAction action) {
  navigatorKey.currentState.pushNamed("/notifications");
  next(action);
}

void _showSettings(NextDispatcher next, ShowSettingsAction action) {
  navigatorKey.currentState.pushNamed("/settings");
  next(action);
}

void _showEditCalendarSubjectNicks(
    NextDispatcher next, ShowEditCalendarSubjectNicksAction action) {
  navigatorKey.currentState.pushNamed("/settings");
  next(action);
}

void _showCalendar(NextDispatcher next, ShowCalendarAction action) {
  navigatorKey.currentState.pushNamed("/calendar");
  next(action);
}

void _showGrades(
    Store<AppState> store, NextDispatcher next, ShowGradesAction action) {
  navigatorKey.currentState.pushNamed("/grades");
  store.dispatch(LoadSubjectsAction());
  next(action);
}

void _showAbsences(
    Store<AppState> store, NextDispatcher next, ShowAbsencesAction action) {
  navigatorKey.currentState.pushNamed("/absences");
  store.dispatch(LoadAbsencesAction());
  next(action);
}

void _showGradesChart(NextDispatcher next, ShowFullscreenChartAciton action) {
  navigatorKey.currentState.pushNamed("/gradesChart");
  next(action);
}
