import 'package:built_redux/built_redux.dart';

import '../data.dart';

part 'notifications_actions.g.dart';

abstract class NotificationsActions extends ReduxActions {
  factory NotificationsActions() => _$NotificationsActions();
  NotificationsActions._();

  VoidActionDispatcher load;
  ActionDispatcher<List> loaded;
  ActionDispatcher<Notification> delete;
  VoidActionDispatcher deleteAll;
}
