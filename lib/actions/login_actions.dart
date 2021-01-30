import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

part 'login_actions.g.dart';

abstract class LoginActions extends ReduxActions {
  factory LoginActions() => _$LoginActions();
  LoginActions._();

  ActionDispatcher<String> setUsername;
  ActionDispatcher<LoginPayload> login;
  ActionDispatcher<LoggedInPayload> loggedIn;
  ActionDispatcher<LoginFailedPayload> loginFailed;
  ActionDispatcher<LogoutPayload> logout;
  ActionDispatcher<void> updateLogout;
  ActionDispatcher<void> loggingIn;
  ActionDispatcher<void> automaticallyReloggedIn;
  ActionDispatcher<bool> showChangePass;
  ActionDispatcher<ChangePassPayload> changePass;
  ActionDispatcher<void Function()> addAfterLoginCallback;
  ActionDispatcher<void> clearAfterLoginCallbacks;
  ActionDispatcher<RequestPassResetPayload> requestPassReset;
  ActionDispatcher<String> resetPass;
  ActionDispatcher<String> passResetFailed;
  ActionDispatcher<String> passResetSucceeded;
  ActionDispatcher<List<String>> setAvailableAccounts;
  ActionDispatcher<void> addAccount;
  // payload: the index of the selected account
  ActionDispatcher<int> selectAccount;
}

abstract class LoginPayload
    implements Built<LoginPayload, LoginPayloadBuilder> {
  factory LoginPayload([void Function(LoginPayloadBuilder) updates]) =
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
  factory ChangePassPayload([void Function(ChangePassPayloadBuilder) updates]) =
      _$ChangePassPayload;
  ChangePassPayload._();
  String get url;
  String get user;
  String get oldPass;
  String get newPass;
}

abstract class RequestPassResetPayload
    implements Built<RequestPassResetPayload, RequestPassResetPayloadBuilder> {
  factory RequestPassResetPayload(
          [void Function(RequestPassResetPayloadBuilder) updates]) =
      _$RequestPassResetPayload;
  RequestPassResetPayload._();
  String get user;
  String get email;
}

abstract class LoggedInPayload
    implements Built<LoggedInPayload, LoggedInPayloadBuilder> {
  factory LoggedInPayload([void Function(LoggedInPayloadBuilder) updates]) =
      _$LoggedInPayload;
  LoggedInPayload._();

  String get username;
  bool get fromStorage;
}

abstract class LoginFailedPayload
    implements Built<LoginFailedPayload, LoginFailedPayloadBuilder> {
  factory LoginFailedPayload(
          [void Function(LoginFailedPayloadBuilder) updates]) =
      _$LoginFailedPayload;
  LoginFailedPayload._();

  String get cause;
  @nullable
  String get username;
}

abstract class LogoutPayload
    implements Built<LogoutPayload, LogoutPayloadBuilder> {
  factory LogoutPayload([void Function(LogoutPayloadBuilder) updates]) =
      _$LogoutPayload;
  LogoutPayload._();

  bool get hard;
  bool get forced;
}
