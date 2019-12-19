import 'package:redux/redux.dart';

import '../actions/absences_actions.dart';
import '../actions/app_actions.dart';
import '../actions/calendar_actions.dart';
import '../actions/grades_actions.dart';
import '../actions/routing_actions.dart';
import '../app_state.dart';
import '../main.dart';
import '../util.dart';
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
        (store, action, next) => _showCalendar(store, next, action),
      ),
      TypedMiddleware<AppState, ShowGradesAction>(
        (store, action, next) => _showGrades(store, next, action),
      ),
      TypedMiddleware<AppState, ShowAbsencesAction>(
        (store, action, next) => _showAbsences(store, next, action),
      ),
      TypedMiddleware<AppState, ShowFullscreenChartAction>(
        (store, action, next) => _showGradesChart(next, action),
      ),
    ];

void _showLogin(Wrapper wrapper, Store<AppState> store) {
  store.dispatch(
    NoInternetAction(
      (b) async => b..noInternet = await wrapper.noInternet,
    ),
  );
  if (store.state.currentRouteIsLogin) return;
  navigatorKey.currentState.pushNamed("/login");
  store.dispatch(
    SetRouteIsLoginAction(
      (b) => b..isLogin = true,
    ),
  );
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

void _showCalendar(
    Store<AppState> store, NextDispatcher next, ShowCalendarAction action) {
  navigatorKey.currentState.pushNamed("/calendar");
  store.dispatch(
    SetCalendarCurrentMondayAction(
      (b) => b..monday = toMonday(DateTime.now()),
    ),
  );
  next(action);
}

void _showGrades(
    Store<AppState> store, NextDispatcher next, ShowGradesAction action) {
  navigatorKey.currentState.pushNamed("/grades");
  store.dispatch(
    LoadSubjectsAction(
      (b) => b..semester = store.state.gradesState.semester.toBuilder(),
    ),
  );
  next(action);
}

void _showAbsences(
    Store<AppState> store, NextDispatcher next, ShowAbsencesAction action) {
  navigatorKey.currentState.pushNamed("/absences");
  store.dispatch(LoadAbsencesAction());
  next(action);
}

void _showGradesChart(NextDispatcher next, ShowFullscreenChartAction action) {
  navigatorKey.currentState.pushNamed("/gradesChart");
  next(action);
}
