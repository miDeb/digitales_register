import 'dart:convert';

import 'package:built_redux/built_redux.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/actions/login_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:dr/serializers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

const serverUrl = "null/v2/api/auth/login";

class MockSecureStorage implements FlutterSecureStorage {
  final Map<String, String> storage = {};
  @override
  Future<bool> containsKey(
      {String key, IOSOptions iOptions, AndroidOptions aOptions}) async {
    return storage.containsKey(key);
  }

  @override
  Future<void> delete(
      {String key, IOSOptions iOptions, AndroidOptions aOptions}) async {
    storage.remove(key);
  }

  @override
  Future<void> deleteAll({IOSOptions iOptions, AndroidOptions aOptions}) async {
    storage.clear();
  }

  @override
  Future<String> read(
      {String key, IOSOptions iOptions, AndroidOptions aOptions}) async {
    return storage[key];
  }

  @override
  Future<Map<String, String>> readAll(
      {IOSOptions iOptions, AndroidOptions aOptions}) async {
    return storage;
  }

  @override
  Future<void> write(
      {String key,
      String value,
      IOSOptions iOptions,
      AndroidOptions aOptions}) async {
    storage[key] = value;
  }
}

class StorageHelper {
  Future<bool> exists(String user) async {
    final value = await read(user);
    return value != null;
  }

  Future<String> read(String user) async {
    return secureStorage.read(key: getStorageKey(user, serverUrl));
  }

  Future<void> cleanup() async {
    await secureStorage.deleteAll();
  }
}

void main() {
  secureStorage = MockSecureStorage();
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
        serializers.deserialize(json.decode(await storageHelper.read(username)))
            is AppState,
        true);
  });
  test('state is not saved when data saving is disabled', () async {
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

    await store.actions.saveState();

    expect(
      await storageHelper.exists(username),
      true,
    );

    expect(
        serializers.deserialize(json.decode(await storageHelper.read(username)))
            is SettingsState,
        true);
  });
  test('state is deleted on logout when state saving is disabled', () async {
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

    await store.actions.saveState();

    // the state should be saved immediately
    expect(
      await storageHelper.exists(username),
      true,
    );

    expect(
        serializers.deserialize(json.decode(await storageHelper.read(username)))
            is AppState,
        true);
    await store.actions.loginActions.logout(
      LogoutPayload(
        (b) => b
          ..hard = true
          ..forced = true,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));

    expect(
        serializers
            .deserialize(json.decode(await storageHelper.read(username))),
        const TypeMatcher<SettingsState>());
  });
  test('state is deleted/saved when the setting is switched', () async {
    const username = "test_username4";
    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState(),
      AppActions(),
      middleware: middleware,
    );
    await store.actions.loginActions.loggedIn(
      LoggedInPayload((b) => b
        ..fromStorage = false
        ..username = username),
    );

    await Future.delayed(const Duration(milliseconds: 100));

    await store.actions.saveState();

    // the state should be saved immediately
    await Future.delayed(const Duration(milliseconds: 100));
    expect(
      await storageHelper.exists(username),
      true,
    );

    expect(
        serializers.deserialize(json.decode(await storageHelper.read(username)))
            is AppState,
        true);

    store.actions.settingsActions.saveNoData(true);
    await Future.delayed(const Duration(milliseconds: 100));

    expect(
        serializers.deserialize(json.decode(await storageHelper.read(username)))
            is SettingsState,
        true);

    store.actions.settingsActions.saveNoData(false);
    await Future.delayed(const Duration(milliseconds: 100));

    expect(
        serializers.deserialize(json.decode(await storageHelper.read(username)))
            is AppState,
        true);

    store.actions.settingsActions.saveNoData(true);
    await Future.delayed(const Duration(milliseconds: 100));

    expect(
        serializers.deserialize(json.decode(await storageHelper.read(username)))
            is SettingsState,
        true);

    store.actions.settingsActions.saveNoData(false);
    await Future.delayed(const Duration(milliseconds: 100));

    expect(
        serializers.deserialize(json.decode(await storageHelper.read(username)))
            is AppState,
        true);
  });
}
