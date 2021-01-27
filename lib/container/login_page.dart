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
  "LHFS Bruneck":
      "https://lhfsbruneck.digitalesregister.it/v2/login",
  "BBZ Bruneck": "https://bbz.digitalesregister.it/v2/login",
  "LBS Zuegg":
      "https://lbszuegg.digitalesregister.it/v2/login",
  "SSP Bruneck 1": "https://bruneck1.digitalesregister.it/v2/login",
  "Cusanus Gymnasium Bruneck":
      "https://cusanus-gymnasium.digitalesregister.it/v2/login",
  "Fachoberschule für Wirtschaft, Grafik und Kommunikation":
      "https://fo-brixen.digitalesregister.it/v2/login",
  "Fachschule für Hauswirtschaft und Ernährung Kortsch":
      "https://fs-kortsch.digitalesregister.it/v2/login",
  "Fachschule für Land- und Forstwirtschaft Fürstenburg Burgeis":
      "https://fs-fuerstenburg.digitalesregister.it/v2/login",
  "FOS Meran": "https://fos-meran.digitalesregister.it/v2/login",
  "Franziskanergymnasium Bozen":
      "https://franziskanergymnasium.digitalesregister.it/v2/login",
  "FS Dietenheim": "https://fs-dietenheim.digitalesregister.it/v2/login",
  "Fachschule Laimburg": "https://fslaimburg.digitalesregister.it/v2/login",
  "Fachschule Neumarkt":
      "https://fachschule-neumarkt.digitalesregister.it/v2/login",
  "Grundschule Ahrntal": "https://gs-ahrntal.digitalesregister.it/v2/login",
  "Grundschule Luttach / Ahrntal":
      "https://gs-luttach.digitalesregister.it/v2/login",
  "Grundschule Prettau / Ahrntal":
      "https://gs-prettau.digitalesregister.it/v2/login",
  "Grundschule Steinhaus / Ahrntal":
      "https://gs-steinhaus.digitalesregister.it/v2/login",
  "Grundschule St. Jakob / Ahrntal":
      "https://gs-stjakob.digitalesregister.it/v2/login",
  "Grundschule St. Johann / Ahrntal":
      "https://gs-stjohann.digitalesregister.it/v2/login",
  "Grundschule St. Peter / Ahrntal":
      "https://gs-stpeter.digitalesregister.it/v2/login",
  "Grundschule Weissenbach / Ahrntal":
      "https://gs-weissenbach.digitalesregister.it/v2/login",
  "Villanders - Grundschulsprengel Klausen 2":
      "https://villanders.digitalesregister.it/v2/login",
  "GS Feldthurns": "https://feldthurns.digitalesregister.it/v2/login",
  "Grundschule Kollmann": "https://kollmann.digitalesregister.it/v2/login",
  "GS Verdings": "https://verdings.digitalesregister.it/v2/login",
  "GS Waidbruck": "https://waidbruck.digitalesregister.it/v2/login",
  "Gymnasien Meran": "https://gymme.digitalesregister.it/v2/login",
  "Gymnasium Walther von der Vogelweide Bozen":
      "https://vogelweide.digitalesregister.it/v2/login",
  "Herzjesu Institut":
      "https://herzjesu-institut.digitalesregister.it/v2/login",
  "Landeshotelfachschule Kaiserhof Meran":
      "https://kaiserhof.digitalesregister.it/v2/login",
  "Mariengarten Zisterzienserinnen-KlosterInternatsschule":
      "https://mariengarten.digitalesregister.it/v2/login",
  "LBS Schlanders": "https://lbs-schlanders.digitalesregister.it/v2/login",
  "Maria Hueber Gymnasium": "https://mhg.digitalesregister.it/v2/login",
  "MS Carl Wolf": "https://mscarlwolf.digitalesregister.it/v2/login",
  "Grundschule Oswald von Wolkenstein Meran":
      "https://gsoswaldvonwolkenstein.digitalesregister.it/v2/login",
  "Grundschule Franz Tappeiner":
      "https://gsfranztappeiner.digitalesregister.it/v2/login",
  "Grundschule Burgstall": "https://gsburgstall.digitalesregister.it/v2/login",
  "GS Albert Schweitzer":
      "https://gsalbertschweitzer.digitalesregister.it/v2/login",
  "MS Neumarkt": "https://ms-neumarkt.digitalesregister.it/v2/login",
  "MS Welsberg": "https://ms-welsberg.digitalesregister.it/v2/login",
  "Oberschulen J. Ph. Fallmerayer":
      "https://fallmerayer.digitalesregister.it/v2/login",
  "OFL Auer": "https://oflauer.digitalesregister.it/v2/login",
  "OSZ Sand in Taufers":
      "https://sz-sand.digitalesregister.it/v2/login",
  "Mittelschule Sand in Taufers":
      "https://ms-sand.digitalesregister.it/v2/login",
  "GS Lappach": "https://gs-lappach.digitalesregister.it/v2/login",
  "GS Sand in Taufers":
      "https://gs-sandintaufers.digitalesregister.it/v2/login",
  "GS Rein in Taufers":
      "https://gs-reinintaufers.digitalesregister.it/v2/login",
  "GS Ahornach": "https://gs-ahornach.digitalesregister.it/v2/login",
  "RG/TFO Meran": "https://rgtfo-me.digitalesregister.it/v2/login",
  "- sogym - fotour":
      "https://sogym-fotour.digitalesregister.it/v2/login",
  "Sozialwissenschaftliches Gymnasium JOSEF GASSER Brixen":
      "https://gymnasiumbrixen.digitalesregister.it/v2/login",
  "Sozialwissenschaftliches Gymnasium Bruneck":
      "https://sowikunstgym-bruneck.digitalesregister.it/v2/login",
  "SSP Ahrntal": "https://ssp-ahrntal.digitalesregister.it/v2/login",
  "MS Algund": "https://ms-algund.digitalesregister.it/v2/login",
  "Schulsprengel Eppan": "https://ssp-eppan.digitalesregister.it/v2/login",
  "Grundschule Girlan": "https://gs-girlan.digitalesregister.it/v2/login",
  "Grundschule Frangart": "https://gs-frangart.digitalesregister.it/v2/login",
  "SSP Innichen": "https://ssp-innichen.digitalesregister.it/v2/login",
  "Grundschule Winnebach": "https://gs-winnebach.digitalesregister.it/v2/login",
  "Grundschule Sexten": "https://gs-sexten.digitalesregister.it/v2/login",
  "Grundschule Vierschach":
      "https://gs-vierschach.digitalesregister.it/v2/login",
  "Grundschule Innichen": "https://gs-innichen.digitalesregister.it/v2/login",
  "SSP Lana": "https://ssp-lana.digitalesregister.it/v2/login",
  "SSP Lana Grundschulen": "https://ssplana-gs.digitalesregister.it/v2/login",
  "Grundschule Latsch": "https://gs-latsch.digitalesregister.it/v2/login",
  "Grundschule Morter": "https://gs-morter.digitalesregister.it/v2/login",
  "Grundschule Tarsch": "https://gs-tarsch.digitalesregister.it/v2/login",
  "Grundschule Tschars": "https://gs-tschars.digitalesregister.it/v2/login",
  "Grundschule Kastelbell":
      "https://gs-kastelbell.digitalesregister.it/v2/login",
  "Grundschule Goldrain": "https://gs-goldrain.digitalesregister.it/v2/login",
  "MS Latsch": "https://ms-latsch.digitalesregister.it/v2/login",
  "SSP Meran Obermais":
      "https://ssp-meran-obermais.digitalesregister.it/v2/login",
  "Grundschulen SSP Obermais":
      "https://gs-ssp-obermais.digitalesregister.it/v2/login",
  "Mühlbach": "https://ssp-muehlbach.digitalesregister.it/v2/login",
  "SSP Nonsberg Mittelschule":
      "https://sspnonsberg-ms.digitalesregister.it/v2/login",
  "Olang": "https://ssp-olang.digitalesregister.it/v2/login",
  "Grundschule Niedertal": "https://gs-niedertal.digitalesregister.it/v2/login",
  "Grundschule Mittertal": "https://gs-mittertal.digitalesregister.it/v2/login",
  "Grundschule Oberrasen": "https://gs-oberrasen.digitalesregister.it/v2/login",
  "Grundschule Niederrasen":
      "https://gs-niederrasen.digitalesregister.it/v2/login",
  "Grundschule Oberolang": "https://gs-oberolang.digitalesregister.it/v2/login",
  "Grundschule Niederolang":
      "https://gs-niederolang.digitalesregister.it/v2/login",
  "Grundschule Geiselsberg":
      "https://gs-geiselsberg.digitalesregister.it/v2/login",
  "Schulsprengel Ritten": "https://ssp-ritten.digitalesregister.it/v2/login",
  "SSP Sarntal": "https://ssp-sarntal.digitalesregister.it/v2/login",
  "GS Kastelruth": "https://gs-kastelruth.digitalesregister.it/v2/login",
  "GS St. Michael": "https://gs-michael.digitalesregister.it/v2/login",
  "GS St. Oswald": "https://gs-oswald.digitalesregister.it/v2/login",
  "GS Seis": "https://gs-seis.digitalesregister.it/v2/login",
  "Schulsprengel Schlern":
      "https://sspschlern-ms.digitalesregister.it/v2/login",
  "SSP St. Leonhard": "https://ssp-stleonhard.digitalesregister.it/v2/login",
  "Grundschule St. Leonhard":
      "https://gs-stleonhard.digitalesregister.it/v2/login",
  "Grundschule Rabenstein in Passeier":
      "https://gs-rabenstein.digitalesregister.it/v2/login",
  "Grundschule Moos im Passeier":
      "https://gs-moos.digitalesregister.it/v2/login",
  "Grundschule Platt in Passeier":
      "https://gs-platt.digitalesregister.it/v2/login",
  "Grundschule Stuls in Passeier":
      "https://gs-stuls.digitalesregister.it/v2/login",
  "Grundschule Walten in Passeier":
      "https://gs-walten.digitalesregister.it/v2/login",
  "St. Martin": "https://ssp-stm.digitalesregister.it/v2/login",
  "Schulsprengel Sterzing I": "https://sterzing1.digitalesregister.it/v2/login",
  "SSP Sterzing 3":
      "https://schulsprengel-sterzing3.digitalesregister.it/v2/login",
  "Grundschulen Sterzing III":
      "https://gs-sterzing3.digitalesregister.it/v2/login",
  "SSP Toblach": "https://ssp-toblach.digitalesregister.it/v2/login",
  "Grundschule Toblach": "https://gs-toblach.digitalesregister.it/v2/login",
  "GS Wahlen": "https://gs-wahlen.digitalesregister.it/v2/login",
  "GS Niederdorf": "https://gs-niederdorf.digitalesregister.it/v2/login",
  "GS Prags": "https://gs-prags.digitalesregister.it/v2/login",
  "Schulsprengel Tramin": "https://ssp-tramin.digitalesregister.it/v2/login",
  "Grundschule Afing SSP Tschögglberg":
      "https://gs-afing.digitalesregister.it/v2/login",
  "Grundschule Flaas SSP Tschögglberg":
      "https://gs-flaas.digitalesregister.it/v2/login",
  "Grundschule Jenesien SSP Tschögglberg":
      "https://gs-jenesien.digitalesregister.it/v2/login",
  "Grundschule Mölten SSP Tschögglberg":
      "https://gs-moelten.digitalesregister.it/v2/login",
  "Grundschule Verschneid SSP Tschögglberg":
      "https://gs-verschneid.digitalesregister.it/v2/login",
  "Grundschule Vöran SSP Tschögglberg":
      "https://gs-voeran.digitalesregister.it/v2/login",
  "SSP Ulten": "https://ssp-ulten.digitalesregister.it/v2/login",
  "Grundschulen im Schulsprengel Ulten":
      "https://gs-ulten.digitalesregister.it/v2/login",
  "Schulsprengel Vintl": "https://ssp-vintl.digitalesregister.it/v2/login",
  "TFO Bozen": "https://tfobz.digitalesregister.it/v2/login",
  "TFO Bruneck":
      "https://tfo-bruneck.digitalesregister.it/v2/login",
  "Ursulinen": "https://ursulinen.digitalesregister.it/v2/login",
  "Vinzentinum":
      "https://vinzentinum.digitalesregister.it/v2/login",
  "WFO Auer": "https://wfoauer.digitalesregister.it/v2/login",
  "WFO Bruneck": "https://wfo-bruneck.digitalesregister.it/v2/login",
  "WFO Bozen": "https://wfobz.digitalesregister.it/v2/login",
  "WFO Meran": "https://wfokafka.digitalesregister.it/v2/login",
  "WFO Raetia St. Ulrich": "https://ite-raetia.digitalesregister.it/v2/login",
  "SSP Algund - Grundschulen":
      "https://ssp-algund.digitalesregister.it/v2/login",
  "Kunstgymnasium und Landesberufsschule Cademia":
      "https://cademia.digitalesregister.it/v2/login",
  "Scores altes La Ila": "https://scoresaltes.digitalesregister.it/v2/login",
  "SSP Abtei Scora elementara":
      "https://gs-abtei.digitalesregister.it/v2/login",
  "SSP Abtei Scuola media \"Tita Alton\"":
      "https://ms-stern.digitalesregister.it/v2/login",
  "Oberschulzentrum Sterzing":
      "https://osz-sterzing.digitalesregister.it/v2/login",
  "Mittelschule Klausen": "https://ms-klausen.digitalesregister.it/v2/login",
  "Grundschulen im SSP Schlanders":
      "https://gs-schlanders.digitalesregister.it/v2/login",
  "Mittelschule Schlanders":
      "https://ms-schlanders.digitalesregister.it/v2/login",
  "Grundschulsprengel Brixen": "https://brixen1.digitalesregister.it/v2/login",
  "Waldorf WOB Bozen": "https://wob.digitalesregister.it/v2/login",
  "Scola mesana Urtijëi": "https://sm-urtijei.digitalesregister.it/v2/login",
  "Scola elementera Urtijei / Runcadic":
      "https://se-urtijei.digitalesregister.it/v2/login",
  "GSP Klausen 1": "https://klausen1.digitalesregister.it/v2/login",
  "Realgymnasium und Fachoberschule für Bauwesen „Peter Anich“ Bozen":
      "https://rg-fob.digitalesregister.it/v2/login",
  "Mittelschule SSP Bozen Europa":
      "https://ms-bozeneuropa.digitalesregister.it/v2/login",
  "Grundschulen SSP Bozen Europa":
      "https://gs-bozeneuropa.digitalesregister.it/v2/login",
  "Scola Mesana Selva": "https://sm-selva.digitalesregister.it/v2/login",
  "MS Rosegger und Tirol": "https://ms-untermais.digitalesregister.it/v2/login",
  "Grundschulen SSP Untermais":
      "https://gs-untermais.digitalesregister.it/v2/login",
  "SSP Deutschnofen": "https://ssp-deutschnofen.digitalesregister.it/v2/login",
  "Grundschulen im SSP Deutschnofen":
      "https://gs-deutschnofen.digitalesregister.it/v2/login",
  "Grundschule Gries": "https://gs-gries.digitalesregister.it/v2/login",
  "Mittelschule \"Adalbert Stifter\"":
      "https://ms-stifter.digitalesregister.it/v2/login",
  "Grundschulen SSP Karneid":
      "https://gs-sspkarneid.digitalesregister.it/v2/login",
  "Mittelschule SSP Karneid":
      "https://ms-sspkarneid.digitalesregister.it/v2/login",
  "Mittelschule Terlan": "https://ms-sspterlan.digitalesregister.it/v2/login",
  "Grundschulen SSP Terlan":
      "https://gs-sspterlan.digitalesregister.it/v2/login",
  "Mittelschule Leifers": "https://ms-leifers.digitalesregister.it/v2/login",
  "Grundschule Leifers": "https://gs-leifers.digitalesregister.it/v2/login",
  "GS St. Jakob (SSP Leifers)":
      "https://gs-st-jakob.digitalesregister.it/v2/login",
  "GS Branzoll": "https://gs-branzoll.digitalesregister.it/v2/login",
  "GS Pfatten": "https://gs-pfatten.digitalesregister.it/v2/login",
  "Mittelschule Mals": "https://ms-mals.digitalesregister.it/v2/login",
  "Grundschulen SSP Mals": "https://sspmals-gs.digitalesregister.it/v2/login",
  "Mittelschule Schluderns":
      "https://ms-schluderns.digitalesregister.it/v2/login",
  "Grundschulen SSP Schluderns":
      "https://gs-schluderns.digitalesregister.it/v2/login",
  "Mittelschule Bruneck II": "https://meusburger.digitalesregister.it/v2/login",
  "Grundschulen im Schulsprengel Laas":
      "https://gs-laas.digitalesregister.it/v2/login",
  "Mittelschule Laas": "https://ms-laas.digitalesregister.it/v2/login",
  "GSP Lana": "https://gsp-lana.digitalesregister.it/v2/login",
  "Grundschulsprengel Neumarkt":
      "https://gsp-neumarkt.digitalesregister.it/v2/login",
  "Grundschulsprengel Bozen": "https://bozen1.digitalesregister.it/v2/login",
  "Grundschulsprengel Eppan": "https://gspeppan.digitalesregister.it/v2/login",
  "Mittelschule Kaltern": "https://ms-kaltern.digitalesregister.it/v2/login",
  "Grundschule Kaltern": "https://gs-kaltern.digitalesregister.it/v2/login"
};
