import 'dart:async';
import 'dart:ui' show VoidCallback;
import 'package:http/http.dart' as http;

import 'package:meta/meta.dart';
import 'package:mutex/mutex.dart';
import 'package:requests/requests.dart';

import 'app_state.dart';

typedef void AddNetworkProtocolItem(NetworkProtocolItem item);

class Wrapper {
  String get _loginAdress => "$baseAdress/api/auth/login";
  String get baseAdress => "$url/v2";
  String user, pass, url;

  bool get loggedIn => _loggedIn;
  bool _loggedIn;
  VoidCallback onLogout, onConfigLoaded, onRelogin;
  AddNetworkProtocolItem onAddProtocolItem;
  bool safeMode;
  Future<bool> get noInternet async {
    try {
      final result = await http.get(baseAdress);
      if (result.statusCode == 200) {
        return false;
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  String error;

  DateTime lastInteraction = DateTime.now();
  DateTime _serverLogoutTime;
  Config config;
  Future<void> login(String user, String pass, String url,
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
        _loginAdress,
        body: {"username": user, "password": pass},
        json: true,
      );
    } catch (e) {
      _loggedIn = false;
      print(e);
      error = "Unknown Error:\n$e";
      return;
    }
    if (response["loggedIn"] == true) {
      _loggedIn = true;
      this.user = user;
      this.pass = pass;
      error = null;
      await _loadConfig().then((_) {
        _serverLogoutTime =
            DateTime.now().add(Duration(seconds: config.autoLogoutSeconds));
        _updateLogout();
        onConfigLoaded();
      });
    } else {
      _loggedIn = false;
      error = "[${response["error"]}] ${response["message"]}";
    }
  }

  Future<void> _loadConfig() async {
    String source;
    try {
      source = await Requests.get(baseAdress);
    } on TimeoutException {
      source = await Requests.get(baseAdress);
    }
    final id = _readUserId(source);
    final fullName = _readFullName(source);
    final imgSource = _readImgSource(source);
    final autoLogout = _readAutoLogoutSeconds(source);
    final currentSemesterMaybe = _readCurrentSemester(source);
    config = Config((b) => b
      ..userId = id
      ..autoLogoutSeconds = autoLogout
      ..fullName = fullName
      ..imgSource = imgSource
      ..currentSemesterMaybe = currentSemesterMaybe);
  }

  int _readCurrentSemester(String source) {
    if (source.contains("semesterWechsel=1")) return 2;
    if (source.contains("semesterWechsel=2"))
      return 1;
    else
      return null;
  }

  int _readAutoLogoutSeconds(String source) {
    var substringFromId = source.substring(
        source.indexOf("auto_logout_seconds: ") +
            "auto_logout_seconds: ".length);
    return int.parse(
        substringFromId.substring(0, substringFromId.indexOf(",")).trim());
  }

  int _readUserId(String source) {
    var substringFromId = source
        .substring(source.indexOf("currentUserId=") + "currentUserId=".length);
    return int.parse(
        substringFromId.substring(0, substringFromId.indexOf(";")).trim());
  }

  String _readAfterImgId(String source) {
    return source
        .substring(source.indexOf("navigationProfilePicture") +
            "navigationProfilePicture".length)
        .trim();
  }

  String _readFullName(String source) {
    final afterImgId = _readAfterImgId(source);
    return afterImgId
        .substring(afterImgId.indexOf(">") + 1, afterImgId.indexOf("<"))
        .trim();
  }

  String _readImgSource(String source) {
    final afterImgId = _readAfterImgId(source);
    final afterStart =
        afterImgId.substring(afterImgId.indexOf('src="') + "src='".length);
    return afterStart.substring(0, afterStart.indexOf('"')).trim();
  }

  var _mutex = new Mutex();
  Future<dynamic> post(String url,
      [Map<String, dynamic> args = const {}, bool json = true]) async {
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
      response = await Requests.post(
        baseAdress + url,
        body: args,
        json: json,
      );
    } on Exception catch (e) {
      await _handleError(e);
      onAddProtocolItem(NetworkProtocolItem((b) => b
        ..address = baseAdress + url
        ..response = e.toString()
        ..parameters = args.toString()));
      return null;
    }
    onAddProtocolItem(NetworkProtocolItem((b) => b
      ..address = baseAdress + url
      ..response = response.toString()
      ..parameters = args.toString()));
    if (response is String && response.trim() != "") {
      print(response);
      throw Error();
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
    if (DateTime.now().add(Duration(seconds: 25)).isAfter(_serverLogoutTime)) {
      //autologout happens soon!
      final result = await post("/api/auth/extendSession", {
        "lastAction": lastInteraction.millisecondsSinceEpoch ~/ 1000,
      });
      if (result == null) {
        logout(hard: safeMode, forceLogout: true);
        return;
      }
      if (result["forceLogout"] == true) {
        logout(hard: safeMode, forceLogout: true);
        return;
      } else {
        _serverLogoutTime =
            DateTime.fromMillisecondsSinceEpoch(result["newExpiration"] * 1000);
      }
    }
    Future.delayed(Duration(seconds: 5), _updateLogout);
  }

  void interaction() {
    lastInteraction = DateTime.now();
  }

  void logout({@required bool hard, bool forceLogout = false}) {
    if (hard) {
      user = pass = null;
      if (forceLogout) {
        onLogout();
      }
    }
    _loggedIn = false;
    if (!forceLogout) {
      Requests.get("$baseAdress/logout");
    }
    _clearCookies();
  }

  Future<void> _clearCookies() async {
    await Requests.clearStoredCookies(Uri.parse(url).host);
  }
}
