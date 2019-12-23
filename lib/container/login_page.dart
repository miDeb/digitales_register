import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import '../actions/app_actions.dart';
import '../actions/login_actions.dart';
import '../app_state.dart';
import '../ui/login_page_content.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnection<AppState, AppActions, LoginPageViewModel>(
      builder: (context, vm, actions) {
        return LoginPageContent(
          vm: vm,
          onLogin: (user, pass, url) {
            actions.loginActions.login(
              LoginAction(
                (b) => b
                  ..user = user
                  ..pass = pass
                  ..url = url
                  ..fromStorage = false,
              ),
            );
          },
          setSaveNoPass: actions.settingsActions.saveNoPass,
          onReload: actions.load,
        );
      },
      connect: (state) {
        return LoginPageViewModel.from(state);
      },
    );
  }
}

typedef void LoginCallback(String user, String pass, String url);
typedef void SetSafeModeCallback(bool safeMode);

class LoginPageViewModel {
  final String error;
  final bool loading, safeMode, noInternet;

  LoginPageViewModel.from(AppState state)
      : error = state.loginState.errorMsg,
        loading = state.loginState.loading,
        safeMode = state.settingsState.noPasswordSaving,
        noInternet = state.noInternet;
}
