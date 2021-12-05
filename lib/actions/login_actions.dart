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
import 'package:built_value/built_value.dart';

part 'login_actions.g.dart';

abstract class LoginActions extends ReduxActions {
  factory LoginActions() => _$LoginActions();
  LoginActions._();

  abstract final ActionDispatcher<String> setUsername;
  abstract final ActionDispatcher<LoginPayload> login;
  abstract final ActionDispatcher<LoggedInPayload> loggedIn;
  abstract final ActionDispatcher<LoginFailedPayload> loginFailed;
  abstract final ActionDispatcher<LogoutPayload> logout;
  abstract final VoidActionDispatcher updateLogout;
  abstract final VoidActionDispatcher loggingIn;
  abstract final VoidActionDispatcher automaticallyReloggedIn;
  abstract final ActionDispatcher<bool> showChangePass;
  abstract final ActionDispatcher<ChangePassPayload> changePass;
  abstract final ActionDispatcher<void Function()> addAfterLoginCallback;
  abstract final VoidActionDispatcher clearAfterLoginCallbacks;
  abstract final ActionDispatcher<RequestPassResetPayload> requestPassReset;
  abstract final ActionDispatcher<String> resetPass;
  abstract final ActionDispatcher<String> passResetFailed;
  abstract final ActionDispatcher<String> passResetSucceeded;
  abstract final ActionDispatcher<List<String>> setAvailableAccounts;
  abstract final VoidActionDispatcher addAccount;
  // payload: the index of the selected account
  abstract final ActionDispatcher<int> selectAccount;
}

abstract class LoginPayload
    implements Built<LoginPayload, LoginPayloadBuilder> {
  factory LoginPayload([void Function(LoginPayloadBuilder)? updates]) =
      _$LoginPayload;
  LoginPayload._();

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LoginPayload')
          ..add('user', user)
          // ..add('pass', pass) // do not include the password
          ..add('url', url)
          ..add('fromStorage', fromStorage)
          ..add('offlineEnabled', offlineEnabled))
        .toString();
  }

  static void _initializeBuilder(LoginPayloadBuilder b) {
    b.offlineEnabled = false;
  }

  String get user;
  String get pass;
  String get url;
  bool get fromStorage;
  bool get offlineEnabled;
}

abstract class ChangePassPayload
    implements Built<ChangePassPayload, ChangePassPayloadBuilder> {
  factory ChangePassPayload(
      [void Function(ChangePassPayloadBuilder)? updates]) = _$ChangePassPayload;
  ChangePassPayload._();
  String get url;
  String get user;
  String get oldPass;
  String get newPass;
}

abstract class RequestPassResetPayload
    implements Built<RequestPassResetPayload, RequestPassResetPayloadBuilder> {
  factory RequestPassResetPayload(
          [void Function(RequestPassResetPayloadBuilder)? updates]) =
      _$RequestPassResetPayload;
  RequestPassResetPayload._();
  String get user;
  String get email;
}

abstract class LoggedInPayload
    implements Built<LoggedInPayload, LoggedInPayloadBuilder> {
  factory LoggedInPayload([void Function(LoggedInPayloadBuilder)? updates]) =
      _$LoggedInPayload;
  LoggedInPayload._();

  String get username;
  bool get fromStorage;
  bool? get keepShowingLoadingIndicator;
}

abstract class LoginFailedPayload
    implements Built<LoginFailedPayload, LoginFailedPayloadBuilder> {
  factory LoginFailedPayload(
          [void Function(LoginFailedPayloadBuilder)? updates]) =
      _$LoginFailedPayload;
  LoginFailedPayload._();

  String get cause;

  String? get username;
}

abstract class LogoutPayload
    implements Built<LogoutPayload, LogoutPayloadBuilder> {
  factory LogoutPayload([void Function(LogoutPayloadBuilder)? updates]) =
      _$LogoutPayload;
  LogoutPayload._();

  bool get hard;
  bool get forced;
}
