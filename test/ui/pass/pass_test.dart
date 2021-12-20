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

import 'package:built_redux/built_redux.dart';
import 'package:dio/dio.dart';
import 'package:dr/actions/app_actions.dart';
import 'package:dr/app_state.dart';
import 'package:dr/main.dart';
import 'package:dr/middleware/middleware.dart';
import 'package:dr/reducer/reducer.dart';
import 'package:dr/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../save_state_test.dart';
import '../../test_utils.dart';

class MockDio extends Mock implements Dio {}

class MockWrapper extends Mock implements Wrapper {}

void main() {
  testGoldens("Request pass reset", (WidgetTester tester) async {
    secureStorage = FakeSecureStorage();
    navigatorKey = GlobalKey();
    scaffoldKey = GlobalKey();
    scaffoldMessengerKey = GlobalKey();

    passDio = MockDio();

    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState(),
      AppActions(),
      middleware: middleware(includeErrorMiddleware: false),
    );
    await tester.pumpWidget(RegisterApp(store: store));
    await store.actions.start(null);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile("start.png"),
    );
    await tester.enterText(find.byType(TextField).first, "Vinze");
    // Debounced
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile("suggestions.png"),
    );
    await tester.tap(find.text("Vinzentinum"));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile("school_selected.png"),
    );
    await tester.tap(find.text("Passwort vergessen"));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile("request_pass_reset.png"),
    );
    await tester.enterText(
      find.ancestor(
          of: find.text("Email-Adresse"), matching: find.byType(TextField)),
      "foo@example.com",
    );
    await tester.enterText(
      find.ancestor(
          of: find.text("Benutzername"), matching: find.byType(TextField)),
      "username23",
    );

    await tester.pumpAndSettle();
    when(
      () => passDio!.post<dynamic>(
        "https://vinzentinum.digitalesregister.it/api/auth/resetPassword",
        data: <String, dynamic>{
          "email": "foo@example.com",
          "username": "username23",
        },
      ),
    ).thenAnswer(
      (invocation) => Future.value(
        Response<dynamic>(
          data: {
            "message": "Eine Email wurde gesendet...",
          },
          requestOptions: RequestOptions(
            path:
                "https://vinzentinum.digitalesregister.it/api/auth/resetPassword",
          ),
        ),
      ),
    );

    await tester.tap(find.text("Anfrage zum Zurücksetzen senden"));
    await tester.pumpAndSettle();

    expect(find.text("Eine Email wurde gesendet..."), findsOneWidget);

    verify(
      () => passDio!.post<dynamic>(
        "https://vinzentinum.digitalesregister.it/api/auth/resetPassword",
        data: <String, dynamic>{
          "email": "foo@example.com",
          "username": "username23",
        },
      ),
    ).called(1);

    expect(
      tester.takeException(),
      isA<MissingPluginException>().having(
        (e) => e.message,
        "message",
        contains(
          "flutter_keyboard_visibility",
        ),
      ),
    );
  });

  testGoldens("Change pass", (WidgetTester tester) async {
    secureStorage = FakeSecureStorage(storage: initialLoggedInStorage);
    navigatorKey = GlobalKey();
    scaffoldKey = GlobalKey();
    scaffoldMessengerKey = GlobalKey();

    passDio = MockDio();
    wrapper = MockWrapper();

    when(
      () => wrapper.login(
        "username23",
        "Passwort123",
        null,
        "https://example.digitales.register.example",
        addProtocolItem: any(named: "addProtocolItem"),
        configLoaded: any(named: "configLoaded"),
        logout: any(named: "logout"),
        relogin: any(named: "relogin"),
      ),
    ).thenAnswer((invocation) async => {"loggedIn": true});
    when(() => wrapper.loggedIn).thenAnswer((_) => Future.value(true));
    when(() => wrapper.config).thenReturn(
      Config(
        (b) => b
          ..autoLogoutSeconds = 300
          ..fullName = "A"
          ..imgSource = "foo"
          ..isStudentOrParent = true
          ..userId = 0,
      ),
    );

    when(
      () => wrapper.noInternet,
    ).thenAnswer((invocation) => false);
    when(() => wrapper.user).thenReturn("username23");
    when(() => wrapper.loginAddress)
        .thenReturn("https://example.digitales.register.example/v2/api/login");

    when(
      () => wrapper.send(
        "api/student/dashboard/dashboard",
        args: any(named: "args"),
      ),
    ).thenAnswer((_) async => null);
    when(
      () => wrapper.send(
        "api/notification/unread",
        args: any(named: "args"),
      ),
    ).thenAnswer((_) async => null);

    final store = Store<AppState, AppStateBuilder, AppActions>(
      appReducerBuilder.build(),
      AppState(),
      AppActions(),
      middleware: middleware(includeErrorMiddleware: false),
    );
    await tester.pumpWidget(RegisterApp(store: store));
    await store.actions.start(null);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();

    when(() => wrapper.send("api/profile/get")).thenAnswer(
      (invocation) => Future<dynamic>.value(
        {
          "name": "Name123",
          "email": "example@localhost",
          "roleName": "Schüler",
          "notificationsEnabled": false,
          "username": "username23"
        },
      ),
    );

    await tester.tap(find.text("Profil"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Passwort ändern"));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile("change_pass.png"),
    );

    await tester.enterText(
      find.ancestor(
          of: find.text("Altes Passwort"), matching: find.byType(TextField)),
      "oldPW",
    );

    await tester.enterText(
      find.ancestor(
          of: find.text("Neues Passwort"), matching: find.byType(TextField)),
      "newPW",
    );
    await tester.enterText(
      find.ancestor(
          of: find.text("Neues Passwort wiederholen"),
          matching: find.byType(TextField)),
      "newPW",
    );

    await tester.pumpAndSettle();
    const validPW = "asdf123/ASDF";

    await tester.enterText(
      find.ancestor(
          of: find.text("Neues Passwort"), matching: find.byType(TextField)),
      validPW,
    );

    await tester.enterText(
      find.ancestor(
          of: find.text("Neues Passwort wiederholen"),
          matching: find.byType(TextField)),
      validPW,
    );

    when(
      () => wrapper.changePass(
        "https://example.digitales.register.example",
        "username23",
        "oldPW",
        validPW,
      ),
    ).thenAnswer((invocation) =>
        Future<dynamic>.value({"message": "Passwort geändert"}));

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile("change_pass_valid.png"),
    );

    when(
      () => wrapper.login(
        "username23",
        validPW,
        null,
        "https://example.digitales.register.example",
        addProtocolItem: any(named: "addProtocolItem"),
        configLoaded: any(named: "configLoaded"),
        logout: any(named: "logout"),
        relogin: any(named: "relogin"),
      ),
    ).thenAnswer((invocation) => Future<dynamic>.value({"loggedIn": true}));

    when(() => wrapper.error).thenReturn("Dummy error");

    await tester.tap(find.widgetWithText(ElevatedButton, "Passwort ändern"));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile("changed_pass.png"),
    );

    //expect(find.text("Passwort erfolgreich geändert"), findsOneWidget);

    verify(
      () => wrapper.changePass(
        "https://example.digitales.register.example",
        "username23",
        "oldPW",
        validPW,
      ),
    ).called(1);
    verify(
      () => wrapper.login(
        "username23",
        validPW,
        null,
        "https://example.digitales.register.example",
        addProtocolItem: any(named: "addProtocolItem"),
        configLoaded: any(named: "configLoaded"),
        logout: any(named: "logout"),
        relogin: any(named: "relogin"),
      ),
    ).called(1);

    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    expect(find.text("Passwort erfolgreich geändert"), findsNothing);
  });
}
