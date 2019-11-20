import 'package:dr/actions.dart';
import 'package:redux/redux.dart';

import '../app_state.dart';

List<Middleware<AppState>> settingsMiddleware = [
  TypedMiddleware<AppState, SetDashboardMarkNewOrChangedEntriesAction>(
    (store, action, next) => _markNewOrChangedEntries(store, action, next),
  ),
];

void _markNewOrChangedEntries(Store store,
    SetDashboardMarkNewOrChangedEntriesAction action, NextDispatcher next) {
  if (!action.mark) {
    store.dispatch(MarkAllAsNotNewOrChangedAction());
  }
  next(action);
}
