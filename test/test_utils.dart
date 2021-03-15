import 'dart:convert';

import 'package:dr/app_state.dart';
import 'package:dr/serializers.dart';

String serializedDefaultAppState =
    json.encode(serializers.serialize(AppState()));

Map<String, String> get initialLoggedInStorage => {
      "login": json.encode(
        {
          "user": "username23",
          "pass": "Passwort123",
          "offlineEnabled": true,
          "url": "https://example.digitales.register.example",
        },
      ),
      json.encode({
        "username": "username23",
        "server_url": "https://example.digitales.register.example/v2/api/login"
      }): serializedDefaultAppState,
    };
