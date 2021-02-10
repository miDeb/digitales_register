import 'dart:async';
import 'dart:developer';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:dr/util.dart';
import 'package:meta/meta.dart';
import 'package:mutex/mutex.dart';

import 'app_state.dart';
import 'main.dart';
import 'ui/dialog.dart';

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

typedef AddNetworkProtocolItem = void Function(NetworkProtocolItem item);

class UnexpectedLogoutException implements Exception {}

class Wrapper {
  final cookieJar = DefaultCookieJar();
  final dio = Dio();
  String get loginAddress => "${baseAddress}api/auth/login";
  String get baseAddress => "$url/v2/";
  String user, pass, _url;

  Wrapper() {
    dio.interceptors.add(CookieManager(cookieJar));
    //dio.interceptors.add(DebugInterceptor());
  }

  String get url => _url;
  set url(String value) {
    if (value != _url) {
      // we should already be logged out, but why not double check
      logout(hard: true);
    }
    _url = value;
  }

  bool get loggedIn => _loggedIn;
  bool _loggedIn = false;
  VoidCallback onLogout, onConfigLoaded, onRelogin;
  AddNetworkProtocolItem onAddProtocolItem;
  bool safeMode;
  Future<bool> get noInternet async {
    final address = url != null ? baseAddress : "https://digitalesregister.it";
    try {
      final result = await http.get(address);
      if (result.statusCode == 200) {
        return false;
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  String error;

  DateTime lastInteraction = now;
  DateTime _serverLogoutTime;
  Config config;
  Future<dynamic> login(String user, String pass, String tfaCode, String url,
      {VoidCallback logout,
      VoidCallback configLoaded,
      VoidCallback relogin,
      AddNetworkProtocolItem addProtocolItem}) async {
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
    Map response;
    _clearCookies();
    try {
      response = getMap((await dio.post(
        loginAddress,
        data: {
          "username": user,
          "password": pass,
          if (tfaCode != null) "two_factor": tfaCode,
        },
      ))
          .data);
    } catch (e) {
      _loggedIn = false;
      log("Error while logging in", error: e);
      error = "Unknown Error:\n$e";
      return null;
    }
    if (getBool(response["loggedIn"])) {
      lastInteraction = DateTime.now();
      _loggedIn = true;
      this.user = user;
      this.pass = pass;
      error = null;
      await _loadConfig().then((_) {
        _serverLogoutTime =
            now.add(Duration(seconds: config.autoLogoutSeconds));
        _updateLogout();
        onConfigLoaded();
      });
    } else {
      _loggedIn = false;
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

  Future<String> _request2FA({bool wasWrong = false}) {
    return showDialog(
      context: navigatorKey.currentContext,
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
      response = getMap((await dio.post(
        "${baseAddress}api/auth/setNewPassword",
        data: {
          "username": user,
          "oldPassword": oldPass,
          "newPassword": newPass,
        },
      ))
          .data);
    } catch (e) {
      _loggedIn = false;
      log("Failed to change pass", error: e);
      error = "Unknown Error:\n$e";
      return null;
    }
    if (response["error"] != null) {
      error = "[${response["error"]}] ${response["message"]}";
    } else {
      _loggedIn = false;
      this.user = user;
      pass = newPass;
      error = null;
    }
    return response;
  }

  Future<void> _loadConfig() async {
    final source = (await dio.get(baseAddress)).data;
    config = parseConfig(source as String);
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

  static int _readCurrentSemester(String source) {
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

  final _mutex = Mutex();
  Future<dynamic> send(String url,
      {Map<String, dynamic> args = const {}, String method = "POST"}) async {
    assert(!url.startsWith("/"));
    await _mutex.acquire();
    if (!_loggedIn) {
      if (user != null && pass != null) {
        await login(user, pass, null, this.url);
        if (!_loggedIn) {
          _mutex.release();
          return null;
        } else {
          onRelogin();
        }
      } else {
        _mutex.release();
        return null;
      }
    }
    _mutex.release();

    dynamic response;
    try {
      response = method == "POST"
          ? await dio.post(
              baseAddress + url,
              data: args,
            )
          : method == "GET"
              ? await dio.get(
                  baseAddress + url,
                )
              : throw Exception(
                  "invalid method: $method; expected POST or GET");
      response = response.data;
    } on Exception catch (e) {
      await _handleError(e);
      onAddProtocolItem(NetworkProtocolItem((b) => b
        ..address = baseAddress + url
        ..response = stringifyMaybeJson(response)
        ..parameters = stringifyMaybeJson(args)));
      return null;
    }
    onAddProtocolItem(NetworkProtocolItem((b) => b
      ..address = baseAddress + url
      ..response = stringifyMaybeJson(response)
      ..parameters = stringifyMaybeJson(args)));

    // returned if we were logged out:
    //	<script type="text/javascript">
    //window.location = "https://vinzentinum.digitalesregister.it/v2/login";
    //</script>

    if (response is String &&
        RegExp(r'\s*<script type="text/javascript">\n?\s*window\.location = "https://.+\.digitalesregister.it/v2/login";\n?\s*</script>')
            .hasMatch(response)) {
      throw UnexpectedLogoutException();
    }
    return response;
  }

  Future<void> _handleError(Exception e) async {
    log("Error while sending request", error: e);
    if (await noInternet) {
      error = "Keine Internetverbindung";
    } else {
      error = e.toString();
    }
  }

  Future<void> _updateLogout() async {
    if (!_loggedIn) return;
    if (now.add(const Duration(seconds: 25)).isAfter(_serverLogoutTime)) {
      //autologout happens soon!
      final result = getMap(await send("api/auth/extendSession", args: {
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
    lastInteraction = now;
  }

  void logout({@required bool hard, bool logoutForcedByServer = false}) {
    if (!logoutForcedByServer && _url != null) {
      dio.get("${baseAddress}logout");
    }
    if (hard) {
      if (logoutForcedByServer) {
        onLogout();
      }
      _url = user = pass = null;
    }
    _loggedIn = false;
    _clearCookies();
  }

  void _clearCookies() {
    cookieJar.deleteAll();
  }
}
