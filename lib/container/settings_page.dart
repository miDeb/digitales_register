import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../app_state.dart';
import '../ui/settings_page_widget.dart';

class SettingsPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingsViewModel>(
      builder: (BuildContext context, SettingsViewModel vm) {
        return SettingsPageWidget(vm: vm);
      },
      converter: (Store<AppState> store) {
        return SettingsViewModel.fromStore(
          store,
          (dm) {
            DynamicTheme.of(context).setBrightness(
                Theme.of(context).brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark);
          },
        );
      },
    );
  }
}

typedef void OnSettingChanged<T>(T newValue);

class SettingsViewModel {
  final OnSettingChanged<bool> onSetNoPassSaving;
  final bool noPassSaving;
  final OnSettingChanged<bool> onSetNoDataSaving;
  final bool noDataSaving;
  final OnSettingChanged<bool> onSetDarkMode;
  final OnSettingChanged<bool> onSetNoAverageForAllSemester;
  final bool noAverageForAllSemester;
  final OnSettingChanged<bool> onSetAskWhenDelete;
  final bool askWhenDelete;
  final OnSettingChanged<bool> onSetDeleteDataOnLogout;
  final bool deleteDataOnLogout;
  final OnSettingChanged<bool> onSetOfflineEnabled;
  final bool offlineEnabled;
  final OnSettingChanged<Map<String, String>> onSetSubjectNicks;
  final Map<String, String> subjectNicks;
  SettingsViewModel.fromStore(Store<AppState> store, this.onSetDarkMode)
      : noPassSaving = store.state.settingsState.noPasswordSaving,
        noDataSaving = store.state.settingsState.noDataSaving,
        noAverageForAllSemester =
            store.state.settingsState.noAverageForAllSemester,
        askWhenDelete = store.state.settingsState.askWhenDelete,
        deleteDataOnLogout = store.state.settingsState.deleteDataOnLogout,
        offlineEnabled = store.state.settingsState.offlineEnabled,
        subjectNicks = store.state.settingsState.subjectNicks.toMap(),
        onSetNoPassSaving = ((bool mode) {
          store.dispatch(SetSaveNoPassAction(mode));
        }),
        onSetNoDataSaving = ((bool mode) {
          store.dispatch(SetSaveNoDataAction(mode));
        }),
        onSetAskWhenDelete = ((bool mode) {
          store.dispatch(SetAskWhenDeleteAction(mode));
        }),
        onSetNoAverageForAllSemester = ((bool mode) {
          store.dispatch(SetNoAverageForAllAction(mode));
        }),
        onSetDeleteDataOnLogout = ((bool mode) {
          store.dispatch(SetDeleteDataOnLogoutAction(mode));
        }),
        onSetOfflineEnabled = ((bool mode) {
          store.dispatch(SetOfflineEnabledAction(mode));
        }),
        onSetSubjectNicks = ((Map<String, String> nicks) {
          store.dispatch(SetSubjectNicksAction(nicks));
        });
}
