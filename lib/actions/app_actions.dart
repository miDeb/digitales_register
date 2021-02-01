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
  ActionDispatcher<Error> error;
  VoidActionDispatcher saveState;
  VoidActionDispatcher deleteData;
  ActionDispatcher<Uri> start;
  VoidActionDispatcher load;
  VoidActionDispatcher refreshNoInternet;
  ActionDispatcher<bool> noInternet;
  ActionDispatcher<Config> setConfig;
  ActionDispatcher<AppState> mountAppState;
  ActionDispatcher<NetworkProtocolItem> addNetworkProtocolItem;
  ActionDispatcher<String> setUrl;
  VoidActionDispatcher restarted;
  AbsencesActions absencesActions;
  CalendarActions calendarActions;
  DashboardActions dashboardActions;
  GradesActions gradesActions;
  LoginActions loginActions;
  NotificationsActions notificationsActions;
  RoutingActions routingActions;
  SavePassActions savePassActions;
  SettingsActions settingsActions;
  ProfileActions profileActions;
  CertificateActions certificateActions;
  MessagesActions messagesActions;
}
