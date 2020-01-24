import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure_storage;
import 'package:dynamic_theme/dynamic_theme.dart' as dynamic_theme;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

secure_storage.FlutterSecureStorage getFlutterSecureStorage() {
  if (Platform.isLinux) {
    return LinuxSecureStorage();
  } else {
    return secure_storage.FlutterSecureStorage();
  }
}

/// Dummy implementation to run development builds on linux;
/// not actually secure
class LinuxSecureStorage implements secure_storage.FlutterSecureStorage {
  Map<String, String> _storage;
  Future _storageFuture;
  LinuxSecureStorage() {
    final file = File("linux/appData/secure_storage.lol");
    if (!file.existsSync()) {
      _storage = {};
    } else {
      (_storageFuture = File("linux/appData/secure_storage.lol").readAsString()).then((string) {
        _storage = Map.from(json.decode(string));
      });
    }
  }
  @override
  Future<void> delete({String key}) async {
    await _storageFuture;
    _storage.remove(key);
    _syncToFileSystem();
  }

  @override
  Future<void> deleteAll() async {
    await _storageFuture;
    _storage.clear();
    _syncToFileSystem();
  }

  @override
  Future<String> read({String key}) async {
    await _storageFuture;
    return _storage[key];
  }

  @override
  Future<Map<String, String>> readAll() async {
    await _storageFuture;
    return Map.of(_storage);
  }

  @override
  Future<void> write({String key, String value}) async {
    await _storageFuture;
    _storage[key] = value;
    _syncToFileSystem();
  }

  void _syncToFileSystem() {
    final file = File("linux/appData/secure_storage.lol");
    file.writeAsString(json.encode(_storage));
  }
}

/// Dummy implementation if on linux to run development builds on it;
/// nothing actually dynamic there
class DynamicTheme extends StatelessWidget {
  final dynamic_theme.ThemedWidgetBuilder themedWidgetBuilder;
  final dynamic_theme.ThemeDataWithBrightnessBuilder data;
  final Brightness defaultBrightness;

  const DynamicTheme({Key key, this.themedWidgetBuilder, this.data, this.defaultBrightness})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux) {
      return themedWidgetBuilder(context, ThemeData.dark()); // Modify here to change theme
    }
    return dynamic_theme.DynamicTheme(
      data: data,
      themedWidgetBuilder: themedWidgetBuilder,
      defaultBrightness: defaultBrightness,
    );
  }
}

/// Dummy implementation if on linux to run development builds on it;
/// only based on the local directory there
Future<Directory> getApplicationDocumentsDirectory() async {
  if (Platform.isLinux) {
    return Directory("linux/appData");
  }
  return await path_provider.getApplicationDocumentsDirectory();
}

void showToast({String msg, Toast toastLength}) {
  if (Platform.isLinux) {
    print("TOAST: - - - - - - - - - - - - ... $msg ... - - - - - - - - - - - -");
  } else {
    Fluttertoast.showToast(msg: msg, toastLength: toastLength);
  }
}
