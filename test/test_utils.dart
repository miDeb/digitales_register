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
