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
              LoginPayload(
                (b) => b
                  ..user = user
                  ..pass = pass
                  ..url = url
                  ..fromStorage = false,
              ),
            );
          },
          onChangePass: (user, oldPass, newPass, url) {
            actions.loginActions.changePass(
              ChangePassPayload(
                (b) => b
                  ..user = user
                  ..url = url
                  ..oldPass = oldPass
                  ..newPass = newPass,
              ),
            );
          },
          setSaveNoPass: actions.settingsActions.saveNoPass,
          onReload: actions.load,
          onRequestPassReset: actions.routingActions.showRequestPassReset,
        );
      },
      connect: (state) {
        return LoginPageViewModel.from(state);
      },
    );
  }
}

typedef LoginCallback = void Function(String user, String pass, String url);
typedef SetSafeModeCallback = void Function(bool safeMode);

class LoginPageViewModel {
  final String error;
  final String username;
  final String url;
  final bool loading, safeMode, noInternet, changePass, mustChangePass;
  final Map<String, String> servers;

  LoginPageViewModel.from(AppState state)
      : error = state.loginState.errorMsg,
        loading = state.loginState.loading,
        safeMode = state.settingsState.noPasswordSaving,
        noInternet = state.noInternet,
        servers = _servers,
        changePass = state.loginState.changePassword,
        mustChangePass = state.loginState.mustChangePassword,
        username = state.loginState.username,
        url = state.url;
}

const _servers = {
  "Vinzentinum": "https://vinzentinum.digitalesregister.it",
};
