import 'package:built_redux/built_redux.dart';

import '../data.dart';

part 'notifications_actions.g.dart';

abstract class NotificationsActions extends ReduxActions {
  NotificationsActions._();
  factory NotificationsActions() => _$NotificationsActions();

  ActionDispatcher<void> load;
  ActionDispatcher<dynamic> loaded;
  ActionDispatcher<Notification> delete;
  ActionDispatcher<void> deleteAll;
}
