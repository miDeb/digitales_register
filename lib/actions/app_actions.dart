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
