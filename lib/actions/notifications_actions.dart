import 'package:built_redux/built_redux.dart';

import '../data.dart';

part 'notifications_actions.g.dart';

abstract class NotificationsActions extends ReduxActions {
  factory NotificationsActions() => _$NotificationsActions();
  NotificationsActions._();

  abstract final VoidActionDispatcher load;
  abstract final ActionDispatcher<List> loaded;
  abstract final ActionDispatcher<Notification> delete;
  abstract final VoidActionDispatcher deleteAll;
}
