// Copyright (C) 2021 Michael Debertol
//
// This file is part of digitales_register.
//
// digitales_register is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// digitales_register is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with digitales_register.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:async';
import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dr/util.dart';
import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';

import 'app_state.dart';
import 'main.dart';
import 'ui/dialog.dart';

/*
// Debug all requests
// IMPORTANT Don't include in release, contains sensitive info
class DebugInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    log("Request, uri: ${options.uri},\ndata: ${options.data},\nheaders: ${options.headers}");
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    log("Response, uri: ${response.request.uri},\nheaders: ${response.headers}");
    if (response.data.toString().length <= 100) {
      log(response.data.toString());
    } else {
      log(response.data.toString().substring(0, 100));
    }
    return response;
  }

  @override
  Future onError(DioError err) async => err;
}
*/
typedef AddNetworkProtocolItem = void Function(NetworkProtocolItem item);

class UnexpectedLogoutException implements Exception {}

class Wrapper {
  final cookieJar = DefaultCookieJar();
  final Dio dio = Dio();
  String get loginAddress => "${baseAddress}api/auth/login";
  String get baseAddress => "$url/v2/";
  String? user, pass, _url;

  Wrapper() {
    dio.interceptors.add(CookieManager(cookieJar));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.userAgent =
          "Digitales-Register-App $appVersion; https://github.com/miDeb/digitales_register";
    };
    //dio.interceptors.add(DebugInterceptor());
  }

  String? get url => _url;
  set url(String? value) {
    if (value != _url) {
      // we should already be logged out, but why not double check
      logout(hard: true);
    }
    _url = value;
  }

  Future<bool> get loggedIn => _loggedIn;
  // This future will be not completed if a login is in progress
  Future<bool> _loggedIn = Future.value(false);
  VoidCallback? onLogout, onConfigLoaded, onRelogin;
  AddNetworkProtocolItem? onAddProtocolItem;
  late bool safeMode;

  bool noInternet = false;
  Future<bool> refreshNoInternet() async {
    final address = url != null ? baseAddress : "https://digitalesregister.it";
    return noInternet = await cannotConnectTo(address);
  }

  String? error;

  DateTime lastInteraction = DateTime.now();
  DateTime? _serverLogoutTime;
  late Config config;
  Future<dynamic> login(
    String? user,
    String? pass,
    String? tfaCode,
    String? url, {
    VoidCallback? logout,
    VoidCallback? configLoaded,
    VoidCallback? relogin,
    AddNetworkProtocolItem? addProtocolItem,
  }) async {
    noInternet = false;
    error = null;
    if (logout != null) {
      onLogout = logout;
    } else {
      assert(onLogout != null);
    }
    if (configLoaded != null) {
      onConfigLoaded = configLoaded;
    } else {
      assert(onConfigLoaded != null);
    }
    if (relogin != null) {
      onRelogin = relogin;
    } else {
      assert(onRelogin != null);
    }
    if (addProtocolItem != null) {
      onAddProtocolItem = addProtocolItem;
    } else {
      assert(onAddProtocolItem != null);
    }
    this.url = url;
    final loggedInCompleter = Completer<bool>();
    _loggedIn = loggedInCompleter.future;
    Map response;
    _clearCookies();
    try {
      response = getMap(
        (await dio.post<dynamic>(
          loginAddress,
          data: {
            "username": user,
            "password": pass,
            if (tfaCode != null) "two_factor": tfaCode,
          },
        ))
            .data,
      )!;
    } catch (e) {
      loggedInCompleter.complete(false);
      log("Error while logging in", error: e);
      if (e is TimeoutException || await refreshNoInternet()) {
        noInternet = true;
      }
      error = "Unknown Error:\n$e";
      return null;
    }
    if (getBool(response["loggedIn"]) ?? false) {
      lastInteraction = DateTime.now();
      loggedInCompleter.complete(true);
      this.user = user;
      this.pass = pass;
      error = null;
      await _loadConfig().then((_) {
        _serverLogoutTime =
            now.add(Duration(seconds: config.autoLogoutSeconds));
        _updateLogout();
        onConfigLoaded!();
      });
    } else {
      loggedInCompleter.complete(false);
      error = "[${response["error"]}] ${response["message"]}";
      switch (getString(response["error"])) {
        case "two_factor_needed":
          final tfaCode = await _request2FA();
          if (tfaCode != null) {
            return login(user, pass, tfaCode, url);
          }
          return;
        case "two_factor_wrong":
          final tfaCode = await _request2FA(wasWrong: true);
          if (tfaCode != null) {
            return login(user, pass, tfaCode, url);
          }
          return;
      }
    }
    return response;
  }

  Future<String?> _request2FA({bool wasWrong = false}) {
    return showDialog(
      context: navigatorKey!.currentContext!,
      builder: (context) {
        final textInputController = TextEditingController();
        return StatefulBuilder(
          builder: (context, setState) => InfoDialog(
            title: Text(
                wasWrong ? "Ungültiger Code" : "Zweiter Faktor wird benötigt"),
            content: TextField(
              controller: textInputController,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Abbrechen"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(
                  context,
                  textInputController.value.text,
                ),
                child: const Text("Bestätigen"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> changePass(
      String url, String user, String oldPass, String newPass) async {
    this.url = url;
    Map response;
    _clearCookies();
    try {
      response = getMap((await dio.post<dynamic>(
        "${baseAddress}api/auth/setNewPassword",
        data: {
          "username": user,
          "oldPassword": oldPass,
          "newPassword": newPass,
        },
      ))
          .data)!;
    } catch (e) {
      _loggedIn = Future.value(false);
      log("Failed to change pass", error: e);
      error = "Unknown Error:\n$e";
      return null;
    }
    if (response["error"] != null) {
      error = "[${response["error"]}] ${response["message"]}";
    } else {
      _loggedIn = Future.value(false);
      this.user = user;
      pass = newPass;
      error = null;
    }
    return response;
  }

  Future<void> _loadConfig() async {
    final source = (await dio.get<String>(baseAddress)).data;
    config = parseConfig(source!);
  }

  static Config parseConfig(String source) {
    final id = _readUserId(source);
    final fullName = _readFullName(source);
    final imgSource = _readImgSource(source);
    final autoLogout = _readAutoLogoutSeconds(source);
    final currentSemesterMaybe = _readCurrentSemester(source);
    final isStudentOrParent = _readIsStudentOrParent(source);
    return Config(
      (b) => b
        ..userId = id
        ..autoLogoutSeconds = autoLogout
        ..fullName = fullName
        ..imgSource = imgSource
        ..currentSemesterMaybe = currentSemesterMaybe
        ..isStudentOrParent = isStudentOrParent,
    );
  }

  static bool _readIsStudentOrParent(String source) {
    return !source.contains("var isStudentOrParent=0;");
  }

  static int? _readCurrentSemester(String source) {
    if (source.contains("semesterWechsel=1")) return 2;
    if (source.contains("semesterWechsel=2")) {
      return 1;
    } else {
      return null;
    }
  }

  static int _readAutoLogoutSeconds(String source) {
    final substringFromId = source.substring(
        source.indexOf("auto_logout_seconds: ") +
            "auto_logout_seconds: ".length);
    return int.parse(
        substringFromId.substring(0, substringFromId.indexOf(",")).trim());
  }

  static int _readUserId(String source) {
    final substringFromId = source
        .substring(source.indexOf("currentUserId=") + "currentUserId=".length);
    return int.parse(
        substringFromId.substring(0, substringFromId.indexOf(";")).trim());
  }

  static String _readAfterImgId(String source) {
    return source
        .substring(source.indexOf("navigationProfilePicture") +
            "navigationProfilePicture".length)
        .trim();
  }

  static String _readFullName(String source) {
    final afterImgId = _readAfterImgId(source);
    return afterImgId
        .substring(afterImgId.indexOf(">") + 1, afterImgId.indexOf("<"))
        .trim();
  }

  static String _readImgSource(String source) {
    final afterImgId = _readAfterImgId(source);
    final afterStart =
        afterImgId.substring(afterImgId.indexOf('src="') + "src='".length);
    return afterStart.substring(0, afterStart.indexOf('"')).trim();
  }

  final _loginMutex = Mutex();

  Future<dynamic> send(String url,
      {Map<String, Object?> args = const <String, Object?>{},
      String method = "POST"}) async {
    assert(!url.startsWith("/"));
    await _loginMutex.acquire();
    try {
      if (!await _loggedIn ||
          (_serverLogoutTime != null && now.isAfter(_serverLogoutTime!))) {
        if (user != null && pass != null) {
          await login(user, pass, null, this.url);
          if (!await _loggedIn) {
            if (noInternet) {
              await actions.noInternet(true);
            } else {
              logout(hard: true, logoutForcedByServer: true);
            }
            return null;
          } else {
            onRelogin!();
          }
        } else {
          if (noInternet) {
            await actions.noInternet(true);
          }
          log("returning null for request to $url, user is not logged in");
          return null;
        }
      }
    } finally {
      _loginMutex.release();
    }

    dynamic responseData;
    try {
      final response = await (method == "POST"
          ? dio.post<dynamic>(
              baseAddress + url,
              data: args,
            )
          : method == "GET"
              ? dio.get<dynamic>(
                  baseAddress + url,
                )
              : throw Exception(
                  "invalid method: $method; expected POST or GET"));
      responseData = response.data;
    } on Exception catch (e) {
      await _handleError(e);
      onAddProtocolItem!(NetworkProtocolItem((b) => b
        ..address = baseAddress + url
        ..response = stringifyMaybeJson(responseData)
        ..parameters = stringifyMaybeJson(args)));
      return null;
    }
    onAddProtocolItem!(NetworkProtocolItem((b) => b
      ..address = baseAddress + url
      ..response = stringifyMaybeJson(responseData)
      ..parameters = stringifyMaybeJson(args)));

    // returned if we were logged out:
    //	<script type="text/javascript">
    //window.location = "https://vinzentinum.digitalesregister.it/v2/login";
    //</script>

    if (responseData is String &&
        RegExp(r'\s*<script type="text/javascript">\n?\s*window\.location = "https://.+\.digitalesregister.it/v2/login";\n?\s*</script>')
            .hasMatch(responseData)) {
      throw UnexpectedLogoutException();
    }
    return responseData;
  }

  Future<void> _handleError(Exception e) async {
    log("Error while sending request", error: e);
    if (e is TimeoutException || await refreshNoInternet()) {
      noInternet = true;
      await actions.noInternet(true);
      error = "Keine Internetverbindung";
    } else {
      error = e.toString();
    }
  }

  Future<void> _updateLogout() async {
    if (!await _loggedIn) return;
    if (_serverLogoutTime != null &&
        DateTime.now()
            .add(const Duration(seconds: 25))
            .isAfter(_serverLogoutTime!)) {
      //autologout happens soon!
      final result =
          getMap(await send("api/auth/extendSession", args: <String, Object?>{
        "lastAction": lastInteraction.millisecondsSinceEpoch ~/ 1000,
      }));
      if (result == null) {
        logout(hard: safeMode, logoutForcedByServer: true);
        return;
      }
      if (result["forceLogout"] == true) {
        logout(hard: safeMode, logoutForcedByServer: true);
        return;
      } else {
        _serverLogoutTime = DateTime.fromMillisecondsSinceEpoch(
            (result["newExpiration"] as int) * 1000);
      }
    }
    Future.delayed(const Duration(seconds: 5), _updateLogout);
  }

  void interaction() {
    lastInteraction = DateTime.now();
  }

  void logout({required bool hard, bool logoutForcedByServer = false}) {
    if (!logoutForcedByServer && _url != null) {
      dio.get<dynamic>("${baseAddress}logout");
    }
    if (hard) {
      if (logoutForcedByServer) {
        onLogout!();
      }
      _url = user = pass = null;
    }
    _loggedIn = Future.value(false);
    _clearCookies();
  }

  void _clearCookies() {
    cookieJar.deleteAll();
  }
}
