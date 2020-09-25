import 'dart:collection';
import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;
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
  Map<String, String> _storage = {};

  /// Will complete when loading finishes
  Future _storageFuture;
  final directory = Directory("linux/appData/secure_storage");
  LinuxSecureStorage() {
    _storageFuture = directory.list().forEach((element) {
      _storage[element.path.split("/").last.replaceAll(".json", "")] =
          (element as File).readAsStringSync();
    });
  }
  @override
  Future<void> delete(
      {String key,
      dynamic iOptions,
      secure_storage.AndroidOptions aOptions}) async {
    await _storageFuture;
    _storage.remove(key);

    final file = File("linux/appData/secure_storage/${_sanitize(key)}.json");
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  @override
  Future<void> deleteAll(
      {dynamic iOptions, secure_storage.AndroidOptions aOptions}) async {
    await _storageFuture;
    for (final key in _storage.keys) {
      delete(key: key);
    }
    _storage.clear();
  }

  @override
  Future<String> read(
      {String key,
      dynamic iOptions,
      secure_storage.AndroidOptions aOptions}) async {
    await _storageFuture;
    return _storage[_sanitize(key)];
  }

  @override
  Future<Map<String, String>> readAll(
      {dynamic iOptions, secure_storage.AndroidOptions aOptions}) async {
    await _storageFuture;
    return UnmodifiableMapView(_storage);
  }

  @override
  Future<void> write(
      {String key,
      String value,
      dynamic iOptions,
      secure_storage.AndroidOptions aOptions}) async {
    await _storageFuture;
    _storage[key] = value;

    final file = File("linux/appData/secure_storage/${_sanitize(key)}.json");
    if (!file.existsSync()) {
      file.createSync();
    }
    file.writeAsString(value);
  }

  String _sanitize(String key) {
    return key.replaceAll("/", "").replaceAll('"', "");
  }
}

/// Dummy implementation if on linux to run development builds on it;
/// nothing actually dynamic there
class DynamicTheme extends StatelessWidget {
  final dynamic_theme.ThemedWidgetBuilder themedWidgetBuilder;
  final dynamic_theme.ThemeDataBuilder data;
  final Brightness defaultBrightness;

  const DynamicTheme(
      {Key key, this.themedWidgetBuilder, this.data, this.defaultBrightness})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux) {
      return themedWidgetBuilder(
          context, ThemeData.dark()); // Modify here to change theme
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
    print(
        "TOAST: - - - - - - - - - - - - ... $msg ... - - - - - - - - - - - -");
  } else {
    Fluttertoast.showToast(msg: msg, toastLength: toastLength);
  }
}

Future<Directory> get downloadsDirectory async {
  if (Platform.isLinux) {
    return Directory.current;
  } else {
    return DownloadsPathProvider.downloadsDirectory;
  }
}
