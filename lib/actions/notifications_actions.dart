import 'package:built_redux/built_redux.dart';

import '../data.dart';

part 'notifications_actions.g.dart';

abstract class NotificationsActions extends ReduxActions {
  factory NotificationsActions() => _$NotificationsActions();
  NotificationsActions._();

  ActionDispatcher<void> load;
  ActionDispatcher<List> loaded;
  ActionDispatcher<Notification> delete;
  ActionDispatcher<void> deleteAll;
}
