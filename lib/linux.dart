import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;
import 'package:dynamic_theme/dynamic_theme.dart' as dynamic_theme;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
import 'package:biometric_storage/biometric_storage.dart';

secure_storage.FlutterSecureStorage getFlutterSecureStorage() {
  if (Platform.isLinux || Platform.isMacOS) {
    return LinuxSecureStorage();
  } else {
    return secure_storage.FlutterSecureStorage();
  }
}

/// Dummy implementation to run development builds on linux;
/// not actually secure
class LinuxSecureStorage implements secure_storage.FlutterSecureStorage {
  BiometricStorage storage = BiometricStorage(); 
  LinuxSecureStorage();
  @override
  Future<void> delete(
      {String key,
      dynamic iOptions,
      secure_storage.AndroidOptions aOptions}) async {
   // storage.delete(key);

  }

  @override
  Future<void> deleteAll(
      {dynamic iOptions, secure_storage.AndroidOptions aOptions}) async {
     
  }

  @override
  Future<String> read(
      {String key,
      dynamic iOptions,
      secure_storage.AndroidOptions aOptions}) async {
    return await (await storage.getStorage(key,forceInit: true, options: StorageFileInitOptions(authenticationRequired: false))).read();
  }

  @override
  Future<Map<String, String>> readAll(
      {dynamic iOptions, secure_storage.AndroidOptions aOptions}) async {
     
  }

  @override
  Future<void> write(
      {String key,
      String value,
      dynamic iOptions,
      secure_storage.AndroidOptions aOptions}) async {
   (await storage.getStorage(key, options: StorageFileInitOptions(authenticationRequired: false))).write(value);
  }

 
  @override
  Future<bool> containsKey(
      {String key,
      secure_storage.IOSOptions iOptions,
      secure_storage.AndroidOptions aOptions}) {
    throw UnimplementedError();
  }
}
 
 

void showToast({String msg, Toast toastLength}) {
  if (Platform.isLinux || Platform.isMacOS) {
    print(
        "TOAST: - - - - - - - - - - - - ... $msg ... - - - - - - - - - - - -");
  } else {
    Fluttertoast.showToast(msg: msg, toastLength: toastLength);
  }
}
 