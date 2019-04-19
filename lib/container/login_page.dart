import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../ui/login_page_content.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginPageViewModel>(
      builder: (BuildContext context, vm) {
        return LoginPageContent(
          vm: vm,
        );
      },
      distinct: true,
      converter: (Store store) {
        return LoginPageViewModel.from(store);
      },
    );
  }
}

typedef void LoginCallback(String user, String pass);
typedef void SetSafeModeCallback(bool safeMode);

class LoginPageViewModel {
  final String error;
  final LoginCallback onLogin;
  final SetSafeModeCallback setSafeMode;
  final VoidCallback onReload;
  final bool loading, safeMode, noInternet;

  operator ==(other) {
    return other is LoginPageViewModel &&
        other.noInternet == noInternet &&
        other.error == error &&
        other.loading == loading &&
        other.safeMode == safeMode;
  }

  LoginPageViewModel.from(Store<AppState> store)
      : error = store.state.loginState.errorMsg,
        onLogin =
            ((user, pass) => store.dispatch(LoginAction(user, pass, false))),
        setSafeMode =
            ((bool safeMode) => store.dispatch(SetSaveNoPassAction(safeMode))),
        loading = store.state.loginState.loading,
        safeMode = store.state.settingsState.noPasswordSaving,
        noInternet = store.state.noInternet,
        onReload = (() => store.dispatch(LoadAction()));
}
