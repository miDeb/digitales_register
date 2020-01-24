import 'package:built_redux/built_redux.dart';

import '../app_state.dart';
import 'absences_actions.dart';
import 'calendar_actions.dart';
import 'dashboard_actions.dart';
import 'grades_actions.dart';
import 'login_actions.dart';
import 'notifications_actions.dart';
import 'routing_actions.dart';
import 'save_pass_actions.dart';
import 'settings_actions.dart';

part 'app_actions.g.dart';

abstract class AppActions extends ReduxActions {
  AppActions._();
  factory AppActions() => _$AppActions();
  ActionDispatcher<Error> error;
  ActionDispatcher<void> saveState;
  ActionDispatcher<void> deleteData;
  ActionDispatcher<void> load;
  ActionDispatcher<bool> refreshNoInternet;
  ActionDispatcher<bool> noInternet;
  ActionDispatcher<bool> isLoginRoute;
  ActionDispatcher<Config> setConfig;
  ActionDispatcher<AppState> mountAppState;
  ActionDispatcher<NetworkProtocolItem> addNetworkProtocolItem;
  AbsencesActions absencesActions;
  CalendarActions calendarActions;
  DashboardActions dashboardActions;
  GradesActions gradesActions;
  LoginActions loginActions;
  NotificationsActions notificationsActions;
  RoutingActions routingActions;
  SavePassActions savePassActions;
  SettingsActions settingsActions;
}
