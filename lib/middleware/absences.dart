import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../wrapper.dart';

List<Middleware<AppState>> absencesMiddlewares(Wrapper wrapper) => [
      TypedMiddleware<AppState, LoadAbsencesAction>(
        (store, action, next) => _loadAbsences(store, action, next, wrapper),
      ),
    ];

void _loadAbsences(Store<AppState> store, LoadAbsencesAction action, next,
    Wrapper wrapper) async {
  next(action);
  final response = await wrapper.post("api/student/dashboard/absences");
  if (response != null) {
    store.dispatch(AbsencesLoadedAction(response));
  }
}
