import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';

final loginReducer = combineReducers<LoginStateBuilder>([
  _createLoginFailedReducer(),
  _createLoginSucceededReducer(),
  _createLoggingInReducer(),
  _createLogoutReducer(),
]);

TypedReducer<LoginStateBuilder, LoginFailedAction> _createLoginFailedReducer() {
  return TypedReducer((LoginStateBuilder state, LoginFailedAction action) {
    return state
      ..errorMsg = action.cause
      ..userName = action.username
      ..loading = false
      ..loggedIn = false;
  });
}

TypedReducer<LoginStateBuilder, LoggedInAction> _createLoginSucceededReducer() {
  return TypedReducer((LoginStateBuilder state, LoggedInAction action) {
    return state
      ..errorMsg = null
      ..userName = action.userName
      ..loading = false
      ..loggedIn = true;
  });
}

TypedReducer<LoginStateBuilder, LoggingInAction> _createLoggingInReducer() {
  return TypedReducer((LoginStateBuilder state, LoggingInAction action) {
    return state..loading = true;
  });
}

TypedReducer<LoginStateBuilder, LogoutAction> _createLogoutReducer() {
  return TypedReducer((LoginStateBuilder state, LogoutAction action) {
    return state
      ..loggedIn = false
      ..userName = null;
  });
}
