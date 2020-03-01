import 'dart:convert';
import 'dart:io';

import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/actions/login_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/linux.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:dr/serializers.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('save state occurs after five seconds', () async {
    final username = "test_username";
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState((b) => b.loginState
        ..loggedIn = true
        ..username = username),
      AppActions(),
      middleware: middleware,
    );
    final saveFile = File(
        "${(await getApplicationDocumentsDirectory()).path}/app_state_${username.hashCode}.json");
    if (saveFile.existsSync()) saveFile.deleteSync();
    // dispatch any action to trigger a state save
    store.actions.setUrl("abc");
    // saving the state is throttled by five seconds
    await Future.delayed(Duration(seconds: 1));
    Directory("linux/appData").createSync(recursive: true);

    expect(
      saveFile.existsSync(),
      false,
    );
    // after over 5 seconds, the state should be saved
    await Future.delayed(Duration(seconds: 6), () async {
      expect(
        await saveFile.exists(),
        true,
      );
    });

    await saveFile.delete();
  });
  test('save state occurs immediately', () async {
    final username = "test_username2";
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState((b) => b.loginState
        ..loggedIn = true
        ..username = username),
      AppActions(),
      middleware: middleware,
    );
    Directory("linux/appData").createSync(recursive: true);

    final saveFile = File(
        "${(await getApplicationDocumentsDirectory()).path}/app_state_${username.hashCode}.json");
    // make sure the file does not already exist
    if (saveFile.existsSync()) saveFile.deleteSync();

    store.actions.saveState();

    // the state should be saved immediately
    await Future.delayed(Duration(milliseconds: 100));
    expect(
      await saveFile.exists(),
      true,
    );
    expect(
        serializers.deserialize(json.decode(await saveFile.readAsString()))
            is AppState,
        true);

    saveFile.deleteSync();
  });
  test('state is not saved when it is disabled', () async {
    final username = "test_username2";
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState(
        (b) {
          b.loginState
            ..loggedIn = true
            ..username = username;
          b.settingsState.noDataSaving = true;
        },
      ),
      AppActions(),
      middleware: middleware,
    );
    Directory("linux/appData").createSync(recursive: true);

    final saveFile = File(
        "${(await getApplicationDocumentsDirectory()).path}/app_state_${username.hashCode}.json");
    // make sure the file does not already exist
    if (saveFile.existsSync()) saveFile.deleteSync();

    store.actions.saveState();

    // the state should be saved immediately
    await Future.delayed(Duration(milliseconds: 100));
    expect(
      await saveFile.exists(),
      true,
    );

    expect(
        serializers.deserialize(json.decode(await saveFile.readAsString()))
            is SettingsState,
        true);

    saveFile.deleteSync();
  });
  test('state is deleted on logout when it is disabled', () async {
    final username = "test_username3";
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState(
        (b) {
          b.loginState
            ..loggedIn = true
            ..username = username;
          b.settingsState.deleteDataOnLogout = true;
        },
      ),
      AppActions(),
      middleware: middleware,
    );
    Directory("linux/appData").createSync(recursive: true);

    final saveFile = File(
        "${(await getApplicationDocumentsDirectory()).path}/app_state_${username.hashCode}.json");
    // make sure the file does not already exist
    if (saveFile.existsSync()) saveFile.deleteSync();

    store.actions.saveState();

    // the state should be saved immediately
    await Future.delayed(Duration(milliseconds: 100));
    expect(
      await saveFile.exists(),
      true,
    );

    expect(
        serializers.deserialize(json.decode(await saveFile.readAsString()))
            is AppState,
        true);
    store.actions.loginActions.logout(
      LogoutPayload(
        (b) => b
          ..hard = true
          ..forced = true,
      ),
    );
    await Future.delayed(Duration(milliseconds: 100));

    expect(
        serializers.deserialize(json.decode(saveFile.readAsStringSync()))
            is SettingsState,
        true);
    saveFile.deleteSync();
  });
}
