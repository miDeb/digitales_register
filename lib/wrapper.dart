import 'dart:async';
import 'dart:io';
import 'dart:ui' show VoidCallback;
import 'package:flutter_ping/flutter_ping.dart';
import 'package:http/http.dart' as http;

import 'package:dr/util.dart';
import 'package:meta/meta.dart';
import 'package:mutex/mutex.dart';
import 'package:requests/requests.dart';

import 'app_state.dart';

typedef AddNetworkProtocolItem = void Function(NetworkProtocolItem item);

class Wrapper {
  String get _loginAddress => "$baseAddress/api/auth/login";
  String get baseAddress => "$url/v2";
  String user, pass, url;

  bool get loggedIn => _loggedIn;
  bool _loggedIn;
  VoidCallback onLogout, onConfigLoaded, onRelogin;
  AddNetworkProtocolItem onAddProtocolItem;
  bool safeMode;
  Future<bool> get noInternet async {
    final address = url != null ? baseAddress : "https://digitalesregister.it";
    if (Platform.isAndroid) {
      final result = await ping(
        Uri.parse(address)
            .host
            // Get the last two components,
            // as pings against subdomains are not answered
            .split(".")
            .reversed
            .take(2)
            .toList()
            .reversed
            .join("."),
      );
      // If there is no internet, the implementation will return an error
      return result.contains("java.lang.NullPointerException");
    } else {
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
  }

  String error;

  DateTime lastInteraction = now;
  DateTime _serverLogoutTime;
  Config config;
  Future<dynamic> login(String user, String pass, String url,
      {VoidCallback logout,
      VoidCallback configLoaded,
      VoidCallback relogin,
      AddNetworkProtocolItem addProtocolItem}) async {
    if (logout != null) {
      this.onLogout = logout;
    } else {
      assert(this.onLogout != null);
    }
    if (configLoaded != null) {
      this.onConfigLoaded = configLoaded;
    } else {
      assert(this.onConfigLoaded != null);
    }
    if (relogin != null) {
      this.onRelogin = relogin;
    } else {
      assert(this.onRelogin != null);
    }
    if (addProtocolItem != null) {
      this.onAddProtocolItem = addProtocolItem;
    } else {
      assert(this.onAddProtocolItem != null);
    }
    this.url = url;
    dynamic response;
    await _clearCookies();
    try {
      response = await Requests.post(
        _loginAddress,
        body: {"username": user, "password": pass},
        json: true,
      );
    } catch (e) {
      _loggedIn = false;
      print(e);
      error = "Unknown Error:\n$e";
      return null;
    }
    if (response["loggedIn"] == true) {
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
    }
    return response;
  }

  Future<dynamic> changePass(
      String url, String user, String oldPass, String newPass) async {
    this.url = url;
    dynamic response;
    await _clearCookies();
    try {
      response = await Requests.post(
        "$baseAddress/api/auth/setNewPassword",
        body: {
          "username": user,
          "oldPassword": oldPass,
          "newPassword": newPass,
        },
        json: true,
      );
    } catch (e) {
      _loggedIn = false;
      print(e);
      error = "Unknown Error:\n$e";
      return null;
    }
    if (response["error"] != null) {
      error = "[${response["error"]}] ${response["message"]}";
    } else {
      this.user = user;
      this.pass = newPass;
      error = null;
    }
    return response;
  }

  Future<void> _loadConfig() async {
    String source;
    try {
      source = await Requests.get(baseAddress);
    } on TimeoutException {
      source = await Requests.get(baseAddress);
    }
    config = parseConfig(source);
  }

  static Config parseConfig(String source) {
    final id = _readUserId(source);
    final fullName = _readFullName(source);
    final imgSource = _readImgSource(source);
    final autoLogout = _readAutoLogoutSeconds(source);
    final currentSemesterMaybe = _readCurrentSemester(source);
    return Config((b) => b
      ..userId = id
      ..autoLogoutSeconds = autoLogout
      ..fullName = fullName
      ..imgSource = imgSource
      ..currentSemesterMaybe = currentSemesterMaybe);
  }

  static int _readCurrentSemester(String source) {
    if (source.contains("semesterWechsel=1")) return 2;
    if (source.contains("semesterWechsel=2"))
      return 1;
    else
      return null;
  }

  static int _readAutoLogoutSeconds(String source) {
    var substringFromId = source.substring(
        source.indexOf("auto_logout_seconds: ") +
            "auto_logout_seconds: ".length);
    return int.parse(
        substringFromId.substring(0, substringFromId.indexOf(",")).trim());
  }

  static int _readUserId(String source) {
    var substringFromId = source
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

  var _mutex = Mutex();
  Future<dynamic> send(String url,
      {Map<String, dynamic> args = const {},
      bool json = true,
      String method = "POST"}) async {
    await _mutex.acquire();
    if (!_loggedIn) {
      if (user != null && pass != null) {
        await login(user, pass, this.url);
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
          ? await Requests.post(
              baseAddress + url,
              body: args,
              json: json,
            )
          : method == "GET"
              ? await Requests.get(
                  baseAddress + url,
                  json: json,
                )
              : throw Exception(
                  "invalid method: $method; expected POST or GET");
    } on Exception catch (e) {
      await _handleError(e);
      onAddProtocolItem(NetworkProtocolItem((b) => b
        ..address = baseAddress + url
        ..response = e.toString()
        ..parameters = args.toString()));
      return null;
    }
    onAddProtocolItem(NetworkProtocolItem((b) => b
      ..address = baseAddress + url
      ..response = response.toString()
      ..parameters = args.toString()));
    if (response is String && response.trim() != "") {
      //print(response);
      //throw Error();
    }
    return response;
  }

  Future<void> _handleError(Exception e) async {
    print(e);
    if (await noInternet) {
      error = "Keine Internetverbindung";
    } else {
      error = e.toString();
    }
  }

  void _updateLogout() async {
    if (!_loggedIn) return;
    if (now.add(Duration(seconds: 25)).isAfter(_serverLogoutTime)) {
      //autologout happens soon!
      final result = await send("/api/auth/extendSession", args: {
        "lastAction": lastInteraction.millisecondsSinceEpoch ~/ 1000,
      });
      if (result == null) {
        logout(hard: safeMode, logoutForcedByServer: true);
        return;
      }
      if (result["forceLogout"] == true) {
        logout(hard: safeMode, logoutForcedByServer: true);
        return;
      } else {
        _serverLogoutTime =
            DateTime.fromMillisecondsSinceEpoch(result["newExpiration"] * 1000);
      }
    }
    Future.delayed(Duration(seconds: 5), _updateLogout);
  }

  void interaction() {
    lastInteraction = now;
  }

  void logout({@required bool hard, bool logoutForcedByServer = false}) {
    if (hard) {
      user = pass = null;
      if (logoutForcedByServer) {
        onLogout();
      }
    }
    _loggedIn = false;
    if (!logoutForcedByServer) {
      Requests.get("$baseAddress/logout");
    }
    _clearCookies();
  }

  Future<void> _clearCookies() async {
    await Requests.clearStoredCookies(Uri.parse(url).host);
  }
}
