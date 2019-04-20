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
  final OnSettingChanged<bool> onSetDoubleTapForDone;
  final bool doubleTapForDone;
  final OnSettingChanged<bool> onSetAskWhenDelete;
  final bool askWhenDelete;
  SettingsViewModel.fromStore(
      Store<AppState> store, this.onSetDarkMode)
      : noPassSaving = store.state.settingsState.noPasswordSaving,
        noDataSaving = store.state.settingsState.noDataSaving,
        noAverageForAllSemester =
            store.state.settingsState.noAverageForAllSemester,
        doubleTapForDone = store.state.settingsState.doubleTapForDone,
        askWhenDelete = store.state.settingsState.askWhenDelete,
        onSetNoPassSaving = ((bool mode) {
          store.dispatch(SetSaveNoPassAction(mode));
        }),
        onSetNoDataSaving = ((bool mode) {
          store.dispatch(SetSaveNoDataAction(mode));
        }),
        onSetAskWhenDelete = ((bool mode) {
          store.dispatch(SetAskWhenDeleteAction(mode));
        }),
        onSetDoubleTapForDone = ((bool mode) {
          store.dispatch(SetDoubleTapForDoneAction(mode));
        }),
        onSetNoAverageForAllSemester = ((bool mode) {
          store.dispatch(SetNoAverageForAllAction(mode));
        });
}
