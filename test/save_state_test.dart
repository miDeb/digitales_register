import 'dart:convert';
import 'dart:io';

import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/actions/login_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/desktop.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:dr/serializers.dart';
import 'package:flutter_test/flutter_test.dart';

const serverUrl = "null/v2/api/auth/login";

class StorageHelper {
  StorageHelper() {
    Directory("linux/appData/secure_storage").createSync(recursive: true);
  }
  Future<bool> exists(String user) async {
    final value = await read(user);
    return value != null;
  }

  Future<String?> read(String user) async {
    return getFlutterSecureStorage().read(key: getStorageKey(user, serverUrl));
  }

  Future<void> cleanup() async {
    await getFlutterSecureStorage().deleteAll();
  }
}

void main() {
  final storageHelper = StorageHelper();
  storageHelper.cleanup();
  test('save state occurs after five seconds', () async {
    const username = "test_username";
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState((b) => b.loginState
        ..loggedIn = true
        ..username = username),
      AppActions(),
      middleware: middleware,
    );
    // dispatch any action to trigger a state save
    store.actions.setUrl("abc");
    // saving the state is throttled by five seconds
    await Future.delayed(const Duration(seconds: 1));

    expect(
      await storageHelper.exists(username),
      false,
    );
    // after over 5 seconds, the state should be saved
    await Future.delayed(const Duration(seconds: 6), () async {
      expect(
        await storageHelper.exists(username),
        true,
      );
    });
  });
  test('save state occurs immediately', () async {
    const username = "test_username2";
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState((b) => b.loginState
        ..loggedIn = true
        ..username = username),
      AppActions(),
      middleware: middleware,
    );

    store.actions.saveState();

    // the state should be saved immediately
    await Future.delayed(const Duration(milliseconds: 100));
    expect(
      await storageHelper.exists(username),
      true,
    );
    expect(
        serializers.deserialize(
                json.decode((await storageHelper.read(username))!) as Object)
            is AppState,
        true);
  });
  test('state is not saved when it is disabled', () async {
    const username = "test_username2";
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

    store.actions.saveState();

    // the state should be saved immediately
    await Future.delayed(const Duration(milliseconds: 100));
    expect(
      await storageHelper.exists(username),
      true,
    );

    expect(
        serializers.deserialize(
                json.decode((await storageHelper.read(username))!) as Object)
            is SettingsState,
        true);
  });
  test('state is deleted on logout when it is disabled', () async {
    const username = "test_username3";
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

    store.actions.saveState();

    // the state should be saved immediately
    await Future.delayed(const Duration(milliseconds: 100));
    expect(
      await storageHelper.exists(username),
      true,
    );

    expect(
        serializers.deserialize(
                json.decode((await storageHelper.read(username))!) as Object)
            is AppState,
        true);
    store.actions.loginActions.logout(
      LogoutPayload(
        (b) => b
          ..hard = true
          ..forced = true,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));

    expect(
        serializers.deserialize(
                json.decode((await storageHelper.read(username))!) as Object)
            is SettingsState,
        true);
  });
  test('state is deleted/saved when the setting is switched', () async {
    const username = "test_username4";
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState(),
      AppActions(),
      middleware: middleware,
    );
    store.actions.loginActions.loggedIn(LoggedInPayload((b) => b
      ..fromStorage = false
      ..username = username));

    await Future.delayed(const Duration(milliseconds: 100));

    store.actions.saveState();

    // the state should be saved immediately
    await Future.delayed(const Duration(milliseconds: 100));
    expect(
      await storageHelper.exists(username),
      true,
    );

    expect(
        serializers.deserialize(
                json.decode((await storageHelper.read(username))!) as Object)
            is AppState,
        true);

    store.actions.settingsActions.saveNoData(true);
    await Future.delayed(const Duration(milliseconds: 100));

    expect(
        serializers.deserialize(
                json.decode((await storageHelper.read(username))!) as Object)
            is SettingsState,
        true);

    store.actions.settingsActions.saveNoData(false);
    await Future.delayed(const Duration(milliseconds: 100));

    expect(
        serializers.deserialize(
                json.decode((await storageHelper.read(username))!) as Object)
            is AppState,
        true);

    store.actions.settingsActions.saveNoData(true);
    await Future.delayed(const Duration(milliseconds: 100));

    expect(
        serializers.deserialize(
                json.decode((await storageHelper.read(username))!) as Object)
            is SettingsState,
        true);

    store.actions.settingsActions.saveNoData(false);
    await Future.delayed(const Duration(milliseconds: 100));

    expect(
        serializers.deserialize(
                json.decode((await storageHelper.read(username))!) as Object)
            is AppState,
        true);
  });
}
