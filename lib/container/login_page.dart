import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions/app_actions.dart';
import '../actions/login_actions.dart';
import '../actions/settings_actions.dart';
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
      converter: (Store store) {
        return LoginPageViewModel.from(store);
      },
    );
  }
}

typedef void LoginCallback(String user, String pass, String url);
typedef void SetSafeModeCallback(bool safeMode);

class LoginPageViewModel {
  final String error;
  final LoginCallback onLogin;
  final SetSafeModeCallback setSafeMode;
  final VoidCallback onReload;
  final bool loading, safeMode, noInternet;

  LoginPageViewModel.from(Store<AppState> store)
      : error = store.state.loginState.errorMsg,
        onLogin = ((user, pass, url) => store.dispatch(
              LoginAction(
                (b) => b
                  ..user = user
                  ..pass = pass
                  ..url = url
                  ..fromStorage = false,
              ),
            )),
        setSafeMode = ((bool safeMode) => store.dispatch(
              SetSaveNoPassAction(
                (b) => b..noSave = safeMode,
              ),
            )),
        loading = store.state.loginState.loading,
        safeMode = store.state.settingsState.noPasswordSaving,
        noInternet = store.state.noInternet,
        onReload = (() => store.dispatch(LoadAction()));
}
