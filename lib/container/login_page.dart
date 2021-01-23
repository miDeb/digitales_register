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
          onSelectAccount: actions.loginActions.selectAccount,
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
  final List<String> otherAccounts;

  LoginPageViewModel.from(AppState state)
      : error = state.loginState.errorMsg,
        loading = state.loginState.loading,
        safeMode = state.settingsState.noPasswordSaving,
        noInternet = state.noInternet,
        servers = _servers,
        changePass = state.loginState.changePassword,
        mustChangePass = state.loginState.mustChangePassword,
        username = state.loginState.username,
        url = state.url,
        otherAccounts = state.loginState.otherAccounts?.toList();
}

const _servers = {
  "Vinzentinum": "https://vinzentinum.digitalesregister.it",
  "Fallmerayer": "https://fallmerayer.digitalesregister.it",
  "WFO Bozen": "https://wfobz.digitalesregister.it",
  "Bruneck 1": "https://bruneck1.digitalesregister.it",
  "Ursulinen": "https://ursulinen.digitalesregister.it",
  "Gymme": "https://gymme.digitalesregister.it",
  "OFL Auer": "https://oflauer.digitalesregister.it",
  "Walther von der Vogelweide": "https://vogelweide.digitalesregister.it",
  "Sterzing I": "https://sterzing1.digitalesregister.it",
  "TFO Bozen ": "https://tfobz.digitalesregister.it",
  "Mariengarten": "https://mariengarten.digitalesregister.it",
  "GS Oswald v. Wolkenstein Meran":
      "https://gsoswaldvonwolkenstein.digitalesregister.it",
  "GS Burgstall": "https://gsburgstall.digitalesregister.it",
  "GS Albert Schweizer": "https://gsalbertschweitzer.digitalesregister.it",
  "BBZ Bruneck": "https://bbz.digitalesregister.it",
  "WFO Auer": "https://wfoauer.digitalesregister.it",
  "LBS Zuegg": "https://lbszuegg.digitalesregister.it",
  "MS Meusburger Bruneck": "https://meusburger.digitalesregister.it",
  "WFO Kafka Meran": "https://wfokafka.digitalesregister.it",
  "Scores altes La Ila": "https://scoresaltes.digitalesregister.it",
  "FS Tisens": "https://fstisens.digitalesregister.it",
  "SOWI Brixen": "https://gymnasiumbrixen.digitalesregister.it",
  "Maria Hueber Gymnasium": "https://mhg.digitalesregister.it",
  "Fachschule Laimburg": "https://fslaimburg.digitalesregister.it",
  "GS Franz Tappeiner": "https://gsfranztappeiner.digitalesregister.it",
  "LHFS Bruneck": "https://lhfsbruneck.digitalesregister.it",
  "Kaiserhof Meran": "https://kaiserhof.digitalesregister.it",
  "Cademia": "https://cademia.digitalesregister.it",
  "Franziskaner Bozen": "https://franziskanergymnasium.digitalesregister.it",
  "MS Carl Wolf": "https://mscarlwolf.digitalesregister.it",
};
